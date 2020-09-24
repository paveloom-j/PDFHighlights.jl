function _sort!(
    lines::Vector{String},
    quad_x_anchors::Vector{Float64},
    quad_y_anchors::Vector{Tuple{Float64, Float64}}
)::Vector{String}

    start_index = 0
    previous_index = 1
    last_index = lastindex(lines)

    # Sort by `x`
    for index in 2:length(lines)

        previous_index = index - 1

        # Unpack the quad anchors
        yl1, yu1 = quad_y_anchors[previous_index]
        yl2, yu2 = quad_y_anchors[index]

        # Check if the lines are crossing
        if (yl1 > yl2 && yl1 < yu2) ||
           (yu1 > yl2 && yl2 < yu2) ||
           (yl2 > yl1 && yl2 < yu1)

            start_index == 0 && (start_index = previous_index)

            # Sort the last chain of lines
            if index == last_index

                perm = sortperm(quad_x_anchors[start_index:index])
                permute!(@view(lines[start_index:index]), perm)
                permute!(@view(quad_y_anchors[start_index:index]), perm)

                if start_index == 1
                    permute!(@view(quad_x_anchors[start_index:index]), perm)
                end

            end

        elseif start_index != 0

            perm = sortperm(quad_x_anchors[start_index:previous_index])
            permute!(@view(lines[start_index:previous_index]), perm)

            if start_index == 1
                permute!(@view(quad_x_anchors[start_index:previous_index]), perm)
                permute!(@view(quad_y_anchors[start_index:previous_index]), perm)
            end

            start_index = 0

        end

    end

    return lines

end

function _sort!(
    highlights::Vector{String},
    comments::Vector{String},
    pages::Vector{Int},
    quad_x_anchors::Vector{Float64},
    quad_y_anchors::Vector{Tuple{Float64, Float64}}
)::Tuple{Vector{String}, Vector{String}}

    # Get the `y` coordinates of the upper left corners
    quad_yu_anchors = [e[2] for e in quad_y_anchors]

    last_index = lastindex(highlights)

    start_index = 1
    previous_index = 0
    current_page = pages[1]

    # Sort by `y`
    for (index, page) in enumerate(pages)
        if page != current_page
            previous_index = index - 1
            if start_index != previous_index
                perm = sortperm(quad_yu_anchors[start_index:previous_index])
                permute!(@view(highlights[start_index:previous_index]), perm)
                permute!(@view(comments[start_index:previous_index]), perm)
            end
            start_index = index
            current_page = page
        elseif index == last_index && pages[start_index] == pages[index]
            perm = sortperm(quad_yu_anchors[start_index:index])
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
            yl1, yu1 = quad_y_anchors[previous_index]
            yl2, yu2 = quad_y_anchors[index]

            # Check if the highlights are crossing
            if (yl1 > yl2 && yl1 < yu2) ||
               (yu1 > yl2 && yl2 < yu2) ||
               (yl2 > yl1 && yl2 < yu1)

                start_index == 0 && (start_index = previous_index)

                # Sort the last chain of highlights
                if index == last_index
                    perm = sortperm(quad_x_anchors[start_index:index])
                    permute!(@view(highlights[start_index:index]), perm)
                    permute!(@view(comments[start_index:index]), perm)
                end

            # Sort the current chain of highlights
            elseif start_index != 0

                perm = sortperm(quad_x_anchors[start_index:previous_index])
                permute!(@view(highlights[start_index:previous_index]), perm)
                permute!(@view(comments[start_index:previous_index]), perm)

                start_index = 0

            end

        end
    end

    return highlights, comments

end
