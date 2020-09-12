function _titles(table::Table)::Vector{String}

    table.check()

    lines = filter(!isempty, readlines(table.file))
    n = length(lines) - 1

    starts_with_quote = false
    ends_with_quote = false

    if n > 0

        titles = Vector{String}(undef, n)

        first_comma_index = 0
        second_comma_index = 0

        # Find the first and the second commas outside of quotes
        for (title_index, line) in enumerate(lines[2:end])

            inside_quotes = false
            commas_counter = 0

            for (char_index, char) in pairs(line)
                if char == ','
                    if !inside_quotes
                        commas_counter += 1
                        commas_counter == 1 && (first_comma_index = char_index)
                        commas_counter == 2 && (second_comma_index = char_index; break)
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

            if second_comma_index == first_comma_index + 1
                titles[title_index] = ""
            else

                title = line[(first_comma_index + 1):(second_comma_index - 1)]

                starts_with_quote = startswith(title, "\"")
                ends_with_quote = endswith(title, "\"")

                if starts_with_quote && ends_with_quote
                    titles[title_index] = chop(title; head = 1, tail = 1)
                elseif starts_with_quote
                    titles[title_index] = chop(title; head = 1)
                elseif ends_with_quote
                    titles[title_index] = chop(title; tail = 1)
                else
                    titles[title_index] = title
                end

            end

        end

        subs = Dict("\\\"" => "\"", "\"\"" => "\"")
        replace.(titles, r"\\\\\"|\"\"" => s -> subs[s])

    else
        return []
    end

end
