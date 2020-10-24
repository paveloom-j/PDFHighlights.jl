# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder, Pkg

name = "PDFHighlights"
version = v"0.1.0"

# Collection of sources required to complete build
sources = [
    ArchiveSource("https://poppler.freedesktop.org/poppler-0.87.0.tar.xz", "6f602b9c24c2d05780be93e7306201012e41459f289b8279a27a79431ad4150e"),
	GitSource("https://github.com/paveloom-j/PDFHighlights.jl.git", "42fc05c2b21d7359d13a38daf252045a79ab55c5"),
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir/poppler-*/

# Create link ${bindir} before starting.  `OpenJPEGTargets.cmake` will try to
# look for some executables in `sys-root/usr/local/bin`
ln -s ${bindir} /opt/${target}/${target}/sys-root/usr/local/bin
export CXXFLAGS="-I${prefix}/include/openjpeg-2.3"

if [[ "${target}" == "${MACHTYPE}" ]]; then
    # When building for the host platform, the system libexpat is picked up
    rm /usr/lib/libexpat.so*
fi

mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=$prefix \
    -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TARGET_TOOLCHAIN} \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_GTK_TESTS=OFF \
    -DENABLE_CMS=lcms2 \
	-DENABLE_CPP=OFF \
    -DENABLE_GLIB=ON \
    -DENABLE_QT5=OFF \
    -DENABLE_UNSTABLE_API_ABI_HEADERS=ON \
    -DWITH_GObjectIntrospection=OFF \
    ..
make -j${nproc}
make install

cd $WORKSPACE/srcdir/PDFHighlights.jl/deps/

CC="gcc"
OBJECTS=(get_author_title get_lines_comments_pages)

OBJECTS_O=()
for index in ${!OBJECTS[@]}; do
    OBJECTS_O[${index}]=${OBJECTS[${index}]}.o
done

INCLUDE_FLAGS="`pkg-config --cflags poppler-glib`"
LINK_FLAGS="-lgio-2.0 `pkg-config --libs poppler-glib`"

if [[ "${target}" == *-darwin* ]]; then
    OBJECT_FLAGS="-std=c99 -O3 -fPIC"
    LIBRARY_EXT=".dylib"
    LIBRARY_FLAGS="-dynamiclib"
elif [[ "${target}" == *-mingw* ]]; then
    OBJECT_FLAGS="-std=c99 -O3"
    LIBRARY_EXT=".dll"
    LIBRARY_FLAGS="-shared"
else
    OBJECT_FLAGS="-std=c99 -O3 -fPIC"
    LIBRARY_EXT=".so"
    LIBRARY_FLAGS="-shared -Wl,--no-undefined"
fi

for file in ${OBJECTS[@]}; do
    ${CC} ${OBJECT_FLAGS} ${file}.c -o ${file}.o ${INCLUDE_FLAGS}
done

${CC} ${LIBRARY_FLAGS} -o ${libdir}/PDFHighlightsWrapper.${LIBRARY_EXT} ${OBJECTS_O[@]} ${LINK_FLAGS}
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = expand_cxxstring_abis(supported_platforms())

# The products that we will ensure are always built
products = [
    LibraryProduct("PDFHighlightsWrapper", :PDFHighlightsWrapper),
]

# Dependencies that must be installed before this package can be built
dependencies = [
    BuildDependency("Xorg_xorgproto_jll"),
	Dependency("Glib_jll"),
    Dependency("JpegTurbo_jll"),
    Dependency("Cairo_jll"),
    #Dependency("gdk_pixbuf_jll"),
    #Dependency("GTK3_jll"),
    Dependency("Libtiff_jll"),
    Dependency("libpng_jll"),
    Dependency("OpenJpeg_jll"),
    Dependency("Fontconfig_jll"),
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies; preferred_gcc_version = v"5")
