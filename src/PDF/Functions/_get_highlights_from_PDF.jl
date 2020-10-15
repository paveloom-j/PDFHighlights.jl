"""
    _get_highlights_from_PDF(target::String; concatenate::Bool=true) -> Vector{String}

Extract all highlights from a passed PDF or all PDFs found recursively in the
passed directory.

# Arguments
- `target::String`: $(TARGET_PDF_ARGUMENT)

# Keywords
- `concatenate::Bool=true`: $(CONCATENATE_KEYWORD)

# Returns
- `Vector{String}`: the highlights

# Throws
- Exceptions from: [`get_highlights_comments_pages`](@ref)

# Example
```jldoctest; output = false
using PDFHighlights

path_to_pdf_dir = joinpath(pathof(PDFHighlights) |> dirname |> dirname, "test", "pdf")
path_to_pdf = joinpath(path_to_pdf_dir, "TestPDF.pdf")

PDFHighlights.Internal.PDF._get_highlights_from_PDF(path_to_pdf_dir) ==
PDFHighlights.Internal.PDF._get_highlights_from_PDF(path_to_pdf) ==
String[
    "Highlight 1",
    "Highlight 2 Highlight 3",
    "Highlight 4",
    "Highhighlight 5",
    "6th Highhigh light-",
    "High light 7",
    "8th Highlight-",
]

# output

true
```
"""
function _get_highlights_from_PDF(target::String; concatenate::Bool=true)::Vector{String}
    highlights, _, _ = get_highlights_comments_pages(target; concatenate)
    return highlights
end
