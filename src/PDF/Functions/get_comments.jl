function get_comments(pdf::String; concatenate = false)::Vector{String}
    _, comments, _ = get_highlights_comments_pages(pdf; concatenate)
    return comments
end
