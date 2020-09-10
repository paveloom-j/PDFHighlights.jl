function highlights_comments(
    pdf::AbstractString;
    concatenate::Bool = true
    )::Tuple{Vector{String}, Vector{String}}

    highlights = String[]
    comments = String[]

    # Import Python packages
    popplerqt5 = pyimport("popplerqt5")
    PyQt5 = pyimport("PyQt5")

    # Load the document
    document = popplerqt5.Poppler.Document.load(pdf)

    for i in 0:document.numPages() - 1
        page = document.page(i)
        annotations = page.annotations()
        (width, height) = (page.pageSize().width(), page.pageSize().height())
        if length(annotations) > 0

            # Find the highlights
            for annotation in annotations
                if pyisinstance(annotation, popplerqt5.Poppler.HighlightAnnotation)

                    # Extract the highlighted text

                    # Highlight lines
                    lines = String[]

                    # Get the quadrilaterals
                    quads = annotation.highlightQuads()

                    # Extract text from each quadrilateral
                    for quad in quads

                        # Gather the coordinates of the quadrilateral
                        rect = (
                            quad.points[1].x() * width,
                            quad.points[1].y() * height,
                            quad.points[3].x() * width,
                            quad.points[3].y() * height
                        )

                        # Create a quadrangle
                        body = PyQt5.QtCore.QRectF()
                        body.setCoords(rect...)

                        # Extract the text that is in this quadrangle
                        text = page.text(body)

                        # Save it
                        push!(lines, string(text))

                    end

                    # Combine all lines in a highlight and save it
                    push!(highlights, strip(join(lines, ' ')))

                    # Extract a comment
                    push!(comments, strip(annotation.contents()))

                end
            end
        end
    end

    if concatenate
        return _concatenate(highlights, comments)
    else
        return highlights, comments
    end

end
