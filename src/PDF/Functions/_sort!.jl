"""
    _sort!(
        lines::Vector{String},
        lines_x_anchors::Vector{Float64},
        lines_yl_anchors::Vector{Float64},
        lines_yu_anchors::Vector{Float64},
    ) -> Vector{String}

Sort the lines vector using the arrays of anchors. Basic principle: if rectangles cross
by ordinate, sort them by abscissa.

# Arguments
- `lines::Vector{String}`: the lines vector of the highlight (text found in the rectangles
  of the highlight)
- `lines_x_anchors::Vector{Float64}`: the coordinate vector of the abscissa of the left
  side of the highlight rectangles
- `lines_yl_anchors::Vector{Float64}`: the coordinate vector of the ordinate of the
  lower-left corner of the highlight rectangles
- `lines_yu_anchors::Vector{Float64}`: the coordinate vector of the ordinate of the
  upper-left corner of the highlight rectangles

# Returns
- `Vector{String}`: the sorted lines vector of the highlight

# Example
```jldoctest; output = false
using PDFHighlights

lines = ["High", "high", "light"]
quad_x_anchors = [0.21, 0.15, 0.17]
quad_yl_anchors = [0.10, 0.10, 0.10]
quad_yu_anchors = [0.15, 0.12, 0.15]

PDFHighlights.Internal.PDF._sort!(
    lines,
    quad_x_anchors,
    quad_yl_anchors,
    quad_yu_anchors,
) == ["high", "light", "High"]

# output

true
```
"""
function _sort!(
    lines::Vector{String},
    lines_x_anchors::Vector{Float64},
    lines_yl_anchors::Vector{Float64},
    lines_yu_anchors::Vector{Float64},
)::Vector{String}

    start_index = 0
    previous_index = 1
    last_index = lastindex(lines)

    # Sort by `x`
    for index in 2:length(lines)

        previous_index = index - 1

        # Unpack the quad anchors
        yl1, yu1 = lines_yl_anchors[previous_index], lines_yu_anchors[previous_index]
        yl2, yu2 = lines_yl_anchors[index], lines_yu_anchors[index]

        # Check if the lines are crossing
        if (yl1 > yl2 && yl1 < yu2) ||
           (yu1 > yl2 && yl2 < yu2) ||
           (yl2 > yl1 && yl2 < yu1)

            start_index == 0 && (start_index = previous_index)

            # Sort the last chain of lines
            if index == last_index

                perm = sortperm(lines_x_anchors[start_index:index])
                permute!(@view(lines[start_index:index]), perm)
                permute!(@view(lines_yl_anchors[start_index:index]), perm)

                if start_index == 1
                    permute!(@view(lines_x_anchors[start_index:index]), perm)
                    permute!(@view(lines_yu_anchors[start_index:index]), perm)
                end

            end

        # Sort the last chain of lines
        elseif start_index != 0

            perm = sortperm(lines_x_anchors[start_index:previous_index])
            permute!(@view(lines[start_index:previous_index]), perm)

            if start_index == 1
                permute!(@view(lines_x_anchors[start_index:previous_index]), perm)
                permute!(@view(lines_yu_anchors[start_index:previous_index]), perm)
            end

            start_index = 0

        end

    end

    return lines

end

"""
    _sort!(
        highlights::Vector{String},
        comments::Vector{String},
        pages::Vector{Int32},
        highlights_x_anchors::Vector{Float64},
        highlights_yl_anchors::Vector{Float64},
        highlights_yu_anchors::Vector{Float64},
    ) -> Tuple{Vector{String}, Vector{String}}

Sort the highlights and comments vectors using the arrays of anchors and pages.
Basic principle: if highlights cross by ordinate, sort them by abscissa.

# Arguments
- `highlights::Vector{String}`: the highlights
- `comments::Vector{String}`: the comments
- `pages::Vector{Int32}`: the pages
- `highlights_x_anchors::Vector{Float64}`: the coordinate vector of the abscissa of the left
  side of the upper-left rectangle of the highlight
- `highlights_yl_anchors::Vector{Float64}`: the coordinate vector of the ordinate of the
  lower-left corner of the lower-left rectangle of the highlight
- `highlights_yu_anchors::Vector{Float64}`: the coordinate vector of the ordinate of the
  upper-left corner of the upper-left rectangle of the highlight

# Returns
- `Tuple{Vector{String}, Vector{String}}`: the sorted vectors of the highlights and comments

# Example
```jldoctest; output = false
using PDFHighlights

highlights = ["High", "high", "light"]
comments = ["Com", "com", "ment"]
pages = Int32[1, 1, 1]
highlights_x_anchors = [0.21, 0.15, 0.17]
highlights_yl_anchors = [0.10, 0.10, 0.10]
highlights_yu_anchors = [0.12, 0.15, 0.15]

PDFHighlights.Internal.PDF._sort!(
    highlights,
    comments,
    pages,
    highlights_x_anchors,
    highlights_yl_anchors,
    highlights_yu_anchors,
) ==
(
    ["high", "light", "High"],
    ["com", "ment", "Com"],
)

# output

true
```
"""
function _sort!(
    highlights::Vector{String},
    comments::Vector{String},
    pages::Vector{Int32},
    highlights_x_anchors::Vector{Float64},
    highlights_yl_anchors::Vector{Float64},
    highlights_yu_anchors::Vector{Float64},
)::Tuple{Vector{String}, Vector{String}}

    last_index = lastindex(highlights)

    start_index = 1
    previous_index = 0
    current_page = pages[1]

    # Sort by `y`
    for (index, page) in enumerate(pages)
        if page != current_page
            previous_index = index - 1
            if start_index != previous_index
                perm = sortperm(highlights_yu_anchors[start_index:previous_index])
                permute!(@view(highlights[start_index:previous_index]), perm)
                permute!(@view(comments[start_index:previous_index]), perm)
            end
            start_index = index
            current_page = page
        elseif index == last_index && pages[start_index] == pages[index]
            perm = sortperm(highlights_yu_anchors[start_index:index])
            permute!(@view(highlights[start_index:index]), perm)
            permute!(@view(comments[start_index:index]), perm)
        end
    end

    start_index = 0
    previous_index = 1

    # Sort by `x`
    for index in 2:length(highlights)
        previous_index = index - 1
        if pages[index] == pages[previous_index]

            # Unpack the quad anchors
            yl1 = highlights_yl_anchors[previous_index]
            yu1 = highlights_yu_anchors[previous_index]
            yl2 = highlights_yl_anchors[index]
            yu2 = highlights_yu_anchors[index]

            # Check if the highlights are crossing
            if (yl1 > yl2 && yl1 < yu2) ||
               (yu1 > yl2 && yl2 < yu2) ||
               (yl2 > yl1 && yl2 < yu1)

                start_index == 0 && (start_index = previous_index)

                # Sort the last chain of highlights
                if index == last_index
                    perm = sortperm(highlights_x_anchors[start_index:index])
                    permute!(@view(highlights[start_index:index]), perm)
                    permute!(@view(comments[start_index:index]), perm)
                end

            # Sort the current chain of highlights
            elseif start_index != 0

                perm = sortperm(highlights_x_anchors[start_index:previous_index])
                permute!(@view(highlights[start_index:previous_index]), perm)
                permute!(@view(comments[start_index:previous_index]), perm)

                start_index = 0

            end

        end
    end

    return highlights, comments

end
