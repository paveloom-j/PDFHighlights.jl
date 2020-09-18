function _get_highlights_from_pdf(pdf::String; concatenate = true)::Vector{String}
    highlights, _, _ = get_highlights_comments_pages(pdf; concatenate)
    return highlights
end
