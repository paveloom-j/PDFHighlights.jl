__precompile__()

baremodule PDFHighlights

module Internal

# Include source code
include("Exceptions.jl")
include("Highlights.jl")
include("Metadata.jl")
include("Tables.jl")

# Export contents of the modules into `Internal`
using .Exceptions
using .Highlights
using .Metadata
using .Tables

end

using .Internal.Highlights
using .Internal.Metadata
using .Internal.Tables

export highlights_comments
export author_title
export Table

end
