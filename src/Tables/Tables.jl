module Tables

using ..Exceptions
using ..Highlights
using ..Metadata

export Table

# Default header
const header = "Highlight,Title,Author,URL,Note,Location"

struct Table

    # Path to the table
    file::String

    # Check if the structure of the table is correct
    check::Function

    # Print the info about the table
    info::Function

    # Import the highlights from the PDF
    pdf::Function

    # Get the column values from the table
    highlights::Function
    titles::Function
    authors::Function
    urls::Function
    notes::Function
    locations::Function

    # Construct an object of this type
    function Table(file::AbstractString)

        # Check that the path has the correct extension
        !endswith(file, ".csv") && throw(IncorrectExtension(file))

        # Check if the file exists
        if isfile(file)

            # Check if the structure of the table is correct
            _check(file)

        else

            # Write the header
            open(file, "w") do io
                println(io, header)
            end

        end

        this = new(
            file,
            () -> _check(this),
            () -> _info(this),
            (pdf::AbstractString; show::Bool = false) -> _pdf(this, pdf; show),
            () -> _highlights(this),
            () -> _titles(this),
            () -> _authors(this),
            () -> _urls(this),
            () -> _notes(this),
            () -> _locations(this),
        )

        return this

    end

end

# Load the functions

# Check if the structure of the table is correct
include("Functions/_check.jl")

# Print the info about the table
include("Functions/_info.jl")

# Import the highlights from the PDF
include("Functions/_pdf.jl")

# Get the column values from the table
include("Functions/_highlights.jl")
include("Functions/_titles.jl")
include("Functions/_authors.jl")
include("Functions/_urls.jl")
include("Functions/_notes.jl")
include("Functions/_locations.jl")

end
