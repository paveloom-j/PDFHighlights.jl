function get_highlights_pages(
    pdf::String;
    concatenate = true
)::Tuple{Vector{String}, Vector{Int}}

    !endswith(pdf, ".pdf") && throw(NotPDF(pdf))
    highlights, _, pages = get_highlights_comments_pages(pdf; concatenate)
    return highlights, pages

end
