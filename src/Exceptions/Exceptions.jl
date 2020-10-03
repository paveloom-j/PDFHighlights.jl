"""
This module contains all the exceptions used in the package, as well as the macro
that they were created by.
"""
module Exceptions

export DirectoryDoesNotExist,
       DoesNotExist,
       FileDoesNotExist,
       IncorrectHeader,
       IntegrityCheckFailed,
       LastElementIsNotAnInteger,
       NotCSV,
       NotCSVorPDF,
       NotPDF,
       NotSixColumns,
       SymbolIsNotSupported

# Load the auxiliary macros
include("Macros/exception.jl")

# Create auxiliary macros for exceptions
@exception exception_with_file file::String
@exception exception_with_line file::String line::Int
@exception exception_with_symbol symbol::Symbol

# Create exceptions

@exception_with_file(
    DirectoryDoesNotExist,
    "Exception thrown when the specified directory doesn't exist.",
    "The specified directory (\"", e.file, "\") doesn't exist.",
)

@exception_with_file(
    DoesNotExist,
    "Exception thrown when the specified file or directory doesn't exist.",
    "The specified file or directory (\"", e.file, "\") doesn't exist.",
)

@exception_with_file(
    FileDoesNotExist,
    "Exception thrown when the specified file doesn't exist.",
    "The specified file (\"", e.file, "\") doesn't exist.",
)

@exception_with_file(
    IncorrectHeader,
    "Exception thrown when the specified file has an incorrect header.",
    "The specified file (\"", e.file, """\") has an incorrect header.
    Check that the header is `Highlight,Title,Author,URL,Note,Location`.""",
)

@exception_with_file(
    IntegrityCheckFailed,
    """
    An exception thrown when another exception was thrown while checking the integrity
    of the table.
    """,
    "Another exception was thrown while checking the integrity of the table \"",
    e.file, "\".",
)

@exception_with_file(
    NotCSV,
    "Exception thrown when the specified path does not end in `.csv`.",
    "The specified path (\"", e.file, "\") does not end in `.csv`.",
)

@exception_with_file(
    NotCSVorPDF,
    "An exception thrown when the specified path does not end in `.csv` or `.pdf`.",
    "The specified path (\"", e.file, "\") does not end in `.csv` or `.pdf`.",
)

@exception_with_file(
    NotPDF,
    "Exception thrown when the specified path does not end in `.pdf`.",
    "The specified path (\"", e.file, "\") does not end in `.pdf`.",
)

@exception_with_line(
    LastElementIsNotAnInteger,
    "Exception thrown when the last element in the line is not an integer.",
    "The last element in row #", e.line, " in the \"", e.file, "\" file is not an integer.",
)

@exception_with_line(
    NotSixColumns,
    "Exception thrown when the row does not represent elements for 6 columns.",
    "The row #", e.line, " in the \"", e.file, "\" file does not represent elements for ",
    "6 columns.",
)

@exception_with_symbol(
    SymbolIsNotSupported,
    "Exception thrown when the specified symbol is not supported.",
    "The specified symbol (:", e.symbol, """) is not supported. Supported symbols:
    `:highlight`, `:title`, `:author`, `:url`, `:note`, `:location`.""",
)

end
