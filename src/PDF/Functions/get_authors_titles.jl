"""
    get_authors_titles(dir::String) -> Tuple{Vector{String}, Vector{String}}

Extract the authors and titles from all PDFs found recursively in the passed directory.

# Arguments
- `dir::String`: $(DIR_ARGUMENT)

# Returns
- `Tuple{Vector{String}, Vector{String}}`: the authors and titles

# Throws
- [`DirectoryDoesNotExist`](@ref): $(DIRECTORY_DOES_NOT_EXIST_EXCEPTION)
- Exceptions from: [`get_author_title`](@ref)

# Example
```jldoctest; output = false
using PDFHighlights

path_to_pdf_dir = joinpath(pathof(PDFHighlights) |> dirname |> dirname, "test", "pdf")

get_authors_titles(path_to_pdf_dir) == (["Pavel Sobolev"], ["A dummy PDF for tests"])

# output

true
```
"""
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
