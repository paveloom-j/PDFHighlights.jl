using Documenter # A package to manage documentation
using PDFHighlights # A package to create the documentation for

# Create documentation
makedocs(
    # Specify modules being used
    modules = [PDFHighlights],

    # Specify a name for the site
    sitename = "PDFHighlights.jl",

    # Specify the author
    authors = "Pavel Sobolev",

    # Specify the pages on the left side
    pages = [
        "Home" => "index.md",

        "Manual" => [
            "Guide" => "manual/guide.md",
            "Format" => "manual/format.md",
            "manual/concatenation.md"
        ],

        "Library" => [
            "Index" => "lib/index.md",
            "Public" => "lib/public.md",
            "Internals" => map(
                s -> "lib/internals/$(s)",
                [
                    "PDFHighlights.md",
                    "PDF.md",
                    "CSV.md",
                    "Both.md",
                    "Exceptions.md",
                    "Constants.md",
                ]
            ),
        ],
    ],

    # Specify a format
    format = Documenter.HTML(
            # Custom assets
            assets = ["assets/custom.css"],
            # A fallback for creating docs locally
            prettyurls = get(ENV, "CI", nothing) == "true",
        ),

    # Fail if any error occurred
    strict = true,
)

# Deploy documentation
deploydocs(
    # Specify a repository
    repo = "github.com/paveloom-j/PDFHighlights.jl.git",

    # Specify a development branch
    devbranch = "develop",
)
