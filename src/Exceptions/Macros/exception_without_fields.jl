"""
    @exception_without_fields(
        exception_name::Symbol,
        docstring::Union{Expr, String},
        error_message_bits::Tuple{Vararg{Union{Expr, String}}},
    ) -> Expr

Create an exception with no fields.

# Arguments
- `exception_name::Symbol`: name of the exception
- `docstring::Union{Expr, String}`: documentation string
- `error_message_bits::Tuple{Vararg{Union{Expr, String}}}`: strings and expressions which
  will be interpolated in the `showerror` output

# Returns
- `Expr`: an exception definition (struct + `showerror` overload)

See also: [`@exception`](@ref)

"""
@exception exception_without_fields context = begin
    docstring = Meta.quot(
        """
            $(exception_name) <: Exception

        $(docstring)

        See also: [`@exception_without_fields`](@ref)
        """
    )
end

@exception_without_fields(
    OnlyOneContext,
    "Exception thrown when more than one context has been passed.",
    "Only one `context` specification is allowed.",
)

@exception_without_fields(
    OnlyOneEquation,
    "Exception thrown when non-context equation has been passed.",
    "Equation is only available for one expression with the first argument " *
    "equal to `context`.",
)
