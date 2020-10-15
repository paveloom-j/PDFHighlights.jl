"""
    get_authors(target::String) -> Vector{String}

Get values from the `Authors` column if a CSV file is passed,
or get the authors of all PDFs found recursively if a directory is passed.

# Arguments
- `target::String`: $(TARGET_CSV_ARGUMENT)

# Returns
- `Vector{String}`: the authors

# Throws
- [`NotCSVorDir`](@ref): $(NOT_CSV_OR_DIR_EXCEPTION)
- Exceptions from: [`_get_authors_from_CSV`](@ref), [`_get_authors_from_PDF`](@ref)

# Example
```jldoctest; output = false
using PDFHighlights
HEADER = PDFHighlights.Internal.Constants.HEADER

path_to_pdf_dir = joinpath(pathof(PDFHighlights) |> dirname |> dirname, "test", "pdf")

(get_authors(path_to_pdf_dir) == ["Pavel Sobolev"]) |> println

_file, io = mktemp()
println(io, HEADER, '\\n', ",,Susanna Kaysen,,1")
flush(io)
file = _file * ".csv"
mv(_file, file)

get_authors(file) == ["Susanna Kaysen"]

# output

true
true
```
"""
function get_authors(target::String)::Vector{String}

    if isdir(target)
        _get_authors_from_PDF(target)
    elseif endswith(target, ".csv")
        _get_authors_from_CSV(target)
    else
        throw(NotCSVorDir(target))
    end

end
