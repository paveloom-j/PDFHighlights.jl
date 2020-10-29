"""
    @fields(strings::String...) -> Expr

Define the `fields` variable in the innermost macro. This variable is a string that
describes type fields.

# Arguments
- `strings::Tuple{Vararg{String}}`: strings to store in the `fields` variable

# Returns
- `Expr`: `fields` definition

# Example
```jldoctest; output = false
using PDFHighlights
using SyntaxTree

strings = ("`Cloverfield`: there's no place like home",)

@macroexpand(
    PDFHighlights.Internal.Exceptions.@fields(
        "`Cloverfield`: there's no place like home"
    )
) |> linefilter! == quote
    strings = \$(strings) |> collect
    strings = join(["- " * string for string in strings], '\\n')
    fields = \"\"\"
    # Fields\\n
    \$(strings)
    \"\"\"
end |> linefilter!

# output

true
```
"""
macro fields(strings::String...)
    return esc(
        quote
            strings = $(strings) |> collect
            strings = join(["- " * string for string in strings], '\n')
            fields = """
            # Fields\n
            $(strings)
            """
        end
    )
end
