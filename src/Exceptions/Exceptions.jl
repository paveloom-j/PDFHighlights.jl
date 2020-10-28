"""
This module contains all the exceptions used in the package, as well as the macro(s)
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
       NotCSVorDir,
       NotCSVorPDForDir,
       NotPDF,
       NotFiveColumns

using Exceptions

# Load the auxiliary macros to create other macros
include("Macros/docstring.jl")
include("Macros/fields.jl")

# Load the auxiliary macros to create exceptions

include("Macros/exception_without_fields.jl")
include("Macros/exception_with_file.jl")
include("Macros/exception_with_line.jl")

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
    Check that the header is `Highlight,Title,Author,Note,Location`.""",
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
    NotCSVorDir,
    """
    An exception thrown when the specified path does not end in `.csv` ans is not
    a directory.
    """,
    "The specified path (\"", e.file, "\") does not end in `.csv` and is not a directory.",
)

@exception_with_file(
    NotCSVorPDForDir,
    """
    An exception thrown when the specified path does not end in `.csv` or `.pdf`
    and is not a directory.
    """,
    "The specified path (\"", e.file, "\") does not end in `.csv` or `.pdf` ",
    "and is not a directory.",
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
    NotFiveColumns,
    "Exception thrown when the row does not represent elements for 5 columns.",
    "The row #", e.line, " in the \"", e.file, "\" file does not represent elements for ",
    "5 columns.",
)

end
