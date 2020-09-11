function highlights_pages(
    pdf::AbstractString;
    concatenate = true
    )::Tuple{Vector{String}, Vector{Int}}

    highlights, _, pages = highlights_comments_pages(pdf; concatenate)
    return highlights, pages

end
