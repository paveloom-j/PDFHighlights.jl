function author_title(pdf::AbstractString)::Tuple{String, String}
    popplerqt5 = pyimport("popplerqt5")
    document = popplerqt5.Poppler.Document.load(pdf)
    return document.info("Author"), document.info("Title")
end
