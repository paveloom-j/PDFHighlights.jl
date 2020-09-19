function initialize(csv::String)

    # Check that the path has the correct extension
    !endswith(csv, ".csv") && throw(NotCSV(csv))

    # Check if the csv exists
    if isfile(csv)

        if length(readlines(csv)) == 0

            # Write the header
            open(csv, "w") do io
                println(io, header)
            end

        else

            # Check if the structure of the table is correct
            _check(csv)

        end

    else

        # Write the header
        open(csv, "w") do io
            println(io, header)
        end

    end

end
