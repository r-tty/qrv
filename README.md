# QRV — a QNX Neutrino-based operating system, re-imagined for 64-bit RISC-V

QRV is a ground-up adaptation and re-implementation of the **QNX Neutrino
6.4 operating system** for modern 64-bit hardware, with **RISC-V (`rv64g`)**
as the primary architecture and **x86-64** as a secondary target. The
project started on Christmas Eve 2020. The name *QRV* deliberately avoids
any association with the QNX trademark.

QRV is a *whole operating system*, not merely a kernel. The microkernel is
its heart — but the larger share of the work has gone into everything that
surrounds it. Most notable is **taskman**, the user-mode process / memory /
path manager (QNX's `procnto`), which has been deeply reworked and lifted
out of the kernel into user space; alongside it the C library, the device
drivers, the filesystem, the dynamic loader, and the system servers have
all been ported, made 64-bit clean, and in many places substantially
rewritten. The microkernel is small by design; the operating system around
it is where most of QRV lives.

This is not a fork that merely compiles old code on a new compiler. It is a
careful, module-by-module port to a true **LP64** model, with the
proprietary `procnto` boundary dismantled, the IFS/startup machinery
replaced, and — as of the most recent releases — the kernel's Big Kernel
Lock removed entirely and the process/memory/path manager moved out of the
kernel into a user-mode server.

> **This README describes QRV v0.43.**

The development blog, with the full story of the port, is at
**https://r-tty.blogspot.com**. A book-length narrative, *The QRV Porting
Story*, lives in the source tree under `doc/tex/PortingStory/`.

QRV has been developed in close collaboration with **Claude Code**,
Anthropic's agentic coding tool — much of the porting, the SMP debugging,
and the documentation (including this README) was carried out as a
human–AI pair-programming effort, working alongside the author.

---

## Contents

1. [What is QRV](#1-what-is-qrv)
2. [Licensing](#2-licensing)
3. [Obtaining the sources: `obtain_proj.sh` and the `os/` tree](#3-obtaining-the-sources-obtain_projsh-and-the-os-tree)
4. [System architecture](#4-system-architecture)
5. [Taskman and the `TM_PRIV` privileged syscall](#5-taskman-and-the-tm_priv-privileged-syscall)
6. [The Big Kernel Lock — and its removal](#6-the-big-kernel-lock--and-its-removal)
7. [Storage: `devb-nvme` and `fs-qrv`](#7-storage-devb-nvme-and-fs-qrv)
8. [User space](#8-user-space)
9. [Building and running](#9-building-and-running)
10. [Running on real hardware](#10-running-on-real-hardware)
11. [Closing remarks: why a free clone matters](#11-closing-remarks-why-a-free-clone-matters)

---

## 1. What is QRV

QNX is a **microkernel** real-time operating system whose defining idea is
*synchronous message passing*. In QNX, the kernel itself is tiny — it knows
how to schedule threads, pass messages, deliver signals, handle timers and
interrupts, and very little else. Everything that a monolithic OS would put
*inside* the kernel — the process manager, the memory manager, the
filesystem, the device drivers, the network stack — runs in ordinary user
processes called **resource managers**, and they talk to one another and to
their clients through the same **send / receive / reply** IPC primitive.

This architecture is what makes QNX elegant, and it is exactly what QRV
preserves. A program that wants to open a file sends a message; the
filesystem server receives it, does the work, and replies. The kernel only
brokers the rendezvous. The result is a system where a driver can crash and
be restarted without taking the kernel down, where the trusted computing
base is measured in tens of kilobytes, and where the boundary between
"kernel" and "application" is a message, not a privilege wall full of
syscalls.

QRV takes the 2009-era QNX Neutrino 6.4 community sources and brings that
design forward:

- **64-bit clean (LP64).** Every pointer and size type is 64-bit; the port
  hunts down and fixes the `int`/`uint32_t`/`pid_t`-on-a-pointer
  truncations that 32-bit code is riddled with.
- **RISC-V first.** The primary target is `qemu-system-riscv64` (the `virt`
  machine) and the **SiFive Unmatched (FU740)** development board. x86-64 is
  kept building as the portability check.
- **No proprietary boundaries.** There is no IFS and no `mkifs` (QRV uses
  the standard **CPIO** format instead); there is no separate
  startup/kernel split (startup is linked directly with the kernel); there
  are no callouts and no mini-drivers.
- **A modern build.** A Linux-style `Kconfig` configuration, an incremental
  kernel link (modules are added and tested one at a time, not thrown at
  the linker as a 32→64 monolith), and a cross-compiler toolchain
  (`riscv64-linux-gnu-gcc`).
- **A renamed, de-trademarked vocabulary.** `procnto` is **`taskman`** (the
  Task Manager) throughout; all "Neutrino" references are purged.

QRV does **not** implement `fork()` (programs start via `posix_spawn()`),
and it has **no demand paging and no swap** — the same choices QNX itself
made in its 8.0 generation.

---

## 2. Licensing

QRV is governed by **two licenses at once**, and understanding which is
which is essential before you build or redistribute anything.

- **QRV's own code is Apache License 2.0.** Everything written from scratch
  for this project — the RISC-V port, the new build system, the user-mode
  taskman split, the lock-free kernel rework, the drivers and tooling we
  authored — is Apache 2.0. The full text is in **`LICENSE.txt`**.

- **QNX-derived code is the BlackBerry QNX Community License (QCL) 2.0.**
  The parts of QRV that descend from the 2009 QNX Neutrino community
  sources remain under the QCL, which permits **non-commercial and academic
  use** of the derived sources. QRV does not, and cannot, relicense QNX's
  code.

This dual-license reality is precisely **why this repository does not
contain a ready-to-build source tree.** We are not permitted to
redistribute the QNX-derived sources. So instead of shipping the code, this
repository ships a **recipe** (see the next section): a map of where each
QNX file goes, plus the QRV patches that transform it. You obtain the
upstream QNX community sources yourself, from their public mirror, and the
recipe reconstructs the QRV tree on your machine. Your copy is yours; we
redistribute only our own Apache-licensed patches and metadata.

QRV also incorporates code under other permissive licenses — for example
BSD-licensed components adopted from FreeBSD (replacing aged QNX modules),
an MIT-licensed virtio block driver of xv6 ancestry, and the MirBSD Korn
shell (`mksh`) as the system shell. **`WHAT_IS_WHAT.md` is the authoritative,
component-by-component breakdown** of what is under which license and where
it came from — consult it whenever you are unsure about a particular file or
subsystem.

Finally, the repository contains **`PETITION.md`**: an open request to QNX
Software Systems and BlackBerry to relicense the historical 2007–2009
Neutrino sources under a permissive OSI-approved license. If you would like
the foundations of this work to one day be fully free, that document is
where to add your name.

---

## 3. Obtaining the sources: `obtain_proj.sh` and the `os/` tree

Because the QNX-derived sources cannot be redistributed here, this
repository is a **source-reconstruction distribution**. It contains:

| File / dir        | Purpose                                                              |
|-------------------|----------------------------------------------------------------------|
| `obtain_proj.sh`  | The reconstruction script — run this.                                |
| `placement.txt`   | Maps each upstream QNX path to its QRV path (≈680 entries).          |
| `patches/`        | The QRV patch series, LZ4-compressed, plus a `series` order file.    |
| `LICENSE.txt`     | Apache License 2.0.                                                  |
| `WHAT_IS_WHAT.md` | Component-by-component licensing and provenance.                     |
| `PETITION.md`     | The relicensing petition.                                            |

### What the script does

```
$ ./obtain_proj.sh
```

1. **Clones the upstream QNX community mirror** (`github.com/vocho/openqnx`,
   a shallow clone).
2. **Places files** according to `placement.txt`, copying each upstream
   file into its QRV location under `os/`. It reports how many files were
   placed, already present, or missing.
3. **Removes the clone** once placement is done.
4. **Applies the QRV patch series** from `patches/series`, in order. Each
   patch is LZ4-compressed (`*.patch.lz4`) and applied with
   `lz4cat … | patch -p1`. The patches carry the version of the current
   release.
5. **Sets executable permissions** on the handful of scripts that need them
   (e.g. `emu.sh`, `host_tools/mkgpt.py`).

The required tools are `git`, `patch`, and `lz4cat` (from the `lz4`
package); the script checks for them up front and tells you how to install
any that are missing.

The end product is **`os/`** — a complete, buildable QRV source tree:

```
os/
├── kernel/          Everything linked into the qrv-kernel binary
│   ├── arch/riscv/     RISC-V port: vectors, traps, SBI, context switch,
│   │   ├── startup/        arch-specific startup (head.S, mmu.c, …)
│   │   ├── platform/       qemu_virt/, unmatched/
│   │   └── include/        context.h, cpu_paging.h, sbi.h, …
│   ├── startup/         arch-independent startup (hardware_init, smp, …)
│   ├── nano/            core nanokernel: messaging, scheduling, sync, xfer
│   ├── kext/            kernel extensions (kerexts)
│   └── include/         kernel-internal headers
├── taskman/         The Task Manager (QNX's "procnto"), a user-mode server
│   ├── sys/            system manager: main, ELF loader, support
│   ├── proc/           process manager: spawn, wait, …
│   ├── mem/            memory manager: page tables, physical allocator
│   │   └── pageman/        page-granularity virtual-memory operations
│   └── path/           path manager: namespace, /dev/*, /proc/*
├── lib/             C library and runtime
├── include/         User-space-visible headers (the public ABI)
├── userland/        Shell, utilities, drivers, servers (resource managers)
├── servers/         pci, slogger
├── dev/             Device drivers (virtio block, 8250 UART, …)
├── boot/            Boot artifacts and deploy helpers
├── host_tools/      Host-side tooling (mkgpt.py, …)
├── doc/             Documentation, incl. The QRV Porting Story (LaTeX)
├── Kconfig, Makefile, def.mk, common.mk, emu.sh
```

From there, `cd os && make` builds the system (see
[§9](#9-building-and-running)).

---

## 4. System architecture

QRV is a true microkernel system. The privilege stack, from the metal up,
looks like this on RISC-V:

```
 ┌───────────────────────────────────────────────────────────────────────┐
 │                          User space  (U-mode)                         │
 │                                                                       │
 │   sh    pidin   lspci   sloginfo   login   ...                        │
 │    │      │       │        │         │                                │
 │   devb-nvme   fs-qrv   devc-ser*   pci   slogger  ← resource managers │
 │    │      │       │        │         │       │                        │
 │    └──────┴───────┴────────┴─────────┴───────┘                        │
 │                        │   libc  (send / receive / reply stubs)       │
 │   ┌─────────────────────────────────────────────────────────────────┐ │
 │   │  taskman  —  process · memory · path manager                    │ │
 │   │             a U-mode server, privileged via TM_PRIV             │ │
 │   └─────────────────────────────────────────────────────────────────┘ │
 └────────────────────────────────────│──────────────────────────────────┘
                                      │   ecall  (syscall / message)
 ┌───────────────────────────────────────────────────────────────────────┐
 │                       QRV microkernel  (S-mode)                       │
 │                                                                       │
 │   message passing  ·  channels & connections  ·  scheduling  ·        │
 │   threads  ·  synchronization  ·  signals  ·  timers & clocks  ·      │
 │   interrupts  ·  syscall dispatch  ·  TM_PRIV kernel extensions       │
 └───────────────────────────────────────│───────────────────────────────┘
                                         │   SBI ecall
 ┌───────────────────────────────────────────────────────────────────────┐
 │                       OpenSBI firmware  (M-mode)                      │
 └───────────────────────────────────────│───────────────────────────────┘
                                         │
 ┌───────────────────────────────────────────────────────────────────────┐
 │   RISC-V 64-bit hardware   —   QEMU virt   ·   SiFive Unmatched U740  │
 └───────────────────────────────────────────────────────────────────────┘
```

**The kernel (S-mode)** is the only component that runs privileged in the
classic sense. Its subsystems are small and focused:

- **Message passing** — `ker_message.c`, `ker_fastmsg.c`, `nano_message.c`
- **Channels & connections** — `ker_channel.c`, `ker_connect.c`
- **Threads & scheduling** — `ker_thread.c`, `ker_sched.c`, `nano_sched.c`
- **Synchronization** — `ker_sync.c`, `nano_sync.c`
- **Signals** — `ker_signal.c`
- **Timers & clocks** — `ker_timer.c`, `ker_clock.c`
- **Interrupts** — `ker_interrupt.c`
- **Syscall dispatch** — `ker_call_table.c`
- **Data transfer** — the `nano_xfer*.c` family (the cross-address-space
  copy engine that moves message payloads safely between processes)

The interface between the bootstrapper and the kernel is the **syspage**
(`include/sys/syspage.h`); per-CPU state lives in the **cpupage**; the full
register context is `RISCV_CPU_REGISTERS`. On RISC-V, each "CPU" is
identified by its **hart ID** everywhere — there is a single CPU-naming
namespace, end to end.

**Everything else is a user process.** The process/memory/path manager,
the block and serial drivers, the filesystem, the PCI server, the system
logger — all of them are resource managers reached by sending a message.
The kernel does not contain a filesystem; it contains the ability for one
process to ask another to *be* a filesystem.

---

## 5. Taskman and the `TM_PRIV` privileged syscall

**`taskman`** is QRV's name for what QNX called `procnto`: the combined
**process manager, memory manager, and path (namespace) manager**. In a
classic QNX system this code is fused into the kernel image. One of QRV's
larger structural achievements is that **taskman now runs in user mode** —
it is an ordinary U-mode process, not part of the privileged kernel.

That raises an obvious question: if taskman lives in user space, how does it
do the deeply privileged things a process and memory manager must do —
manipulate page tables, allocate physical RAM, create and destroy address
spaces, deliver signals and pulses, tear down processes?

The answer is a single, tightly controlled gateway: **`__KER_TM_PRIV`**,
syscall slot 2. It is the *only* door through which taskman reaches into
kernel-privileged operations, and behind that one slot sits a dispatch
table of **~98 sub-operations** — small **kernel extensions** ("kerexts")
that each perform one well-defined privileged action and return. A few
representative families:

- **Process lifecycle** — `PROCESS_CREATE`, `PROCESS_EXEC`,
  `PROCESS_DESTROY`, `PROCESS_STARTUP`, `PROCESS_SHUTDOWN`, `REPARENT`
- **Physical & virtual memory** — `PA_ALLOC`, `PA_FREE`,
  `PA_QUANTUM_TO_PADDR`, `PAGE_CONT`, `STACK_CONT`, `ASPACE_MEMCPY`
- **Credentials & limits** — `CRED_GET`, `CRED_SET`, `LIMITS_GET/SET`
- **Delivery & objects** — `PULSE_DELIVER`, `SIGNAL_DELIVER`,
  `QUERY_OBJECT`, `CHANNEL_DESTROY`, `CONNECT_DETACH`
- **SMP & platform** — `SMP_BRINGUP`, `LEGAL_CPU_MASK`, `GET_KERN_PGDIR`,
  `ICACHE_SYNC` (the RISC-V instruction-cache coherence operation new in
  v0.43)

This design keeps the **trusted computing base small** — the actual kernel
stays minimal — while giving taskman exactly the privileged primitives it
needs and **nothing more**. Crucially, the kernel heap and other kernel
internals remain inaccessible to U-mode (kernel pages keep `PTE_U=0`);
taskman gets its work done through copy-in/copy-out kerexts, never by being
handed a raw kernel pointer. The enum lives in
`kernel/include/ker+tm/tm_kercalls.h`; the dispatch table is in
`kernel/ker_tm_priv.c`.

---

## 6. The Big Kernel Lock — and its removal

Early QRV — like the QNX generation it came from on multiprocessor systems
— protected the kernel with a single **Big Kernel Lock (BKL)**: a global
`inkernel` word that admitted exactly one hart into the kernel at a time. No
matter how many CPUs were running, every system call and every taskman
message serialized through that one lock. Correct, simple — and a hard
ceiling on SMP scalability.

**As of v0.42, the BKL is gone.** This was the headline of a long line of
release candidates and the subject of chapters 9–14 of *The QRV Porting
Story*. System calls and taskman messages now run **concurrently across
harts** under fine-grained, per-object locks:

- **Per-object locking.** A per-`tChannel` lock and per-`tConnect` lock
  guard message queues; a per-process `vec_slock` guards the thread vector;
  a per-dispatch `sched_slock` guards the run queues; an `alloc_slock`
  guards the kernel heap.
- **Lock-free message passing.** `MsgSend` / `MsgReceive` / `MsgReply` and
  the `Sync*` family take **no global lock at all**. Cross-hart rendezvous
  is coordinated by per-thread bridge bits and hardware memory fences rather
  than by mutual exclusion.
- **SMR (RCU-equivalent) reclamation.** Threads, connections, and channels
  are retired through safe-memory-reclamation so that lock-free lookups
  never dereference a freed object.

On QEMU `virt` with `-smp 8`, the kernel boots reliably to a `login:`
prompt and sustains a 300-iteration `pidin` stress loop with no stalls.

---

## 7. Storage: `devb-nvme` and `fs-qrv`

True to the microkernel model, storage in QRV is **two cooperating user
processes**, not a kernel subsystem:

- **`devb-nvme`** — the block-device driver. It speaks NVMe over PCIe (with
  GPT partition parsing built in), discovers the controller through the PCI
  server, and presents block devices such as `/dev/nvme0n1` and its
  partitions. (A `devb-virtio` sibling drives the QEMU virtio-blk device for
  the emulated target.)
- **`fs-qrv`** — the filesystem resource manager. It mounts a partition and
  serves the POSIX filesystem namespace over message passing: an
  application's `open`/`read`/`write`/`close` become messages that `fs-qrv`
  answers.

A typical bring-up mounts a real NVMe partition and runs programs from it:

```
mount -t qrv /dev/nvme0n1p5 /disk2
```

This path — block driver, partitioning, filesystem server, and the kernel
brokering every message between them — runs end-to-end both on QEMU and on
the SiFive Unmatched's NVMe drive.

---

## 8. User space

QRV boots through `sysinit`/`init`, brings up the serial console driver
(`devc-ser8250` on QEMU, `devc-sersifive` on the FU740), the PCI server, the
storage stack, and `getty`/`login`, and lands you at a shell prompt. The
headline user-space programs:

- **`sh` — `mksh`, the MirBSD Korn shell.** A real, scriptable POSIX shell
  is the system shell; boot scripts (`level1.sh`, …) are ordinary shell
  scripts.
- **`pidin`** — the classic QNX "process info" tool: lists processes,
  threads, their states, memory, and more. It is QRV's primary "is the
  system alive and well?" probe and its standard stress-test workload.
- **`lspci`** — enumerates the PCI/PCIe bus through the PCI server.
- **`sloginfo`** — dumps the system log collected by the `slogger` server.

Alongside these are the building blocks of a usable multi-user system:
`getty` and `login` (with credential/auth support), `mount`, `shutdown`,
`pipe`, and core utilities (`ls`, `cat`, …). Every QRV program is
**multi-threaded** — at minimum a main thread and a system thread — which is
exactly why correct SMP synchronization (see [§6](#6-the-big-kernel-lock--and-its-removal))
matters so much.

---

## 9. Building and running

### Toolchain

```
Cross-compiler : riscv64-linux-gnu-gcc
CPU flags      : -march=rv64g -mcmodel=medany -mno-relax
Build style    : -nostdinc -nostdlib -ffreestanding
```

### Common commands (run inside `os/`)

```bash
make                 # Build everything: startup + kernel + module package
make -Bj             # Force a full parallel rebuild (do this after header changes)
make startup         # Build startup only
make kernel          # Build kernel only
make modpkg          # Create the module package (CPIO)
make qemu            # Build and run in QEMU
./emu.sh             # Run in QEMU (4 CPUs, 256M RAM, virt machine)
./emu.sh -P 1        # Run with a single hart
./emu.sh -gdb        # Run with the GDB remote stub (port 1234)
```

The primary test platform is **`qemu-system-riscv64`** on the `virt`
machine. Configuration is Kconfig-based.

---

## 10. Running on real hardware

QRV's secondary-but-serious target is the **SiFive Unmatched (FU740)** — a
real RISC-V workstation board. Getting a microkernel that boots cleanly on
QEMU to also boot cleanly on physical silicon surfaced a class of bugs that
emulation simply does not exhibit, and chasing them down is much of what the
recent releases are about.

The defining example, fixed in **v0.43**: for two months QRV ran flawlessly
on QEMU and *faulted on iron*. On the FU740, **any** program — `pidin`,
`lspci`, anything — would crash after a handful of spawns, each crash
different from the last, the program counter wandering into garbage. The
cause turned out not to be memory corruption at all, but **instruction-cache
incoherence**: RISC-V guarantees no coherence between data stores and
instruction fetch, so freshly-loaded program code is invisible to a hart's
fetch unit until that hart executes `fence.i` — and code that will run on a
*different* hart than the one that loaded it needs a *remote* `fence.i`
there. QRV's loader did neither (it even computed an "invalidate I-cache"
flag and then threw it away). QEMU models no instruction cache, so the bug
was invisible there and deterministic on the U74.

The fix — a local plus SBI-broadcast `fence.i` (`cpu_icache_sync_all()`) at
every point where a page becomes executable — turned a spawn loop that
faulted every few runs into one that ran **past 600 consecutive spawns
clean** on the FU740. The full investigation, including the wrong hypothesis
it first produced and the diagnostic that overturned it, is the closing
section of chapter 14 of *The QRV Porting Story*.

The hardware milestones reached so far include booting to a `login:` prompt
in user-mode taskman on the FU740, and mounting and running test programs
from a real NVMe partition.

---

## 11. Closing remarks: why a free clone matters

QNX is one of the most influential microkernel designs ever shipped. Its
send/receive/reply model has taught generations of systems engineers what a
clean OS architecture can look like. And yet the code that embodies it has
spent more than a decade in a peculiar limbo: visible enough to study under
a community license, but not free enough to redistribute, evolve, or build a
living ecosystem around. A design this good deserves better than to be
preserved only as a read-only artifact.

That is the reason this work exists. QRV is, frankly, a transitional
vehicle — a way to learn the architecture deeply by porting it, by taking it
apart and putting it back together on new hardware, by removing the kernel
lock and lifting the process manager into user space and discovering exactly
which assumptions were load-bearing. Every bug chased down on real silicon,
every subsystem rewritten to be 64-bit clean, every proprietary boundary
dismantled, is knowledge that a truly free implementation will need.

Because the long-term goal is not to maintain a patched copy of someone
else's sources forever. It is a **fully free, from-scratch operating system
that is compatible with QNX's interfaces and faithful to its microkernel
philosophy, yet owes nothing to proprietary code** — one that can be used,
taught, shipped, and improved without asking anyone's permission. QRV is how
we prove that such a system is not only possible but practical, and how we
earn the experience to build it properly.

If you would like the historical foundations themselves to become free, add
your name to **`PETITION.md`**. And if you would like to see what a modern,
honestly-engineered microkernel looks like from the inside — clone the
recipe, run `obtain_proj.sh`, and read the code.

---

*QRV — adaptation and re-implementation of QNX Neutrino 6.4 for 64-bit
hardware. Started Christmas Eve 2020. Apache 2.0 (QRV's own code) +
BlackBerry QCL 2.0 (QNX-derived sources). See `WHAT_IS_WHAT.md` for the
component-by-component breakdown.*
