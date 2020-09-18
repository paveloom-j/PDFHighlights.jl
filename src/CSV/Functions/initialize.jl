function initialize(csv::String)

    # Check that the path has the correct extension
    !endswith(csv, ".csv") && throw(NotCSV(csv))

    # Check if the csv exists
    if isfile(csv)

        # Check if the structure of the table is correct
        _check(csv)

    else

        # Write the header
        open(csv, "w") do io
            println(io, header)
        end

    end

end
