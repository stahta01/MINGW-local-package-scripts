####
#
####

./build-depends.sh || exit 1
./config-program.sh || exit 1
./clean-program.sh || exit 1
./make-program.sh
