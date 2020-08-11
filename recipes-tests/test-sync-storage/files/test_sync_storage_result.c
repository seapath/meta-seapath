/*
 * Copyright (C) 2020, RTE (http://www.rte-france.com)
*/

#include <glib.h>
#include <string.h>

int main(int argc, char *argv[])
{
    GError* error = NULL;
    gint64 *time = NULL;
    gsize length;
    gboolean res;
    GDateTime* dateTime = NULL;
    gchar *timeString = NULL;
    gint ret = 0;
    gchar *file_path = NULL;
    gchar **file_array = NULL;
    GOptionContext *context;
    GOptionEntry entries[] =
    {
        { G_OPTION_REMAINING,
        0,
        0,
        G_OPTION_ARG_FILENAME_ARRAY,
        &file_array,
        NULL,
        NULL },
        { 0 }
    };
    context = g_option_context_new ("file_path");
    g_option_context_add_main_entries (context, entries, NULL);
    if (!g_option_context_parse (context, &argc, &argv, &error))
    {
        g_printerr ("option parsing failed: %s\n", error->message);
        if (error)
            g_error_free(error);
        g_option_context_free(context);
        return 1;
    }
    g_option_context_free(context);
    if (!file_array)
    {
        g_printerr ("option parsing failed\n");
        return 1;
    }
    file_path = file_array[0];
    if (!file_path)
    {
        g_printerr ("option parsing failed\n");
        g_strfreev (file_array);
        return 1;
    }

    res = g_file_get_contents(file_path, (gchar**) &time, &length, &error);
    if (!res)
    {
        g_printerr("Error when reading %s: %s\n", file_path, error->message);
        ret = 1;
    }
    else if (length != sizeof(gint64))
    {
        g_printerr("Error when reading %s: bad read length\n",file_path);
        ret = 1;
    }
    else
    {
        dateTime = g_date_time_new_from_unix_local(*time);
        if (dateTime)
        {
            timeString = g_date_time_format(dateTime,
                    "timestamp %s %FT%H:%M:%S%:::z");

            g_print("Last time: %s\n", timeString);
        }
        else
        {
            g_printerr("Error when reading %s: bad format\n",file_path);
            ret = 1;
        }
    }
    if (time)
    {
        g_free(time);
    }
    if (error)
    {
        g_error_free(error);
    }
    if(dateTime)
    {
        g_date_time_unref(dateTime);
    }
    if (timeString)
    {
        g_free(timeString);
    }
    g_strfreev (file_array);
    return ret;
}
