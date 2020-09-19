using Base: sort!

function Base.sort!(csv::String; column::Symbol = :title)::Nothing

    try
        initialize(csv)
    catch
        throw(IntegrityCheckFailed(csv))
    end

    highlights = replace.(_get_highlights_from_CSV(csv), "\"" => "\"\"")
    titles = replace.(_get_titles_from_CSV(csv), "\"" => "\"\"")
    authors = replace.(_get_authors_from_CSV(csv), "\"" => "\"\"")
    urls = replace.(get_urls(csv), "\"" => "\"\"")
    notes = replace.(get_notes(csv), "\"" => "\"\"")
    locations = get_locations(csv)

    columns = Dict{Symbol, Union{Array{String, 1}, Array{Int, 1}}}(
        (:highlight, :title, :author, :url, :note, :location) .=>
        (highlights, titles, authors, urls, notes, locations)
    )

    perm = sortperm(columns[column])

    lines = string.(
        "\"",
        highlights[perm],
        "\",\"",
        titles[perm],
        "\",\"",
        authors[perm],
        "\",\"",
        urls[perm],
        "\",\"",
        notes[perm],
        "\",",
        locations[perm],
    )

    open(csv, "w") do io
        println(io, header, '\n', join(lines, '\n'))
    end

    return nothing

end
