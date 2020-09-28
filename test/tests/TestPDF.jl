# This file contains the tests for the `PDF` module

module TestPDF

using PDFHighlights
using Test

# Print the header
println("\e[1;32mRUNNING\e[0m: TestPDF.jl")

const pdf = joinpath(@__DIR__, "..", "pdf", "TestPDF.pdf")

@testset "_concatenate" begin

    # Without halves of words
    @test PDFHighlights.Internal.PDF._concatenate(
        String["Highlight 1", "Highlight 2", "Highlight 3"],
        String["Comment 1", ".c1 Comment 2", ".c2 Comment 3"],
        Int32[1, 2, 3],
    ) ==
    (
        String["Highlight 1", "Highlight 2 Highlight 3"],
        String["Comment 1", "Comment 2 Comment 3"],
        Int32[1, 2],
    )

    # With halves of words
    @test PDFHighlights.Internal.PDF._concatenate(
        String["Highlight 1", "High-", "light 2"],
        String["Comment 1", ".c1 Comment 2", ".c2"],
        Int32[1, 2, 3],
    ) ==
    (
        String["Highlight 1", "Highlight 2"],
        String["Comment 1", "Comment 2"],
        Int32[1, 2],
    )

end

@testset "_get_authors_from_PDF" begin

    dir = joinpath(@__DIR__, "..")

    @test PDFHighlights.Internal.PDF._get_authors_from_PDF(dir) == String[
        "Pavel Sobolev",
    ]

end

@testset "_get_highlights_from_PDF" begin

    # With concatenation
    @test PDFHighlights.Internal.PDF._get_highlights_from_PDF(pdf) == String[
        "Highlight 1",
        "Highlight 2 Highlight 3",
        "Highlight 4",
        "Highhighlight 5",
        "6th Highhigh light-",
        "High light 7",
        "8th Highlight-",
    ]

    # Without concatenation
    @test PDFHighlights.Internal.PDF._get_highlights_from_PDF(pdf; concatenate = false) ==
    String[
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

end

@testset "_get_titles_from_PDF" begin

    dir = joinpath(@__DIR__, "..")

    @test PDFHighlights.Internal.PDF._get_titles_from_PDF(dir) == String[
        "A dummy PDF for tests",
    ]

end

@testset "_sort! (lines)" begin

    lines = ["High", "high", "light"]
    quad_x_anchors = Float64[0.21, 0.15, 0.17]
    quad_yl_anchors = Float64[0.10, 0.10, 0.10]
    quad_yu_anchors = Float64[0.15, 0.12, 0.15]

    @test PDFHighlights.Internal.PDF._sort!(
        lines,
        quad_x_anchors,
        quad_yl_anchors,
        quad_yu_anchors,
    ) == ["high", "light", "High"]

    lines = ["High", "high", "light"]
    quad_x_anchors = Float64[0.21, 0.15, 0.17]
    quad_yl_anchors = Float64[0.10, 0.10, 0.17]
    quad_yu_anchors = Float64[0.15, 0.12, 0.20]

    @test PDFHighlights.Internal.PDF._sort!(
        lines,
        quad_x_anchors,
        quad_yl_anchors,
        quad_yu_anchors,
    ) == ["high", "High", "light"]

    lines = ["High", "high", "highlight", "light"]
    quad_x_anchors = Float64[0.21, 0.15, 0.17, 0.19]
    quad_yl_anchors = Float64[0.10, 0.10, 0.17, 0.17]
    quad_yu_anchors = Float64[0.15, 0.12, 0.20, 0.20]

    @test PDFHighlights.Internal.PDF._sort!(
        lines,
        quad_x_anchors,
        quad_yl_anchors,
        quad_yu_anchors,
    ) == ["high", "High", "highlight", "light"]

end

@testset "_sort! (highlights)" begin

    pages = Int32[1, 1, 1]

    highlights = ["High", "high", "light"]
    comments = ["Com", "com", "ment"]
    quad_x_anchors = Float64[0.21, 0.15, 0.17]
    quad_yl_anchors = Float64[0.10, 0.10, 0.10]
    quad_yu_anchors = Float64[0.12, 0.15, 0.15]

    @test PDFHighlights.Internal.PDF._sort!(
        highlights,
        comments,
        pages,
        quad_x_anchors,
        quad_yl_anchors,
        quad_yu_anchors,
    ) ==
    (
        ["high", "light", "High"],
        ["com", "ment", "Com"],
    )

    highlights = ["High", "high", "light"]
    comments = ["Com", "com", "ment"]
    quad_x_anchors = Float64[0.21, 0.15, 0.17]
    quad_yl_anchors = Float64[0.10, 0.10, 0.17]
    quad_yu_anchors = Float64[0.12, 0.15, 0.20]

    @test PDFHighlights.Internal.PDF._sort!(
        highlights,
        comments,
        pages,
        quad_x_anchors,
        quad_yl_anchors,
        quad_yu_anchors,
    ) ==
    (
        ["high", "High", "light"],
        ["com", "Com", "ment"],
    )

    pages = Int32[1, 1, 1, 1]

    highlights = ["High", "high", "highlight", "light"]
    comments = ["Com", "com", "comment", "ment"]
    quad_x_anchors = Float64[0.21, 0.15, 0.17, 0.19]
    quad_yl_anchors = Float64[0.10, 0.10, 0.17, 0.17]
    quad_yu_anchors = Float64[0.12, 0.15, 0.20, 0.20]

    @test PDFHighlights.Internal.PDF._sort!(
        highlights,
        comments,
        pages,
        quad_x_anchors,
        quad_yl_anchors,
        quad_yu_anchors,
    ) ==
    (
        ["high", "High", "highlight", "light"],
        ["com", "Com", "comment", "ment"],
    )

    pages = Int32[1, 1, 2, 2]

    highlights = ["High", "highlight", "light", "high"]
    comments = ["Com", "comment", "ment", "com"]
    quad_yl_anchors = Float64[0.08, 0.10, 0.17, 0.10]
    quad_yu_anchors = Float64[0.09, 0.15, 0.20, 0.12]

    @test PDFHighlights.Internal.PDF._sort!(
        highlights,
        comments,
        pages,
        quad_x_anchors,
        quad_yl_anchors,
        quad_yu_anchors,
    ) ==
    (
        ["High", "highlight", "high", "light"],
        ["Com", "comment", "com", "ment"],
    )

end

@testset "get_author_title" begin

    @test get_author_title(pdf) == ("Pavel Sobolev", "A dummy PDF for tests")

    @test_throws(
        PDFHighlights.Internal.Exceptions.FileDoesNotExist("oof"),
        get_author_title("oof"),
    )

    touch("oof")

    @test_throws(
        PDFHighlights.Internal.Exceptions.NotPDF("oof"),
        get_author_title("oof"),
    )

    isfile("oof") && rm("oof")

end

@testset "get_author" begin

    @test get_author(pdf) == "Pavel Sobolev"

end

@testset "get_authors_titles" begin

    dir = joinpath(@__DIR__, "..")

    @test get_authors_titles(dir) == (
        String["Pavel Sobolev",],
        String["A dummy PDF for tests",]
    )

    @test_throws(
        PDFHighlights.Internal.Exceptions.DirectoryDoesNotExist("oof"),
        get_authors_titles("oof"),
    )

end

@testset "get_highlights_comments_pages" begin

    # With concatenation
    @test get_highlights_comments_pages(pdf) ==
    (
        String[
            "Highlight 1",
            "Highlight 2 Highlight 3",
            "Highlight 4",
            "Highhighlight 5",
            "6th Highhigh light-",
            "High light 7",
            "8th Highlight-",
        ],
        String[
            "Comment 1",
            "Comment 2 Comment 3",
            "Comment 4",
            "",
            "",
            "",
            "",
        ],
        Int32[1, 2, 4, 6, 7, 8, 9],
    )

    # Without concatenation
    @test get_highlights_comments_pages(pdf; concatenate = false) ==
    (
        String[
            "Highlight 1",
            "Highlight 2",
            "Highlight 3",
            "High-",
            "light 4",
            "Highhighlight 5",
            "6th Highhigh light-",
            "High light 7",
            "8th Highlight-",
        ],
        String[
            "Comment 1",
            ".c1 Comment 2",
            ".c2 Comment 3",
            ".c1 Comment 4",
            ".c2",
            "",
            "",
            "",
            "",
        ],
        Int32[1:9...],
    )

    @test_throws(
        PDFHighlights.Internal.Exceptions.DoesNotExist("oof"),
        get_highlights_comments_pages("oof"),
    )

    touch("oof")

    @test_throws(
        PDFHighlights.Internal.Exceptions.NotPDF("oof"),
        get_highlights_comments_pages("oof"),
    )

    isfile("oof") && rm("oof")

    dir = joinpath(@__DIR__, "..")

    # With concatenation
    @test get_highlights_comments_pages(dir) ==
    (
        String[
            "Highlight 1",
            "Highlight 2 Highlight 3",
            "Highlight 4",
            "Highhighlight 5",
            "6th Highhigh light-",
            "High light 7",
            "8th Highlight-",
        ],
        String[
            "Comment 1",
            "Comment 2 Comment 3",
            "Comment 4",
            "",
            "",
            "",
            "",
        ],
        Int32[1, 2, 4, 6, 7, 8, 9],
    )

    # Without concatenation
    @test get_highlights_comments_pages(dir; concatenate = false) ==
    (
        String[
            "Highlight 1",
            "Highlight 2",
            "Highlight 3",
            "High-",
            "light 4",
            "Highhighlight 5",
            "6th Highhigh light-",
            "High light 7",
            "8th Highlight-",
        ],
        String[
            "Comment 1",
            ".c1 Comment 2",
            ".c2 Comment 3",
            ".c1 Comment 4",
            ".c2",
            "",
            "",
            "",
            "",
        ],
        Int32[1:9...],
    )

end

@testset "get_comments_pages" begin

    # With concatenation
    @test get_comments_pages(pdf; concatenate = true) ==
    (
        String["Comment 1", "Comment 2 Comment 3", "Comment 4", "", "", "", ""],
        Int32[1, 2, 4, 6, 7, 8, 9],
    )

    # Without concatenation
    @test get_comments_pages(pdf) ==
    (
        String[
            "Comment 1",
            ".c1 Comment 2",
            ".c2 Comment 3",
            ".c1 Comment 4",
            ".c2",
            "",
            "",
            "",
            "",
        ],
        Int32[1:9...],
    )

end

@testset "get_highlights_comments" begin

    # With concatenation
    @test get_highlights_comments(pdf) ==
    (
        String[
            "Highlight 1",
            "Highlight 2 Highlight 3",
            "Highlight 4",
            "Highhighlight 5",
            "6th Highhigh light-",
            "High light 7",
            "8th Highlight-",
        ],
        String[
            "Comment 1",
            "Comment 2 Comment 3",
            "Comment 4",
            "",
            "",
            "",
            "",
        ],
    )

    # Without concatenation
    @test get_highlights_comments(pdf; concatenate = false) ==
    (
        String[
            "Highlight 1",
            "Highlight 2",
            "Highlight 3",
            "High-",
            "light 4",
            "Highhighlight 5",
            "6th Highhigh light-",
            "High light 7",
            "8th Highlight-",
        ],
        String[
            "Comment 1",
            ".c1 Comment 2",
            ".c2 Comment 3",
            ".c1 Comment 4",
            ".c2",
            "",
            "",
            "",
            "",
        ],
    )

end

@testset "get_highlights_pages" begin

    # With concatenation
    @test get_highlights_pages(pdf) ==
    (
        String[
            "Highlight 1",
            "Highlight 2 Highlight 3",
            "Highlight 4",
            "Highhighlight 5",
            "6th Highhigh light-",
            "High light 7",
            "8th Highlight-",
        ],
        Int32[1, 2, 4, 6, 7, 8, 9],
    )

    # Without concatenation
    @test get_highlights_pages(pdf; concatenate = false) ==
    (
        String[
            "Highlight 1",
            "Highlight 2",
            "Highlight 3",
            "High-",
            "light 4",
            "Highhighlight 5",
            "6th Highhigh light-",
            "High light 7",
            "8th Highlight-",
        ],
        Int32[1:9...],
    )

end

@testset "get_comments" begin

    # With concatenation
    @test get_comments(pdf; concatenate = true) == String[
        "Comment 1",
        "Comment 2 Comment 3",
        "Comment 4",
        "",
        "",
        "",
        "",
    ]

    # Without concatenation
    @test get_comments(pdf) == String[
        "Comment 1",
        ".c1 Comment 2",
        ".c2 Comment 3",
        ".c1 Comment 4",
        ".c2",
        "",
        "",
        "",
        "",
    ]

end

@testset "get_pages" begin

    # With concatenation
    @test get_pages(pdf; concatenate = true) ==
    Int32[1, 2, 4, 6, 7, 8, 9]

    # Without concatenation
    @test get_pages(pdf) ==
    Int32[1:9...]

end

@testset "get_title" begin

    @test get_title(pdf) == "A dummy PDF for tests"

end

end
