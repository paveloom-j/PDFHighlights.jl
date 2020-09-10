function _pdf(table::Table, pdf::AbstractString; show::Bool = false)::Nothing

    table.check()

    existing_lines = readlines(table.file)

    author, title = map(
        collection -> replace.(collection, "\"" => "\"\""),
        author_title(pdf)
    )

    highlights, comments = map(
        collection -> replace.(collection, "\"" => "\"\""),
        highlights_comments(pdf)
    )

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
        "\","
    )

    found = length(new_lines)

    new_lines = filter(line -> !(line in existing_lines), new_lines)

    added = length(new_lines)

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
