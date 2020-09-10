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

    # Get the highlights for the table
    highlights::Function

    # Get the notes for the table
    notes::Function

    # Import the highlights from the PDF
    pdf::Function

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
            () -> _highlights(this),
            () -> _notes(this),
            (pdf::AbstractString; show::Bool = false) -> _pdf(this, pdf; show),
        )

        return this

    end

end

# Load the functions
include("Functions/_check.jl")
include("Functions/_highlights.jl")
include("Functions/_info.jl")
include("Functions/_notes.jl")
include("Functions/_pdf.jl")

end
