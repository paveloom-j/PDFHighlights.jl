"""
    _get_authors_from_CSV(csv::String) -> Vector{String}

Extract the values of the `Author` column from the CSV file.

# Arguments
- `csv::String`: $(CSV_ARGUMENT)

# Returns
- `Vector{String}`: the authors

# Throws
- Exceptions from: [`get_all`](@ref)

# Example
```jldoctest; output = false
using PDFHighlights

_file, io = mktemp()
println(io, "Highlight,Title,Author,URL,Note,Location", '\\n', ",,Susanna Kaysen,,,1")
flush(io)
file = _file * ".csv"
mv(_file, file)

PDFHighlights.Internal.CSV._get_authors_from_CSV(file) == ["Susanna Kaysen"]

# output

true
```
"""
function _get_authors_from_CSV(csv::String)::Vector{String}
    _, _, authors, _, _, _ = get_all(csv)
    return authors
end
