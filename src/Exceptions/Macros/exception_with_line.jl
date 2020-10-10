"""
    @exception_with_line(
        exception_name::Symbol,
        docstring::Union{Expr, String},
        error_message_bits::Tuple{Vararg{Union{Expr, String}}},
    ) -> Expr

Create an exception with two fields: a path to the file and a line number.

# Arguments
- `exception_name::Symbol`: name of the exception
- `docstring::Union{Expr, String}`: documentation string
- `error_message_bits::Tuple{Vararg{Union{Expr, String}}}`: strings and expressions which
  will be interpolated in the `showerror` output

# Returns
- `Expr`: an exception definition (struct + `showerror` overload)

See also: [`@exception`](@ref)

"""
@exception exception_with_line file::String line::Int context = begin
    @fields(
        "`file::String`: absolute or relative path to a file that is associated with the
        exception",
        "`line::Int`: line number of the specified file to which this exception is
        associated",
    )
    @docstring exception_with_line
end
