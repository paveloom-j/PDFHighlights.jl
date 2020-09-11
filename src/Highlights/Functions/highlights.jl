function highlights(pdf::AbstractString; concatenate = true)::Vector{String}
    highlights, _, _ = highlights_comments_pages(pdf; concatenate)
    return highlights
end
