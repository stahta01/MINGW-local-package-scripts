# import custom-settings.sh file
  source custom-settings.sh

  # Extract asxs, GCC, and Newlib packages
  mkdir -p ${_source_folder}
  cd ${_source_folder}
  echo "Delete files in src-asxs"
  [ -d src-asxs ] && rm -rf src-asxs
  echo "Delete files in src-newlib"
  [ -d src-newlib ] && rm -rf src-newlib
  echo "Delete files in src-gcc"
  [ -d src-gcc ] && rm -rf src-gcc
  mkdir src-asxs
  if [[ ${VERSION_NEWLIB} != "git" ]] ; then
    mkdir src-newlib
  fi
  if [[ ${VERSION_GCC} != "git" ]] ; then
    mkdir src-gcc
  fi

  echo "Extract ${ZIP_BASENAME_AS6809}"
  unzip ${_downloaded_files}/${ZIP_BASENAME_AS6809}.zip -d src-asxs
  if [[ ${VERSION_NEWLIB} == "git" ]] ; then
    cd ${VCFOLDER_NEWLIB}
    echo "checkout git branch for newlib"
    git checkout ${VCBRANCH_NEWLIB} || exit 1
    cd ${_source_folder}
  else
    echo "Extract ${TAR_BASENAME_NEWLIB}"
    tar -xzf ${_downloaded_files}/${TAR_BASENAME_NEWLIB}.tar.gz -C src-newlib --strip-components 1 --checkpoint=500
  fi
  if [[ ${VERSION_GCC} == "git" ]] ; then
    cd ${VCFOLDER_GCC}
    echo "checkout git branch for GCC"
    git checkout ${VCBRANCH_GCC} || exit 1
    cd ${_source_folder}
  else
    echo "Extract ${TAR_BASENAME_GCC}"
    tar -xjf ${_downloaded_files}/${TAR_BASENAME_GCC}.tar.bz2 -C src-gcc --strip-components 1 --checkpoint=500
  fi

  cd ${_source_folder}/src-asxs
  if [[ ${VERSION_AS6809:0:4} == "5p10" && ${_target:0:5} == "m6809" ]] ; then
    patch -p1 --forward -i ../../201-as-5p10-Import-of-ASxxxx-update-u01510.patch
    patch -p1 --forward -i ../../202-as-5p10-Add-files-from-gcc6809-as-5.1.1-folder.patch
    patch -p1 --forward -i ../../203-as-5p10-Add-binutils-folder-from-gcc6809.patch
    patch -p1 --forward -i ../../204-as-5p10-Set-M6809STRICT-0.patch
  fi

  if [[ ${VERSION_GCC} != "git" ]] ; then
    cd ${_source_folder}/src-gcc
    if [[ ${VERSION_GCC:0:5} == "3.3.6" ]] ; then
      patch -p1 --forward -i ../../001-gcc-3.3.6-s12x-20121024_changes.patch
      patch -p1 --forward -i ../../002-gcc-3.3.6-define-POSIX-signals.patch
      patch -p1 --forward -i ../../003-gcc-3.3.6-replace-fcntl-F_DUPFD-with-dup2.patch
      patch -p1 --forward -i ../../004-gcc-3.3.6-define-kill.patch
    fi
    if [[ ${VERSION_GCC:0:3} == "4.3" || ${VERSION_GCC:0:3} == "4.4" ]] ; then
      patch -p1 --forward -i ../../001-gcc-4.3-fixed-compile-issue-with-gcc-5-in-gcc-toplev.patch
    fi
    if [[ ${VERSION_GCC:0:3} == "4.3" ]] ; then
      patch -p1 --forward -i ../../002-gcc-4.3-Fix-texi-docs-syntax-errors.patch
      if [[ ${_target:0:5} == "m6809" ]] ; then
        patch -p1 --forward -i ../../003-gcc-4.3-compound-commit-using-as6809-assembler.patch
      fi
      patch -p1 --forward -i ../../004-gcc-4.3-Change-bug-reporting-URL.patch
    fi
    if [[ ${VERSION_GCC:0:3} == "4.4" ]] ; then
      patch -p1 --forward -i ../../104-gcc-4.4-Fix-texi-docs-syntax-errors.patch
    fi
    if [[ ${VERSION_GCC:0:3} == "4.5" ]] ; then
      patch -p1 --forward -i ../../105-gcc-4.5-Fix-texi-docs-syntax-errors.patch
    fi
  fi

  if [[ ${VERSION_NEWLIB} != "git" ]] ; then
    cd ${_source_folder}/src-newlib
    if [[ ${VERSION_NEWLIB:0:6} == "1.16.0" && ${_target:0:5} == "m6809" ]] ; then
      patch --forward -p1 -i ../../301-newlib-1.15-df-changed-seek-offset-from-int-to-_fpos_t.patch
      patch --forward -p1 -i ../../302-newlib-1.16-include-string-h.patch

      patch --forward -p1 -i ../../305-newlib-1.15-edit-config-sub.patch
      patch --forward -p1 -i ../../306-newlib-1.15-edit-newlib-configure-host.patch

      patch --forward -p1 -i ../../310-newlib-1.15-bcd-modified-source-files.patch
      patch --forward -p1 -i ../../311-newlib-1.15-bcd-added-source-files.patch
      patch --forward -p1 -i ../../312-newlib-1.15-bcd-added-.m4-files.patch
      patch --forward -p1 -i ../../313-newlib-1.15-bcd-added-.am-files.patch
      patch --forward -p1 -i ../../314-newlib-1.15-bcd-added-Makefile.in-files.patch
      patch --forward -p1 -i ../../315-newlib-1.15-bcd-added-configure.in-files.patch
      patch --forward -p1 -i ../../316-newlib-1.15-bcd-added-configure-files.patch
      patch --forward -p1 -i ../../317-newlib-1.15-df-modified-source-files.patch
      patch --forward -p1 -i ../../318-newlib-1.15-df-added-source-files.patch
      patch --forward -p1 -i ../../319-newlib-1.15-df-modified-build-files-except-for-configure-files.patch
      patch --forward -p1 -i ../../324-newlib-1.16-Add-m6809-to-configure.ac.patch
      patch --forward -p1 -i ../../325-newlib-1.15-Add-coco-and-m6809sim-to-newlib-libc-machine-configu.patch
      patch --forward -p1 -i ../../326-newlib-1.15-Add-m6809-to-libgloss-configure.in.patch
      patch --forward -p1 -i ../../327-newlib-1.16-Add-m6809-to-newlib-libc-machine-configure.in.patch
      patch --forward -p1 -i ../../328-newlib-1.16-Regenerate-configure.patch
      patch --forward -p1 -i ../../329-newlib-1.16-Regenerate-libgloss-configure.patch
      patch --forward -p1 -i ../../330-newlib-1.16-Regenerate-newlib-libc-machine-configure.patch
      patch --forward -p1 -i ../../331-newlib-1.16-Regenerate-newlib-libc-sys-configure.patch
    fi
  fi
