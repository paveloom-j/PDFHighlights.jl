function _get_authors_from_CSV(csv::String)::Vector{String}

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
                    if char == '"'
                        inside_quotes ? inside_quotes = false : inside_quotes = true
                    end
                end
            end

            if third_comma_index == second_comma_index + 1
                authors[author_index] = ""
            else

                author = line[(second_comma_index + 1):(third_comma_index - 1)]

                if author == "\"\""
                    authors[author_index] = ""
                elseif startswith(author, "\"")
                    authors[author_index] = chop(author; head = 1, tail = 1)
                else
                    authors[author_index] = author
                end

            end

        end

        replace.(authors, "\"\"" => "\"")

    else
        return []
    end

end
