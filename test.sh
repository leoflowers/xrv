set -euo pipefail

TEST_DIR=/tmp/xrv-test
TEST_BIN=xrv
TEST_REMOTE=/tmp/xrv-remote.git

setup_test_git_remote () {
    echo "setting up test remote"

    if [ -d $TEST_REMOTE ]; then
        rm -rf $TEST_REMOTE
    fi

    mkdir $TEST_REMOTE
    pushd $TEST_REMOTE > /dev/null
    git init --bare
    popd > /dev/null
}

setup_test_git_repo () {
    echo "setting up test repo"

    if [ -d $TEST_DIR ]; then 
        rm -rf $TEST_DIR
    fi

    mkdir -p $TEST_DIR/.bin
    pushd $TEST_DIR > /dev/null

    git init
    git remote add origin $TEST_REMOTE

    echo ".bin/" > $TEST_DIR/.gitignore
    echo "hello!\n" > $TEST_DIR/example.txt

    popd > /dev/null
}

setup_test_git_remote
setup_test_git_repo

echo $(pwd)
if [ ! -f $TEST_BIN ]; then
    echo "make sure xrv binary exists; run make"
fi
cp ./$TEST_BIN $TEST_DIR/.bin

$TEST_DIR/.bin/xrv
if ! git show --oneline | grep "autocommitted"; then
    echo "failed"
fi
echo "all tests passed"