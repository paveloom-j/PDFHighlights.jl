function get_author_title(pdf::String)::Tuple{String, String}

    !isfile(pdf) && throw(FileDoesNotExist(pdf))
    !endswith(pdf, ".pdf") && throw(NotPDF(pdf))

    poppler = pyimport("popplerqt5")
    document = poppler.Poppler.Document.load(pdf)

    return document.info("Author"), document.info("Title")

end
