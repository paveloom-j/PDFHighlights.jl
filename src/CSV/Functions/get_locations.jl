function get_locations(csv::String)::Vector{Int}

    try
        initialize(csv)
    catch
        throw(IntegrityCheckFailed(csv))
    end

    lines = filter(!isempty, readlines(csv))
    n = length(lines) - 1

    if n > 0

        locations = Vector{Int}(undef, n)

        comma_index = 0

        # Find the last comma
        for (location_index, line) in enumerate(lines[2:end])

            last_index = lastindex(line)
            comma_index = findprev(',', line, last_index)

            if comma_index == last_index
                locations[location_index] = 0
            else
                locations[location_index] = parse(Int, line[(comma_index + 1):end])
            end

        end

        return locations

    else
        return []
    end

end
