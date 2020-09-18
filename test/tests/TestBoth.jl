# This file contains the tests for the `Both` module

module TestBoth

using PDFHighlights
using Suppressor
using Test

# Print the header
println("\e[1;32mRUNNING\e[0m: TestBoth.jl")

const pdf = joinpath(@__DIR__, "..", "pdf", "TestPDF.pdf")

@testset "get_highlights" begin

    csv = "oof.csv"
    @suppress_out import_highlights(csv, pdf)

    @test get_highlights(pdf) == String[
        "Highlight 1",
        "Highlight 2 Highlight 3",
        "Highlight 4"
    ]

    @test get_highlights(pdf; concatenate = false) == String[
        "Highlight 1",
        "Highlight 2",
        "Highlight 3",
        "High-",
        "light 4"
    ]

    @test get_highlights(csv) == String[
        "Highlight 1",
        "Highlight 2 Highlight 3",
        "Highlight 4"
    ]

    isfile(csv) && rm(csv)

    @test_throws PDFHighlights.Internal.Exceptions.NotCSVorPDF("oof") get_highlights("oof")

end

end
