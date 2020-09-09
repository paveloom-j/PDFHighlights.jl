module Metadata

export author_title,
       author,
       title

using PyCall: pyimport, pyisinstance

function author_title(pdf::AbstractString)::Tuple{String, String}
    popplerqt5 = pyimport("popplerqt5")
    document = popplerqt5.Poppler.Document.load(pdf)
    return document.info("Author"), document.info("Title")
end

function author(pdf::AbstractString)::String
    author, _ = author_title(pdf)
    return author
end

function title(pdf::AbstractString)::String
    _, title = author_title(pdf)
    return title
end

end
