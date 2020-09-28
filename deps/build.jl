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
const library_flag = "-shared"
const library_ext = ".so"
const include_flags = split(chop(read(`pkg-config --cflags --libs poppler-glib`, String)))

for path in [path_to_get_lines_comments_pages_library, path_to_get_author_title_library]
    if !isfile(path)
        c_file_path = path * ".c"
        o_file_path = path * ".o"
        shared_lib_path = path * ".so"
        run(`$compiler $object_flags -c $c_file_path -o $o_file_path $include_flags`)
        run(`$compiler $library_flag -o $shared_lib_path $o_file_path $include_flags`)
    end
end
