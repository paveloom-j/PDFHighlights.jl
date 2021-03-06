# PDFHighlights.jl

_Export highlights from PDF files to a CSV file with one call._

```@raw html

<table style="width: fit-content; border-collapse: collapse;">
  <tbody>
    <tr>
      <th style="text-align: center; border: 1px solid lightgray; padding: 6px 12px;">
        Code Coverage
      </th>

      <th style="text-align: center; border: 1px solid lightgray; padding: 6px 12px;">
        Repository & License
      </th>

      <th style="text-align: center; border: 1px solid lightgray; padding: 6px 12px;">
        Playground
      </th>
    </tr>
    <tr>
      <td style="text-align: center; border: 1px solid lightgray; padding: 6px 12px;">
        <a href="https://codecov.io/gh/paveloom-j/PDFHighlights.jl" style="position: relative; bottom: -2px;">
          <img src="https://codecov.io/gh/paveloom-j/PDFHighlights.jl/branch/master/graph/badge.svg" />
        </a>
      </td>

      <td style="text-align: center; border: 1px solid lightgray; padding: 6px 12px;">
        <a href="https://github.com/paveloom-j/PDFHighlights.jl" style="position: relative; bottom: -2px;">
          <img src="https://img.shields.io/badge/GitHub-paveloom--j%2FPDFHighlights.jl-5DA399.svg">
        </a>
        <a href="https://github.com/paveloom-j/PDFHighlights.jl/blob/master/LICENSE.md" style="position: relative; bottom: -2px;">
          <img src="https://img.shields.io/badge/license-MIT-5DA399.svg">
        </a>
      </td>

      <td style="text-align: center; border: 1px solid lightgray; padding: 6px 12px;">
        <a href="https://mybinder.org/v2/gh/paveloom-j/PDFHighlights.jl/master?urlpath=lab/tree/playground.ipynb" style="position: relative; bottom: -2px;">
          <img src="https://mybinder.org/badge_logo.svg">
        </a>
      </td>
    </tr>
  </tbody>
</table>

```

A package for exporting highlights (and related data) from PDF files and saving them to
a CSV.

## Package Features

- [Import](@ref Importing) highlights into a new or already created CSV file with one call
- [Concatenate](@ref Concatenation) highlights utilizing comments
- [Extract](@ref Retrieving) any piece of a highlight from a PDF or CSV file

## Manual Outline

```@contents
Pages = map(
    s -> "manual/$(s)",
    ["guide.md", "format.md", "concatenation.md"],
)
```

## Library Outline

```@contents
Pages = [
    "lib/index.md",
    "lib/public.md",
]
```

- Internals
  - [PDFHighlights](@ref PDFHighlightsPage)
  - [PDF](@ref PDFPage)
  - [CSV](@ref CSVPage)
  - [Both](@ref BothPage)
  - [Exceptions](@ref ExceptionsPage)
  - [Constants](@ref ConstantsPage)

Logo from [icons8.com](https://icons8.com).
