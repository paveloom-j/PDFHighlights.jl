function import_highlights(
    csv::String,
    pdf::String;
    show::Bool = false
)::Nothing

    try
        initialize(csv)
    catch
        throw(IntegrityCheckFailed(csv))
    end

    existing_lines = readlines(csv)

    author, title = map(
        collection -> replace.(collection, "\"" => "\\\""),
        get_author_title(pdf)
    )

    highlights, comments, pages = get_highlights_comments_pages(pdf)

    replace!(highlight -> replace(highlight, "\"" => "\\\""), highlights)
    replace!(comment -> replace(comment, "\"" => "\\\""), comments)

    new_lines = string.(
        "\"",
        highlights,
        "\",\"",
        title,
        "\",\"",
        author,
        "\",",
        ",\"",
        comments,
        "\",",
        pages
    )

    # Get the number of highlights found in the pdf
    found = length(new_lines)

    # Filter existing strings
    new_lines = filter(line -> !(line in existing_lines), new_lines)

    # Get the number of highlights that will be added to the table
    added = length(new_lines)

    # Write the new lines
    if !isempty(new_lines)
        open(csv, "a") do io
            println(io, join(new_lines, '\n'))
        end
    end

    println("""

        CSV: "$(basename(csv))"
        PDF: "$(basename(pdf))"
        Highlights (found / added): $(found) / $(added)
    """)

    if show

        println("    Found highlights:")
        for (index, highlight) in enumerate(highlights)
            println("    ", "[$(index)] ", highlight)
        end

        println("\n    Found comments:")
        for (index, comment) in enumerate(comments)
            println("    ", "[$(index)] ", comment)
        end

        println()

    end

    return nothing

end
