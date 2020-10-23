#include <stdio.h>
#include "glib.h"
#include "poppler.h"

void get_author_title(
    const char *file,
    char **author,
    char **title
)
{
    // load the document
    PopplerDocument *document = poppler_document_new_from_gfile(
        g_file_new_for_path(file), NULL, NULL, NULL
    );

    *author = poppler_document_get_author(document);
    *title = poppler_document_get_title(document);

    return;
}
