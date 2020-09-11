function _pdf(table::Table, pdf::AbstractString; show::Bool = false)::Nothing

    table.check()

    existing_lines = readlines(table.file)

    author, title = map(
        collection -> replace.(collection, "\"" => "\\\""),
        author_title(pdf)
    )

    highlights, comments, pages = highlights_comments_pages(pdf)

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
        open(table.file, "a") do io
            println(io, join(new_lines, '\n'))
        end
    end

    println("""

        File: "$(pdf)"
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
