function import_highlights(
    csv::String,
    target::String;
    show::Bool = false
)::Nothing

    try
        initialize(csv)
    catch
        throw(IntegrityCheckFailed(csv))
    end

    existing_lines = readlines(csv)

    all_highlights = String[]
    all_comments = String[]

    if isdir(target)

        new_lines = String[]

        for (root, dirs, files) in walkdir(target), file in files
            if endswith(file, ".pdf")

                path = joinpath(root, file)

                author, title = map(
                    collection -> replace.(collection, "\"" => "\\\""),
                    get_author_title(path)
                )

                highlights, comments, pages = get_highlights_comments_pages(path)

                replace!(highlight -> replace(highlight, "\"" => "\\\""), highlights)
                replace!(comment -> replace(comment, "\"" => "\\\""), comments)

                all_highlights = vcat(all_highlights, highlights)
                all_comments = vcat(all_comments, comments)

                new_lines = vcat(
                    new_lines,
                    string.(
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
                )

            end
        end

    else

        author, title = map(
            collection -> replace.(collection, "\"" => "\\\""),
            get_author_title(target)
        )

        highlights, comments, pages = get_highlights_comments_pages(target)

        replace!(highlight -> replace(highlight, "\"" => "\\\""), highlights)
        replace!(comment -> replace(comment, "\"" => "\\\""), comments)

        all_highlights = highlights
        all_comments = comments

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

    end

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

    if isdir(target)

        dir = normpath(target)
        basename_dir = basename(dir)

        if basename_dir == ""
            dir = basename(dirname(dir))
        else
            dir = basename_dir
        end

        println("""

            CSV: "$(basename(csv))"
            Directory: "$(basename(dir))"
            Highlights (found / added): $(found) / $(added)
        """)

    else

        println("""

            CSV: "$(basename(csv))"
            PDF: "$(basename(target))"
            Highlights (found / added): $(found) / $(added)
        """)

    end

    if show

        println("    Found highlights:")
        for (index, highlight) in enumerate(all_highlights)
            println("    ", "[$(index)] ", highlight)
        end

        println("\n    Found comments:")
        for (index, comment) in enumerate(all_comments)
            println("    ", "[$(index)] ", comment)
        end

        println()

    end

    return nothing

end
