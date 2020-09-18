function get_urls(csv::String)::Vector{String}

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

        urls = Vector{String}(undef, n)

        third_comma_index = 0
        fourth_comma_index = 0

        # Find the third and the fourth commas outside of quotes
        for (url_index, line) in enumerate(lines[2:end])

            inside_quotes = false
            commas_counter = 0

            for (char_index, char) in pairs(line)
                if char == ','
                    if !inside_quotes
                        commas_counter += 1
                        commas_counter == 3 && (third_comma_index = char_index)
                        commas_counter == 4 && (fourth_comma_index = char_index; break)
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

            if fourth_comma_index == third_comma_index + 1
                urls[url_index] = ""
            else

                url = line[(third_comma_index + 1):(fourth_comma_index - 1)]

                starts_with_quote = startswith(url, "\"")
                ends_with_quote = endswith(url, "\"")

                if startswith(url, "\"") && !startswith(url, "\"\"") &&
                   !startswith(url, "\\\"")
                    urls[url_index] = chop(url; head = 1, tail = 1)
                else
                    urls[url_index] = url
                end

            end

        end

        subs = Dict("\\\"" => "\"", "\"\"" => "\"")
        replace.(urls, r"\\\\\"|\"\"" => s -> subs[s])

    else
        return []
    end

end
