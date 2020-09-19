macro exception_with_symbol(
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
            symbol::Symbol
            $exception_name(symbol::Symbol) = new(symbol)
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
