macro exception(
    macro_name::Symbol,
    module_name::Symbol,
    args::Expr...,
)

    return esc(quote
        macro $(macro_name)(
            exception_name::Union{Symbol, QuoteNode},
            docstring::String,
            error_message_bits::Union{Expr, String}...,
        )

            typeof(exception_name) == QuoteNode && (exception_name = exception_name.value)

            module_name = $(module_name)
            args = $(args)
            error_header = "$(module_name).$(exception_name):"

            return quote
                @doc $docstring
                mutable struct $(exception_name) <: Exception
                    $(args...)
                    $(exception_name)($(args...)) = new($(args...))
                end

                Base.showerror(io::IO, e::$(module_name).$(exception_name)) =
                print(
                    io, string(
                        '\n', '\n',
                        $error_header, '\n',
                        $(error_message_bits...), '\n',
                    )
                )
            end

        end
    end)

end
