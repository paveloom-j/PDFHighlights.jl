module Highlights

export comments,
       comments_pages,
       highlights,
       highlights_comments,
       highlights_comments_pages,
       highlights_pages,
       pages

using PyCall: pyimport, pyisinstance

# Load the functions

# Concatenation of highlights based on comments
include("Functions/_concatenate.jl")

# Export highlights, comments, and pages from PDF
include("Functions/highlights_comments_pages.jl")

# Same, but export any pair
include("Functions/comments_pages.jl")
include("Functions/highlights_comments.jl")
include("Functions/highlights_pages.jl")

# Same, but export one thing
include("Functions/comments.jl")
include("Functions/highlights.jl")
include("Functions/pages.jl")

end
