function _concatenate(
    highlights::Vector{String},
    comments::Vector{String}
    )::Tuple{Vector{String}, Vector{String}}

    # The initial concatenation identifier
    id = 1

    # Combine highlights if there are concatenation identifiers
    for (index, comment) in enumerate(comments)

        # Start a new chain of highlights
        if startswith(comment, ".c1")

            id = 2

        # Continue the current chain of highlights
        elseif startswith(comment, ".c$(id)")

            # Get the current highlight
            current_highlight = highlights[index]

            # Get the chain's first highlight
            first_highlight = highlights[index - id + 1]

            # Take the last word from the chain's first highlight
            half_word = split(first_highlight, ' ')[end]

            # If the last word ends with `-`, concatenate the halves
            if length(half_word) > 1 && endswith(half_word, '-')
                highlights[index - id + 1] = first_highlight[1:end-1] * current_highlight
                highlights[index] = ""
            else
                highlights[index - id + 1] *= ' ' * current_highlight
                highlights[index] = ""
            end

            id += 1

        # Drop the current chain of highlights
        else

            id = 1

        end

    end

    return filter(!isempty, highlights),
           filter(element -> !startswith(element, r".c([2-9]|[1-9][0-9])+"), comments)

end
