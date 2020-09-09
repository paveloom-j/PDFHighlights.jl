module Tables

using CSV
using ..Exceptions
using ..Highlights
using ..Metadata

export Table

# Default header
const header = "Highlight,Title,Author,URL,Note,Location"

struct Table

    # Path to the table
    file::String

    # Check if the structure of the table is correct
    check::Function

    # Print the info about the table
    info::Function

    # Get the highlights for the table
    highlights::Function

    # Get the notes for the table
    notes::Function

    # Import the highlights from the PDF
    pdf::Function

    # Construct an object of this type
    function Table(file::AbstractString)

        # Check that the path has the correct extension
        !endswith(file, ".csv") && throw(IncorrectExtension(file))

        # Check if the file exists
        if isfile(file)

            # Check if the structure of the table is correct
            _check(file)

        else

            # Write the header
            open(file, "w") do io
                println(io, header)
            end

        end

        this = new(
            file,
            () -> _check(this),
            () -> _info(this),
            () -> _highlights(this),
            () -> _notes(this),
            (pdf::AbstractString; show::Bool = false) -> _pdf(this, pdf; show),
        )

        return this

    end

end

function _check(table::Table)::Nothing

    try
        _check(table.file)
    catch
        throw(StatusChanged(table.file))
    end

    return nothing

end

function _check(file::AbstractString)::Nothing

    lines = filter(!isempty, readlines(file))

    # Check if the header is correct
    rstrip(lines[1]) != header && throw(IncorrectHeader(file))

    for (index, line) in enumerate(lines[2:end])

        # Check if the last element is parsing as an integer

        j = lastindex(line)
        i = findprev(',', line, j)

        if i != j && !isa(Meta.parse(line[(i+1):end]), Int)
            throw(LastElementIsNotAnInteger(file, index + 1))
        end

        # Check that each row represents values of 6 columns

        inside_quotes = false
        commas = 0

        for char in line
            if char == ','
                if !inside_quotes
                    commas += 1
                end
            elseif char == '"'
                if inside_quotes
                    inside_quotes = false
                else
                    inside_quotes = true
                end
            end
        end

        commas != 5 && throw(NotSixColumns(file, index + 1))

    end

    return nothing

end

function _info(table::Table)::Nothing
    table.check()
    println("""

        Table path: "$(table.file)"
        Number of highlights: $(length(table.highlights()))
    """)

    return nothing
end

function _highlights(table::Table)::Vector{String}
    table.check()
    csv = CSV.File(table.file; silencewarnings = true)
    return csv.Highlight
end

function _notes(table::Table)::Vector{String}
    table.check()
    csv = CSV.File(table.file; silencewarnings = true)
    return csv.Note
end

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

end
