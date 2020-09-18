function _get_titles_from_PDF(target::String)::Vector{String}
    _, titles = get_authors_titles(target)
    return titles
end
