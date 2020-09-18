function get_title(pdf::String)::String
    _, title = get_author_title(pdf)
    return title
end
