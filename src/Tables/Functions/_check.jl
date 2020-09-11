function _check(table::Table)::Nothing

    try
        _check(table.file)
    catch
        throw(StatusChanged(table.file))
    end

    return nothing

end

function _check(file::AbstractString)::Nothing

    lines = filter(!isempty, readlines(file))

    # Check if the header is correct
    rstrip(lines[1]) != header && throw(IncorrectHeader(file))

    for (index, line) in enumerate(lines[2:end])

        # Check if the last element is parsing as an integer

        j = lastindex(line)
        i = findprev(',', line, j)

        if i != j && !isa(Meta.parse(line[(i+1):end]), Int)
            throw(LastElementIsNotAnInteger(file, index + 1))
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

        commas != 5 && throw(NotSixColumns(file, index + 1))

    end

    return nothing

end
