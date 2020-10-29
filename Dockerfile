# Base image
FROM paveloom/binder-julia:0.1.2

# Meta information
LABEL maintainer="Pavel Sobolev (https://github.com/Paveloom)"
LABEL version="0.1.2"
LABEL description="A playground for the `PDFHighlights.jl` package."
LABEL github-repository="https://github.com/paveloom-j/PDFHighlights.jl"
LABEL docker-repository="https://github.com/orgs/paveloom-j/packages/container/pdfhighlights/"

# Install the package
RUN julia -e 'using Pkg; Pkg.add("PDFHighlights"); using PDFHighlights'

# Get the notebook
RUN wget https://raw.githubusercontent.com/paveloom-j/PDFHighlights.jl/master/binder/playground.ipynb >/dev/null 2>&1

# Get the PDF
RUN wget https://raw.githubusercontent.com/paveloom-j/PDFHighlights.jl/master/test/pdf/TestPDF.pdf >/dev/null 2>&1