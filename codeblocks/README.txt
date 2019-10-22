# From a MSys2 mingw prompt run:

# Contains program setting used by other scripts
# program-settings.sh

# Update version control repo
./update-repo.sh

# Patch version control repo
./patch-repo.sh

# build/test cycle
./build-program.sh
./install-program.sh
./run-program.sh

# low level build/test cycle
./build-depends.sh    # called by build-program.sh
./config-program.sh   # called by build-program.sh
./clean-program.sh    # called by build-program.sh
./make-program.sh     # called by build-program.sh
./install-program.sh
./run-program.sh
