####
#
####

# import program settings file
  source program-settings.sh

  _srcdir=`pwd`

  GIT_AM="git am --committer-date-is-author-date"

  cd ${_PROGRAM_REPO} && \
  ( git checkout temp || git checkout -b temp ) && \
  git reset --hard master || exit 1

  # Cygwin needs patch 20
  # patch -p1 -i 011-cb-17.12-Fix-sdk-configure-make-build.patch
  # patch -p1 -i 020-cb-16.01-Add-exe-to-auto_revision.patch

  ${GIT_AM} "${_srcdir}"/001-cb-17.12r11227-Do-not-include-boost-m4-files.patch

  ${GIT_AM} "${_srcdir}"/011-cb-17.12-Fix-sdk-configure-make-build.patch
  ${GIT_AM} "${_srcdir}"/012-cb-16.01-Fix-compiler-configure-make-build.patch
  ${GIT_AM} "${_srcdir}"/013-cb-16.01-Fix-coreapp-configure-make-build.patch

  ${GIT_AM} "${_srcdir}"/201-cb-16.01-Fix-ConsoleRunner-build-error.patch

  ${GIT_AM} "${_srcdir}"/302-cb-17.12-Fix-cb-startup-issue.patch
  ${GIT_AM} "${_srcdir}"/303-cb-17.12-Change-default-personality-to-msys2.patch
