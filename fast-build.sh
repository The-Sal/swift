#!/bin/bash
export SCCACHE_CACHE_SIZE="50G"

# Clean the stdlib build
#rm -rf /Volumes/fSTORAGE/STORED/SwiftCompilerBuild/Ninja-RelWithDebInfoAssert/swift-macosx-arm64/lib/swift

# Rebuild everything
#utils/build-script --skip-build-benchmarks \
# --swift-darwin-supported-archs "$(uname -m)" \
# --release-debuginfo \
# --swift-disable-dead-stripping \
# --bootstrapping=hosttools \
# --reconfigure \
# --sccache

 export CWD=$(pwd)
 export SWIFT_BUILD_DIR=/Users/Salman/Projects/CLionProjects/build/Ninja-RelWithDebInfoAssert/swift-macosx-arm64
#
 cd $SWIFT_BUILD_DIR
 ninja swift-stdlib && nativenotifier "Swift stdlib build completed successfully" && cd $CWD && \
# Compile y
  # our test with custom stdlib
    /Users/Salman/Projects/CLionProjects/build/Ninja-RelWithDebInfoAssert/swift-macosx-arm64/bin/swiftc \
    -Onone \
    -resource-dir /Users/Salman/Projects/CLionProjects/build/Ninja-RelWithDebInfoAssert/swift-macosx-arm64/lib/swift \
    -sdk /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk \
    -Xlinker -rpath -Xlinker /Users/Salman/Projects/CLionProjects/build/Ninja-RelWithDebInfoAssert/swift-macosx-arm64/lib/swift/macosx \
    ./test_files/*.swift -o ./test_files/a.out &&
    DYLD_LIBRARY_PATH=/Users/Salman/Projects/CLionProjects/build/Ninja-RelWithDebInfoAssert/swift-macosx-arm64/lib/swift/macosx \
                                                    ./test_files/a.out



# incremental build
# ninja -C ../build/Ninja-RelWithDebInfoAssert/swift-${platform}-$(uname -m)
