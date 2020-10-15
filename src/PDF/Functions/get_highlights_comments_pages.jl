"""
    @unsafe_wrap(array::Symbol, len::Symbol) -> Expr

Wrap a Julia `Array` object around the data at the address given by `array[]` pointer with
length equal to `len[]`.

# Arguments
- `array::Symbol`: name of the variable which holds the pointer to the array data
- `len::Symbol`: name of the variable which holds the pointer to the length of this array

# Returns
- `Expr`: a wrapping expression

# Example
```jldoctest; output = false
using PDFHighlights

_array = :array
_len = :len

@macroexpand(PDFHighlights.Internal.PDF.@unsafe_wrap(array, len)) ==
:(unsafe_wrap(Array, \$(_array)[], \$(_len)[]; own = true))

# output

true
```

See also: [`@unsafe_wrap_strings`](@ref)
"""
macro unsafe_wrap(array::Symbol, len::Symbol)
    return esc(:(unsafe_wrap(Array, $(array)[], $(len)[]; own = true)))
end

"""
    @unsafe_wrap(array::Expr, len::Union{Symbol, Expr}) -> Expr

Wrap a Julia `Array` object around the data at the address given by `array` pointer with
length equal to `len`.

# Arguments
- `array::Expr`: expression that will yield a pointer to the array data
- `len::Union{Symbol, Expr}`: name of the variable which holds the length of this array,
  or an expression that will yield it

# Returns
- `Expr`: a wrapping expression

# Example
```jldoctest; output = false
using PDFHighlights

_array = :(array[index])
_len = :len

@macroexpand(PDFHighlights.Internal.PDF.@unsafe_wrap(array[index], len)) ==
:(unsafe_wrap(Array, \$(_array), \$(_len); own = true))

# output

true
```

See also: [`@unsafe_wrap_strings`](@ref)
"""
macro unsafe_wrap(array::Expr, len::Union{Symbol, Expr})
    return esc(:(unsafe_wrap(Array, $(array), $(len); own = true)))
end

"""
    @unsafe_wrap_strings(array::Union{Symbol, Expr}, len::Union{Symbol, Expr}) -> Expr

Wrap a Julia `Array` object around the array of C-style strings at the address given by
`array` (or `array[]`) pointer with length equal to `len` (or `len[]`); convert each
string to a Julia string encoded as UTF-8.

# Arguments
- `array::Union{Symbol, Expr}`: name of the variable which holds the pointer to the array
  data, or expression that will yield it
- `len::Union{Symbol, Expr}`: name of the variable which holds the length of this array
  (or a pointer to it), or expression that will yield it

# Returns
- `Expr`: a wrapping expression

# Example
```jldoctest; output = false
using PDFHighlights
using PDFHighlights: Internal.PDF.@unsafe_wrap

_array = :array
_len = :len

@macroexpand(PDFHighlights.Internal.PDF.@unsafe_wrap_strings(array, len)) ==
:(unsafe_string.(unsafe_wrap(Array, \$(_array)[], \$(_len)[]; own = true)))

# output

true
```

See also: [`@unsafe_wrap`](@ref)
"""
macro unsafe_wrap_strings(array::Union{Symbol, Expr}, len::Union{Symbol, Expr})
    return esc(:(unsafe_string.(@unsafe_wrap $(array) $(len))))
end

"""
    get_highlights_comments_pages(
        target::String;
        concatenate::Bool=true
    ) -> Tuple{Vector{String}, Vector{String}, Vector{Int32}}

Extract the highlights, comments, and pages from a passed PDF or all PDFs found recursively
in the passed directory.

# Arguments
- `target::String`: $(TARGET_PDF_ARGUMENT)

# Keywords
- `concatenate::Bool=true`: $(CONCATENATE_KEYWORD)

# Returns
- `Tuple{Vector{String}, Vector{String}, Vector{Int32}}`: the highlights, comments,
  and pages

# Throws
- [`DoesNotExist`](@ref): $(DOES_NOT_EXIST_EXCEPTION)
- [`NotPDF`](@ref): $(NOT_PDF_EXCEPTION)

# Example
```jldoctest; output = false
using PDFHighlights

path_to_pdf_dir = joinpath(pathof(PDFHighlights) |> dirname |> dirname, "test", "pdf")
path_to_pdf = joinpath(path_to_pdf_dir, "TestPDF.pdf")

get_highlights_comments_pages(path_to_pdf_dir) ==
get_highlights_comments_pages(path_to_pdf) ==
(
    [
        "Highlight 1",
        "Highlight 2 Highlight 3",
        "Highlight 4",
        "Highhighlight 5",
        "6th Highhigh light-",
        "High light 7",
        "8th Highlight-",
    ],
    ["Comment 1", "Comment 2 Comment 3", "Comment 4", "", "", "", ""],
    Int32[1, 2, 4, 6, 7, 8, 9],
)

# output

true
```
"""
function get_highlights_comments_pages(
    target::String;
    concatenate::Bool=true,
)::Tuple{Vector{String}, Vector{String}, Vector{Int32}}

    if isdir(target)

        highlights = String[]
        comments = String[]
        pages = Int32[]

        for (root, dirs, files) in walkdir(target), file in files
            if endswith(file, ".pdf")
                _highlights, _comments, _pages = get_highlights_comments_pages(
                    joinpath(root, file);
                    concatenate,
                )
                highlights = vcat(highlights, _highlights)
                comments = vcat(comments, _comments)
                pages = vcat(pages, _pages)
            end
        end

        return highlights, comments, pages

    end

    !isfile(target) && throw(DoesNotExist(target))
    !endswith(target, ".pdf") && throw(NotPDF(target))

    # Compute the check sum
    checksum = ""
    open(target, "r") do io
        checksum = bytes2hex(sha1(io))
    end

    get!(GET_HIGHLIGHTS_COMMENTS_PAGES_OUTPUTS, (checksum, concatenate)) do

        # Prepare pointers
        lines_arrays_ref = Ref{Ptr{Ptr{Cstring}}}()
        lines_x_anchors_arrays_ref = Ref{Ptr{Ptr{Cdouble}}}()
        lines_yl_anchors_arrays_ref = Ref{Ptr{Ptr{Cdouble}}}()
        lines_yu_anchors_arrays_ref = Ref{Ptr{Ptr{Cdouble}}}()
        lines_lens_ref = Ref{Ptr{Culong}}()
        comments_ref = Ref{Ptr{Cstring}}()
        pages_ref = Ref{Ptr{Cint}}()
        num_ref = Ref{Culong}(0)

        # Call
        ccall(
            # Function and library names
            (
                :get_lines_comments_pages,
                PATH_TO_GET_LINES_COMMENTS_PAGES_LIBRARY,
            ),
            # Type of return value
            Cvoid,
            # Types of the arguments
            (
                Cstring,
                Ref{Ptr{Ptr{Cstring}}},
                Ref{Ptr{Ptr{Cdouble}}},
                Ref{Ptr{Ptr{Cdouble}}},
                Ref{Ptr{Ptr{Cdouble}}},
                Ref{Ptr{Culong}},
                Ref{Ptr{Cstring}},
                Ref{Ptr{Cint}},
                Ref{Culong},
            ),
            # Arguments
            target,
            lines_arrays_ref,
            lines_x_anchors_arrays_ref,
            lines_yl_anchors_arrays_ref,
            lines_yu_anchors_arrays_ref,
            lines_lens_ref,
            comments_ref,
            pages_ref,
            num_ref,
        )

        # Steal the upper-level arrays
        lines_arrays = @unsafe_wrap lines_arrays_ref num_ref
        lines_x_anchors_arrays = @unsafe_wrap lines_x_anchors_arrays_ref num_ref
        lines_yl_anchors_arrays = @unsafe_wrap lines_yl_anchors_arrays_ref num_ref
        lines_yu_anchors_arrays = @unsafe_wrap lines_yu_anchors_arrays_ref num_ref
        lines_lens = @unsafe_wrap lines_lens_ref num_ref
        comments = @unsafe_wrap_strings comments_ref num_ref
        pages = @unsafe_wrap pages_ref num_ref

        highlights = Vector{String}(undef, num_ref[])

        highlights_x_anchors = Vector{Float64}(undef, num_ref[])
        highlights_yl_anchors = Vector{Float64}(undef, num_ref[])
        highlights_yu_anchors = Vector{Float64}(undef, num_ref[])

        # Sort the lines
        for index in 1:num_ref[]

            # Steal the lower-level array
            len = lines_lens[index]
            lines = @unsafe_wrap_strings lines_arrays[index] len
            lines_x_anchors = @unsafe_wrap lines_x_anchors_arrays[index] len
            lines_yl_anchors = @unsafe_wrap lines_yl_anchors_arrays[index] len
            lines_yu_anchors = @unsafe_wrap lines_yu_anchors_arrays[index] len

            # Sort the lines by `x` if they cross each other by `y`
            _sort!(lines, lines_x_anchors, lines_yl_anchors, lines_yu_anchors)

            # Save the highlights anchors
            highlights_x_anchors[index] = lines_x_anchors[1]
            highlights_yl_anchors[index] = lines_yl_anchors[end]
            highlights_yu_anchors[index] = lines_yu_anchors[1]

            # Highlight string
            highlight = ""

            hyphen_chopped = false

            # Remove word transfers
            for (index, line) in enumerate(lines)
                if endswith(line, "-")
                    if hyphen_chopped
                        if index == len
                            highlight = string(highlight, line)
                        else
                            highlight = string(highlight, chop(line))
                        end
                    else
                        if len == 1
                            highlight = string(highlight, line)
                        elseif index == 1
                            highlight = string(highlight, chop(line))
                        elseif index == len
                            highlight = string(highlight, ' ', line)
                        else
                            highlight = string(highlight, ' ', chop(line))
                        end
                    end
                    hyphen_chopped = true
                else
                    if hyphen_chopped
                        highlight = string(highlight, line)
                    else
                        if index == 1
                            highlight = string(highlight, line)
                        else
                            highlight = string(highlight, ' ', line)
                        end
                    end
                    hyphen_chopped = false
                end
            end

            # Combine all lines in a highlight and save it
            highlights[index] = highlight

        end

        # Sort the highlights by `x` if they cross
        # each other and by `y` if they don't
        _sort!(
            highlights,
            comments,
            pages,
            highlights_x_anchors,
            highlights_yl_anchors,
            highlights_yu_anchors,
        )

        if concatenate
            return _concatenate(highlights, comments, pages)
        else
            return highlights, comments, pages
        end

    end


end
