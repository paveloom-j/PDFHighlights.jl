function _get_authors_from_PDF(target::String)::Vector{String}
    authors, _ = get_authors_titles(target)
    return authors
end
