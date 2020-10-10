"""
    initialize(csv::String) -> Nothing

If the file along the `csv` path does not exist, then create it and write the header;
if it exists but empty, do the same; if it exists and is not empty, check structural
correctness.

# Arguments
- `csv::String`: $(CSV_ARGUMENT)

# Throws
- [`NotCSV`](@ref): $(NOT_CSV_EXCEPTION)
- Exceptions from: [`_check`](@ref)

# Example
```jldoctest; output = false
using PDFHighlights

_file, _ = mktemp()
file = _file * ".csv"
mv(_file, file)

initialize(file)

open(file, "r") do io
    readlines(io) == [\"$(HEADER)\"]
end

# output

true
```
"""
function initialize(csv::String)::Nothing

    # Check that the path has the correct extension
    !endswith(csv, ".csv") && throw(NotCSV(csv))

    # Check if the csv exists
    if isfile(csv)

        if length(readlines(csv)) == 0

            # Write the header
            open(csv, "w") do io
                println(io, HEADER)
            end

        else

            # Check if the structure of the table is correct
            _check(csv)

        end

    else

        # Write the header
        open(csv, "w") do io
            println(io, HEADER)
        end

    end

    return nothing

end
