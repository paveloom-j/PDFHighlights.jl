"""
    get_urls(csv::String) -> Vector{String}

Extract the values of the `URL` column from the CSV file.

# Arguments
- `csv::String`: $(CSV_ARGUMENT)

# Returns
- `Vector{String}`: the URLs

# Throws
- Exceptions from: [`get_all`](@ref)

# Example
```jldoctest; output = false
using PDFHighlights

_file, io = mktemp()
println(
    io,
    "Highlight,Title,Author,URL,Note,Location\\n",
    ",,,https://www.imdb.com/title/tt0172493,,"
)
flush(io)
file = _file * ".csv"
mv(_file, file)

get_urls(file) == ["https://www.imdb.com/title/tt0172493"]

# output

true
```
"""
function get_urls(csv::String)::Vector{String}
    _, _, _, urls, _, _ = get_all(csv)
    return urls
end
