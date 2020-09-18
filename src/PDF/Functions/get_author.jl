function get_author(pdf::String)::String
    author, _ = get_author_title(pdf)
    return author
end
