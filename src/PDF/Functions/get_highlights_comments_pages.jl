macro unsafe_wrap(array::Symbol, len::Symbol)
    return esc(:(unsafe_wrap(Array, $array[], $len[]; own = true)))
end

macro unsafe_wrap(array::Expr, len::Union{Symbol, Expr})
    return esc(:(unsafe_wrap(Array, $array, $len; own = true)))
end

macro unsafe_wrap_strings(array::Union{Symbol, Expr}, len::Union{Symbol, Expr})
    return esc(:(unsafe_string.(@unsafe_wrap $array $len)))
end

function get_highlights_comments_pages(
    target::String;
    concatenate::Bool = true,
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

    get!(get_highlights_comments_pages_outputs, (checksum, concatenate)) do

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
                path_to_get_lines_comments_pages_library,
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
