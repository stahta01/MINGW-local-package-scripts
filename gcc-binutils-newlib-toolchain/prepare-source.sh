# import custom-settings.sh file
  source custom-settings.sh

  # Extract binutils, GCC, and Newlib packages
  mkdir -p ${_source_folder}
  cd ${_source_folder}
  echo "Delete files in src-binutil"
  [ -d src-binutils ] && rm -rf src-binutils
  echo "Delete files in src-newlib"
  [ -d src-newlib ] && rm -rf src-newlib
  echo "Delete files in src-gcc"
  [ -d src-gcc ] && rm -rf src-gcc
  mkdir src-binutils
  mkdir src-newlib
  mkdir src-gcc


  if [[ ${VERSION_BINUTILS:0:4} == "2.16" ]] ; then
    cd src-binutils
    p7zip -d binutils-2.16.x.7z
    cd ..
  else
    echo "Extract ${TAR_BASENAME_BINUTILS}"
    tar -xjf ${_downloaded_files}/${TAR_BASENAME_BINUTILS}.tar.bz2 -C src-binutils --strip-components 1 --checkpoint=500
  fi
  echo "Extract ${TAR_BASENAME_NEWLIB}"
  tar -xzf ${_downloaded_files}/${TAR_BASENAME_NEWLIB}.tar.gz -C src-newlib --strip-components 1 --checkpoint=500
  echo "Extract ${TAR_BASENAME_GCC}"
  tar -xjf ${_downloaded_files}/${TAR_BASENAME_GCC}.tar.bz2 -C src-gcc --strip-components 1 --checkpoint=500


  cd ${_source_folder}/src-gcc
  echo "Patching GCC"
  if [[ ${VERSION_GCC:0:5} == "3.3.6" ]] ; then
    patch -p1 --forward -i ../../001-gcc-3.3.6-s12x-20121024_changes.patch
    patch -p1 --forward -i ../../002-gcc-3.3.6-define-POSIX-signals.patch
    patch -p1 --forward -i ../../003-gcc-3.3.6-replace-fcntl-F_DUPFD-with-dup2.patch
    patch -p1 --forward -i ../../004-gcc-3.3.6-define-kill.patch
  fi
  if [[ ${VERSION_GCC:0:3} == "4.3" || ${VERSION_GCC:0:3} == "4.4" ]] ; then
    patch -p1 --forward -i ../../101-gcc-4.3-fixed-compile-issue-with-gcc-5.patch
  fi
  if [[ ${VERSION_GCC:0:3} == "4.3" ]] ; then
    patch -p1 --forward -i ../../103-gcc-4.3-Fix-texi-docs-syntax-errors.patch
  fi
  if [[ ${VERSION_GCC:0:3} == "4.4" ]] ; then
    patch -p1 --forward -i ../../104-gcc-4.4-Fix-texi-docs-syntax-errors.patch
  fi
  if [[ ${VERSION_GCC:0:3} == "4.5" ]] ; then
    patch -p1 --forward -i ../../105-gcc-4.5-Fix-texi-docs-syntax-errors.patch
  fi
  if [[ ${VERSION_GCC:0:3} == "4.6" ]] ; then
    if [[ ${VERSION_GCC} == "4.6.4" ]] ; then
      patch -p1 --forward -i ../../108-gcc-4.6.4-Fix-texi-docs-syntax-errors.patch
    else
      patch -p1 --forward -i ../../106-gcc-4.6-Fix-texi-docs-syntax-errors.patch
    fi
  fi
  if [[ ${VERSION_GCC:0:3} == "4.5"  || ${VERSION_GCC:0:3} == "4.6" ]] ; then
    patch -p1 --forward -i ../../102-gcc-4.5-cfns-fix-mismatch-in-gnu_inline-attributes.patch
  fi
  patch -p1 --forward -i ../../130-dont-escape-arguments-that-dont-need-it-in-pex-win32.c.patch
  patch -p1 --forward -i ../../140-fix-for-windows-not-minding-non-existant-parent-dirs.patch
  patch -p1 --forward -i ../../150-windows-lrealpath-no-force-lowercase-nor-backslash.patch

  cd ${_source_folder}/src-newlib
  echo "Patching Newlib"
  if [[ ${VERSION_NEWLIB:0:6} == "1.16.0" ]] ; then
    patch -p1 --forward -i ../../302-newlib-1.16-changed-seek-offset-from-int-to-_fpos_t.patch
    patch -p1 --forward -i ../../305-newlib-1.16-Patch-newlib-with-new-subdirectories-and-build-suppo.patch
    patch -p1 --forward -i ../../306-newlib-1.16-Import-CoCo-system-files.patch
    patch -p1 --forward -i ../../307-newlib-1.16-Say-that-6809-is-big-endian.patch
    patch -p1 --forward -i ../../308-newlib-1.16-Configure-jmpbuf-size-for-6809.patch
    patch -p1 --forward -i ../../309-newlib-1.16-Add-6809-machines-systems-to-subdirs.patch
    patch -p1 --forward -i ../../310-newlib-1.16-Add-m6809-to-libgloss-subdirs.patch
    patch -p1 --forward -i ../../311-newlib-1.16-Don-t-try-to-emit-a-.stabs-for-a-linker-warning-6809.patch
    patch -p1 --forward -i ../../313-newlib-1.16-Fix-read-and-write-system-call-return-codes.patch
    patch -p1 --forward -i ../../314-newlib-1.16-make-_POINTER_INT-proper-size.patch
    patch -p1 --forward -i ../../316-newlib-1.16-updated-sys-config.h.patch
    patch -p1 --forward -i ../../318-newlib-1.16-improved-setjmp-longjmp.patch
    patch -p1 --forward -i ../../322-newlib-1.16-added-optimized-memcpy-memset.patch
    patch -p1 --forward -i ../../323-newlib-1.16-added-target-libgloss-to-noconfigdirs.patch
    patch -p1 --forward -i ../../325-newlib-1.16-minor-changes-to-config.patch
    patch -p1 --forward -i ../../327-newlib-1.16-added-setdp-to-regs.h.patch
    patch -p1 --forward -i ../../330-newlib-1.16-improved-regs.h.patch
    patch -p1 --forward -i ../../331-newlib-1.16-cc-reg-only-for-bit-test.patch
    patch -p1 --forward -i ../../332-newlib-1.16-added-support-for-__ABI_STACK__.patch
    patch -p1 --forward -i ../../334-newlib-1.16-compat.patch

#    patch -p1 --forward -i ../../m6812-elf/newlib-1.16.0-s12x.patch
  fi
  if [[ ${VERSION_NEWLIB:0:4} == "1.20" ]] ; then
    patch -p1 --forward -i ../../301-newlib-1.20-remove-conflicting-types-from-headers.patch
  fi

  cd ${_source_folder}/src-binutils
  if [[ ${VERSION_BINUTILS:0:4} == "2.21" ]] ; then
    patch -p1 --forward -i ../../201-binutils-2.21-Fix-texi-docs-syntax-errors.patch
  fi
