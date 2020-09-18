macro exception_with_one_arg(
    exception_name::String,
    docstring::String,
    error_message::String,
)
    return esc(
        Meta.parse("""
        begin
        \"\"\"
            $exception_name <: Exception

        $docstring

        \"\"\"
        mutable struct $exception_name <: Exception
            file::String
            $exception_name(file::String) = new(file)
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
