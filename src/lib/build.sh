#!/bin/bash

WORK_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
LIBRARY_DIR=$WORK_DIR/glm/

RELEASE_MODE="MinSizeRel"

REST_ARGS=
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    --arch)
        TARGET_ARCH="$2"
        shift
        shift
        ;;
    --ndk)
        NDK="$2"
        shift
        shift
        ;;
    --debug)
        RELEASE_MODE="Debug"
        shift
        ;;
    *)
        REST_ARGS+="$1"
        shift
        ;;
esac
done

BUILD_DIR="$WORK_DIR/build/$REST_ARGS/"

function build_android {
    if [[ -z "$NDK" ]]; then
        echo "Path to Android NDK must be provided via --android-ndk"
        exit 1
    fi

    ANDROID_ABI=arm64-v8a
    case "$TARGET_ARCH" in
        aarch64)
            ANDROID_ABI=arm64-v8a
            ;;
        armv7a)
            ANDROID_ABI=armeabi-v7a
            ;;
        *)
            echo "Using ABI $ANDROID_ABI"
            ;;
    esac

    mkdir -p $BUILD_DIR && cd $BUILD_DIR
    cmake -DANDROID_ABI=$ANDROID_ABI \
          -DANDROID_PLATFORM=23 \
          -DANDROID_ARM_NEON=ON \
          -DCMAKE_TOOLCHAIN_FILE="$NDK/build/cmake/android.toolchain.cmake" \
          $WORK_DIR
    cmake --build . --config "$RELEASE_MODE"
}

function build_desktop {
    mkdir -p $BUILD_DIR && cd $BUILD_DIR
    cmake -DCMAKE_BUILD_TYPE=$RELEASE_MODE \
          -DCMAKE_C_COMPILER=clang \
          -DCMAKE_CXX_COMPILER=clang++ \
          -DCMAKE_SHARED_LINKER_FLAGS="-stdlib=libc++ -lc++abi" \
          -DCMAKE_CXX_FLAGS="-ferror-limit=0" \
          $WORK_DIR
    cmake --build  . --config $RELEASE_MODE
}


case "$REST_ARGS" in
    desktop)
        build_desktop
        ;;
    android)
        build_android
        ;;
    *)
        echo "Unrecognized platform $REST_ARGS"
        exit -1
        ;;
esac
