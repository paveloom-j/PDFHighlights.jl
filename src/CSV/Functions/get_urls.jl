function get_urls(csv::String)::Vector{String}
    _, _, _, urls, _, _ = get_all(csv)
    return urls
end
