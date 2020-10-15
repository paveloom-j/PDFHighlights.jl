"""
    _check(csv::String) -> Nothing

Check the structural integrity of the CSV file (see the exceptions list).

# Arguments
- `csv::String`: $(CSV_ARGUMENT)

# Throws
- [`IncorrectHeader`](@ref): $(INCORRECT_HEADER_EXCEPTION)
- [`LastElementIsNotAnInteger`](@ref): $(LAST_ELEMENT_IS_NOT_AN_INTEGER_EXCEPTION)
- [`NotFiveColumns`](@ref): $(NOT_FIVE_COLUMNS_EXCEPTION)

# Example
```jldoctest; output = false
using PDFHighlights
HEADER = PDFHighlights.Internal.Constants.HEADER

_file, io = mktemp()
println(io, HEADER)
flush(io)
file = _file * ".csv"
mv(_file, file)

PDFHighlights.Internal.CSV._check(file)

# output


```
"""
function _check(csv::String)::Nothing

    lines = filter(!isempty, readlines(csv))

    # Check if the header is correct
    rstrip(lines[1]) != HEADER && throw(IncorrectHeader(csv))

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

        # Check that each row represents values of 5 columns

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

        commas != 4 && throw(NotFiveColumns(csv, index + 1))

    end

    return nothing

end
