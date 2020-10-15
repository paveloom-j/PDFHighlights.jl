# Compile C libraries if they don't already exist as shared objects

const PATH_TO_C_LIBRARIES = joinpath(@__DIR__, "C")
const PATH_TO_GET_LINES_COMMENTS_PAGES_LIBRARY = joinpath(
    PATH_TO_C_LIBRARIES,
    "get_lines_comments_pages",
    "get_lines_comments_pages",
)
const PATH_TO_GET_AUTHOR_TITLE_LIBRARY = joinpath(
    PATH_TO_C_LIBRARIES,
    "get_author_title",
    "get_author_title",
)

const COMPILER = "gcc"
const OBJECT_FLAGS = ["-g", "-Ofast", "-fPIC"]

if Sys.islinux()
    const LIBRARY_EXT = ".so"
    const LIBRARY_FLAGS = "-shared"
elseif Sys.isapple()
    const LIBRARY_EXT = ".dylib"
    const LIBRARY_FLAGS = ["-dynamiclib", "-undefined", "dynamic_lookup"]
end

const INCLUDE_FLAGS = split(chop(read(`pkg-config --cflags poppler-glib`, String)))
const LINK_FLAGS = split(chop(read(`pkg-config --libs poppler-glib`, String)))

for path in [PATH_TO_GET_LINES_COMMENTS_PAGES_LIBRARY, PATH_TO_GET_AUTHOR_TITLE_LIBRARY]
    if !isfile(path)
        c_file_path = path * ".c"
        o_file_path = path * ".o"
        shared_lib_path = path * LIBRARY_EXT
        run(`$COMPILER $OBJECT_FLAGS -c $c_file_path -o $o_file_path $INCLUDE_FLAGS`)
        run(`$COMPILER $LIBRARY_FLAGS -o $shared_lib_path $o_file_path $LINK_FLAGS`)
    end
end
