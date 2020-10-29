module TestExceptions

using PDFHighlights
using Test

# Print the header
println("\e[1;32mRUNNING\e[0m: TestExceptions.jl")

PDFHighlights.Internal.Exceptions.@exception(
    exception_with_file,
    file::String,
)

@testset "@exception_with_file" begin

    @exception_with_file(
        HelloThere,
        "Exception thrown when Obi-Wan Kenobi joins the server.",
        "Hello there, ", e.file, "!"
    )

    try
        throw(HelloThere("Obi-Wan"))
    catch e
        @test sprint(showerror, e) == """


        Main.TestExceptions.HelloThere:
        Hello there, Obi-Wan!
        """
    end

end

PDFHighlights.Internal.Exceptions.@exception(
    exception_with_line,
    file::String,
    line::Int,
)

@testset "@exception_with_line" begin

    @exception_with_line(
        ObjectsDestroyed,
        "Exception thrown when another god damn Death Star was destroyed.",
        e.file, " destroyed: ", e.line, ".",
    )

    try
        throw(ObjectsDestroyed("Death Stars", 2))
    catch e
        @test sprint(showerror, e) == """


        Main.TestExceptions.ObjectsDestroyed:
        Death Stars destroyed: 2.
        """
    end

end

end
