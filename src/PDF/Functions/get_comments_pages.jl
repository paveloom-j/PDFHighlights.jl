function get_comments_pages(
    pdf::String;
    concatenate = false
)::Tuple{Vector{String}, Vector{Int32}}

    _, comments, pages = get_highlights_comments_pages(pdf; concatenate)
    return comments, pages

end
