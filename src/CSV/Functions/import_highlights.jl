"""
    import_highlights(csv::String, target::String) -> Nothing

Extract the values of the `URL` column from the CSV file.

# Arguments
- `csv::String`: $(CSV_ARGUMENT)
- `target::String`: $(TARGET_PDF_ARGUMENT)

# Throws
- [`IntegrityCheckFailed`](@ref): $(INTEGRITY_CHECK_FAILED_EXCEPTION)
- Exceptions from: [`initialize`](@ref)

# Example
```jldoctest; output = false
using PDFHighlights
using Suppressor

path_to_pdf_dir = joinpath(pathof(PDFHighlights) |> dirname |> dirname, "test", "pdf")
path_to_pdf = joinpath(path_to_pdf_dir, "TestPDF.pdf")

_file, io = mktemp()
file = _file * ".csv"
mv(_file, file)

(@capture_out(import_highlights(file, path_to_pdf)) ==
\"\"\"

    CSV: "\$(basename(file))"
    PDF: "TestPDF.pdf"
    Highlights (found / added): 7 / 7

\"\"\") |> println

@capture_out(import_highlights(file, path_to_pdf_dir)) ==
\"\"\"

    CSV: "\$(basename(file))"
    Directory: "pdf"
    Highlights (found / added): 7 / 0

\"\"\"

# output

true
true
```
"""
function import_highlights(csv::String, target::String)::Nothing

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
                    collection -> replace.(collection, "\"" => "\"\""),
                    get_author_title(path)
                )

                highlights, comments, pages = get_highlights_comments_pages(path)

                replace!(highlight -> replace(highlight, "\"" => "\"\""), highlights)
                replace!(comment -> replace(comment, "\"" => "\"\""), comments)

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
                        "\",\"",
                        "\",\"",
                        comments,
                        "\",",
                        pages
                    )
                )

            end
        end

    else

        author, title = map(
            collection -> replace.(collection, "\"" => "\"\""),
            get_author_title(target)
        )

        highlights, comments, pages = get_highlights_comments_pages(target)

        replace!(highlight -> replace(highlight, "\"" => "\"\""), highlights)
        replace!(comment -> replace(comment, "\"" => "\"\""), comments)

        all_highlights = highlights
        all_comments = comments

        new_lines = string.(
            "\"",
            highlights,
            "\",\"",
            title,
            "\",\"",
            author,
            "\",\"",
            "\",\"",
            comments,
            "\",",
            pages,
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

    return nothing

end
