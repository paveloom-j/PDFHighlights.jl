# [Package Guide](@id Guide)

The design of this package serves one purpose: to make exporting highlights from PDF files
to a CSV file as simple as calling a single function. The [format](@ref CSVFormat) of the
resulting file corresponds to the requirements defined by the
[Readwise](https://readwise.io/) service for the bulk import of CSV files. It makes it
possible not only to extract and store highlights but also to benefit from them using
[spaced repetition](https://en.wikipedia.org/wiki/Spaced_repetition).

## Installation

The package is available in the [General](https://github.com/JuliaRegistries/General)
registry, so the installation is not different from the standard procedure:
from the Julia REPL, type `]` to enter the Pkg REPL mode and run:

```
pkg> add PDFHighlights
```

## [Importing highlights](@id Importing)

You can import highlights from a PDF file or a directory containing PDF files using
the [`import_highlights`](@ref) function:

```julia
using PDFHighlights
import_highlights("highlights.csv", pdf)
```

This function prints to standard output. For example, for the PDF used for tests in this
package, the output will be as follows:

```@setup pdf
using PDFHighlights
dir = joinpath(pathof(PDFHighlights) |> dirname |> dirname, "test", "pdf")
pdf = joinpath(dir, "TestPDF.pdf")
```

```@example pdf
import_highlights("highlights.csv", pdf) # hide
```

Every highlight and associated metadata get represented by a row in a CSV file. These rows
are generated by this function and discarded if identical rows already exist in the target
file. Therefore, the reinvocation of this function gives the following output:

```@example pdf
import_highlights("highlights.csv", pdf) # hide
```

For this reason, the function name has a verb `import`: it allows you to update existing
CSV files (obtained by this package, presumably) with new highlights. Third-party CSV files
may be supported if they match the [format](@ref CSVFormat).

An empty CSV file with a correct header can be created using the [`initialize`](@ref)
function:

```@example pdf
initialize("highlights.csv")
```

## [Retrieving pieces](@id Retrieving)

For more crafty workflows, you can use the remaining functions from the
[public interface](@ref PublicInterface). They allow you to retrieve pieces of data related to
highlights. Confusion of terminology may be here, as CSV files require slightly different
field names. Here is a table showing what can you can extract from each file type:

```@raw html

<table style="width: fit-content; border-collapse: collapse;">
  <tbody>
    <tr>
      <th style="text-align: center; border: 1px solid lightgray; padding: 6px 12px;">
        CSV
      </th>

      <td style="text-align: center; border: 1px solid lightgray; padding: 6px 12px;">
        Highlights
      </td>

      <td style="text-align: center; border: 1px solid lightgray; padding: 6px 12px;">
        Titles
      </td>

      <td style="text-align: center; border: 1px solid lightgray; padding: 6px 12px;">
        Authors
      </td>

      <td style="text-align: center; border: 1px solid lightgray; padding: 6px 12px;">
        Notes
      </td>

      <td style="text-align: center; border: 1px solid lightgray; padding: 6px 12px;">
        Locations
      </td>
    </tr>
    <tr>
      <th style="text-align: center; border: 1px solid lightgray; padding: 6px 12px;">
        PDF
      </th>

      <td style="text-align: center; border: 1px solid lightgray; padding: 6px 12px;">
        Highlights
      </td>

      <td style="text-align: center; border: 1px solid lightgray; padding: 6px 12px;">
        Titles
      </td>

      <td style="text-align: center; border: 1px solid lightgray; padding: 6px 12px;">
        Authors
      </td>

      <td style="text-align: center; border: 1px solid lightgray; padding: 6px 12px;">
        Comments
      </td>

      <td style="text-align: center; border: 1px solid lightgray; padding: 6px 12px;">
        Pages
      </td>
    </tr>
  </tbody>
</table>

```

Each peace has its own function. For example, you can get a PDF title like this:

```@example pdf
get_title(pdf)
```

This and some other functions have recursive analogs:

```@example pdf
get_titles(dir)
```

There are also functions returning multiple pieces at once. For example, to get the author
and the title:

```@example pdf
get_author_title(pdf)
```

See the full list of functions in the [Extracting data](@ref ExtractingData) section in the
public interface description.
