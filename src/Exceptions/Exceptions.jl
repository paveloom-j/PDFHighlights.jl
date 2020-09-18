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
       NotSixColumns

# Load the auxiliary macros
include("Macros/exception_with_one_arg.jl")
include("Macros/exception_with_two_args.jl")

@exception_with_one_arg(
    "DirectoryDoesNotExist",
    "Exception thrown when the specified directory doesn't exist.",
    "The specified directory (\\\"\", e.file, \"\\\") doesn't exist.",
)

@exception_with_one_arg(
    "DoesNotExist",
    "Exception thrown when the specified file or directory doesn't exist.",
    "The specified file or directory (\\\"\", e.file, \"\\\") doesn't exist.",
)

@exception_with_one_arg(
    "FileDoesNotExist",
    "Exception thrown when the specified file doesn't exist.",
    "The specified file (\\\"\", e.file, \"\\\") doesn't exist.",
)

@exception_with_one_arg(
    "IncorrectHeader",
    "Exception thrown when the specified file has an incorrect header.",
    """
    The specified file (\\\"\", e.file, \"\\\") has an incorrect header.
    Check that the header is `Highlight,Title,Author,URL,Note,Location`.""",
)

@exception_with_one_arg(
    "IntegrityCheckFailed",
    """
    An exception thrown when another exception was thrown while checking the integrity
    of the table.
    """,
    """
    Another exception was thrown while checking the\e[s
    \e[u\e[A integrity of the table \\\"\", e.file, \"\\\".""",
)

@exception_with_one_arg(
    "NotCSV",
    "Exception thrown when the specified path does not end in `.csv`.",
    "The specified path (\\\"\", e.file, \"\\\") does not end in `.csv`.",
)

@exception_with_one_arg(
    "NotCSVorPDF",
    "An exception thrown when the specified path does not end in `.csv` or `.pdf`.",
    "The specified path (\\\"\", e.file, \"\\\") does not end in `.csv` or `.pdf`."
)

@exception_with_one_arg(
    "NotPDF",
    "Exception thrown when the specified path does not end in `.pdf`.",
    "The specified path (\\\"\", e.file, \"\\\") does not end in `.pdf`.",
)

@exception_with_two_args(
    "LastElementIsNotAnInteger",
    "Exception thrown when the last element in the line is not an integer.",
    """
    The last element in row #\", e.line, \" in the \\\"\", e.file, \"\\\"\e[s
    \e[u\e[A file is not an integer.""",
)

@exception_with_two_args(
    "NotSixColumns",
    "Exception thrown when the row does not represent elements for 6 columns.",
    """
    The row #\", e.line, \" in the \\\"\", e.file, \"\\\" does not\e[s
    \e[u\e[A represent elements for 6 columns.""",
)

end
