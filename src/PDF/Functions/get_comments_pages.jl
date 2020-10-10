"""
    get_comments_pages(
        target::String;
        concatenate::Bool=false,
    ) -> Tuple{Vector{String}, Vector{Int32}}

Extract the comments and pages from a passed PDF or all PDFs found recursively in the
passed directory.

# Arguments
- `target::String`: $(TARGET_PDF_ARGUMENT)

# Keywords
- `concatenate::Bool=false`: $(CONCATENATE_KEYWORD)

# Returns
- `Tuple{Vector{String}, Vector{Int32}}`: the comments and pages

# Throws
- Exceptions from: [`get_highlights_comments_pages`](@ref)

# Example
```jldoctest; output = false
using PDFHighlights

path_to_pdf_dir = joinpath(pathof(PDFHighlights) |> dirname |> dirname, "test", "pdf")
path_to_pdf = joinpath(path_to_pdf_dir, "TestPDF.pdf")

get_comments_pages(path_to_pdf_dir; concatenate = true) ==
get_comments_pages(path_to_pdf; concatenate = true) ==
(
    String["Comment 1", "Comment 2 Comment 3", "Comment 4", "", "", "", ""],
    Int32[1, 2, 4, 6, 7, 8, 9],
)

# output

true
```
"""
function get_comments_pages(
    target::String;
    concatenate::Bool=false,
)::Tuple{Vector{String}, Vector{Int32}}

    _, comments, pages = get_highlights_comments_pages(target; concatenate)
    return comments, pages

end
