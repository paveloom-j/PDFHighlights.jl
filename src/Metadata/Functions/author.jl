function author(pdf::AbstractString)::String
    author, _ = author_title(pdf)
    return author
end
