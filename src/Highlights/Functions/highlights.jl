function highlights(pdf::AbstractString; concatenate = true)::Vector{String}
    highlights, _ = highlights_comments(pdf; concatenate)
    return highlights
end
