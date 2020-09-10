function comments(pdf::AbstractString; concatenate = false)::Vector{String}
    _, comments = highlights_comments(pdf; concatenate)
    return comments
end
