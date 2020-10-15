"""
    get_author_title(pdf::String) -> Tuple{String, String}

Extract the author and title from the PDF.

# Arguments
- `pdf::String`: $(PDF_ARGUMENT)

# Returns
- `Tuple{String, String}`: the author and title

# Throws
- [`FileDoesNotExist`](@ref): $(FILE_DOES_NOT_EXIST_EXCEPTION)
- [`NotPDF`](@ref): $(NOT_PDF_EXCEPTION)

# Example
```jldoctest; output = false
using PDFHighlights

path_to_pdf = joinpath(
    pathof(PDFHighlights) |> dirname |> dirname,
    "test",
    "pdf",
    "TestPDF.pdf",
)

get_author_title(path_to_pdf) == ("Pavel Sobolev", "A dummy PDF for tests")

# output

true
```
"""
function get_author_title(pdf::String)::Tuple{String, String}

    !isfile(pdf) && throw(FileDoesNotExist(pdf))
    !endswith(pdf, ".pdf") && throw(NotPDF(pdf))

    # Compute the check sum
    checksum = ""
    open(pdf, "r") do io
        checksum = bytes2hex(sha1(io))
    end

    get!(GET_AUTHOR_TITLE_OUTPUTS, checksum) do

        author_ref = Ref{Cstring}()
        title_ref = Ref{Cstring}()

        ccall(
            (:get_author_title, PATH_TO_GET_AUTHOR_TITLE_LIBRARY),
            Cvoid,
            (Cstring, Ref{Cstring}, Ref{Cstring}),
            pdf, author_ref, title_ref,
        )

        return unsafe_string(author_ref[]), unsafe_string(title_ref[])

    end

end
