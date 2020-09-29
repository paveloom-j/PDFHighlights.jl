# Compile C libraries if they don't already exist as shared objects

const path_to_c_libraries = joinpath(@__DIR__, "C")
const path_to_get_lines_comments_pages_library = joinpath(
    path_to_c_libraries,
    "get_lines_comments_pages",
    "get_lines_comments_pages",
)
const path_to_get_author_title_library = joinpath(
    path_to_c_libraries,
    "get_author_title",
    "get_author_title",
)

const compiler = "gcc"
const object_flags = ["-g", "-Ofast", "-fPIC"]

if Sys.islinux()
    const library_ext = ".so"
    const library_flags = "-shared"
elseif Sys.isapple()
    const library_ext = ".dylib"
    const library_flags = ["-dynamiclib", "-undefined", "dynamic_lookup"]
end

const include_flags = split(chop(read(`pkg-config --cflags poppler-glib`, String)))
const link_flags = split(chop(read(`pkg-config --libs poppler-glib`, String)))

for path in [path_to_get_lines_comments_pages_library, path_to_get_author_title_library]
    if !isfile(path)
        c_file_path = path * ".c"
        o_file_path = path * ".o"
        shared_lib_path = path * library_ext
        run(`$compiler $object_flags -c $c_file_path -o $o_file_path $include_flags`)
        run(`$compiler $library_flags -o $shared_lib_path $o_file_path $link_flags`)
    end
end
