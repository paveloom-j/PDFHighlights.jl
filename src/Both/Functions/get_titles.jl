function get_titles(target::String)::Vector{String}

    if isdir(target) || endswith(target, ".pdf")
        _get_titles_from_PDF(target)
    elseif endswith(target, ".csv")
        _get_titles_from_CSV(target)
    else
        throw(NotCSVorPDF(target))
    end

end
