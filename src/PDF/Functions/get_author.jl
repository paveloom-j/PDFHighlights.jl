"""
    get_author(pdf::String) -> String

Extract the author from the PDF.

# Arguments
- `pdf::String`: $(PDF_ARGUMENT)

# Returns
- `String`: the author

# Throws
- Exceptions from: [`get_author_title`](@ref)

# Example
```jldoctest; output = false
using PDFHighlights

path_to_pdf = joinpath(
    pathof(PDFHighlights) |> dirname |> dirname,
    "test",
    "pdf",
    "TestPDF.pdf"
)

get_author(path_to_pdf) == "Pavel Sobolev"

# output

true
```
"""
function get_author(pdf::String)::String
    author, _ = get_author_title(pdf)
    return author
end
