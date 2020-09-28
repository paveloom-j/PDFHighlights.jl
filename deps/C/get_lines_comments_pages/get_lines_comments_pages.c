#include <stdio.h>
#include "poppler.h"

void get_lines_comments_pages(
    const char *file,
    char **lines_arrays,
    double **lines_x_anchors_arrays,
    double **lines_yl_anchors_arrays,
    double **lines_yu_anchors_arrays,
    gsize **lines_lens,
    char **comments,
    int **pages,
    gsize *num
)
{
    // For pages loop
    PopplerPage *page;
    GList *annotation_mappings;
    gdouble width, height;

    // For annotations loop
    GList *element;
    PopplerAnnot *annotation;

    // For quads loop
    GArray *quads;
    guint i;

    // For highlights condition
    PopplerQuadrilateral *quad;
    GArray *_lines;
    GArray *_lines_x_anchors;
    GArray *_lines_yl_anchors;
    GArray *_lines_yu_anchors;
    PopplerRectangle *rectangle = poppler_rectangle_new();
    char *text;
    double *a;
    char **p;
    char *comment;
    char *empty_comment = "";
    int page_number_plus_one;

    // For stealing
    gpointer data_pointer;
    gsize data_len;

    // load the document
    PopplerDocument *document = poppler_document_new_from_gfile(
        g_file_new_for_path(file), NULL, NULL, NULL
    );

    // Get the number of pages
    int n_pages = poppler_document_get_n_pages(document);

    // Create actual arrays
    GArray *_lines_arrays = g_array_new(FALSE, FALSE, sizeof(char **));
    GArray *_lines_x_anchors_arrays = g_array_new(FALSE, FALSE, sizeof(double *));
    GArray *_lines_yl_anchors_arrays = g_array_new(FALSE, FALSE, sizeof(double *));
    GArray *_lines_yu_anchors_arrays = g_array_new(FALSE, FALSE, sizeof(double *));
    GArray *_lines_lens = g_array_new(FALSE, FALSE, sizeof(gsize));
    GArray *_comments = g_array_new(FALSE, FALSE, sizeof(char **));
    GArray *_pages = g_array_new(FALSE, FALSE, sizeof(int));

    // Extract the annotations
    for (int page_number = 0; page_number < n_pages; ++page_number)
    {
        // Load the page
        page = poppler_document_get_page(document, page_number);

        // Get the annnotation mappings
        annotation_mappings = poppler_page_get_annot_mapping(page);

        // Skip if there are no annotations on the page
        if (!annotation_mappings)
        {
             g_object_unref(page);
             continue;
        }

        poppler_page_get_size(page, &width, &height);

        // Loop through every annotation
        for(element = annotation_mappings; element; element = element->next)
        {
            // Unpack the annotation
            annotation = ((PopplerAnnotMapping *)element->data)->annot;

            // Perform the following steps only for highlights
            if (poppler_annot_get_annot_type(annotation) == POPPLER_ANNOT_HIGHLIGHT)
            {
                // Get the quadrilaterals
                quads = poppler_annot_text_markup_get_quadrilaterals(
                    (PopplerAnnotTextMarkup *) annotation
                );

                // Create an array to store lines
                _lines = g_array_sized_new(FALSE, FALSE, sizeof(char **), quads->len);
                g_array_set_size(_lines, quads->len);

                // Create an array to store the `x` anchors
                _lines_x_anchors = g_array_sized_new(FALSE, FALSE, sizeof(double), quads->len);
                g_array_set_size(_lines_x_anchors, quads->len);

                // Create an array to store the lower `y` anchors
                _lines_yl_anchors = g_array_sized_new(FALSE, FALSE, sizeof(double), quads->len);
                g_array_set_size(_lines_yl_anchors, quads->len);

                // Create an array to store the upper `y` anchors
                _lines_yu_anchors = g_array_sized_new(FALSE, FALSE, sizeof(double), quads->len);
                g_array_set_size(_lines_yu_anchors, quads->len);

                for (i = 0; i < quads->len; i++)
                {
                    // Load a quadrilateral
                    quad = &g_array_index(quads, PopplerQuadrilateral, i);

                    // Unpack it into a rectangle
                    rectangle->x1 = quad->p3.x;
                    rectangle->y1 = height - quad->p2.y + 5;
                    rectangle->x2 = quad->p2.x;
                    rectangle->y2 = height - quad->p3.y - 5;

                    // Save the `x` anchor
                    a = &g_array_index(_lines_x_anchors, double, i);
                    *a = quad->p3.x;

                    // Save the lower `y` anchor
                    a = &g_array_index(_lines_yl_anchors, double, i);
                    *a = height - quad->p2.y;

                    // Save the upper `y` anchor
                    a = &g_array_index(_lines_yu_anchors, double, i);
                    *a = height - quad->p3.y;

                    // Get the text from the rectangle
                    text = poppler_page_get_text_for_area(page, rectangle);

                    // Save it to the lines
                    p = &g_array_index(_lines, char *, i);
                    *p = text;
                }

                // Steal the `_lines` array
                data_pointer = (char **)g_array_steal(_lines, &data_len);
                g_array_append_val(_lines_arrays, data_pointer);
                g_array_append_val(_lines_lens, data_len);

                // Steal the `_lines_x_anchors` array
                data_pointer = (double *)g_array_steal(_lines_x_anchors, &data_len);
                g_array_append_val(_lines_x_anchors_arrays, data_pointer);

                // Steal the `_lines_yl_anchors` array
                data_pointer = (double *)g_array_steal(_lines_yl_anchors, &data_len);
                g_array_append_val(_lines_yl_anchors_arrays, data_pointer);

                // Steal the `_lines_yu_anchors` array
                data_pointer = (double *)g_array_steal(_lines_yu_anchors, &data_len);
                g_array_append_val(_lines_yu_anchors_arrays, data_pointer);

                // Save the comment (if it exists)
                comment = poppler_annot_get_contents(annotation);
                if (comment)
                {
                    g_array_append_val(_comments, comment);
                }
                else
                {
                    g_array_append_val(_comments, empty_comment);
                }

                // Save the page
                page_number_plus_one = page_number + 1;
                g_array_append_val(_pages, page_number_plus_one);

                g_array_free(quads, TRUE);
            }
        }

        // Clean up
        poppler_page_free_annot_mapping(annotation_mappings);
        g_object_unref(page);

    }

    // Clean up
    g_object_unref(document);
    poppler_rectangle_free(rectangle);

    // Steal the `_lines_lens` array
    data_pointer = g_array_steal(_lines_lens, &data_len);
    *lines_lens = (gsize *)data_pointer;

    // Steal the `_lines_arrays` array
    data_pointer = g_array_steal(_lines_arrays, &data_len);
    *lines_arrays = (char *)data_pointer;

    // Steal the `_lines_x_anchors_arrays` array
    data_pointer = g_array_steal(_lines_x_anchors_arrays, &data_len);
    *lines_x_anchors_arrays = (double *)data_pointer;

    // Steal the `_lines_yl_anchors_arrays` array
    data_pointer = g_array_steal(_lines_yl_anchors_arrays, &data_len);
    *lines_yl_anchors_arrays = (double *)data_pointer;

    // Steal the `_lines_yu_anchors_arrays` array
    data_pointer = g_array_steal(_lines_yu_anchors_arrays, &data_len);
    *lines_yu_anchors_arrays = (double *)data_pointer;

    // Steal the `_comments` array
    data_pointer = g_array_steal(_comments, &data_len);
    *comments = (char *)data_pointer;

    // Steal the `_pages` array
    data_pointer = g_array_steal(_pages, &data_len);
    *pages = (int *)data_pointer;
    *num = data_len;

    return;
}
