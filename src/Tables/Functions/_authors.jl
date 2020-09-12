function _authors(table::Table)::Vector{String}

    table.check()

    lines = filter(!isempty, readlines(table.file))
    n = length(lines) - 1

    starts_with_quote = false
    ends_with_quote = false

    if n > 0

        authors = Vector{String}(undef, n)

        second_comma_index = 0
        third_comma_index = 0

        # Find the second and the third commas outside of quotes
        for (author_index, line) in enumerate(lines[2:end])

            inside_quotes = false
            commas_counter = 0

            for (char_index, char) in pairs(line)
                if char == ','
                    if !inside_quotes
                        commas_counter += 1
                        commas_counter == 2 && (second_comma_index = char_index)
                        commas_counter == 3 && (third_comma_index = char_index; break)
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

            if third_comma_index == second_comma_index + 1
                authors[author_index] = ""
            else

                author = line[(second_comma_index + 1):(third_comma_index - 1)]

                starts_with_quote = startswith(author, "\"")
                ends_with_quote = endswith(author, "\"")

                if starts_with_quote && ends_with_quote
                    authors[author_index] = chop(author; head = 1, tail = 1)
                elseif starts_with_quote
                    authors[author_index] = chop(author; head = 1)
                elseif ends_with_quote
                    authors[author_index] = chop(author; tail = 1)
                else
                    authors[author_index] = author
                end

            end

        end

        subs = Dict("\\\"" => "\"", "\"\"" => "\"")
        replace.(authors, r"\\\\\"|\"\"" => s -> subs[s])

    else
        return []
    end

end
