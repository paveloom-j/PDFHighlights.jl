__precompile__()

"""
A package for exporting highlights (and related data) from PDF files and saving them to
a CSV.

Links:
- Repo: https://github.com/paveloom-j/PDFHighlights.jl
- Docs: https://paveloom-j.github.io/PDFHighlights.jl
"""
baremodule PDFHighlights

"This module contains all inner parts of this package."
module Internal

# Include source code
include("Exceptions/Exceptions.jl")
include("Constants.jl")
include("PDF/PDF.jl")
include("CSV/CSV.jl")
include("Both/Both.jl")

# Export contents of the modules into `Internal`
using .Exceptions
using .Constants
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
       get_all,
       get_locations,
       get_notes,
       import_highlights,
       initialize,
       #= Both =#
       get_authors,
       get_highlights,
       get_titles

end
