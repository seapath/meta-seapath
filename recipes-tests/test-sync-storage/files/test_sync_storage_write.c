/*
 * Copyright (C) 2020, RTE (http://www.rte-france.com)
 * This program is distributed under the Apache 2 license.
*/

#include <glib-unix.h>
#include <glib.h>
#include <glib/gstdio.h>

static GMainLoop* mainloop;

gboolean period_write(gpointer data);

gboolean exit_callback(gpointer data);

int main(int argc, char* argv[])
{
    guint periode_ms = 1000;
    gchar* file_path = NULL;
    gchar** file_array = NULL;
    GMainContext* context = NULL;
    GError* error = NULL;
    GOptionContext* optionContext;
    GOptionEntry entries[] = {
        {
            "periode_ms",
            'p',
            0,
            G_OPTION_ARG_INT,
            &periode_ms,
            "Period in ms",
            ""
        },
        {
            G_OPTION_REMAINING,
            0,
            0,
            G_OPTION_ARG_FILENAME_ARRAY,
            &file_array,
            NULL,
            NULL
        },
        { 0 }
    };
    optionContext = g_option_context_new("file_path");
    g_option_context_add_main_entries(optionContext, entries, NULL);
    if (!g_option_context_parse(optionContext, &argc, &argv, &error)) {
        g_printerr("option parsing failed: %s\n", error->message);
        if (error)
            g_error_free(error);
        g_option_context_free(optionContext);
        return 1;
    }
    g_option_context_free(optionContext);
    if (!file_array) {
        g_printerr("option parsing failed no path given\n");
        return 1;
    }
    file_path = file_array[0];
    if (!file_path) {
        g_printerr("option parsing failed no path given\n");
        g_strfreev(file_array);
        return 1;
    }

    if (periode_ms <= 0) {
        g_printerr("Bad period\n");
        g_strfreev(file_array);
        return 1;
    }
    g_print("Launch with a period of %u ms. CTRL+C to stop\n", periode_ms);
    mainloop = g_main_loop_new(context, FALSE);
    g_timeout_add(periode_ms, period_write, file_path);
    g_unix_signal_add(SIGINT, exit_callback, NULL);
    g_unix_signal_add(SIGTERM, exit_callback, NULL);
    g_main_loop_run(mainloop);
    g_print("Exiting\n");
    g_main_loop_unref(mainloop);
    g_strfreev(file_array);
    return 0;
}

gboolean period_write(gpointer data)
{
    gboolean res;
    GError* error = NULL;
    gint64 current_time;
    GDateTime* dateTime = NULL;
    gchar* file_path = (gchar*) data;
    dateTime = g_date_time_new_now_utc();
    current_time = g_date_time_to_unix(dateTime);
    g_print("%ld\n", current_time);
    res = g_file_set_contents(
        file_path, (const gchar*)&current_time, sizeof(gint64), &error);
    if (!res) {
        g_printerr("Error when writting %s: %s\n",file_path, error->message);
        g_error_free(error);
        g_main_loop_quit(mainloop);
        return G_SOURCE_REMOVE;
    }
    if (error) {
        g_error_free(error);
    }
    if (dateTime) {
        g_date_time_unref(dateTime);
    }
    return G_SOURCE_CONTINUE;
}

gboolean exit_callback(gpointer data)
{
    (void)data;
    g_main_loop_quit(mainloop);
    return G_SOURCE_REMOVE;
}
