function get_notes(csv::String)::Vector{String}

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
                    if char == '"'
                        inside_quotes ? inside_quotes = false : inside_quotes = true
                    end
                end
            end

            if fifth_comma_index == fourth_comma_index + 1
                notes[note_index] = ""
            else

                note = line[(fourth_comma_index + 1):(fifth_comma_index - 1)]

                if note == "\"\""
                    notes[note_index] = ""
                elseif startswith(note, "\"")
                    notes[note_index] = chop(note; head = 1, tail = 1)
                else
                    notes[note_index] = note
                end

            end

        end

        replace.(notes, "\"\"" => "\"")

    else
        return []
    end

end
