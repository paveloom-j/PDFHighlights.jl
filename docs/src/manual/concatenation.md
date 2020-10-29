# [Concatenation](@id Concatenation)

Due to the limitations of the PDF format, creating highlights spanning two or more pages is
rather complicated. Similar to [Readwise](https://readwise.io/)'s solution on this problem,
this package supports the concatenation of highlights utilizing comments.

## Concatenation IDs

To connect two or more highlights, the comments of these highlights must start with the
identifiers `.c1`, `.c2`, and so on. The order of the identifiers must coincide with the
order of display of the highlights themselves: left to right, top-down within one page,
and in ascending order of pages otherwise.

Example: highlight with the text "Hello" and the comment ".c1 General" on page 1, a
highlight with the text "there!" and the comment ".c2 Kenobi" on page 2. Concatenation
result: highlight with the text "Hello there!" and the comment "General Kenobi".

## Word hyphenation

Concatenation does some magic under the hood. It removes concatenation identifiers
(even if the chain consists of one highlight) and also connects hyphenated words.

Example: highlight with the text "Mine-" and the comment ".c1" on page 1, a
highlight with the text "craft" and the comment ".c2" on page 2. Concatenation
result: highlight with the text "Minecraft" and an empty comment.

## The keyword

The [`import_highlights`](@ref) function uses concatenation by default. Functions for
[getting pieces](@ref ExtractingData) containing the words `highlights`, `comments`, or
`pages` in their name support the keyword `concatenate`.

Example without concatenation:

```@setup pdf
using PDFHighlights
pdf = joinpath(pathof(PDFHighlights) |> dirname |> dirname, "test", "pdf", "TestPDF.pdf")
```

```@example pdf
get_highlights_comments(pdf; concatenate = false)
```

Example with concatenation:

```@example pdf
get_highlights_comments(pdf)
```

where `pdf` is the path to the PDF used by this package in the tests.
