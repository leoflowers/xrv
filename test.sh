set -euo pipefail

TEST_DIR=/tmp/xrv-test
TEST_BIN=xrv
TEST_REMOTE=/tmp/xrv-remote.git

if [ ! -f $TEST_BIN ]; then
    make
fi

if [ -d $TEST_DIR ]; then 
    rmdir $TEST_DIR
fi

if [ ! -d $TEST_REMOTE ]; then
    mkdir $TEST_REMOTE
    cd $TEST_REMOTE
    git init --bare
fi

mkdir -p $TEST_DIR/.bin
cp $TEST_BIN $TEST_DIR/.bin

cd $TEST_DIR
git init
git remote add origin $TEST_REMOTE
echo ".bin/" > $TEST_DIR/.gitignore

# Basic functionality test
echo "hello!\n" > $TEST_DIR/example.txt
$TEST_DIR/.bin/xrv