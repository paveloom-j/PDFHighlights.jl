"""
    get_comments(target::String; concatenate::Bool=false) -> Vector{String}

Extract the comments from a passed PDF or all PDFs found recursively in the
passed directory.

# Arguments
- `target::String`: $(TARGET_PDF_ARGUMENT)

# Keywords
- `concatenate::Bool=false`: $(CONCATENATE_KEYWORD)

# Returns
- `Vector{String}`: the comments

# Throws
- Exceptions from: [`get_highlights_comments_pages`](@ref)

# Example
```jldoctest; output = false
using PDFHighlights

path_to_pdf_dir = joinpath(pathof(PDFHighlights) |> dirname |> dirname, "test", "pdf")
path_to_pdf = joinpath(path_to_pdf_dir, "TestPDF.pdf")

get_comments(path_to_pdf_dir; concatenate=true) ==
get_comments(path_to_pdf; concatenate=true) ==
["Comment 1", "Comment 2 Comment 3", "Comment 4", "", "", "", ""]

# output

true
```
"""
function get_comments(target::String; concatenate::Bool=false)::Vector{String}
    _, comments, _ = get_highlights_comments_pages(target; concatenate)
    return comments
end
