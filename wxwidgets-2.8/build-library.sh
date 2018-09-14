####
#
####

./build-depends.sh || exit 1
./config-library.sh || exit 1
./clean-library.sh || exit 1
./make-library.sh
