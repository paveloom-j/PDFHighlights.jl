"This module contains functions that can be applied to both PDF and CSV files."
module Both

export get_authors,
       get_highlights,
       get_titles

using ..Constants
using ..Exceptions
using ..CSV
using ..PDF

# Load the functions

# Export the authors from a table or from a PDF
include("Functions/get_authors.jl")

# Export the highlights from a table or from a PDF
include("Functions/get_highlights.jl")

# Export the titles from a table or from a PDF
include("Functions/get_titles.jl")

end
