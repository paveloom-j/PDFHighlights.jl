function get_highlights_comments_pages(
    target::String;
    concatenate::Bool = true,
)::Tuple{Vector{String}, Vector{String}, Vector{Int}}

    highlights = String[]
    comments = String[]
    pages = Int[]

    if isdir(target)

        for (root, dirs, files) in walkdir(target), file in files
            if endswith(file, ".pdf")
                highlights, comments, pages = vcat.(
                    (highlights, comments, pages),
                    get_highlights_comments_pages(joinpath(root, file); concatenate)
                )
            end
        end

        return highlights, comments, pages

    end

    !isfile(target) && throw(DoesNotExist(target))
    !endswith(target, ".pdf") && throw(NotPDF(target))

    # Import Python packages
    poppler = pyimport("popplerqt5")
    PyQt5 = pyimport("PyQt5")

    # Load the document
    document = poppler.Poppler.Document.load(target)

    for page_number in 0:(document.numPages() - 1)

        # Load the page
        page = document.page(page_number)

        # Get the annotations
        annotations = page.annotations()

        # Get the width and the height of the page
        (width, height) = (page.pageSize().width(), page.pageSize().height())

        if length(annotations) > 0

            # Find the highlights
            for annotation in annotations
                if pyisinstance(annotation, poppler.Poppler.HighlightAnnotation)

                    # Extract the highlighted text

                    # Highlight lines
                    lines = String[]

                    # Highlight string
                    highlight = ""

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
                        push!(lines, strip(string(text)))

                    end

                    hyphen_chopped = false
                    number_of_lines = length(lines)

                    # Remove word transfers
                    for (index, line) in enumerate(lines)
                        if endswith(line, "-")
                            if hyphen_chopped
                                if index == number_of_lines
                                    highlight = string(highlight, line)
                                else
                                    highlight = string(highlight, chop(line))
                                end
                            else
                                if number_of_lines == 1
                                    highlight = string(highlight, line)
                                elseif index == 1
                                    highlight = string(highlight, chop(line))
                                elseif index == number_of_lines
                                    highlight = string(highlight, ' ', line)
                                else
                                    highlight = string(highlight, ' ', chop(line))
                                end
                            end
                            hyphen_chopped = true
                        else
                            if hyphen_chopped
                                highlight = string(highlight, line)
                            else
                                if index == 1
                                    highlight = string(highlight, line)
                                else
                                    highlight = string(highlight, ' ', line)
                                end
                            end
                            hyphen_chopped = false
                        end
                    end

                    # Combine all lines in a highlight and save it
                    push!(highlights, highlight)

                    # Save the comment
                    push!(comments, strip(annotation.contents()))

                    # Save the page
                    push!(pages, page_number + 1)

                end
            end

        end

    end

    if concatenate
        return _concatenate(highlights, comments, pages)
    else
        return highlights, comments, pages
    end

end
