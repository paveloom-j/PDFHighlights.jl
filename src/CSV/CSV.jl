"This module contains functions that can only be applied to CSV files."
module CSV

using ..Constants
using ..Exceptions
using ..PDF

export _get_authors_from_CSV,
       _get_highlights_from_CSV,
       _get_titles_from_CSV,
       get_all,
       get_locations,
       get_notes,
       get_titles,
       get_urls,
       import_highlights,
       initialize

# Load the functions

# Initialize a table
include("Functions/initialize.jl")

# Check if the structure of the table is correct
include("Functions/_check.jl")

# Import the highlights from the PDF
include("Functions/import_highlights.jl")

# Get the column values from the table
include("Functions/_get_authors_from_CSV.jl")
include("Functions/_get_highlights_from_CSV.jl")
include("Functions/_get_titles_from_CSV.jl")
include("Functions/get_all.jl")
include("Functions/get_urls.jl")
include("Functions/get_notes.jl")
include("Functions/get_locations.jl")

end
