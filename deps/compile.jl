# Create a shared C library

const COMPILER = "gcc"
const LIB_NAME = "PDFHighlightsWrapper"
const OBJ_FLAGS = ["-O3", "-fPIC"]

if Sys.islinux()
    const LIB_EXT = ".so"
    const LIB_FLAGS = ["-shared", "-Wl,--no-undefined"]
elseif Sys.isapple()
    const LIB_EXT = ".dylib"
    const LIB_FLAGS = ["-dynamiclib"]
end

const LIB = LIB_NAME * LIB_EXT

const INCLUDE_FLAGS = split(chop(read(`pkg-config --cflags poppler-glib`, String)))
const LINK_FLAGS = split(
    chop(
        "-lgio-2.0 " * read(`pkg-config --libs poppler-glib`, String)
    )
)

if !isfile(LIB)
    for file in ["get_lines_comments_pages", "get_author_title"]
        c_file_path = file * ".c"
        o_file_path = file * ".o"
        run(`$(COMPILER) $(OBJ_FLAGS) -c $(c_file_path) -o $(o_file_path) $(INCLUDE_FLAGS)`)
        run(`$(COMPILER) $(LIB_FLAGS) -o $(LIB) $(o_file_path) $(LINK_FLAGS)`)
    end
end
