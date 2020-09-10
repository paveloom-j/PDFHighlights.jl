module Highlights

export comments,
       highlights,
       highlights_comments

using PyCall: pyimport, pyisinstance

# Load the functions
include("Functions/_concatenate.jl")
include("Functions/comments.jl")
include("Functions/highlights.jl")
include("Functions/highlights_comments.jl")

end
