function get_highlights_comments(
    pdf::String;
    concatenate = true
)::Tuple{Vector{String}, Vector{String}}

    highlights, comments, _ = get_highlights_comments_pages(pdf; concatenate)
    return highlights, comments

end
