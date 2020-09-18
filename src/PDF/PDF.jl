module PDF

export _get_highlights_from_pdf,
       get_author_title,
       get_author,
       get_comments_pages,
       get_comments,
       get_highlights_comments_pages,
       get_highlights_comments,
       get_highlights_pages,
       get_pages,
       get_title

using ..Exceptions
using PyCall: pyimport, pyisinstance

# Load the functions

# Export author and title from a PDF
include("Functions/get_author_title.jl")

# Same, but export one thing
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
include("Functions/_get_highlights_from_pdf.jl")
include("Functions/get_pages.jl")

end
