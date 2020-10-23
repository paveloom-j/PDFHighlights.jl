using PDFHighlights_jll
using Test

const pdf = joinpath(@__DIR__, "TestPDF.pdf")

@testset "get_author_title" begin

    # Prepare pointers
    author_ref = Ref{Cstring}()
    title_ref = Ref{Cstring}()

    ccall(
        (:get_author_title, PDFHighlightsWrapper),
        Cvoid,
        (Cstring, Ref{Cstring}, Ref{Cstring}),
        pdf, author_ref, title_ref,
    )

    @test unsafe_string(author_ref[]) == "Pavel Sobolev"
    @test unsafe_string(title_ref[]) == "A dummy PDF for tests"

end

macro unsafe_wrap(array::Symbol, len::Symbol)
    return esc(:(unsafe_wrap(Array, $(array)[], $(len)[]; own = true)))
end

macro unsafe_wrap(array::Expr, len::Union{Symbol, Expr})
    return esc(:(unsafe_wrap(Array, $(array), $(len); own = true)))
end

macro unsafe_wrap_strings(array::Union{Symbol, Expr}, len::Union{Symbol, Expr})
    return esc(:(unsafe_string.(@unsafe_wrap $(array) $(len))))
end

@testset "get_lines_comments_pages" begin

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
            PDFHighlightsWrapper,
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
        pdf,
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

    for index in 1:num_ref[]

        # Steal the lower-level array
        len = lines_lens[index]
        lines = @unsafe_wrap_strings lines_arrays[index] len
        lines_x_anchors = @unsafe_wrap lines_x_anchors_arrays[index] len
        lines_yl_anchors = @unsafe_wrap lines_yl_anchors_arrays[index] len
        lines_yu_anchors = @unsafe_wrap lines_yu_anchors_arrays[index] len

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

    @test highlights == [
        "Highlight 1",
        "Highlight 2",
        "Highlight 3",
        "High-",
        "light 4",
        "Highhighlight 5",
        "6th Highhigh light-",
        "High light 7",
        "8th Highlight-",
    ]

    @test comments == [
        "Comment 1",
        ".c1 Comment 2",
        ".c2 Comment 3",
        ".c1 Comment 4",
        ".c2",
        "",
        "",
        "",
        "",
    ]

    @test pages == Int32[1, 2, 3, 4, 5, 6, 7, 8, 9]

    @test highlights_x_anchors == repeat([42.52], 9)
    @test highlights_yl_anchors == [
        repeat([24.50399999999999], 5);
        [
            53.396000000000015,
            67.84200000000001,
            38.95000000000002,
            38.95000000000002
        ]
    ]
    @test highlights_yu_anchors == repeat([39.59200000000001], 9)

end
