function get_authors(target::String)::Vector{String}

    if isdir(target) || endswith(target, ".pdf")
        _get_authors_from_PDF(target)
    elseif endswith(target, ".csv")
        _get_authors_from_CSV(target)
    else
        throw(NotCSVorPDF(target))
    end

end
