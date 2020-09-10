macro exception_with_line(
    exception_name::AbstractString,
    docstring::AbstractString,
    error_message::AbstractString,
)
    return esc(
        Meta.parse("""
        begin
        \"\"\"
            $exception_name <: Exception

        $docstring

        \"\"\"
        mutable struct $exception_name <: Exception
            file::AbstractString
            line::Int
            $exception_name(file::AbstractString, line::Int) = new(file, line)
        end

        Base.showerror(io::IO, e::$exception_name) =
        print(
            io, string(
                "\n\n",
                "PDFHighlights.Internal.Exceptions.$exception_name:\n",
                "$error_message\n"
            )
        )

        end""")
    )
end
