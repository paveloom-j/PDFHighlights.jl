function get_author_title(pdf::String)::Tuple{String, String}

    !endswith(pdf, ".pdf") && throw(NotPDF(pdf))
    !isfile(pdf) && throw(DoesNotExist(pdf))

    poppler = pyimport("popplerqt5")
    document = poppler.Poppler.Document.load(pdf)

    return document.info("Author"), document.info("Title")

end
