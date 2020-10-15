"""
    get_titles(target::String) -> Vector{String}

Get values from the `Titles` column if a CSV file is passed,
or get the titles of all PDFs found recursively if a directory is passed.

# Arguments
- `target::String`: $(TARGET_CSV_ARGUMENT)

# Returns
- `Vector{String}`: the titles

# Throws
- [`NotCSVorDir`](@ref): $(NOT_CSV_OR_DIR_EXCEPTION)
- Exceptions from: [`_get_titles_from_CSV`](@ref), [`_get_titles_from_PDF`](@ref)

# Example
```jldoctest; output = false
using PDFHighlights
HEADER = PDFHighlights.Internal.Constants.HEADER

path_to_pdf_dir = joinpath(pathof(PDFHighlights) |> dirname |> dirname, "test", "pdf")

(get_titles(path_to_pdf_dir) == ["A dummy PDF for tests"]) |> println

_file, io = mktemp()
println(io, HEADER, '\\n', ",\\"Girl, Interrupted\\",,,1")
flush(io)
file = _file * ".csv"
mv(_file, file)

get_titles(file) == ["Girl, Interrupted"]

# output

true
true
```
"""
function get_titles(target::String)::Vector{String}

    if isdir(target)
        _get_titles_from_PDF(target)
    elseif endswith(target, ".csv")
        _get_titles_from_CSV(target)
    else
        throw(NotCSVorDir(target))
    end

end
