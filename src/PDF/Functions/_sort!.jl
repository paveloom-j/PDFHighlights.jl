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
