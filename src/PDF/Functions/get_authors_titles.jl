function get_authors_titles(dir::String)::Tuple{Vector{String}, Vector{String}}

    authors = String[]
    titles = String[]

    if isdir(dir)
        for (root, dirs, files) in walkdir(dir), file in files
            if endswith(file, ".pdf")
                author, title = get_author_title(joinpath(root, file))
                push!(authors, author)
                push!(titles, title)
            end
        end
    else
        throw(DirectoryDoesNotExist(dir))
    end

    return authors, titles

end
