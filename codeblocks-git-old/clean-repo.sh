####
#
####

# import program settings file
  source program-settings.sh

  cd ${_PROGRAM_REPO} && \
  git clean -ixd && \
  git reset --hard || exit 1
