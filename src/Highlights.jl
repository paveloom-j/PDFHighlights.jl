module Highlights

export highlights_comments,
       highlights,
       comments

using PyCall: pyimport, pyisinstance

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

function _concatenate(
    highlights::Vector{String},
    comments::Vector{String}
    )::Tuple{Vector{String}, Vector{String}}

    # The initial concatenation identifier
    id = 1

    # Combine highlights if there are concatenation identifiers
    for (index, comment) in enumerate(comments)

        # Start a new chain of highlights
        if startswith(comment, ".c1")

            id = 2

        # Continue the current chain of highlights
        elseif startswith(comment, ".c$(id)")

            # Get the current highlight
            current_highlight = highlights[index]

            # Get the chain's first highlight
            first_highlight = highlights[index - id + 1]

            # Take the last word from the chain's first highlight
            half_word = split(first_highlight, ' ')[end]

            # If the last word ends with `-`, concatenate the halves
            if length(half_word) > 1 && endswith(half_word, '-')
                highlights[index - id + 1] = first_highlight[1:end-1] * current_highlight
                highlights[index] = ""
            else
                highlights[index - id + 1] *= ' ' * current_highlight
                highlights[index] = ""
            end

            id += 1

        # Drop the current chain of highlights
        else

            id = 1

        end

    end

    return filter(!isempty, highlights),
           filter(element -> !startswith(element, r".c([2-9]|[1-9][0-9])+"), comments)

end

function highlights(pdf::AbstractString; concatenate = true)::Vector{String}
    highlights, _ = highlights_comments(pdf; concatenate)
    return highlights
end

function comments(pdf::AbstractString; concatenate = false)::Vector{String}
    _, comments = highlights_comments(pdf; concatenate)
    return comments
end

end
