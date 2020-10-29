"This module contains functions that can only be applied to PDF files."
module PDF

export _get_authors_from_PDF,
       _get_highlights_from_PDF,
       _get_titles_from_PDF,
       get_author_title,
       get_author,
       get_authors_titles,
       get_comments_pages,
       get_comments,
       get_highlights_comments_pages,
       get_highlights_comments,
       get_highlights_pages,
       get_pages,
       get_title

using ..Constants
using ..Exceptions
using PDFHighlights_jll
using SHA

# Load the functions

# Sort the highlights and their lines by `x`
include("Functions/_sort!.jl")

# Export author(s) and title(s) from the PDF(s)
include("Functions/_get_authors_from_PDF.jl")
include("Functions/_get_titles_from_PDF.jl")
include("Functions/get_author_title.jl")
include("Functions/get_authors_titles.jl")
include("Functions/get_author.jl")
include("Functions/get_title.jl")

# Concatenation of highlights based on comments
include("Functions/_concatenate.jl")

# Export highlights, comments, and pages from a PDF
include("Functions/get_highlights_comments_pages.jl")

# Same, but export any pair
include("Functions/get_comments_pages.jl")
include("Functions/get_highlights_comments.jl")
include("Functions/get_highlights_pages.jl")

# Same, but export one thing
include("Functions/get_comments.jl")
include("Functions/_get_highlights_from_PDF.jl")
include("Functions/get_pages.jl")

function __init__()

    # Create dictionaries to save outputs
    @doc """
    A dictionary that is created at runtime to store the results of the
    [`get_author_title`](@ref) function.
    """
    global GET_AUTHOR_TITLE_OUTPUTS = Dict{String,Tuple{String, String}}()

    @doc """
    A dictionary that is created at runtime to store the results of the
    [`get_highlights_comments_pages`](@ref) function.
    """
    global GET_HIGHLIGHTS_COMMENTS_PAGES_OUTPUTS = Dict{
        Tuple{String, Bool},
        Tuple{Vector{String}, Vector{String}, Vector{Int32}}
    }()

end

end
