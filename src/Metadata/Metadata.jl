module Metadata

export author_title,
       author,
       title

using PyCall: pyimport, pyisinstance

# Load the functions
include("Functions/author.jl")
include("Functions/author_title.jl")
include("Functions/title.jl")

end
