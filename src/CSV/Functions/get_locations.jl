function get_locations(csv::String)::Vector{Int32}
    _, _, _, _, _, locations = get_all(csv)
    return locations
end
