function _info(table::Table)::Nothing
    table.check()
    println("""

        Table path: "$(table.file)"
        Number of highlights: $(length(table.highlights()))
    """)

    return nothing
end
