function get_highlights(target::String; concatenate::Bool = true)::Vector{String}

    if isdir(target) || endswith(target, ".pdf")
        _get_highlights_from_PDF(target; concatenate)
    elseif endswith(target, ".csv")
        _get_highlights_from_CSV(target)
    else
        throw(NotCSVorPDF(target))
    end

end
