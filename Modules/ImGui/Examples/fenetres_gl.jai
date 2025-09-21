#import "Basic";
#import "GL";
Fenetres :: #import "Fenetres";
Fenetres_GL :: #import "Fenetres/GL";
ImGui :: #import "ImGui";
ImGui_Fenetres :: #import "ImGui/Impl/Fenetres";
ImGui_GL :: #import "ImGui/Impl/GL";

main :: ()
{
    Fenetres_GL.LoadGL();

    window := Fenetres.CreateWindow("ImGui Fenetres GL", 1600, 900, 100, 100);
    defer Fenetres.DestroyWindow(window);

    gl_ctx := Fenetres_GL.CreateContext(window);
    defer Fenetres_GL.DestroyContext(gl_ctx);

    assert(glShaderSource != null);

    ImGui.CreateContext();
    defer ImGui.DestroyContext();

    io := ImGui.GetIO();
    io.ConfigFlags_ |= .NavEnableKeyboard;
    io.ConfigFlags_ |= .DockingEnable;
    // io.ConfigFlags_ |= .ViewportsEnable;

    ImGui_Fenetres.InitForGL(window, gl_ctx);
    defer ImGui_Fenetres.Terminate();

    if !ImGui_GL.Init()
    {
        log_error("Could not initialize ImGui GL backend");
        exit(1);
    }

    defer ImGui_GL.Terminate();

    delta_time := 1 / 60.0;
    quit := false;
    while !quit
    {
        frame_start := current_time_monotonic();
        defer {
            frame_time := current_time_monotonic() - frame_start;
            delta_time = cast(float) to_float64_seconds(frame_time);
        }

        reset_temporary_storage();

        for Fenetres.PollMessages()
        {
            ImGui_Fenetres.HandleWindowMessage(it, false);

            if it.kind == .Window_Closed && it.window == window
                quit = true;
        }

        ImGui_Fenetres.NewFrame(delta_time, true);
        ImGui.NewFrame();
        ImGui.ShowDemoWindow();
        ImGui.Render();

        imgui_io := ImGui.GetIO();

        if imgui_io.ConfigFlags_ & .ViewportsEnable
        {
            backup_current_window := Fenetres_GL.GetCurrentWindow();
            backup_current_context := Fenetres_GL.GetCurrentContext();

            ImGui.UpdatePlatformWindows();
            ImGui.RenderPlatformWindowsDefault();

            Fenetres_GL.MakeCurrent(backup_current_window, backup_current_context);
        }

        width, height := Fenetres.GetViewportSizeInPixels(window);
        glViewport(0, 0, xx width, xx height);
        glClearColor(0, 0, 0, 1);
        glClear(GL_COLOR_BUFFER_BIT);

        ImGui_GL.RenderDrawData(ImGui.GetDrawData());

        Fenetres_GL.SwapBuffers(window);
    }
}
