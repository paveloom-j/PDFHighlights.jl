"""
    _get_highlights_from_CSV(csv::String) -> Vector{String}

Extract the values of the `Highlight` column from the CSV file.

# Arguments
- `csv::String`: $(CSV_ARGUMENT)

# Returns
- `Vector{String}`: the highlights

# Throws
- Exceptions from: [`get_all`](@ref)

# Example
```jldoctest; output = false
using PDFHighlights
HEADER = PDFHighlights.Internal.Constants.HEADER

_file, io = mktemp()
println(io, HEADER, '\\n', "The world didn't stop spinning,,,,1")
flush(io)
file = _file * ".csv"
mv(_file, file)

PDFHighlights.Internal.CSV._get_highlights_from_CSV(file) ==
["The world didn't stop spinning"]

# output

true
```
"""
function _get_highlights_from_CSV(csv::String)::Vector{String}
    highlights, _, _, _, _ = get_all(csv)
    return highlights
end
