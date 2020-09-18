function print_info(csv::String)::Nothing

    try
        initialize(csv)
    catch
        throw(IntegrityCheckFailed(csv))
    end

    println("""

        Table path: "$(csv)"
        Number of highlights: $(length(_get_highlights_from_csv(csv)))
    """)

    return nothing

end
