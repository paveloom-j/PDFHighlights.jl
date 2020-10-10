"""
    get_locations(csv::String) -> Vector{Int32}

Extract the values of the `Location` column from the CSV file.

# Arguments
- `csv::String`: $(CSV_ARGUMENT)

# Returns
- `Vector{Int32}`: the locations

# Throws
- Exceptions from: [`get_all`](@ref)

# Example
```jldoctest; output = false
using PDFHighlights

_file, io = mktemp()
println(io, "Highlight,Title,Author,URL,Note,Location\\n", ",,,,,5722")
flush(io)
file = _file * ".csv"
mv(_file, file)

get_locations(file) == Int32[5722]

# output

true
```
"""
function get_locations(csv::String)::Vector{Int32}
    _, _, _, _, _, locations = get_all(csv)
    return locations
end
