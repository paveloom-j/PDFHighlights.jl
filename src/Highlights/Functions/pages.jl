function pages(pdf::AbstractString; concatenate = false)::Vector{Int}
    _, _, pages = highlights_comments_pages(pdf; concatenate)
    return pages
end
