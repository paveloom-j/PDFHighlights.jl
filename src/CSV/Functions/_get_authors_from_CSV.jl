function _get_authors_from_CSV(csv::String)::Vector{String}
    _, _, authors, _, _, _ = get_all(csv)
    return authors
end
