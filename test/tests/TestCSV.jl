# This file contains the tests for the `CSV` module

module TestCSV

using PDFHighlights
using Suppressor
using Test

# Print the header
println("\e[1;32mRUNNING\e[0m: TestCSV.jl")

const pdf = joinpath(@__DIR__, "..", "pdf", "TestPDF.pdf")
const header = "Highlight,Title,Author,URL,Note,Location"

macro initialize()
    return esc(
        quote
            csv = mktemp((path, _) -> string(path, ".csv"))
            initialize(csv)
        end
    )
end

@testset "initialize" begin

    @initialize

    @test readlines(csv) == [header,]
    @test_nowarn initialize(csv)
    @test_throws PDFHighlights.Internal.Exceptions.NotCSV("oof") initialize("oof")

end

@testset "_check" begin

    @initialize

    @test_nowarn PDFHighlights.Internal.CSV._check(csv)

    line = "\"Highlight with \\\"quotes\\\"\",\"Title 1\",\"Author 1\",,\"Note 1\",1"

    open(csv, "a") do io
        println(io, line)
    end

    @test_nowarn PDFHighlights.Internal.CSV._check(csv)

    line = "\"Highlight 1\",\"Title 1\",\"Author 1\",,\"Note 1\",\"Love\""

    open(csv, "w") do io
        println(io, header, '\n', line)
    end

    @test_throws(
        PDFHighlights.Internal.Exceptions.LastElementIsNotAnInteger(csv, 2),
        PDFHighlights.Internal.CSV._check(csv),
    )

    line = "Wrong header"

    open(csv, "w") do io
        println(io, line)
    end

    @test_throws(
        PDFHighlights.Internal.Exceptions.IncorrectHeader(csv),
        PDFHighlights.Internal.CSV._check(csv),
    )

    line = "Column 1, Column 2, Column 3, Column 4, Column 5, Column 6, 7"

    open(csv, "w") do io
        println(io, header, '\n', line)
    end

    @test_throws(
        PDFHighlights.Internal.Exceptions.NotSixColumns(csv, 2),
        PDFHighlights.Internal.CSV._check(csv),
    )

end

@testset "import_highlights" begin

    @initialize

    @suppress_out @test_nowarn import_highlights(csv, pdf)
    @suppress_out @test_nowarn import_highlights(csv, pdf)

    @initialize

    s1 = @capture_out import_highlights(csv, pdf)
    s2 = """

        CSV: "$(basename(csv))"
        PDF: "$(basename(pdf))"
        Highlights (found / added): 3 / 3

    """

    @test s1 == s2

    s1 = @capture_out import_highlights(csv, pdf)
    s2 = """

        CSV: "$(basename(csv))"
        PDF: "$(basename(pdf))"
        Highlights (found / added): 3 / 0

    """

    @test s1 == s2

    s1 = @capture_out import_highlights(csv, pdf; show = true)
    s2 = """

        CSV: "$(basename(csv))"
        PDF: "$(basename(pdf))"
        Highlights (found / added): 3 / 0

        Found highlights:
        [1] Highlight 1
        [2] Highlight 2 Highlight 3
        [3] Highlight 4

        Found comments:
        [1] Comment 1
        [2] Comment 2 Comment 3
        [3] Comment 4

    """

    @test s1 == s2

    @test_throws(
        PDFHighlights.Internal.Exceptions.IntegrityCheckFailed("oof"),
        import_highlights("oof", pdf),
    )

end

@testset "print_info" begin

    @initialize

    s1 = @capture_out print_info(csv)
    s2 = """

        Table path: "$(csv)"
        Number of highlights: 0

    """

    @test s1 == s2

    @suppress_out import_highlights(csv, pdf)

    s1 = @capture_out print_info(csv)
    s2 = """

        Table path: "$(csv)"
        Number of highlights: 3

    """

    @test s1 == s2

    @test_throws(
        PDFHighlights.Internal.Exceptions.IntegrityCheckFailed("oof"),
        print_info("oof"),
    )

end

@testset "_get_highlights_from_csv" begin

    @initialize

    @test PDFHighlights.Internal.CSV._get_highlights_from_csv(csv) == []

    line = "\"Highlight with \\\"quotes\\\"\",\"Title 1\",\"Author 1\",,\"Note 1\",1"

    open(csv, "a") do io
        println(io, line)
    end

    @test PDFHighlights.Internal.CSV._get_highlights_from_csv(csv) ==
    ["Highlight with \"quotes\""]

    line = "Highlight without quotes,\"Title 1\",\"Author 1\",,\"Note 1\",1"

    open(csv, "w") do io
        println(io, header, '\n', line)
    end

    @test PDFHighlights.Internal.CSV._get_highlights_from_csv(csv) ==
    ["Highlight without quotes"]

    line = ",\"Title 1\",\"Author 1\",,\"Note 1\",1"

    open(csv, "w") do io
        println(io, header, '\n', line)
    end

    @test PDFHighlights.Internal.CSV._get_highlights_from_csv(csv) ==
    [""]

    @test_throws(
        PDFHighlights.Internal.Exceptions.IntegrityCheckFailed("oof"),
        PDFHighlights.Internal.CSV._get_highlights_from_csv("oof"),
    )

end

@testset "get_titles" begin

    @initialize

    @test get_titles(csv) == []

    line = "\"Highlight 1\",\"Title with \\\"quotes\\\"\",\"Author 1\",,\"Note 1\",1"

    open(csv, "a") do io
        println(io, line)
    end

    @test get_titles(csv) ==
    ["Title with \"quotes\""]

    line = "\"Highlight 1\",Title without quotes,\"Author 1\",,\"Note 1\",1"

    open(csv, "w") do io
        println(io, header, '\n', line)
    end

    @test get_titles(csv) ==
    ["Title without quotes"]

    line = "\"Highlight 1\",,\"Author 1\",,\"Note 1\",1"

    open(csv, "w") do io
        println(io, header, '\n', line)
    end

    @test get_titles(csv) ==
    [""]

    @test_throws(
        PDFHighlights.Internal.Exceptions.IntegrityCheckFailed("oof"),
        get_titles("oof"),
    )

end

@testset "get_authors" begin

    @initialize

    @test get_authors(csv) == []

    line = "\"Highlight 1\",\"Title 1\",\"Author with \\\"quotes\\\"\",,\"Note 1\",1"

    open(csv, "a") do io
        println(io, line)
    end

    @test get_authors(csv) ==
    ["Author with \"quotes\""]

    line = "\"Highlight 1\",\"Title 1\",Author without quotes,,\"Note 1\",1"

    open(csv, "w") do io
        println(io, header, '\n', line)
    end

    @test get_authors(csv) ==
    ["Author without quotes"]

    line = "\"Highlight 1\",\"Title 1\",,,\"Note 1\",1"

    open(csv, "w") do io
        println(io, header, '\n', line)
    end

    @test get_authors(csv) ==
    [""]

    @test_throws(
        PDFHighlights.Internal.Exceptions.IntegrityCheckFailed("oof"),
        get_authors("oof"),
    )

end

@testset "get_urls" begin

    @initialize

    @test get_urls(csv) == []

    line = "\"Highlight 1\",\"Title 1\",\"Author 1\",\"URL, \\\"quotes\\\"\",\"Note 1\",1"

    open(csv, "a") do io
        println(io, line)
    end

    @test get_urls(csv) ==
    ["URL, \"quotes\""]

    line = "\"Highlight 1\",\"Title 1\",\"Author 1\",URL without quotes,\"Note 1\",1"

    open(csv, "w") do io
        println(io, header, '\n', line)
    end

    @test get_urls(csv) ==
    ["URL without quotes"]

    line = "\"Highlight 1\",\"Title 1\",\"Author 1\",,\"Note 1\",1"

    open(csv, "w") do io
        println(io, header, '\n', line)
    end

    @test get_urls(csv) ==
    [""]

    @test_throws(
        PDFHighlights.Internal.Exceptions.IntegrityCheckFailed("oof"),
        get_urls("oof"),
    )

end

@testset "get_notes" begin

    @initialize

    @test get_notes(csv) == []

    line = "\"Highlight 1\",\"Title 1\",\"Author 1\",,\"Note with \\\"quotes\\\"\",1"

    open(csv, "a") do io
        println(io, line)
    end

    @test get_notes(csv) ==
    ["Note with \"quotes\""]

    line = "\"Highlight 1\",\"Title 1\",\"Author 1\",,Note without quotes,1"

    open(csv, "w") do io
        println(io, header, '\n', line)
    end

    @test get_notes(csv) ==
    ["Note without quotes"]

    line = "\"Highlight 1\",\"Title 1\",\"Author 1\",,,1"

    open(csv, "w") do io
        println(io, header, '\n', line)
    end

    @test get_notes(csv) ==
    [""]

    @test_throws(
        PDFHighlights.Internal.Exceptions.IntegrityCheckFailed("oof"),
        get_notes("oof"),
    )

end

@testset "get_locations" begin

    @initialize

    @test get_locations(csv) == []

    line = "\"Highlight 1\",\"Title 1\",\"Author 1\",,\"Note 1\","

    open(csv, "a") do io
        println(io, line)
    end

    @test get_locations(csv) ==
    [0]

    line = "\"Highlight 1\",\"Title 1\",\"Author 1\",,\"Note 1\",1"

    open(csv, "w") do io
        println(io, header, '\n', line)
    end

    @test get_locations(csv) ==
    [1]

    @test_throws(
        PDFHighlights.Internal.Exceptions.IntegrityCheckFailed("oof"),
        get_locations("oof"),
    )

end

end
