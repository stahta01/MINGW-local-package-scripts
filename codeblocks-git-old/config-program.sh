####
#
####

# import program settings file
  source program-settings.sh

  cd ${_PROGRAM_REPO}

  ./bootstrap

  ##This export needed for spellchecker plugin
  export CB_HUNSPELL_LIBS="`${MINGW_PREFIX}/bin/pkg-config hunspell --libs-only-l`"

  _MINGW_PREFIX_WIN="$(cygpath -am "${MINGW_PREFIX}")"
  # This export needed if NOT using plain "wx-config"
  # export WX_CONFIG_PATH="${MINGW_PREFIX}/bin/wx-config-${_wx_basever} --prefix=${_MINGW_PREFIX_WIN}"
  export WX_CONFIG_PATH="${MINGW_PREFIX}/bin/wx-config --static=no --prefix=${_MINGW_PREFIX_WIN}"

  MSYS2_ARG_CONV_EXCL="--prefix=" \
  PATH="${MINGW_PREFIX}/bin":"$PATH" ./configure --with-platform=win32 \
    --disable-pch \
    --prefix=${_PROGRAM_PREFIX} \
    --host=${MINGW_CHOST} \
    --target=${MINGW_CHOST} \
    --build=${MINGW_CHOST} \
    --with-contrib-plugins=yes,-Valgrind,-keybinder,-help,-NassiShneiderman,-exporter,-wxsmithcontrib,-wxsmithaui

  ###
  #
  # The Valgrind program does NOT work under Win32; therefore no reason to build Valgrind plugin.
  # keybinder has major build problem; needs patched wxWidgets package or major code fix.
  #   wxMSW30: cbkeybinder.cpp:38:41: fatal error: wx/msw/private/keyboard.h: No such file or directory
  # Plug-ins with compile search path issues:
  #   exporter
  #   wxsmithcontrib
  #   wxsmithaui
  # Plug-ins with run-time issues
  #   help (crashes when enabled)
  # Plugins with linking issues
  #   NassiShneiderman has link errors because it does not link to the boost library
  #
  ###
