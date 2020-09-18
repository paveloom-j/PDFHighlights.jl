# This file contains the tests for the `PDF` module

module TestPDF

using PDFHighlights
using Test

# Print the header
println("\e[1;32mRUNNING\e[0m: TestPDF.jl")

const pdf = joinpath(@__DIR__, "..", "pdf", "TestPDF.pdf")

@testset "get_author_title" begin

    @test get_author_title(pdf) == ("Pavel Sobolev", "A dummy PDF for tests")

    @test_throws(
        PDFHighlights.Internal.Exceptions.NotPDF("oof"),
        get_author_title("oof"),
    )

    @test_throws(
        PDFHighlights.Internal.Exceptions.DoesNotExist("oof.pdf"),
        get_author_title("oof.pdf"),
    )

end

@testset "get_author" begin

    @test get_author(pdf) == "Pavel Sobolev"

end

@testset "_concatenate" begin

    # Without halves of words
    @test PDFHighlights.Internal.PDF._concatenate(
        String["Highlight 1", "Highlight 2", "Highlight 3"],
        String["Comment 1", ".c1 Comment 2", ".c2 Comment 3"],
        Int[1, 2, 3],
    ) ==
    (
        String["Highlight 1", "Highlight 2 Highlight 3"],
        String["Comment 1", "Comment 2 Comment 3"],
        Int[1, 2],
    )

    # With halves of words
    @test PDFHighlights.Internal.PDF._concatenate(
        String["Highlight 1", "High-", "light 2"],
        String["Comment 1", ".c1 Comment 2", ".c2"],
        Int[1, 2, 3],
    ) ==
    (
        String["Highlight 1", "Highlight 2"],
        String["Comment 1", "Comment 2"],
        Int[1, 2],
    )

end

@testset "get_highlights_comments_pages" begin

    # With concatenation
    @test get_highlights_comments_pages(pdf) ==
    (
        String["Highlight 1", "Highlight 2 Highlight 3", "Highlight 4"],
        String["Comment 1", "Comment 2 Comment 3", "Comment 4"],
        Int[1, 2, 4],
    )

    # Without concatenation
    @test get_highlights_comments_pages(pdf; concatenate = false) ==
    (
        String["Highlight 1", "Highlight 2", "Highlight 3", "High-", "light 4"],
        String["Comment 1", ".c1 Comment 2", ".c2 Comment 3", ".c1 Comment 4", ".c2"],
        Int[1, 2, 3, 4, 5],
    )

    @test_throws(
        PDFHighlights.Internal.Exceptions.NotPDF("oof"),
        get_highlights_comments_pages("oof"),
    )

    @test_throws(
        PDFHighlights.Internal.Exceptions.DoesNotExist("oof.pdf"),
        get_highlights_comments_pages("oof.pdf"),
    )

end

@testset "get_comments_pages" begin

    # With concatenation
    @test get_comments_pages(pdf; concatenate = true) ==
    (
        String["Comment 1", "Comment 2 Comment 3", "Comment 4"],
        Int[1, 2, 4],
    )

    # Without concatenation
    @test get_comments_pages(pdf) ==
    (
        String["Comment 1", ".c1 Comment 2", ".c2 Comment 3", ".c1 Comment 4", ".c2"],
        Int[1, 2, 3, 4, 5],
    )

end

@testset "get_highlights_comments" begin

    # With concatenation
    @test get_highlights_comments(pdf) ==
    (
        String["Highlight 1", "Highlight 2 Highlight 3", "Highlight 4"],
        String["Comment 1", "Comment 2 Comment 3", "Comment 4"],
    )

    # Without concatenation
    @test get_highlights_comments(pdf; concatenate = false) ==
    (
        String["Highlight 1", "Highlight 2", "Highlight 3", "High-", "light 4"],
        String["Comment 1", ".c1 Comment 2", ".c2 Comment 3", ".c1 Comment 4", ".c2"],
    )

end

@testset "get_highlights_pages" begin

    # With concatenation
    @test get_highlights_pages(pdf) ==
    (
        String["Highlight 1", "Highlight 2 Highlight 3", "Highlight 4"],
        Int[1, 2, 4],
    )

    # Without concatenation
    @test get_highlights_pages(pdf; concatenate = false) ==
    (
        String["Highlight 1", "Highlight 2", "Highlight 3", "High-", "light 4"],
        Int[1, 2, 3, 4, 5],
    )

end

@testset "get_comments" begin

    # With concatenation
    @test get_comments(pdf; concatenate = true) ==
    String["Comment 1", "Comment 2 Comment 3", "Comment 4"]

    # Without concatenation
    @test get_comments(pdf) ==
    String["Comment 1", ".c1 Comment 2", ".c2 Comment 3", ".c1 Comment 4", ".c2"]

end

@testset "_get_highlights_from_pdf" begin

    # With concatenation
    @test PDFHighlights.Internal.PDF._get_highlights_from_pdf(pdf) ==
    String["Highlight 1", "Highlight 2 Highlight 3", "Highlight 4"]

    # Without concatenation
    @test PDFHighlights.Internal.PDF._get_highlights_from_pdf(pdf; concatenate = false) ==
    String["Highlight 1", "Highlight 2", "Highlight 3", "High-", "light 4"]

end

@testset "get_pages" begin

    # With concatenation
    @test get_pages(pdf; concatenate = true) ==
    Int[1, 2, 4]

    # Without concatenation
    @test get_pages(pdf) ==
    Int[1, 2, 3, 4, 5]

end

@testset "get_title" begin

    @test get_title(pdf) == "A dummy PDF for tests"

end

end
