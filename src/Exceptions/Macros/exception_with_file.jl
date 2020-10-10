"""
    @exception_with_file(
        exception_name::Symbol,
        docstring::Union{Expr, String},
        error_message_bits::Tuple{Vararg{Union{Expr, String}}},
    ) -> Expr

Create an exception with one field: a path to the file.

# Arguments
- `exception_name::Symbol`: name of the exception
- `docstring::Union{Expr, String}`: documentation string
- `error_message_bits::Tuple{Vararg{Union{Expr, String}}}`: strings and expressions which
  will be interpolated in the `showerror` output

# Returns
- `Expr`: an exception definition (struct + `showerror` overload)

See also: [`@exception`](@ref)

"""
@exception exception_with_file file::String context = begin
    @fields(
        "`file::String`: absolute or relative path to a file that is associated with the
        exception",
    )
    @docstring exception_with_file
end
