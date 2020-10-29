"""
This module contains all the constants used in the package, as well as the macro
that they were created by.
"""
module Constants

using ..Exceptions
using SyntaxTree

"""
    @constant(name::Symbol, docstring::String, value::Union{Expr, String}) -> Expr

Create a constant with a documentation string and export it.

# Arguments
- `name::Symbol`: name of the constant
- `docstring::String`: documentation string
- `value::Union{Expr, String}`: value of the constant

# Returns
- `Expr`: constant definition

# Example
```jldoctest; output = false
using PDFHighlights
using Suppressor
using SyntaxTree

name = :CONSTANT_NAME
docstring = "Docstring"
value = "Value"

d1 = @capture_out @macroexpand(
    PDFHighlights.Internal.Constants.@constant(
        CONSTANT_NAME,
        "Docstring",
        "Value"
    )
) |> linefilter! |> dump

macro oof()
    return esc(
        quote
            @doc \$(docstring)
            const \$(name) = \$(value)
            export \$(name)
        end
    )
end

d2 = @capture_out @macroexpand(@oof) |> linefilter! |> dump

d1 == d2

# output

true
```
"""
macro constant(name::Symbol, docstring::String, value::Union{Expr, String})
    name_string = "$(name)"
    if endswith(name_string, "_EXCEPTION")
        docstring = """
        A documentation constant for the [`$(docstring)`](@ref) exception.
        """
    end
    if typeof(value) == String
        docstring = """
            $(name) = "$(value)"

        $(docstring)
        """
    end
    return esc(
        quote
            @doc $(docstring)
            const $(name) = $(value)
            export $(name)
        end
    )
end

# For the `CSV` module

@constant(
    HEADER,
    "Default (expected) header for CSV files.",
    "Highlight,Title,Author,Note,Location",
)

# Documentation constants

## For exceptions

@constant(
    INCORRECT_HEADER_EXCEPTION,
    "IncorrectHeader",
    "the specified file has an incorrect header",
)
@constant(
    LAST_ELEMENT_IS_NOT_AN_INTEGER_EXCEPTION,
    "LastElementIsNotAnInteger",
    "the last element in the line is not an integer",
)
@constant(
    NOT_FIVE_COLUMNS_EXCEPTION,
    "NotFiveColumns",
    "the row does not represent elements for 5 columns",
)
@constant(
    INTEGRITY_CHECK_FAILED_EXCEPTION,
    "IntegrityCheckFailed",
    "another exception was thrown while checking the integrity of the table",
)

@constant(
    NOT_CSV_EXCEPTION,
    "NotCSV",
    "the specified path does not end in `.csv`",
)
@constant(
    NOT_CSV_OR_DIR_EXCEPTION,
    "NotCSVorDir",
    "the specified path does not end in `.csv` and is not a directory",
)
@constant(
    NOT_CSV_OR_PDF_OR_DIR_EXCEPTION,
    "NotCSVorPDForDir",
    "the specified path does not end in `.csv` or `.pdf` and is not a directory",
)

@constant(
    FILE_DOES_NOT_EXIST_EXCEPTION,
    "FileDoesNotExist",
    "the specified file doesn't exist",
)
@constant(
    NOT_PDF_EXCEPTION,
    "NotPDF",
    "the specified path does not end in `.pdf`",
)
@constant(
    DIRECTORY_DOES_NOT_EXIST_EXCEPTION,
    "DirectoryDoesNotExist",
    "the specified directory doesn't exist",
)
@constant(
    DOES_NOT_EXIST_EXCEPTION,
    "DoesNotExist",
    "the specified file or directory doesn't exist",
)

## For arguments

@constant(
    CSV_ARGUMENT,
    "A documentation constant for the `csv` argument.",
    "absolute or relative path to the CSV file",
)
@constant(
    PDF_ARGUMENT,
    "A documentation constant for the `pdf` argument.",
    "absolute or relative path to the PDF file",
)
@constant(
    TARGET_CSV_ARGUMENT,
    "A documentation constant for the `target` argument that mentions CSV.",
    "a CSV file or a directory with PDF files",
)
@constant(
    TARGET_PDF_ARGUMENT,
    "A documentation constant for the `target` argument that mentions PDF.",
    "a PDF file or a directory with PDF files",
)
@constant(
    HIGHLIGHTS_ARGUMENT,
    "A documentation constant for the `highlights` argument.",
    "the highlights vector",
)
@constant(
    COMMENTS_ARGUMENT,
    "A documentation constant for the `comments` argument.",
    "the comments vector",
)
@constant(
    PAGES_ARGUMENT,
    "A documentation constant for the `pages` argument.",
    "the pages vector",
)
@constant(
    DIR_ARGUMENT,
    "A documentation constant for the `dir` argument.",
    "a directory with PDF files",
)

## For keywords

@constant(
    CONCATENATE_KEYWORD,
    "A documentation constant for the `concatenate` keyword.",
    "if `true`, concatenate the highlights",
)
@constant(
    CONCATENATE_BOTH_KEYWORD,
    "A documentation constant for the `concatenate` keyword (for the `Both` module).",
    "if `true`, concatenate the highlights (only for PDFs)",
)

end
