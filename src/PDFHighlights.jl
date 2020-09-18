__precompile__()

baremodule PDFHighlights

module Internal

# Include source code
include("Exceptions/Exceptions.jl")
include("PDF/PDF.jl")
include("CSV/CSV.jl")
include("Both/Both.jl")

# Export contents of the modules into `Internal`
using .Exceptions
using .PDF
using .CSV
using .Both

end

# Export the second-level functions
using .Internal.PDF
using .Internal.CSV
using .Internal.Both

# Export the first-level functions
export #= PDF =#
       get_author_title,
       get_author,
       get_authors_titles,
       get_comments_pages,
       get_comments,
       get_highlights_comments_pages,
       get_highlights_comments,
       get_highlights_pages,
       get_pages,
       get_title,
       #= CSV =#
       get_locations,
       get_notes,
       get_urls,
       import_highlights,
       initialize,
       print_info,
       #= Both =#
       get_authors,
       get_highlights,
       get_titles

end
