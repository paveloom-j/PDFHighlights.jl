function get_pages(pdf::String; concatenate = false)::Vector{Int}
    _, _, pages = get_highlights_comments_pages(pdf; concatenate)
    return pages
end
