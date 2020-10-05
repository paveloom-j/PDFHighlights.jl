function _get_titles_from_CSV(csv::String)::Vector{String}
    _, titles, _, _, _, _ = get_all(csv)
    return titles
end
