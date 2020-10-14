"""
    get_highlights(target::String; concatenate::Bool=true) -> Vector{String}

Get values from the `Highlights` column if a CSV file is passed,
or get the highlights from a PDF file if it is passed, or get the highlights from all
PDFs found recursively if a directory is passed.

# Arguments
- `target::String`: a CSV file, or a PDF file, or a directory with PDF files

# Keywords
- `concatenate::Bool=true`: $(CONCATENATE_BOTH_KEYWORD)

# Returns
- `Vector{String}`: the highlights

# Throws
- [`NotCSVorPDForDir`](@ref): $(NOT_CSV_OR_PDF_OR_DIR_EXCEPTION)
- Exceptions from: [`_get_highlights_from_CSV`](@ref), [`_get_highlights_from_PDF`](@ref)

# Example
```jldoctest; output = false
using PDFHighlights
HEADER = PDFHighlights.Internal.Constants.HEADER

path_to_pdf_dir = joinpath(pathof(PDFHighlights) |> dirname |> dirname, "test", "pdf")
path_to_pdf = joinpath(path_to_pdf_dir, "TestPDF.pdf")

(get_highlights(path_to_pdf_dir) == get_highlights(path_to_pdf) == String[
    "Highlight 1",
    "Highlight 2 Highlight 3",
    "Highlight 4",
    "Highhighlight 5",
    "6th Highhigh light-",
    "High light 7",
    "8th Highlight-",
]) |> println

_file, io = mktemp()
println(io, HEADER, '\\n', "The world didn't stop spinning,,,,1")
flush(io)
file = _file * ".csv"
mv(_file, file)

get_highlights(file) == ["The world didn't stop spinning"]

# output

true
true
```
"""
function get_highlights(target::String; concatenate::Bool=true)::Vector{String}

    if isdir(target) || endswith(target, ".pdf")
        _get_highlights_from_PDF(target; concatenate)
    elseif endswith(target, ".csv")
        _get_highlights_from_CSV(target)
    else
        throw(NotCSVorPDForDir(target))
    end

end
