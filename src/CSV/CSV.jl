module CSV

using ..Exceptions
using ..PDF

export _get_highlights_from_csv,
       get_authors,
       get_locations,
       get_notes,
       get_titles,
       get_urls,
       import_highlights,
       initialize,
       print_info

# Default header
const header = "Highlight,Title,Author,URL,Note,Location"

# Load the functions

# Initialize a table
include("Functions/initialize.jl")

# Check if the structure of the table is correct
include("Functions/_check.jl")

# Print the info about the table
include("Functions/print_info.jl")

# Import the highlights from the PDF
include("Functions/import_highlights.jl")

# Get the column values from the table
include("Functions/_get_highlights_from_csv.jl")
include("Functions/get_titles.jl")
include("Functions/get_authors.jl")
include("Functions/get_urls.jl")
include("Functions/get_notes.jl")
include("Functions/get_locations.jl")

end
