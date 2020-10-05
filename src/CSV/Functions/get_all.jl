macro extract(array::Symbol)
    if array == :highlights
        return esc(
            quote
                if current_comma_index == 1
                    highlights[line_index] = ""
                else
                    piece = line[1:(current_comma_index - 1)]
                    if piece == "\"\""
                        highlights[line_index] = ""
                    elseif startswith(piece, "\"")
                        highlights[line_index] = chop(piece; head = 1, tail = 1)
                    else
                        highlights[line_index] = piece
                    end
                end
            end
        )
    elseif array == :locations
        return esc(
            quote
                if current_comma_index == lastindex(line)
                    locations[line_index] = 0
                else
                    locations[line_index] = parse(
                        Int32,
                        line[(current_comma_index + 1):end],
                    )
                end
            end
        )
    else
        return esc(
            quote
                if current_comma_index == previous_comma_index + 1
                    $(array)[line_index] = ""
                else
                    piece = line[(previous_comma_index + 1):(current_comma_index - 1)]
                    if piece == "\"\""
                        $(array)[line_index] = ""
                    elseif startswith(piece, "\"")
                        $(array)[line_index] = chop(piece; head = 1, tail = 1)
                    else
                        $(array)[line_index] = piece
                    end
                end
            end
        )
    end
end

function get_all(csv::String)::Tuple{
    Vector{String},
    Vector{String},
    Vector{String},
    Vector{String},
    Vector{String},
    Vector{Int32}
}

    try
        initialize(csv)
    catch
        throw(IntegrityCheckFailed(csv))
    end

    lines = filter(!isempty, readlines(csv))
    n = length(lines) - 1

    starts_with_quote = false
    ends_with_quote = false

    if n > 0

        highlights = Vector{String}(undef, n)
        titles = Vector{String}(undef, n)
        authors = Vector{String}(undef, n)
        urls = Vector{String}(undef, n)
        notes = Vector{String}(undef, n)
        locations = Vector{Int32}(undef, n)

        previous_comma_index = 0
        current_comma_index = 0

        for (line_index, line) in enumerate(lines[2:end])
        comma_number = 1
        inside_quotes = false
            for (char_index, char) in pairs(line)
                if char == ','
                    if !inside_quotes
                        previous_comma_index = current_comma_index
                        current_comma_index = char_index

                        if comma_number == 1
                            @extract highlights
                        elseif comma_number == 2
                            @extract titles
                        elseif comma_number == 3
                            @extract authors
                        elseif comma_number == 4
                            @extract urls
                        elseif comma_number == 5
                            @extract notes
                            @extract locations
                        end

                        comma_number += 1
                    end
                elseif char == '"'
                    inside_quotes ? inside_quotes = false : inside_quotes = true
                end
            end
        end

        return replace.(highlights, "\"\"" => "\""),
               replace.(titles, "\"\"" => "\""),
               replace.(authors, "\"\"" => "\""),
               replace.(urls, "\"\"" => "\""),
               replace.(notes, "\"\"" => "\""),
               locations

    else
        return String[], String[], String[], String[], String[], Int32[]
    end

end
