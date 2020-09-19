function _get_highlights_from_CSV(csv::String)::Vector{String}

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
        comma_index = 0

        # Find the first comma outside of quotes
        for (highlight_index, line) in enumerate(lines[2:end])

            inside_quotes = false

            for (char_index, char) in pairs(line)
                if char == ','
                    if !inside_quotes
                        comma_index = char_index
                        break
                    end
                else
                    if char == '"'
                        inside_quotes ? inside_quotes = false : inside_quotes = true
                    end
                end
            end

            if comma_index == 1
                highlights[highlight_index] = ""
            else

                highlight = line[1:(comma_index - 1)]

                if highlight == "\"\""
                    highlights[highlight_index] = ""
                elseif startswith(highlight, "\"")
                    highlights[highlight_index] = chop(highlight; head = 1, tail = 1)
                else
                    highlights[highlight_index] = highlight
                end

            end

        end

        replace.(highlights, "\"\"" => "\"")

    else
        return []
    end

end
