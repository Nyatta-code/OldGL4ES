#!/usr/bin/env bash
# Builds GL4ES (libGL.so) for every ABI with the Android NDK and copies each
# result into app/src/main/jniLibs/<abi>/libgl4es.so.
#
# Inputs (environment):
#   ABIS         space separated list, default "arm64-v8a armeabi-v7a"
#   ANDROID_API  default 26
#   GL4ES_DIR    GL4ES source directory, default gl4es-src
set -euo pipefail

ABIS="${ABIS:-arm64-v8a armeabi-v7a}"
ANDROID_API="${ANDROID_API:-26}"
GL4ES_DIR="${GL4ES_DIR:-gl4es-src}"
NDK="${ANDROID_NDK_LATEST_HOME:-${ANDROID_NDK_HOME:?ANDROID_NDK_HOME is not set}}"

echo "NDK: $NDK"
echo "ABIs: $ABIS"

for ABI in $ABIS; do
  echo "::group::GL4ES $ABI"

  # GL4ES writes its output to <source>/lib (not to the build dir), so clean
  # it before every ABI to avoid copying the library of the previous one.
  rm -rf "$GL4ES_DIR/lib"

  cmake -S "$GL4ES_DIR" -B "build-$ABI" \
    -DCMAKE_TOOLCHAIN_FILE="$NDK/build/cmake/android.toolchain.cmake" \
    -DANDROID_ABI="$ABI" \
    -DANDROID_PLATFORM="android-$ANDROID_API" \
    -DCMAKE_BUILD_TYPE=Release \
    -DANDROID=ON \
    -DCMAKE_C_FLAGS="-O3" \
    -DCMAKE_SHARED_LINKER_FLAGS="-ldl -llog"
  cmake --build "build-$ABI" -j"$(nproc)"

  LIB="$(find "$GL4ES_DIR/lib" "build-$ABI" -name 'libGL.so' 2>/dev/null | head -n1)"
  if [ -z "$LIB" ]; then
    echo "libGL.so not found for $ABI. Libraries present:"
    find "$GL4ES_DIR/lib" "build-$ABI" -name '*.so*' 2>/dev/null || true
    exit 1
  fi
  echo "Found: $LIB"
  file "$LIB" || true

  mkdir -p "app/src/main/jniLibs/$ABI"
  cp "$LIB" "app/src/main/jniLibs/$ABI/libgl4es.so"
  echo "::endgroup::"
done

echo "Result:"
ls -l app/src/main/jniLibs/*/
