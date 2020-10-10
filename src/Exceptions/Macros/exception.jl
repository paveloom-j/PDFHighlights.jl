"""
    @exception(macro_name::Symbol, args::Expr...; context::Expr=:()) -> Expr

Create a macro to create exceptions. Optionally inject context before defining
the structure.

# Arguments
- `macro_name::Symbol`: name of the macro
- `args::Tuple{Vararg{Expr}}`: a set of fields to be defined in the exception structure

# Keywords
- `context::Expr=:()`: expression evaluated before defining the exception structure

# Returns
- `Expr`: new macro definition

# Throws
- [`OnlyOneContext`](@ref): more than one context has been passed
- [`OnlyOneEquation`](@ref): more than one equation has been passed

# Example
```jldoctest; output = false
using PDFHighlights
using Suppressor
using SyntaxTree

macro_name = :name
args = (:(arg1::String), :(arg2::Int))
context = :()

d1 = @capture_out @macroexpand(
    PDFHighlights.Internal.Exceptions.@exception(
        name,
        arg1::String,
        arg2::Int,
    )
) |> linefilter! |> dump

d2 = @capture_out quote
    macro \$(macro_name)(
        exception_name::Symbol,
        docstring::Union{Expr, String},
        error_message_bits::Union{Expr, String}...,
    )
        module_name = __module__

        args = \$(args)
        error_header = "\$(module_name).\$(exception_name):"

        \$(context)

        return esc(
            quote
                @doc \$(docstring)
                mutable struct \$(exception_name) <: Exception
                    \$(args...)
                    \$(exception_name)(\$(args...)) = new(\$(args...))
                end

                Base.showerror(io::IO, e::\$(module_name).\$(exception_name)) =
                print(
                    io, string(
                        '\\n', '\\n',
                        \$(error_header), '\\n',
                        \$(error_message_bits...), '\\n',
                    )
                )
            end
        )
    end
end |> linefilter! |> dump

d1 == d2

# output

true
```
"""
macro exception(
    macro_name::Symbol,
    args::Expr...,
)
    context_specified = false
    context = :()

    for (index, arg) in pairs(args)
        if arg.head == :(=)
            if arg.args[1] == :context
                if context_specified
                    throw(OnlyOneContext())
                else
                    context = args[index]
                    args = args[1:end .≠ index]
                    context_specified = true
                end
            else
                throw(OnlyOneEquation())
            end
        end
    end

    return esc(
        quote
            macro $(macro_name)(
                exception_name::Symbol,
                docstring::Union{Expr, String},
                error_message_bits::Union{Expr, String}...,
            )
                module_name = __module__

                args = $(args)
                error_header = "$(module_name).$(exception_name):"

                $(context)

                return esc(
                    quote
                        @doc $(docstring)
                        mutable struct $(exception_name) <: Exception
                            $(args...)
                            $(exception_name)($(args...)) = new($(args...))
                        end

                        Base.showerror(io::IO, e::$(module_name).$(exception_name)) =
                        print(
                            io, string(
                                '\n', '\n',
                                $(error_header), '\n',
                                $(error_message_bits...), '\n',
                            )
                        )
                    end
                )
            end
        end
    )

end
