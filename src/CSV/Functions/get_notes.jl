function get_notes(csv::String)::Vector{String}
    _, _, _, _, notes, _ = get_all(csv)
    return notes
end
