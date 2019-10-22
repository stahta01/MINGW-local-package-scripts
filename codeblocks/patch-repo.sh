####
#
####

# import program settings file
  source program-settings.sh

  _srcdir=`pwd`

  SVN_PATCH="svn patch"

  cd ${_PROGRAM_REPO}

  svn revert -R .

  ${SVN_PATCH} "${_srcdir}"/001-cb-17.12r11227-Do-not-include-boost-m4-files.patch

  ${SVN_PATCH} "${_srcdir}"/011-cb-17.12-Fix-sdk-configure-make-build.patch
  ${SVN_PATCH} "${_srcdir}"/012-cb-16.01-Fix-compiler-configure-make-build.patch
  ${SVN_PATCH} "${_srcdir}"/013-cb-16.01-Fix-coreapp-configure-make-build.patch

  ${SVN_PATCH} "${_srcdir}"/201-cb-16.01-Fix-ConsoleRunner-build-error.patch

  ${SVN_PATCH} "${_srcdir}"/302-cb-17.12-Fix-cb-startup-issue.patch
  ${SVN_PATCH} "${_srcdir}"/303-cb-17.12-Change-default-personality-to-msys2.patch
