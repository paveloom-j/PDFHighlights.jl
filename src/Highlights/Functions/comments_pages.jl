function comments_pages(
    pdf::AbstractString;
    concatenate = true
    )::Tuple{Vector{String}, Vector{Int}}

    _, comments, pages = highlights_comments_pages(pdf; concatenate)
    return comments, pages

end
