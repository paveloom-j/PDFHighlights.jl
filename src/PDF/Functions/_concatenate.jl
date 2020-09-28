function _concatenate(
    highlights::Vector{String},
    comments::Vector{String},
    pages::Vector{Int32},
)::Tuple{Vector{String}, Vector{String}, Vector{Int32}}

    # Label for the comments which will be deleted
    comments_remove_label = "__REMOVE_AFTER_CONCATENATION__"

    # The initial concatenation identifier
    id = 1

    # Combine highlights if there are concatenation identifiers
    for (index, comment) in enumerate(comments)

        # Start a new chain of highlights
        if startswith(comment, ".c1")

            comments[index] = lstrip(chop(comment; head = 3, tail = 0))
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
            comment = replace(comment, Regex("(^.c$id) |(?1)") => "")
            if !isempty(comment)
                comments[index - id + 1] *= ' ' * comment
            end

            comments[index] = comments_remove_label

            id += 1

        # Drop the current chain of highlights
        else

            comments[index] = replace(comment, r"(^.c([2-9]|[1-9][0-9])+) |(?1)" => "")
            id = 1

        end

    end

    return filter(!isempty, highlights),
           filter(comment -> comment != comments_remove_label, comments),
           filter(element -> element != 0, pages)

end
