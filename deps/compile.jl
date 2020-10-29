# Create a shared C library

const CC = "gcc"
const LIB_NAME = "PDFHighlightsWrapper"
const OBJ_FLAGS = ["-O3", "-fPIC"]

if Sys.islinux()
    const LIB_EXT = ".so"
    const LIB_FLAGS = ["-shared", "-Wl,--no-undefined"]
elseif Sys.isapple()
    const LIB_EXT = ".dylib"
    const LIB_FLAGS = ["-shared"]
end

const LIB = joinpath(@__DIR__, LIB_NAME * LIB_EXT)

const INCLUDE_FLAGS = split(chop(read(`pkg-config --cflags poppler-glib`, String)))
const LINK_FLAGS = split(
    chop(
        "-lgio-2.0 " * read(`pkg-config --libs poppler-glib`, String)
    )
)

const OBJECTS = joinpath.(@__DIR__, ["get_lines_comments_pages", "get_author_title"])
const OBJECTS_C = OBJECTS .* ".c"
const OBJECTS_O = OBJECTS .* ".o"

if !isfile(LIB)
    for i in eachindex(OBJECTS)
        run(`$(CC) $(OBJ_FLAGS) -c $(OBJECTS_C[i]) -o $(OBJECTS_O[i]) $(INCLUDE_FLAGS)`)
    end
    run(`$(CC) $(LIB_FLAGS) -o $(LIB) $(OBJECTS_O) $(LINK_FLAGS)`)
end
