function _concatenate(
    highlights::Vector{String},
    comments::Vector{String},
    pages::Vector{Int},
)::Tuple{Vector{String}, Vector{String}, Vector{Int}}

    # The initial concatenation identifier
    id = 1

    # Combine highlights if there are concatenation identifiers
    for (index, comment) in enumerate(comments)

        # Start a new chain of highlights
        if startswith(comment, ".c1")

            comments[index] = strip(chop(comment; head = 3, tail = 0))
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
                highlights[index - id + 1] =
                chop(first_highlight; tail = 1) * current_highlight
            else
                highlights[index - id + 1] *= ' ' * current_highlight
            end

            # Delete metadata
            highlights[index] = ""
            pages[index] = 0

            # Append the current comment to the first comment in the chain
            comment = strip(chop(comment; head = 3, tail = 0))
            if !isempty(comment)
                comments[index - id + 1] *= ' ' * comment
            end

            id += 1

        # Drop the current chain of highlights
        else

            id = 1

        end

    end

    return filter(!isempty, highlights),
           filter(element -> !startswith(element, r".c([2-9]|[1-9][0-9])+"), comments),
           filter(element -> element != 0, pages)

end
