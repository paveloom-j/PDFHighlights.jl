function get_author_title(pdf::String)::Tuple{String, String}

    !isfile(pdf) && throw(FileDoesNotExist(pdf))
    !endswith(pdf, ".pdf") && throw(NotPDF(pdf))

    author_ref = Ref{Cstring}()
    title_ref = Ref{Cstring}()

    ccall(
        (:get_author_title, path_to_get_author_title_library),
        Cvoid,
        (Cstring, Ref{Cstring}, Ref{Cstring}),
        pdf, author_ref, title_ref,
    )

    return unsafe_string(author_ref[]), unsafe_string(title_ref[])

end
