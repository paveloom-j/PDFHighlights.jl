function get_highlights(file::String; concatenate::Bool = true)

    if endswith(file, ".pdf")
        _get_highlights_from_pdf(file; concatenate)
    elseif endswith(file, ".csv")
        _get_highlights_from_csv(file)
    else
        throw(NotCSVorPDF(file))
    end

end
