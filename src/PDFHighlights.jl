__precompile__()

baremodule PDFHighlights

module Internal

# Include source code
include("Exceptions/Exceptions.jl")
include("Highlights/Highlights.jl")
include("Metadata/Metadata.jl")
include("Tables/Tables.jl")

# Export contents of the modules into `Internal`
using .Exceptions
using .Highlights
using .Metadata
using .Tables

end

# Export the second-level functions
using .Internal.Highlights
using .Internal.Metadata
using .Internal.Tables

# Export the first level functions
export comments_pages,
       highlights_comments,
       highlights_comments_pages,
       highlights_pages
export author_title
export Table

end
