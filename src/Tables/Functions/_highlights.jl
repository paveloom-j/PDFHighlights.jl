function _highlights(table::Table)::Vector{String}

    table.check()

    lines = filter(!isempty, readlines(table.file))
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
                    if char_index == 1
                        if char == '"'
                            inside_quotes ? inside_quotes = false : inside_quotes = true
                        end
                    else
                        if char == '"' && line[prevind(line, char_index)] != '\\'
                            inside_quotes ? inside_quotes = false : inside_quotes = true
                        end
                    end
                end
            end

            if comma_index == 1
                highlights[highlight_index] = ""
            else

                highlight = line[1:(comma_index - 1)]

                starts_with_quote = startswith(highlight, "\"")
                ends_with_quote = endswith(highlight, "\"")

                if starts_with_quote && ends_with_quote
                    highlights[highlight_index] = chop(highlight; head = 1, tail = 1)
                elseif starts_with_quote
                    highlights[highlight_index] = chop(highlight; head = 1)
                elseif ends_with_quote
                    highlights[highlight_index] = chop(highlight; tail = 1)
                else
                    highlights[highlight_index] = highlight
                end

            end

        end

        subs = Dict("\\\"" => "\"", "\"\"" => "\"")
        replace.(highlights, r"\\\\\"|\"\"" => s -> subs[s])

    else
        return []
    end

end
