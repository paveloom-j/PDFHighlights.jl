function _check(csv::String)::Nothing

    lines = filter(!isempty, readlines(csv))

    # Check if the header is correct
    rstrip(lines[1]) != header && throw(IncorrectHeader(csv))

    for (index, line) in enumerate(lines[2:end])

        # Check if the last element is parsing as an integer

        j = lastindex(line)
        i = findprev(',', line, j)

        if i != j
            try
                parse(Int32, line[(i+1):end])
            catch
                throw(LastElementIsNotAnInteger(csv, index + 1))
            end
        end

        # Check that each row represents values of 6 columns

        inside_quotes = false
        commas = 0

        for (char_index, char) in pairs(line)
            if char == ','
                if !inside_quotes
                    commas += 1
                end
            else
                if char == '"'
                    inside_quotes ? inside_quotes = false : inside_quotes = true
                end
            end
        end

        commas != 5 && throw(NotSixColumns(csv, index + 1))

    end

    return nothing

end
