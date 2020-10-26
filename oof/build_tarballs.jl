# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder, Pkg

name = "PopplerTest"
version = v"0.87.0"

# Collection of sources required to complete build
sources = [
    ArchiveSource("https://poppler.freedesktop.org/poppler-0.87.0.tar.xz", "6f602b9c24c2d05780be93e7306201012e41459f289b8279a27a79431ad4150e"),
    GitSource("https://github.com/paveloom-j/PDFHighlights.jl.git", "42fc05c2b21d7359d13a38daf252045a79ab55c5")
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd $WORKSPACE/srcdir/poppler-*
# ln -s ${bindir} /opt/${target}/${target}/sys-root/usr/local/bin
export CXXFLAGS="-I${prefix}/include/openjpeg-2.3"
mkdir build && cd build
echo ${bindir}
cmake -DCMAKE_INSTALL_PREFIX=$prefix     -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TARGET_TOOLCHAIN}     -DCMAKE_BUILD_TYPE=Release     -DBUILD_GTK_TESTS=OFF     -DENABLE_CMS=lcms2     -DENABLE_GLIB=ON     -DENABLE_QT5=OFF     -DENABLE_UNSTABLE_API_ABI_HEADERS=ON     -DWITH_GObjectIntrospection=OFF     ..
make -j${nproc}
make install
false
[[ false == true ]]
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Windows(:x86_64)
]


# The products that we will ensure are always built
products = [
    ExecutableProduct("libpoppler-glib-8.dll", :libpoppler_glib)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    Dependency(PackageSpec(name="Xorg_xorgproto_jll", uuid="c4d99508-4286-5418-9131-c86396af500b"))
    Dependency(PackageSpec(name="Cairo_jll", uuid="83423d85-b0ee-5818-9007-b63ccbeb887a"))
    Dependency(PackageSpec(name="Fontconfig_jll", uuid="a3f928ae-7b40-5064-980b-68af3947d34b"))
    Dependency(PackageSpec(name="Glib_jll", uuid="7746bdde-850d-59dc-9ae8-88ece973131d"))
    Dependency(PackageSpec(name="JpegTurbo_jll", uuid="aacddb02-875f-59d6-b918-886e6ef4fbf8"))
    Dependency(PackageSpec(name="Libtiff_jll", uuid="89763e89-9b03-5906-acba-b20f662cd828"))
    Dependency(PackageSpec(name="OpenJpeg_jll", uuid="643b3616-a352-519d-856d-80112ee9badc"))
    Dependency(PackageSpec(name="libpng_jll", uuid="b53b4c65-9356-5827-b1ea-8c7a1a84506f"))
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies; preferred_gcc_version = v"5.2.0")
