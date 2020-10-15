# This file contains the tests for the `Both` module

module TestBoth

using PDFHighlights
using Test

# Print the header
println("\e[1;32mRUNNING\e[0m: TestBoth.jl")

const pdf = joinpath(@__DIR__, "..", "pdf", "TestPDF.pdf")

@testset "get_authors" begin

    dir = joinpath(@__DIR__, "..")

    @test get_authors(dir) == String["Pavel Sobolev",]

    csv = "oof.csv"
    import_highlights(csv, pdf; quiet=true)

    @test get_authors(csv) == repeat(["Pavel Sobolev",], 7)

    isfile(csv) && rm(csv)

    @test_throws PDFHighlights.Internal.Exceptions.NotCSVorDir("oof") get_authors("oof")

end

@testset "get_highlights" begin

    # With concatenation
    @test get_highlights(pdf) == String[
        "Highlight 1",
        "Highlight 2 Highlight 3",
        "Highlight 4",
        "Highhighlight 5",
        "6th Highhigh light-",
        "High light 7",
        "8th Highlight-",
    ]

    # Without concatenation
    @test get_highlights(pdf; concatenate=false) == String[
        "Highlight 1",
        "Highlight 2",
        "Highlight 3",
        "High-",
        "light 4",
        "Highhighlight 5",
        "6th Highhigh light-",
        "High light 7",
        "8th Highlight-",
    ]

    dir = joinpath(@__DIR__, "..")

    # With concatenation
    @test get_highlights(dir) == String[
        "Highlight 1",
        "Highlight 2 Highlight 3",
        "Highlight 4",
        "Highhighlight 5",
        "6th Highhigh light-",
        "High light 7",
        "8th Highlight-",
    ]

    # Without concatenation
    @test get_highlights(dir; concatenate=false) == String[
        "Highlight 1",
        "Highlight 2",
        "Highlight 3",
        "High-",
        "light 4",
        "Highhighlight 5",
        "6th Highhigh light-",
        "High light 7",
        "8th Highlight-",
    ]

    csv = "oof.csv"
    import_highlights(csv, pdf; quiet=true)

    @test get_highlights(csv) == String[
        "Highlight 1",
        "Highlight 2 Highlight 3",
        "Highlight 4",
        "Highhighlight 5",
        "6th Highhigh light-",
        "High light 7",
        "8th Highlight-",
    ]

    isfile(csv) && rm(csv)

    @test_throws(
        PDFHighlights.Internal.Exceptions.NotCSVorPDForDir("oof"),
        get_highlights("oof")
    )

end

@testset "get_titles" begin

    dir = joinpath(@__DIR__, "..")

    @test get_titles(dir) == String["A dummy PDF for tests",]

    csv = "oof.csv"
    import_highlights(csv, pdf; quiet=true)

    @test get_titles(csv) == repeat(["A dummy PDF for tests",], 7)

    isfile(csv) && rm(csv)

    @test_throws PDFHighlights.Internal.Exceptions.NotCSVorDir("oof") get_titles("oof")

end

end
