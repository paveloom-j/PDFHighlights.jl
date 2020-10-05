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

    @test readlines(csv) == String[header,]
    @test_nowarn initialize(csv)

    csv = mktemp((path, _) -> string(path, ".csv"))
    touch(csv)
    initialize(csv)

    @test readlines(csv) == String[header,]
    @test_nowarn initialize(csv)

    @test_throws PDFHighlights.Internal.Exceptions.NotCSV("oof") initialize("oof")

end

@testset "_check" begin

    @initialize

    @test_nowarn PDFHighlights.Internal.CSV._check(csv)

    line = "\"Highlight with \"\"quotes\"\"\",\"Title 1\",\"Author 1\",,\"Note 1\",1"

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
        Highlights (found / added): 7 / 7

    """

    @test s1 == s2

    s1 = @capture_out import_highlights(csv, pdf)
    s2 = """

        CSV: "$(basename(csv))"
        PDF: "$(basename(pdf))"
        Highlights (found / added): 7 / 0

    """

    @test s1 == s2

    @test_throws(
        PDFHighlights.Internal.Exceptions.IntegrityCheckFailed("oof"),
        import_highlights("oof", pdf),
    )

    @initialize

    dir = joinpath(@__DIR__, "..")

    s1 = @capture_out import_highlights(csv, dir)
    s2 = """

        CSV: "$(basename(csv))"
        Directory: "$(basename(dirname(normpath(dir))))"
        Highlights (found / added): 7 / 7

    """

    @test s1 == s2

    s1 = @capture_out import_highlights(csv, dir)
    s2 = """

        CSV: "$(basename(csv))"
        Directory: "$(basename(dirname(normpath(dir))))"
        Highlights (found / added): 7 / 0

    """

    @test s1 == s2

    @initialize

    dir = dirname(normpath(@__DIR__, ".."))

    s1 = @capture_out import_highlights(csv, dir)
    s2 = """

        CSV: "$(basename(csv))"
        Directory: "$(basename(dir))"
        Highlights (found / added): 7 / 7

    """

    @test s1 == s2

    s1 = @capture_out import_highlights(csv, dir)
    s2 = """

        CSV: "$(basename(csv))"
        Directory: "$(basename(dir))"
        Highlights (found / added): 7 / 0

    """

    @test s1 == s2

end

@testset "_get_authors_from_CSV" begin

    @initialize

    @test PDFHighlights.Internal.CSV._get_authors_from_CSV(csv) == String[]

    line = "\"Highlight 1\",\"Title 1\",\"Author with \"\"quotes\"\"\",,\"Note 1\",1"

    open(csv, "a") do io
        println(io, line)
    end

    @test PDFHighlights.Internal.CSV._get_authors_from_CSV(csv) ==
    String["Author with \"quotes\""]

    line = "\"Highlight 1\",\"Title 1\",Author without quotes,,\"Note 1\",1"

    open(csv, "w") do io
        println(io, header, '\n', line)
    end

    @test PDFHighlights.Internal.CSV._get_authors_from_CSV(csv) ==
    String["Author without quotes"]

    line = "\"Highlight 1\",\"Title 1\",\"\",,\"Note 1\",1"

    open(csv, "w") do io
        println(io, header, '\n', line)
    end

    @test PDFHighlights.Internal.CSV._get_authors_from_CSV(csv) ==
    String[""]

    line = "\"Highlight 1\",\"Title 1\",,,\"Note 1\",1"

    open(csv, "w") do io
        println(io, header, '\n', line)
    end

    @test PDFHighlights.Internal.CSV._get_authors_from_CSV(csv) ==
    String[""]

    @test_throws(
        PDFHighlights.Internal.Exceptions.IntegrityCheckFailed("oof"),
        PDFHighlights.Internal.CSV._get_authors_from_CSV("oof"),
    )

end

@testset "_get_highlights_from_CSV" begin

    @initialize

    @test PDFHighlights.Internal.CSV._get_highlights_from_CSV(csv) == String[]

    line = "\"Highlight with \"\"quotes\"\"\",\"Title 1\",\"Author 1\",,\"Note 1\",1"

    open(csv, "a") do io
        println(io, line)
    end

    @test PDFHighlights.Internal.CSV._get_highlights_from_CSV(csv) ==
    String["Highlight with \"quotes\""]

    line = "Highlight without quotes,\"Title 1\",\"Author 1\",,\"Note 1\",1"

    open(csv, "w") do io
        println(io, header, '\n', line)
    end

    @test PDFHighlights.Internal.CSV._get_highlights_from_CSV(csv) ==
    String["Highlight without quotes"]

    line = "\"\",\"Title 1\",\"Author 1\",,\"Note 1\",1"

    open(csv, "w") do io
        println(io, header, '\n', line)
    end

    @test PDFHighlights.Internal.CSV._get_highlights_from_CSV(csv) ==
    String[""]

    line = ",\"Title 1\",\"Author 1\",,\"Note 1\",1"

    open(csv, "w") do io
        println(io, header, '\n', line)
    end

    @test PDFHighlights.Internal.CSV._get_highlights_from_CSV(csv) ==
    String[""]

    @test_throws(
        PDFHighlights.Internal.Exceptions.IntegrityCheckFailed("oof"),
        PDFHighlights.Internal.CSV._get_highlights_from_CSV("oof"),
    )

end

@testset "_get_titles_from_CSV" begin

    @initialize

    @test PDFHighlights.Internal.CSV._get_titles_from_CSV(csv) == String[]

    line = "\"Highlight 1\",\"Title with \"\"quotes\"\"\",\"Author 1\",,\"Note 1\",1"

    open(csv, "a") do io
        println(io, line)
    end

    @test PDFHighlights.Internal.CSV._get_titles_from_CSV(csv) ==
    String["Title with \"quotes\""]

    line = "\"Highlight 1\",Title without quotes,\"Author 1\",,\"Note 1\",1"

    open(csv, "w") do io
        println(io, header, '\n', line)
    end

    @test PDFHighlights.Internal.CSV._get_titles_from_CSV(csv) ==
    String["Title without quotes"]

    line = "\"Highlight 1\",\"\",\"Author 1\",,\"Note 1\",1"

    open(csv, "w") do io
        println(io, header, '\n', line)
    end

    @test PDFHighlights.Internal.CSV._get_titles_from_CSV(csv) ==
    String[""]

    line = "\"Highlight 1\",,\"Author 1\",,\"Note 1\",1"

    open(csv, "w") do io
        println(io, header, '\n', line)
    end

    @test PDFHighlights.Internal.CSV._get_titles_from_CSV(csv) ==
    String[""]

    @test_throws(
        PDFHighlights.Internal.Exceptions.IntegrityCheckFailed("oof"),
        PDFHighlights.Internal.CSV._get_titles_from_CSV("oof"),
    )

end

@testset "get_all" begin

    @initialize

    @test get_all(csv) == (String[], String[], String[], String[], String[], Int32[])

    line = "\"Highlight 1\",\"Title with \"\"quotes\"\"\",\"Author 1\",,\"Note 1\",1"

    open(csv, "a") do io
        println(io, line)
    end

    @test get_all(csv) == (
        String["Highlight 1"],
        String["Title with \"quotes\""],
        String["Author 1"], String[""],
        String["Note 1"],
        Int32[1],
    )

    @test_throws(
        PDFHighlights.Internal.Exceptions.IntegrityCheckFailed("oof"),
        get_all("oof"),
    )

end

@testset "get_locations" begin

    @initialize

    @test get_locations(csv) == Int32[]

    line = "\"Highlight 1\",\"Title 1\",\"Author 1\",,\"Note 1\","

    open(csv, "a") do io
        println(io, line)
    end

    @test get_locations(csv) ==
    Int32[0]

    line = "\"Highlight 1\",\"Title 1\",\"Author 1\",,\"Note 1\",1"

    open(csv, "w") do io
        println(io, header, '\n', line)
    end

    @test get_locations(csv) ==
    Int32[1]

    @test_throws(
        PDFHighlights.Internal.Exceptions.IntegrityCheckFailed("oof"),
        get_locations("oof"),
    )

end

@testset "get_notes" begin

    @initialize

    @test get_notes(csv) == String[]

    line = "\"Highlight 1\",\"Title 1\",\"Author 1\",,\"Note with \"\"quotes\"\"\",1"

    open(csv, "a") do io
        println(io, line)
    end

    @test get_notes(csv) ==
    String["Note with \"quotes\""]

    line = "\"Highlight 1\",\"Title 1\",\"Author 1\",,Note without quotes,1"

    open(csv, "w") do io
        println(io, header, '\n', line)
    end

    @test get_notes(csv) ==
    String["Note without quotes"]

    line = "\"Highlight 1\",\"Title 1\",\"Author 1\",,\"\",1"

    open(csv, "w") do io
        println(io, header, '\n', line)
    end

    @test get_notes(csv) ==
    String[""]

    line = "\"Highlight 1\",\"Title 1\",\"Author 1\",,,1"

    open(csv, "w") do io
        println(io, header, '\n', line)
    end

    @test get_notes(csv) ==
    String[""]

    @test_throws(
        PDFHighlights.Internal.Exceptions.IntegrityCheckFailed("oof"),
        get_notes("oof"),
    )

end

@testset "get_urls" begin

    @initialize

    @test get_urls(csv) == String[]

    line = "\"Highlight 1\",\"Title 1\",\"Author 1\",\"URL, \"\"quotes\"\"\",\"Note 1\",1"

    open(csv, "a") do io
        println(io, line)
    end

    @test get_urls(csv) ==
    String["URL, \"quotes\""]

    line = "\"Highlight 1\",\"Title 1\",\"Author 1\",URL without quotes,\"Note 1\",1"

    open(csv, "w") do io
        println(io, header, '\n', line)
    end

    @test get_urls(csv) ==
    String["URL without quotes"]

    line = "\"Highlight 1\",\"Title 1\",\"Author 1\",\"\",\"Note 1\",1"

    open(csv, "w") do io
        println(io, header, '\n', line)
    end

    @test get_urls(csv) ==
    String[""]

    line = "\"Highlight 1\",\"Title 1\",\"Author 1\",,\"Note 1\",1"

    open(csv, "w") do io
        println(io, header, '\n', line)
    end

    @test get_urls(csv) ==
    String[""]

    @test_throws(
        PDFHighlights.Internal.Exceptions.IntegrityCheckFailed("oof"),
        get_urls("oof"),
    )

end

macro initialize_with_lines()
    return esc(
        quote
            @initialize
            open(csv, "a") do io
                println(io, join(lines, '\n'))
            end
        end
    )
end

macro test_column(column)
    return esc(
        quote
            @initialize_with_lines
            @test_nowarn sort!(csv; column = $column)
            @test readlines(csv) == expected_lines
        end
    )
end

@testset "sort!" begin

    lines = [
        "\"C\",\"C\",\"C\",\"C\",\"C\",3",
        "\"B\",\"B\",\"B\",\"B\",\"B\",2",
        "\"A\",\"A\",\"A\",\"A\",\"A\",1",
    ]

    expected_lines = vcat(header, reverse(lines))

    @test_column(:highlight)
    @test_column(:title)
    @test_column(:author)
    @test_column(:url)
    @test_column(:note)
    @test_column(:location)

    @test_throws(
        PDFHighlights.Internal.Exceptions.SymbolIsNotSupported(:oof),
        sort!("oof"; column = :oof)
    )

    @test_throws(
        PDFHighlights.Internal.Exceptions.IntegrityCheckFailed("oof"),
        sort!("oof")
    )

end

end
