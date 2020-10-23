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

echo "PKG-CONFIG-OUTPUT"
pkg-config --cflags poppler-glib
pkg-config --libs poppler-glib

cd $WORKSPACE/srcdir/PDFHighlights.jl/deps/

gcc -std=c99 -g -O3 -fPIC -c get_author_title.c -o get_author_title.o `pkg-config --cflags poppler-glib`
gcc -std=c99 -g -O3 -fPIC -c get_lines_comments_pages.c -o get_lines_comments_pages.o `pkg-config --cflags poppler-glib`
gcc -shared -o $libdir/PDFHighlightsWrapper.so get_author_title.o get_lines_comments_pages.o `pkg-config --libs poppler-glib`
echo $libdir/PDFHighlightsWrapper.so
ls -a $libdir/PDFHighlightsWrapper.so

cd $WORKSPACE/srcdir/
wget https://julialang-s3.julialang.org/bin/linux/x64/1.5/julia-1.5.2-linux-x86_64.tar.gz -P ./julia
tar -xf ./julia/julia*.tar.gz -C ./julia --strip-components 1

./julia/bin/julia PDFHighlights.jl/test/tests/wrapper_build.jl
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = expand_cxxstring_abis(supported_platforms()[1:9])

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
