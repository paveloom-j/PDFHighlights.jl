function _get_highlights_from_CSV(csv::String)::Vector{String}
    highlights, _, _, _, _, _ = get_all(csv)
    return highlights
end
