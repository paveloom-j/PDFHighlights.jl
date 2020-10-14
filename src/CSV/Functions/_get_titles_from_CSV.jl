"""
    _get_titles_from_CSV(csv::String) -> Vector{String}

Extract the values of the `Title` column from the CSV file.

# Arguments
- `csv::String`: $(CSV_ARGUMENT)

# Returns
- `Vector{String}`: the titles

# Throws
- Exceptions from: [`get_all`](@ref)

# Example
```jldoctest; output = false
using PDFHighlights
HEADER = PDFHighlights.Internal.Constants.HEADER

_file, io = mktemp()
println(io, HEADER, '\\n', ",\\"Girl, Interrupted\\",,,1")
flush(io)
file = _file * ".csv"
mv(_file, file)

PDFHighlights.Internal.CSV._get_titles_from_CSV(file) == ["Girl, Interrupted"]

# output

true
```
"""
function _get_titles_from_CSV(csv::String)::Vector{String}
    _, titles, _, _, _ = get_all(csv)
    return titles
end
