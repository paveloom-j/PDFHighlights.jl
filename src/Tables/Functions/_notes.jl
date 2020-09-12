function _notes(table::Table)::Vector{String}

    table.check()

    lines = filter(!isempty, readlines(table.file))
    n = length(lines) - 1

    starts_with_quote = false
    ends_with_quote = false

    if n > 0

        notes = Vector{String}(undef, n)

        fourth_comma_index = 0
        fifth_comma_index = 0

        # Find the fourth and fifth commas outside of quotes
        for (note_index, line) in enumerate(lines[2:end])

            inside_quotes = false
            commas_counter = 0

            for (char_index, char) in pairs(line)
                if char == ','
                    if !inside_quotes
                        commas_counter += 1
                        commas_counter == 4 && (fourth_comma_index = char_index)
                        commas_counter == 5 && (fifth_comma_index = char_index; break)
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

            if fifth_comma_index == fourth_comma_index + 1
                notes[note_index] = ""
            else

                note = line[(fourth_comma_index + 1):(fifth_comma_index - 1)]

                starts_with_quote = startswith(note, "\"")
                ends_with_quote = endswith(note, "\"")

                if starts_with_quote && ends_with_quote
                    notes[note_index] = chop(note; head = 1, tail = 1)
                elseif starts_with_quote
                    notes[note_index] = chop(note; head = 1)
                elseif ends_with_quote
                    notes[note_index] = chop(note; tail = 1)
                else
                    notes[note_index] = note
                end

            end

        end

        subs = Dict("\\\"" => "\"", "\"\"" => "\"")
        replace.(notes, r"\\\\\"|\"\"" => s -> subs[s])

    else
        return []
    end

end
