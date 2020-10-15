"""
    get_highlights_pages(
        target::String;
        concatenate::Bool=true
    ) -> Tuple{Vector{String}, Vector{Int32}}

Extract the highlights and pages from a passed PDF or all PDFs found recursively
in the passed directory.

# Arguments
- `target::String`: $(TARGET_PDF_ARGUMENT)

# Keywords
- `concatenate::Bool=true`: $(CONCATENATE_KEYWORD)

# Returns
- `Tuple{Vector{String}, Vector{Int32}}`: the highlights and pages

# Throws
- Exceptions from: [`get_highlights_comments_pages`](@ref)

# Example
```jldoctest; output = false
using PDFHighlights

path_to_pdf_dir = joinpath(pathof(PDFHighlights) |> dirname |> dirname, "test", "pdf")
path_to_pdf = joinpath(path_to_pdf_dir, "TestPDF.pdf")

get_highlights_pages(path_to_pdf_dir) ==
get_highlights_pages(path_to_pdf) ==
(
    [
        "Highlight 1",
        "Highlight 2 Highlight 3",
        "Highlight 4",
        "Highhighlight 5",
        "6th Highhigh light-",
        "High light 7",
        "8th Highlight-",
    ],
    Int32[1, 2, 4, 6, 7, 8, 9],
)

# output

true
```
"""
function get_highlights_pages(
    target::String;
    concatenate::Bool=true,
)::Tuple{Vector{String}, Vector{Int32}}

    highlights, _, pages = get_highlights_comments_pages(target; concatenate)
    return highlights, pages

end
