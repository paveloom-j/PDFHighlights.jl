"""
This module contains all the exceptions used in the package, as well as the macro
that they were created by.
"""
module Exceptions

export IncorrectExtension,
       IncorrectHeader,
       IntegrityCheckFailed,
       LastElementIsNotAnInteger,
       NotSixColumns

# Load the auxiliary macros
include("Macros/exception_with_line.jl")
include("Macros/exception_without_line.jl")

@exception_without_line(
    "IncorrectExtension",
    "Exception thrown when the specified path does not end in `.csv`.",
    "The specified path (\\\"\", e.file, \"\\\") does not end in `.csv`.",
)

@exception_without_line(
    "IncorrectHeader",
    "Exception thrown when the specified file has an incorrect header.",
    """
    The specified file (\\\"\", e.file, \"\\\") has an incorrect header.
    Check that the header is `Highlight,Title,Author,URL,Note,Location`.""",
)

@exception_without_line(
    "IntegrityCheckFailed",
    """
    An exception thrown when another exception was thrown while rechecking the status
    of the file.
    """,
    """
    Another exception was thrown when rechecking the\e[s
    \e[u\e[A structural correctness of the file \\\"\", e.file, \"\\\".""",
)

@exception_with_line(
    "LastElementIsNotAnInteger",
    "Exception thrown when the last element in the line is not an integer.",
    """
    The last element in row #\", e.line, \" in the \\\"\", e.file, \"\\\"\e[s
    \e[u\e[A file is not an integer.""",
)

@exception_with_line(
    "NotSixColumns",
    "Exception thrown when the row does not represent elements for 6 columns.",
    """
    The row #\", e.line, \" in the \\\"\", e.file, \"\\\" does not\e[s
    \e[u\e[A represent elements for 6 columns.""",
)

end
