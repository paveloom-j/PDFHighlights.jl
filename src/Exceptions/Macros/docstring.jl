"""
    @docstring(macro_name::Symbol) -> Expr

Redefine the `docstring` variable in the innermost macro.

# Arguments
- `macro_name::Symbol`: name of the macro that generated the exception

# Returns
- `Expr`: `docstring` redefinition

# Example
```jldoctest; output = false
using PDFHighlights
using SyntaxTree

macro_name = QuoteNode(:name)

@macroexpand(PDFHighlights.Internal.Exceptions.@docstring(name)) |> linefilter! ==
quote
    macro_name = \$(macro_name)
    docstring = Meta.quot(
        \"\"\"
            \$(exception_name) <: Exception

        \$(docstring)

        \$(fields)

        See also: [`@\$(macro_name)`](@ref)
        \"\"\"
    )
end |> linefilter!

# output

true
```
"""
macro docstring(macro_name::Symbol)
    macro_name = QuoteNode(macro_name)
    return esc(
        quote
            macro_name = $(macro_name)
            docstring = Meta.quot(
                """
                    $(exception_name) <: Exception

                $(docstring)

                $(fields)

                See also: [`@$(macro_name)`](@ref)
                """
            )
        end
    )
end
