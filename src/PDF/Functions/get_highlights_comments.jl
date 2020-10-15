"""
    get_highlights_comments(
        target::String;
        concatenate::Bool=true
    ) -> Tuple{Vector{String}, Vector{String}}

Extract the highlights and comments from a passed PDF or all PDFs found recursively
in the passed directory.

# Arguments
- `target::String`: $(TARGET_PDF_ARGUMENT)

# Keywords
- `concatenate::Bool=true`: $(CONCATENATE_KEYWORD)

# Returns
- `Tuple{Vector{String}, Vector{String}}`: the highlights and comments

# Throws
- Exceptions from: [`get_highlights_comments_pages`](@ref)

# Example
```jldoctest; output = false
using PDFHighlights

path_to_pdf_dir = joinpath(pathof(PDFHighlights) |> dirname |> dirname, "test", "pdf")
path_to_pdf = joinpath(path_to_pdf_dir, "TestPDF.pdf")

get_highlights_comments(path_to_pdf_dir) ==
get_highlights_comments(path_to_pdf) ==
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
    ["Comment 1", "Comment 2 Comment 3", "Comment 4", "", "", "", ""],
)

# output

true
```
"""
function get_highlights_comments(
    target::String;
    concatenate::Bool=true,
)::Tuple{Vector{String}, Vector{String}}

    highlights, comments, _ = get_highlights_comments_pages(target; concatenate)
    return highlights, comments

end
