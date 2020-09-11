function comments(pdf::AbstractString; concatenate = false)::Vector{String}
    _, comments, _ = highlights_comments_pages(pdf; concatenate)
    return comments
end
