# WHAT_IS_WHAT.md — Provenance and Licensing Manifest

This document records the **origin and license of every file** in a QRV
source tree, so that anyone building or redistributing QRV knows exactly
which parts are freely-licensed QRV work and which parts descend from the
QNX Neutrino community sources and therefore carry the BlackBerry QNX
Community License.

It is the companion to `README.md` §2 (*Licensing*).

## How this tree is produced

QRV is distributed as a **reconstruction recipe**, not as a ready source
tree (see `README.md` §3). Running `./obtain_proj.sh`:

1. clones the upstream QNX community mirror (`github.com/vocho/openqnx`),
2. places the QNX-derived files according to `placement.txt`,
3. applies the QRV patch series from `patches/`,

and the result is the `os/` directory. **This manifest describes exactly
the files that end up in `os/`** — QRV's own internal files
(development docs, helper scripts, the `CLAUDE.md` notes, the historical
QNX reference texts under `doc/old_qnx/`, etc.) are *not* part of the
distribution and are *not* listed here.

The two sections below partition the distributed tree completely: every
file is in exactly one of them.

| Section | Files | License |
|---------|------:|---------|
| A — Free / openly-licensed | 512 | Apache-2.0, MIT, MirOS/BSD (per file) |
| B — QNX-derived            | 676 | BlackBerry QNX Community License (QCL) 2.0 |
| **Total distributed**      | **1188** | |

---

## Section A — Free / openly-licensed code

These files are QRV's own work or were adopted from other freely-licensed
projects. **The default license is the Apache License 2.0** (full text in
`LICENSE.txt`); the following adopted components keep their original
permissive licenses, which take precedence where they apply:

- **`userland/sh/`** — the **mksh** (MirBSD Korn Shell). MirOS license
  (a permissive BSD-style license); see the per-file headers.
- **`userland/devb-virtio/`** — virtio block driver of **xv6** ancestry.
  MIT license.
- A small number of **`lib/libc/`** components carry their own BSD-style
  headers (e.g. `strlcpy`, `crypt`/`sha512`); the file's own header
  comment governs.

In all cases, **the license header at the top of an individual file is
authoritative** for that file. The grouping below is by directory.

### `(top level)`

- `.gitignore`
- `Kconfig`
- `Makefile`
- `README.md`
- `def.mk`
- `emu.sh`

### `Licenses/Apache-2.0`

- `Apache_license_2.0.txt`

### `boot`

- `Makefile`
- `boot-qrv.txt`
- `boot.scr`

### `host_tools`

- `Makefile`
- `mkasmoff.c`
- `mkfs-qrv.c`
- `mkgpt.py`
- `treeqrvfs.c`

### `include`

- `ar.h`
- `assert.h`
- `cpio.h`
- `crypt.h`
- `ctype.h`
- `glob.h`
- `inttypes.h`
- `link.h`
- `minmax.h`
- `mkasmoff.h`
- `paths.h`
- `qrv_version.h`
- `regex.h`
- `search.h`
- `semaphore.h`
- `signal.h`
- `stdarg.h`
- `stdbool.h`
- `stdint-gcc.h`
- `stdint.h`
- `stdio.h`
- `string.h`
- `strings.h`
- `syslog.h`
- `wordexp.h`

### `include/arch`

- `context.h`
- `cpu.h`
- `cpu_asmoff.h`
- `cpu_attrs.h`
- `cpu_def.h`
- `cpu_inline.h`
- `cpu_paging.h`
- `cpu_pgtable.h`
- `cpu_startup.h`
- `defs_proto.h`
- `fault.h`
- `intr_controller.h`
- `kercpu.h`
- `ktrace.h`
- `pcpu.h`
- `platform.h`
- `plic_regs.h`
- `sbi.h`
- `sbi_ecall_interface.h`
- `smpxchg.h`
- `syspage.h`
- `trap_asm.h`
- `trapframe.h`

### `include/arch/asm`

- `image.h`

### `include/elf`

- `elf_riscv.h`

### `include/hw`

- `hwinfo_lookup.h`

### `include/pci`

- `pci.h`

### `include/sys`

- `_clocktypes.h`
- `_filetypes.h`
- `_idtypes.h`
- `_intsup.h`
- `_locale.h`
- `_multibytetypes.h`
- `_offsettypes.h`
- `_sizetypes.h`
- `_timetypes.h`
- `cdefs.h`
- `compiler.h`
- `cpio.h`
- `fdt.h`
- `features.h`
- `ioctl.h`
- `libc_cfg.h`
- `limits.h`
- `lock.h`
- `qrv_diag.h`
- `qrv_ident.h`
- `queue.h`
- `sockio.h`
- `spinlock.h`
- `types.h`

### `kernel`

- `Kconfig`
- `Makefile`
- `ker_call_tbl.c`
- `ker_call_tbl.h`
- `ker_init.c`
- `ker_sync.c`
- `ker_tm_priv.c`
- `kerlink.c`
- `kerlink.h`
- `klock_debug.c`
- `kprintf.c`
- `ksymtab.c`
- `ksymtab.h`
- `modpkg_elf.c`
- `modpkg_elf.h`
- `monitor.c`
- `objects.mk`
- `smr.c`
- `stall_detector.c`
- `stubs.c`
- `trace_ring.c`

### `kernel/arch/riscv`

- `Kconfig`
- `Makefile`
- `cpu_elf_reloc.c`
- `cpu_misc.c`
- `cpu_pgtable.c`
- `ker_exit.c`
- `kercalls.c`
- `kernel.S`
- `plic.c`
- `qrv_kernel.ld`
- `trap.S`
- `trap_handler.c`
- `xfer_jmp.S`

### `kernel/arch/riscv/include`

- `context.h`
- `cpu_asmoff.h`
- `cpu_attrs.h`
- `cpu_inline.h`
- `cpu_paging.h`
- `cpu_pgtable.h`
- `defs_proto.h`
- `fault.h`
- `intr_controller.h`
- `ktrace.h`
- `pcpu.h`
- `platform.h`
- `plic_regs.h`
- `sbi.h`
- `sbi_ecall_interface.h`
- `syspage.h`
- `trap_asm.h`
- `trapframe.h`

### `kernel/arch/riscv/include/asm`

- `image.h`

### `kernel/arch/riscv/platform/qemu_virt`

- `dbg_uart.c`
- `mem.c`

### `kernel/arch/riscv/startup`

- `board.c`
- `head.S`
- `init_asinfo.c`
- `init_cpu.c`
- `mmu.c`
- `print_syspage.h`

### `kernel/arch/x86_64/include`

- `cpu_inline.h`
- `syspage.h`

### `kernel/include`

- `asmmacro.h`
- `config.h`
- `cpu_elf.h`
- `kerext_mm_xboundary.h`
- `klock.h`
- `ksymtab.h`
- `log.h`
- `options.h`
- `pa_kerext.h`
- `paging.h`
- `percpu.h`
- `posix_types.h`
- `smr.h`
- `trace_ring.h`

### `kernel/include/ker+tm`

- `pa_pq_op.h`
- `qrv_kerlib.h`
- `tm_kercalls.h`
- `tm_proc_info.h`

### `kernel/kext`

- `kerext_aspace_memcpy.c`
- `kerext_exit.c`
- `kerext_manipulate.c`
- `kerext_mm_xboundary.c`
- `kerext_reboot.c`
- `kerext_register.c`
- `kerext_register_pool_stack.c`
- `kerext_smp.c`

### `kernel/mm`

- `mm_map_xfer.c`
- `mm_mcreate.c`
- `mm_vaddrinfo.c`
- `taskman_view.c`

### `kernel/startup`

- `Makefile`
- `init_intrinfo.c`
- `init_raminfo.c`
- `objects.mk`

### `kernel/startup/lib`

- `cpio.c`
- `mem.c`

### `kernel/trace+instr`

- `tr_dumper.c`

### `lib/libc`

- `Makefile`
- `compat.h`

### `lib/libc/1`

- `_exit.c`
- `dup.c`
- `gettimeofday.c`
- `kill.c`
- `localtime.c`
- `lseek.c`
- `raise.c`
- `setjmp.c`
- `sigaction.c`
- `signal.c`
- `sigprocmask.c`
- `strftime.c`

### `lib/libc/1/riscv`

- `_setjmp.S`

### `lib/libc/1b`

- `mem_offset.c`

### `lib/libc/1c`

- `pthread_attr_setdetachstate.c`

### `lib/libc/1c/riscv`

- `__my_thread_exit.S`

### `lib/libc/alloc`

- `malloc.c`
- `rtld_malloc.c`
- `rtld_malloc.h`

### `lib/libc/atomic/riscv`

- `atomic_rv64.S`

### `lib/libc/inc`

- `signal_state.h`

### `lib/libc/kercover`

- `MsgSendsvnc.c`

### `lib/libc/qrv`

- `crypt.c`
- `delay.c`
- `dladdr_stub.c`
- `getgrent.c`
- `getpass.c`
- `getpwent.c`
- `getspent.c`
- `kdebug_stub.c`
- `netmgr_stub.c`
- `posix_id.c`
- `posix_stubs.c`
- `progname.c`
- `sha512.c`
- `sha512.h`
- `signal_state.c`
- `syspage_ptr.c`
- `tell64.c`
- `time.c`
- `tls.c`

### `lib/libc/riscv`

- `crt0.S`
- `syscalls.c`
- `syschan_init.c`

### `lib/libc/services`

- `procmgr_detach.c`
- `sysmgr_console_set.c`

### `lib/libc/stdio`

- `clearerr.c`
- `fclose.c`
- `fdopen.c`
- `feof.c`
- `ferror.c`
- `fflush.c`
- `fgetc.c`
- `fgets.c`
- `fileno.c`
- `findfp.c`
- `flags.c`
- `fopen.c`
- `fprintf.c`
- `fputc.c`
- `fputs.c`
- `fread.c`
- `fseek.c`
- `ftell.c`
- `fvwrite.c`
- `fvwrite.h`
- `fwrite.c`
- `local.h`
- `makebuf.c`
- `perror.c`
- `printf.c`
- `putc.c`
- `putchar.c`
- `puts.c`
- `refill.c`
- `rget.c`
- `setvbuf.c`
- `snprintf.c`
- `sprintf.c`
- `stdio.c`
- `strerror.c`
- `ungetc.c`
- `vfprintf.c`
- `vprintf.c`
- `vsnprintf.c`
- `wbuf.c`
- `wsetup.c`

### `lib/libc/stdlib`

- `abort.c`
- `abs.c`
- `atoi.c`
- `atol.c`
- `atoll.c`
- `basename.c`
- `bsearch.c`
- `div.c`
- `exit.c`
- `fnmatch.c`
- `getenv.c`
- `getopt.c`
- `getsubopt.c`
- `labs.c`
- `ldiv.c`
- `qsort.c`
- `strtol.c`
- `strtoll.c`
- `strtoul.c`
- `strtoull.c`

### `lib/libc/string`

- `bcopy.c`
- `bzero.c`
- `memccpy.c`
- `memchr.c`
- `memcmp.c`
- `memcpy.c`
- `memmove.c`
- `memset.c`
- `strcasecmp.c`
- `strcat.c`
- `strchr.c`
- `strchrnul.c`
- `strcmp.c`
- `strcpy.c`
- `strcspn.c`
- `strdup.c`
- `strlcat.c`
- `strlcpy.c`
- `strlen.c`
- `strncat.c`
- `strncmp.c`
- `strncpy.c`
- `strpbrk.c`
- `strrchr.c`
- `strsep.c`
- `strspn.c`
- `strstr.c`
- `strtok.c`

### `lib/libc/support`

- `assert.c`
- `dbgprintf.c`

### `lib/libgpt`

- `Makefile`
- `crc32.c`
- `gpt.c`
- `libgpt.h`
- `test_gpt.c`

### `lib/libpci`

- `Makefile`
- `pci_client.c`
- `pci_strerror.c`

### `lib/rtld`

- `Makefile`
- `Symbol.map`
- `debug.c`
- `debug.h`
- `elf-hints.h`
- `libmap.c`
- `libmap.h`
- `map_object.c`
- `notes.h`
- `qrv_rtld_stubs.c`
- `qrv_syscalls.c`
- `qrv_syscalls.h`
- `rtld.c`
- `rtld.h`
- `rtld_compat.h`
- `rtld_libc.h`
- `rtld_lock.c`
- `rtld_lock.h`
- `rtld_malloc.c`
- `rtld_malloc.h`
- `rtld_paths.h`
- `rtld_printf.c`
- `rtld_printf.h`
- `rtld_tls.h`
- `rtld_utrace.h`
- `xmalloc.c`

### `lib/rtld/machine`

- `asm.h`
- `atomic.h`
- `elf.h`
- `tls.h`

### `lib/rtld/riscv`

- `reloc.c`
- `rtld_machdep.h`
- `rtld_start.S`

### `servers/pci`

- `Makefile`
- `ecam.c`
- `pci_dw_atu.c`
- `pci_dwmsi.c`
- `pci_msix.c`

### `servers/slogger`

- `Makefile`

### `taskman`

- `Kconfig`
- `Makefile`
- `chk_qkx_syms.sh`

### `taskman/include`

- `mm_map_head.h`
- `pa_pq.h`
- `tm_log.h`
- `tm_process.h`

### `taskman/mem`

- `pa.c`

### `taskman/mem/riscv`

- `cpu_mm_internal.h`
- `cpu_pageman.c`
- `pageman_aspace.c`
- `pageman_init_mem.c`
- `pageman_map_xfer.c`
- `pte_temp_map.c`

### `taskman/path`

- `cpiofs.c`
- `pinode.h`
- `sysfs.c`

### `taskman/proc`

- `kerext_wrappers.c`
- `process_kercalls.c`
- `procmgr_detach.c`
- `procmgr_exit.c`
- `procmgr_kill.c`
- `procmgr_syschan.c`

### `taskman/sys`

- `bootimage_init.c`
- `misc.c`
- `sysmgr_console.c`
- `tm_log.c`
- `tm_process.c`

### `taskman/sys/riscv`

- `cpudeps.h`

### `userland`

- `Makefile`
- `init`

### `userland/devb-nvme`

- `Makefile`
- `main.c`
- `nvme.h`
- `nvme_admin.c`
- `nvme_ctrl.c`
- `nvme_io.c`
- `nvme_ist.c`
- `nvme_resmgr.c`

### `userland/devb-virtio`

- `Makefile`
- `main.c`
- `virtio_blk.c`
- `virtio_blk.h`

### `userland/devc-ser8250`

- `Makefile`
- `main.c`

### `userland/devc-sersifive`

- `Makefile`
- `main.c`

### `userland/esh`

- `Makefile`

### `userland/fs-qrv`

- `Makefile`
- `bio.c`
- `bio.h`
- `fs.c`
- `fs.h`
- `main.c`

### `userland/getty`

- `Makefile`
- `getty.c`

### `userland/login`

- `Makefile`
- `login.c`

### `userland/lspci`

- `Makefile`
- `lspci.c`

### `userland/mount`

- `Makefile`
- `fstab.c`
- `fstab.h`
- `vfslist.c`

### `userland/pidin`

- `Makefile`
- `pidin.use`

### `userland/pipe`

- `Makefile`

### `userland/sh`

- `.clang-format`
- `License-mksh-orig.txt`
- `Makefile`
- `coproc.c`
- `edit.c`
- `eval.c`
- `exec.c`
- `expr.c`
- `funcs.c`
- `funcs_alias.c`
- `funcs_io.c`
- `funcs_jobs.c`
- `funcs_read.c`
- `funcs_shctl.c`
- `funcs_test.c`
- `funcs_time.c`
- `histrap.c`
- `io.c`
- `jobs.c`
- `lalloc.c`
- `lex.c`
- `main.c`
- `misc.c`
- `shell.c`
- `shf.c`
- `strlcpy.c`
- `syn.c`
- `tbl.c`
- `tempfile.c`
- `tree.c`
- `ulimit.c`
- `var.c`

### `userland/sh/gen`

- `rlimits.gen`
- `sh_flags.gen`
- `signames.inc`
- `ulimits.gen`

### `userland/sh/include`

- `cclass.h`
- `env.h`
- `exprtok.h`
- `lex.h`
- `mbsdcc.h`
- `mbsdint.h`
- `mirhash.h`
- `mksh_config.h`
- `msgs.h`
- `proto.h`
- `sh.h`
- `shf.h`
- `tree.h`
- `var.h`
- `var_spec.h`

### `userland/sloginfo`

- `Makefile`

### `userland/sysinit`

- `level1.sh`

### `userland/test`

- `Makefile`
- `main.c`
- `printf_test.c`
- `setjmp_test.c`
- `signals_test.c`
- `sync.c`
- `test.h`
- `timers.c`

### `userland/utils`

- `Makefile`
- `authtest.c`
- `cat.c`
- `crypttest.c`
- `ls.c`
- `shutdown.c`
- `syscmd.c`

---

## Section B — QNX-derived code (BlackBerry QNX Community License 2.0)

Every file below descends from the QNX Neutrino community source release
and is governed by the **BlackBerry QNX Community License (QCL) 2.0**,
which permits non-commercial and academic use of the derived sources. QRV
may carry substantial modifications to these files, but their QNX
ancestry means they remain under the QCL — they are **not** redistributed
by this repository (that is why `obtain_proj.sh` fetches them from the
upstream mirror and patches them locally on your machine).

The grouping below is by directory.

### `Licenses/QNX`

- `QCL_2.0.txt`

### `include`

- `alloca.h`
- `atomic.h`
- `confname.h`
- `devctl.h`
- `dirent.h`
- `dlfcn.h`
- `err.h`
- `errno.h`
- `fcntl.h`
- `fnmatch.h`
- `ftw.h`
- `grp.h`
- `gulliver.h`
- `intr.h`
- `iso646.h`
- `libc.h`
- `libelf.h`
- `libgen.h`
- `limits.h`
- `malloc.h`
- `mqueue.h`
- `process.h`
- `pthread.h`
- `pwd.h`
- `sched.h`
- `setjmp.h`
- `shadow.h`
- `share.h`
- `spawn.h`
- `stdlib.h`
- `sync.h`
- `termcap.h`
- `termios.h`
- `time.h`
- `ucontext.h`
- `unistd.h`
- `utime.h`

### `include/devctl`

- `dcmd_all.h`
- `dcmd_chr.h`
- `dcmd_misc.h`
- `dcmd_proc.h`

### `include/elf`

- `elf_386.h`
- `elf_dyn.h`
- `elf_notes.h`
- `elf_nto.h`
- `elftypes.h`

### `include/hw`

- `inout.h`
- `pci.h`
- `sysinfo.h`

### `include/malloc`

- `malloc-debug.h`
- `malloc-lib.h`
- `prototypes.h`

### `include/sys`

- `_pthreadtypes.h`
- `_schedtypes.h`
- `_signaltypes.h`
- `_synctypes.h`
- `asyncmsg.h`
- `auxv.h`
- `conf.h`
- `debug.h`
- `dir.h`
- `dispatch.h`
- `elf.h`
- `fault.h`
- `ftype.h`
- `gcc_lp64.h`
- `iofunc.h`
- `iomgr.h`
- `iomsg.h`
- `ipc.h`
- `kdebug.h`
- `kercalls.h`
- `link.h`
- `memmsg.h`
- `mman.h`
- `mount.h`
- `msg.h`
- `netmgr.h`
- `netmsg.h`
- `param.h`
- `pathmgr.h`
- `pathmsg.h`
- `pci_serv.h`
- `perfregs.h`
- `platform.h`
- `poll.h`
- `posix_spawn.h`
- `procfs.h`
- `procmgr.h`
- `procmsg.h`
- `profiler.h`
- `qrv_core.h`
- `resmgr.h`
- `resource.h`
- `rsrcdbmgr.h`
- `rsrcdbmsg.h`
- `select.h`
- `sem.h`
- `siginfo.h`
- `slog.h`
- `slogcodes.h`
- `stat.h`
- `states.h`
- `statvfs.h`
- `storage.h`
- `sysmgr.h`
- `sysmsg.h`
- `syspage.h`
- `termio.h`
- `time.h`
- `times.h`
- `trace.h`
- `uio.h`
- `utsname.h`
- `wait.h`

### `kernel`

- `asmoff.c`
- `cpu_debug.c`
- `dbg_rec.c`
- `externs.h`
- `idle.c`
- `init.c`
- `ker_channel.c`
- `ker_clock.c`
- `ker_connect.c`
- `ker_fastmsg.c`
- `ker_interrupt.c`
- `ker_message.c`
- `ker_net.c`
- `ker_sched.c`
- `ker_sys.c`
- `ker_thread.c`
- `ker_timer.c`
- `kerargs.h`
- `kermacros.h`
- `kernel_entry.c`
- `kernel_init.c`
- `kerproto.h`
- `kertrace.h`
- `kexterns.c`
- `kgetopt.c`
- `shutdown.c`
- `smp_flush_tlb.c`
- `smp_get_cpunum.c`
- `walk_asinfo.c`

### `kernel/arch/riscv`

- `cpu_pte.c`
- `pageman_aspace.c`

### `kernel/arch/riscv/include`

- `cpu.h`
- `cpu_def.h`
- `cpu_startup.h`
- `kercpu.h`
- `smpxchg.h`

### `kernel/arch/riscv/startup`

- `arch_init.c`
- `debug.c`
- `print_syspage.c`
- `startup_entry.c`

### `kernel/arch/x86_64`

- `_cstart_.S`
- `_xfer_fault_handler.S`
- `cpu_asmoff.h`
- `cpu_debug.c`
- `cpu_misc.c`
- `cpu_perfregs.c`
- `hook_idle.S`
- `hook_trace.S`
- `hw_cpuid.s`
- `init_cpu.c`
- `kdebug.c`
- `kercpu.h`
- `kernel.S`
- `nano_fpu.c`
- `nano_v86.S`
- `nano_xfer_check.S`
- `nano_xfer_cpy.S`
- `nano_xfer_msg.S`
- `nano_xfer_pulse.S`
- `out_intr_mask.S`
- `out_intr_unmask.S`
- `out_kd_request.S`
- `out_kdebug_path.S`
- `out_trace_event.S`
- `out_vtop.S`
- `syscall_template.sh`
- `util.ah`
- `xfer_jmp.S`

### `kernel/arch/x86_64/include`

- `bios.h`
- `boot_rec.h`
- `context.h`
- `cpu.h`
- `cpu_def.h`
- `cpuinline.h`
- `cpumsg.h`
- `defs_proto.h`
- `fault.h`
- `inline.h`
- `inout.h`
- `kern_def.h`
- `ktrace.h`
- `mman.h`
- `platform.h`
- `proto.h`
- `smpxchg.h`
- `string.h`
- `u386.h`
- `v86.h`

### `kernel/arch/x86_64/smp`

- `_smpstart.S`
- `init_smp.c`
- `smp_get_cpunum.S`
- `smp_send_ipi.c`

### `kernel/include`

- `debug.h`
- `event.h`
- `kerext.h`
- `macros.h`
- `memclass.h`
- `memmgr_hooks.h`
- `objects.h`
- `proto.h`
- `query.h`
- `smpswitch.h`
- `startup.h`
- `startup_proto.h`
- `variables.h`

### `kernel/kext`

- `kerext_bind.c`
- `kerext_cred.c`
- `kerext_debug.c`
- `kerext_idle.c`
- `kerext_limits.c`
- `kerext_misc.c`
- `kerext_page.c`
- `kerext_process.c`
- `kerext_query.c`
- `kerext_reparent.c`
- `kerext_signal.c`
- `kerext_stack.c`
- `kerext_sysaddr.c`
- `kerext_trace.c`
- `kerext_vaddrinfo.c`
- `pa.c`

### `kernel/mm`

- `mm.c`

### `kernel/nano`

- `nano_alloc.c`
- `nano_asyncmsg.c`
- `nano_clock.c`
- `nano_connect.c`
- `nano_cred.c`
- `nano_debug.c`
- `nano_event.c`
- `nano_fault.c`
- `nano_interrupt.c`
- `nano_kerdebug.c`
- `nano_lookup.c`
- `nano_message.c`
- `nano_misc.c`
- `nano_object.c`
- `nano_pulse.c`
- `nano_query.c`
- `nano_sched.c`
- `nano_smp_interrupt.c`
- `nano_specret.c`
- `nano_sync.c`
- `nano_syspage.c`
- `nano_thread.c`
- `nano_timer.c`
- `nano_trace.c`
- `nano_vector.c`
- `nano_xfer.c`
- `nano_xfer_check.c`
- `nano_xfer_cpy.c`
- `nano_xfer_len.c`
- `nano_xfer_msg.c`
- `nano_xfer_pulse.c`

### `kernel/startup`

- `addr_space.c`
- `common_options.c`
- `cpu_syspage_memory.c`
- `hardware_init.c`
- `hwi.c`
- `private.c`
- `ram.c`
- `smp.c`
- `syspage_memory.c`

### `kernel/startup/lib`

- `getopt.c`
- `strtoul.c`
- `typed_strings.c`
- `util.c`

### `kernel/trace+instr`

- `ker_instr.c`
- `ker_trace.c`

### `lib/libc/1`

- `access.c`
- `chdir.c`
- `chroot.c`
- `close.c`
- `creat.c`
- `fcntl.c`
- `fdatasync.c`
- `fpathconf.c`
- `fstat.c`
- `getcwd.c`
- `getgroups.c`
- `iodir.c`
- `isatty.c`
- `open.c`
- `pipe.c`
- `read.c`
- `setids.c`
- `setpgid.c`
- `sleep.c`
- `stat.c`
- `sysconf.c`
- `tcgetattr.c`
- `tcgetpgrp.c`
- `tcsetattr.c`
- `tcsetpgrp.c`
- `tcsetsid.c`
- `unlink.c`
- `waitpid.c`
- `write.c`

### `lib/libc/1a`

- `confstr.c`
- `readlink.c`

### `lib/libc/1b`

- `mmap.c`
- `mprotect.c`
- `msync.c`
- `munmap.c`
- `nanosleep.c`
- `pwrite.c`
- `sched_yield.c`

### `lib/libc/1c`

- `pthread_attr_default.c`
- `pthread_attr_init.c`
- `pthread_attr_setstacksize.c`
- `pthread_cond_broadcast.c`
- `pthread_cond_destroy.c`
- `pthread_cond_init.c`
- `pthread_cond_signal.c`
- `pthread_cond_timedwait.c`
- `pthread_cond_wait.c`
- `pthread_condattr_destroy.c`
- `pthread_condattr_init.c`
- `pthread_condattr_setclock.c`
- `pthread_create.c`
- `pthread_detach.c`
- `pthread_exit.c`
- `pthread_getspecific.c`
- `pthread_key_create.c`
- `pthread_key_data.c`
- `pthread_mutex_destroy.c`
- `pthread_mutex_init.c`
- `pthread_mutex_lock.c`
- `pthread_mutex_trylock.c`
- `pthread_mutex_unlock.c`
- `pthread_mutexattr_destroy.c`
- `pthread_mutexattr_init.c`
- `pthread_mutexattr_setrecursive.c`
- `pthread_once.c`
- `pthread_self.c`
- `pthread_setspecific.c`

### `lib/libc/1d`

- `posix_spawn.c`
- `posix_spawn_file_actions.h`
- `posix_spawn_file_actions_init.c`
- `posix_spawn_file_actions_private.c`
- `posix_spawn_file_actions_support.c`
- `posix_spawn_file_getactions.c`
- `posix_spawnattr.h`
- `posix_spawnattr_getflags.c`
- `posix_spawnattr_getnode.c`
- `posix_spawnattr_getpgroup.c`
- `posix_spawnattr_getrunmask.c`
- `posix_spawnattr_getsched.c`
- `posix_spawnattr_getsig.c`
- `posix_spawnattr_getstackmax.c`
- `posix_spawnattr_init.c`
- `posix_spawnattr_private.c`
- `posix_spawnattr_support.c`
- `posix_spawnp.c`

### `lib/libc/dispatch`

- `_thread_pool_thread.c`
- `data.c`
- `dispatch.c`
- `dispatch.h`
- `dispatch_select.c`
- `dispatch_sigwait.c`
- `message.c`
- `resmgr.c`
- `resmgr_detach.c`
- `thread_pool.c`
- `thread_pool_ctrl.c`
- `vec_util.c`

### `lib/libc/inc`

- `connect.h`
- `cpucfg.h`
- `iofunc.h`
- `pthread_key.h`
- `sleepon.h`

### `lib/libc/iofunc`

- `_iofunc_create.c`
- `_iofunc_lock.c`
- `_iofunc_misc.c`
- `_iofunc_open.c`
- `iofunc_attr_init.c`
- `iofunc_attr_lock.c`
- `iofunc_attr_trylock.c`
- `iofunc_attr_unlock.c`
- `iofunc_check_access.c`
- `iofunc_chmod.c`
- `iofunc_chmod_default.c`
- `iofunc_chown.c`
- `iofunc_chown_default.c`
- `iofunc_client_info.c`
- `iofunc_close_dup.c`
- `iofunc_close_dup_default.c`
- `iofunc_close_ocb.c`
- `iofunc_close_ocb_default.c`
- `iofunc_devctl.c`
- `iofunc_devctl_default.c`
- `iofunc_fdinfo.c`
- `iofunc_fdinfo_default.c`
- `iofunc_func_init.c`
- `iofunc_llist_lock.c`
- `iofunc_lock.c`
- `iofunc_lock_default.c`
- `iofunc_lock_ocb_default.c`
- `iofunc_lseek.c`
- `iofunc_lseek_default.c`
- `iofunc_mmap.c`
- `iofunc_mmap_default.c`
- `iofunc_notify.c`
- `iofunc_notify_remove.c`
- `iofunc_notify_trigger.c`
- `iofunc_ocb_attach.c`
- `iofunc_ocb_calloc.c`
- `iofunc_ocb_detach.c`
- `iofunc_open.c`
- `iofunc_open_default.c`
- `iofunc_openfd.c`
- `iofunc_openfd_default.c`
- `iofunc_pathconf.c`
- `iofunc_pathconf_default.c`
- `iofunc_read_default.c`
- `iofunc_read_verify.c`
- `iofunc_sleepon.c`
- `iofunc_stat.c`
- `iofunc_stat_default.c`
- `iofunc_sync_default.c`
- `iofunc_sync_verify.c`
- `iofunc_time_update.c`
- `iofunc_unblock.c`
- `iofunc_unblock_default.c`
- `iofunc_unlink.c`
- `iofunc_unlock_ocb_default.c`
- `iofunc_utime.c`
- `iofunc_utime_default.c`
- `iofunc_write_default.c`
- `iofunc_write_verify.c`

### `lib/libc/kercover`

- `timertimeout.c`

### `lib/libc/qrv`

- `__getset_thread_name.c`
- `devctl.c`
- `iofdinfo.c`
- `itoa.c`
- `lltoa.c`
- `ltoa.c`
- `nsec2timespec.c`
- `openfd.c`
- `sigaddset.c`
- `sigdelset.c`
- `sigemptyset.c`
- `sigfillset.c`
- `sigismember.c`
- `sleepon.c`
- `sopen.c`
- `spawn.c`
- `spawnp.c`
- `straddstr.c`
- `ulltoa.c`
- `ultoa.c`
- `utoa.c`

### `lib/libc/resmgr`

- `_resmgr_access.c`
- `_resmgr_close_handler.c`
- `_resmgr_connect_handler.c`
- `_resmgr_detach_id.c`
- `_resmgr_disconnect_handler.c`
- `_resmgr_dup_handler.c`
- `_resmgr_handle.c`
- `_resmgr_handle_grow.c`
- `_resmgr_handler.c`
- `_resmgr_io_func.c`
- `_resmgr_io_handler.c`
- `_resmgr_iofuncs.c`
- `_resmgr_link_alloc.c`
- `_resmgr_link_free.c`
- `_resmgr_link_handler.c`
- `_resmgr_link_query.c`
- `_resmgr_mmap_handler.c`
- `_resmgr_mount_handler.c`
- `_resmgr_notify_handler.c`
- `_resmgr_ocb.c`
- `_resmgr_openfd_handler.c`
- `_resmgr_thread.c`
- `_resmgr_unbind.c`
- `_resmgr_unblock_handler.c`
- `resmgr.h`
- `resmgr_again.c`
- `resmgr_data.c`
- `resmgr_devino.c`
- `resmgr_endian.c`
- `resmgr_msgread.c`
- `resmgr_msgreadv.c`
- `resmgr_msgwrite.c`
- `resmgr_msgwritev.c`
- `resmgr_open_bind.c`
- `resmgr_pathname.c`
- `resmgr_pulse_attach.c`

### `lib/libc/services`

- `_rsrcdbmgr_pack.c`
- `pathmgr_link.c`
- `pathmgr_symlink.c`
- `procmgr_session.c`
- `rsrcdbmgr_attach.c`
- `rsrcdbmgr_create.c`
- `rsrcdbmgr_destroy.c`
- `rsrcdbmgr_detach.c`
- `rsrcdbmgr_minor_attach.c`
- `rsrcdbmgr_minor_detach.c`
- `rsrcdbmgr_query.c`
- `slog.c`
- `slogdata.c`
- `sysmgr_confstr_set.c`

### `lib/libc/support`

- `__dir_keep_symlink.c`
- `__posixly_correct.c`
- `_conf_destroy.c`
- `_conf_get.c`
- `_conf_set.c`
- `_connect.c`
- `_connect_combine.c`
- `_connect_ctrl.c`
- `_connect_entry.c`
- `_connect_fd.c`
- `_connect_object.c`
- `_devctl.c`
- `_notifyreadxv.c`
- `_vopen.c`

### `lib/libc/unix`

- `wait4.c`

### `lib/libc/xopen`

- `waitid.c`

### `servers/pci`

- `pci_attach.c`
- `pci_bridge.c`
- `pci_client.c`
- `pci_config.c`
- `pci_enum.c`
- `pci_globals.c`
- `pci_globals.h`
- `pci_main.c`
- `pci_resource.c`
- `pci_scan.c`
- `pcidrvr.h`
- `server.h`

### `servers/slogger`

- `externs.c`
- `externs.h`
- `io_notify.c`
- `io_read.c`
- `io_unblock.c`
- `io_unlink.c`
- `io_write.c`
- `logger.c`
- `main.c`
- `options.c`
- `proto.h`
- `struct.h`

### `taskman/include`

- `externs.h`
- `memmgr_proto.h`
- `pageman.h`
- `pathmgr_node.h`
- `pathmgr_object.h`
- `pathmgr_proto.h`
- `procmgr_proto.h`
- `rsrcdbmgr.h`
- `rsrcdbmsg.h`
- `struct.h`
- `sysmgr_proto.h`

### `taskman/mem`

- `memmgr_ctrl.c`
- `memmgr_debug_info.c`
- `memmgr_fd.c`
- `memmgr_info.c`
- `memmgr_init.c`
- `memmgr_map.c`
- `memmgr_offset.c`
- `memmgr_shmem.c`
- `memmgr_support.c`
- `memmgr_tymem.c`
- `mm_anmem.c`
- `mm_internal.h`
- `mm_map.c`
- `mm_memobj.c`
- `mm_memref.c`
- `mm_pte.c`
- `mm_reference.c`
- `mm_rlimit.c`
- `mm_sysaddr.c`
- `mm_temp_map.c`
- `pa.h`

### `taskman/mem/pageman`

- `pageman_configure.c`
- `pageman_debuginfo.c`
- `pageman_dup.c`
- `pageman_fault.c`
- `pageman_madvise.c`
- `pageman_mapinfo.c`
- `pageman_mcreate.c`
- `pageman_mdestroy.c`
- `pageman_memobj_phys.c`
- `pageman_mmap.c`
- `pageman_mprotect.c`
- `pageman_msync.c`
- `pageman_munmap.c`
- `pageman_pmem_add.c`
- `pageman_resize.c`
- `pageman_swapper.c`
- `pageman_vaddr_to_memobj.c`
- `pageman_vaddrinfo.c`
- `pageman_validate.c`

### `taskman/mem/x86_64`

- `cpu_mm_internal.h`
- `cpu_pa.c`
- `cpu_pageman.c`
- `pageman_aspace.c`
- `pageman_init_mem.c`
- `pageman_map_xfer.c`
- `pageman_vaddr_to_memobj.c`
- `x86_mtrr.c`

### `taskman/path`

- `devmem.c`
- `devnull.c`
- `devstd.c`
- `devtext.c`
- `devtty.c`
- `devzero.c`
- `namedsem.c`
- `pathmgr_init.c`
- `pathmgr_link.c`
- `pathmgr_netmgr_pid.c`
- `pathmgr_node.c`
- `pathmgr_object.c`
- `pathmgr_open.c`
- `pathmgr_resolve.c`
- `procfs.c`
- `procfs.h`

### `taskman/proc`

- `procmgr_coredump.c`
- `procmgr_daemon.c`
- `procmgr_event.c`
- `procmgr_fork.c`
- `procmgr_getsetid.c`
- `procmgr_guardian.c`
- `procmgr_init.c`
- `procmgr_internal.h`
- `procmgr_misc.c`
- `procmgr_posix_spawn.c`
- `procmgr_resource.c`
- `procmgr_session.c`
- `procmgr_setpgid.c`
- `procmgr_spawn.c`
- `procmgr_stack.c`
- `procmgr_umask.c`
- `procmgr_wait.c`

### `taskman/sys`

- `gcov_begin.c`
- `gcov_end.c`
- `loader_elf.c`
- `main.c`
- `message.c`
- `proc_loader.c`
- `proc_read.c`
- `rsrcdbmgr_api.c`
- `rsrcdbmgr_cmd.c`
- `rsrcdbmgr_init.c`
- `rsrcdbmgr_list.c`
- `rsrcdbmgr_minor.c`
- `rsrcdbmgr_seed.c`
- `support.c`
- `sysmgr_cmd.c`
- `sysmgr_conf.c`
- `sysmgr_init.c`

### `taskman/sys/x86_64`

- `cpudeps.h`

### `userland/esh`

- `esh.c`

### `userland/mount`

- `mount.c`

### `userland/pidin`

- `pidin.c`
- `pidin.h`
- `pidin_data.c`
- `pidin_proc.c`
- `syspage.c`

### `userland/pipe`

- `main.c`

### `userland/sloginfo`

- `sloginfo.c`

---

*Generated for QRV v0.43. If you add or remove files, regenerate this
manifest so it continues to match the actual `os/` tree.*
