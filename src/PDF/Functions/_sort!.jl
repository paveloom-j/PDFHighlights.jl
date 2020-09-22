function _sort!(
    lines::Vector{String},
    quad_x_anchors::Vector{Float64},
    quad_y_anchors::Vector{Tuple{Float64, Float64}}
)::Vector{String}

    start_index = 0
    last_index = lastindex(lines)

    for (index, line) in enumerate(lines)
        if index > 1
            if index == last_index

                # Unpack the previous quad anchor
                yl1, yu1 = quad_y_anchors[index - 1]

                # Unpack the current quad anchor
                yl2, yu2 = quad_y_anchors[index]

                # Check if the lines are crossing
                if (yl1 > yl2 && yl1 < yu2) ||
                   (yu1 > yl2 && yl2 < yu2) ||
                   (yl2 > yl1 && yl2 < yu1)

                    start_index == 0 && (start_index = index - 1)

                    perm = sortperm(
                        quad_x_anchors[start_index:index]
                    )

                    permute!(@view(lines[start_index:index]), perm)

                    permute!(
                        @view(quad_y_anchors[start_index:index]),
                        perm,
                    )

                    if start_index == 1
                        permute!(
                            @view(quad_x_anchors[start_index:index]),
                            perm,
                        )
                    end

                # Sort the current chain of lines
                elseif start_index != 0

                    perm = sortperm(
                        quad_x_anchors[start_index:(index - 1)]
                    )

                    permute!(@view(lines[start_index:(index - 1)]), perm)

                    if start_index == 1
                        permute!(
                            @view(quad_x_anchors[start_index:(index - 1)]),
                            perm,
                        )
                        permute!(
                            @view(quad_y_anchors[start_index:(index - 1)]),
                            perm,
                        )
                    end

                end

            else

                # Unpack the previous quad anchor
                yl1, yu1 = quad_y_anchors[index - 1]

                # Unpack the current quad anchor
                yl2, yu2 = quad_y_anchors[index]

                # Check if the lines are crossing
                if (yl1 > yl2 && yl1 < yu2) ||
                   (yu1 > yl2 && yl2 < yu2) ||
                   (yl2 > yl1 && yl2 < yu1)

                    start_index == 0 && (start_index = index - 1)

                # Sort the current chain of lines
                elseif start_index != 0

                    perm = sortperm(
                        quad_x_anchors[start_index:(index - 1)]
                    )

                    permute!(@view(lines[start_index:(index - 1)]), perm)

                    if start_index == 1
                        permute!(
                            @view(quad_x_anchors[start_index:(index - 1)]),
                            perm,
                        )
                        permute!(
                            @view(quad_y_anchors[start_index:(index - 1)]),
                            perm,
                        )
                    end

                    start_index = 0

                end

            end
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

    start_index = 0
    last_index = lastindex(highlights)

    for (index, highlight) in enumerate(highlights)
        if index > 1 && pages[index] == pages[index - 1]
            if index == last_index

                # Unpack the previous quad anchor
                yl1, yu1 = quad_y_anchors[index - 1]

                # Unpack the current quad anchor
                yl2, yu2 = quad_y_anchors[index]

                # Check if the highlights are crossing
                if (yl1 > yl2 && yl1 < yu2) ||
                   (yu1 > yl2 && yl2 < yu2) ||
                   (yl2 > yl1 && yl2 < yu1)

                    start_index == 0 && (start_index = index - 1)

                    perm = sortperm(quad_x_anchors[start_index:index])

                    permute!(@view(highlights[start_index:index]), perm)
                    permute!(@view(comments[start_index:index]), perm)

                # Sort the current chain of highlights
                elseif start_index != 0

                    perm = sortperm(quad_x_anchors[start_index:(index - 1)])

                    permute!(@view(highlights[start_index:(index - 1)]), perm)
                    permute!(@view(comments[start_index:(index - 1)]), perm)

                end

            else

                # Unpack the previous quad anchor
                yl1, yu1 = quad_y_anchors[index - 1]

                # Unpack the current quad anchor
                yl2, yu2 = quad_y_anchors[index]

                # Check if the highlights are crossing
                if (yl1 > yl2 && yl1 < yu2) ||
                   (yu1 > yl2 && yl2 < yu2) ||
                   (yl2 > yl1 && yl2 < yu1)

                    start_index == 0 && (start_index = index - 1)

                # Sort the current chain of highlights
                elseif start_index != 0

                    perm = sortperm(quad_x_anchors[start_index:(index - 1)])

                    permute!(@view(highlights[start_index:(index - 1)]), perm)
                    permute!(@view(comments[start_index:(index - 1)]), perm)

                    start_index = 0

                end

            end
        end
    end

    return highlights, comments

end
