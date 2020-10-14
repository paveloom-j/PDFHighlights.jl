"""
    get_notes(csv::String) -> Vector{String}

Extract the values of the `Note` column from the CSV file.

# Arguments
- `csv::String`: $(CSV_ARGUMENT)

# Returns
- `Vector{String}`: the notes

# Throws
- Exceptions from: [`get_all`](@ref)

# Example
```jldoctest; output = false
using PDFHighlights
HEADER = PDFHighlights.Internal.Constants.HEADER

_file, io = mktemp()
println(io, HEADER, '\\n', ",,,Journal,")
flush(io)
file = _file * ".csv"
mv(_file, file)

get_notes(file) == ["Journal"]

# output

true
```
"""
function get_notes(csv::String)::Vector{String}
    _, _, _, notes, _ = get_all(csv)
    return notes
end
