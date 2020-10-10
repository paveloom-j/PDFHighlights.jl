"""
    _get_titles_from_PDF(target::String) -> Vector{String}

Extract all titles from all PDFs found recursively in the passed directory.

# Arguments
- `dir::String`: $(DIR_ARGUMENT)

# Returns
- `Vector{String}`: the titles

# Throws
- Exceptions from: [`get_authors_titles`](@ref)

# Example
```jldoctest; output = false
using PDFHighlights

path_to_pdf_dir = joinpath(pathof(PDFHighlights) |> dirname |> dirname, "test", "pdf")

PDFHighlights.Internal.PDF._get_titles_from_PDF(path_to_pdf_dir) ==
["A dummy PDF for tests"]

# output

true
```
"""
function _get_titles_from_PDF(dir::String)::Vector{String}
    _, titles = get_authors_titles(dir)
    return titles
end
