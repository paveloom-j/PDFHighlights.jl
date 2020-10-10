"""
    _get_authors_from_PDF(dir::String) -> Vector{String}

Extract all authors from all PDFs found recursively in the passed directory.

# Arguments
- `dir::String`: $(DIR_ARGUMENT)

# Returns
- `Vector{String}`: the authors

# Throws
- Exceptions from: [`get_authors_titles`](@ref)

# Example
```jldoctest; output = false
using PDFHighlights

path_to_pdf_dir = joinpath(pathof(PDFHighlights) |> dirname |> dirname, "test", "pdf")

PDFHighlights.Internal.PDF._get_authors_from_PDF(path_to_pdf_dir) == ["Pavel Sobolev"]

# output

true
```
"""
function _get_authors_from_PDF(dir::String)::Vector{String}
    authors, _ = get_authors_titles(dir)
    return authors
end
