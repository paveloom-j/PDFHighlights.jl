# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder, Pkg

name = "PDFHighlights"
version = v"0.1.0"

# Collection of sources required to complete build
sources = [
    ArchiveSource("https://poppler.freedesktop.org/poppler-0.87.0.tar.xz", "6f602b9c24c2d05780be93e7306201012e41459f289b8279a27a79431ad4150e"),
	ArchiveSource("https://ftp.gnome.org/pub/gnome/sources/glib/2.66/glib-2.66.2.tar.xz", "ec390bed4e8dd0f89e918f385e8d4cfd7470b1ef7c1ce93ec5c4fc6e3c6a17c4"),
    GitSource("https://github.com/paveloom-j/PDFHighlights.jl.git", "b5e7f7740feb91351dea93d9c31596355c7308df"),
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir/glib-*/

# Get a local gettext for msgfmt cross-building
apk add gettext

# Provide answers to a few configure questions automatically
cat > glib.cache <<END
glib_cv_stack_grows=no
glib_cv_uscore=no
END

export NOCONFIGURE=true
export LDFLAGS="${LDFLAGS} -L${libdir}"
export CPPFLAGS="-I${prefix}/include"

./autogen.sh

if [[ "${target}" == i686-linux-musl ]]; then
    # Small hack: swear that we're cross-compiling.  Our `i686-linux-musl` is
    # bugged and it can run only a few programs, with the result that the
    # configure test to check whether we're cross-compiling returns that we're
    # doing a native build, but then it fails to run a bunch of programs during
    # other tests.
    sed -i 's/cross_compiling=no/cross_compiling=yes/' configure
fi

./configure --cache-file=glib.cache --with-libiconv=gnu --prefix=${prefix} --host=${target}
find -name Makefile -exec sed -i 's?/workspace/destdir/bin/msgfmt?/usr/bin/msgfmt?g' '{}' \;

make -j${nproc}
make install

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
grep -Ri g_array_steal -A4 -B4 /workspace/destdir/include/glib-2.0

cd $WORKSPACE/srcdir/PDFHighlights.jl/deps/

gcc -std=c99 -g -O3 -fPIC -c get_author_title.c -o get_author_title.o `pkg-config --cflags poppler-glib`
gcc -std=c99 -g -O3 -fPIC -c get_lines_comments_pages.c -o get_lines_comments_pages.o `pkg-config --cflags poppler-glib`
gcc -shared -o $libdir/PDFHighlightsWrapper.so get_author_title.o get_lines_comments_pages.o `pkg-config --libs poppler-glib`
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = expand_cxxstring_abis(Platform[Linux(:x86_64, libc=:glibc)])

# The products that we will ensure are always built
products = [
    LibraryProduct("PDFHighlightsWrapper", :PDFHighlightsWrapper),
]

# Dependencies that must be installed before this package can be built
dependencies = [
    BuildDependency("Xorg_xorgproto_jll"),
	# Dependency("Glib_jll"),
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
