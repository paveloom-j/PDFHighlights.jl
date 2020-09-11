function highlights_comments(
    pdf::AbstractString;
    concatenate = true
    )::Tuple{Vector{String}, Vector{String}}

    highlights, comments, _ = highlights_comments_pages(pdf; concatenate)
    return highlights, comments

end
