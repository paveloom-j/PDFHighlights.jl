macro exception_without_line(
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
            $exception_name(file::AbstractString) = new(file)
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
