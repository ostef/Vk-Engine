Jolt :: #import "JoltPhysics";

Log_Physics :: Log_Section.{name="Physics"};

InitJolt :: () {
    LogSectionScope(*Log_Physics);

    LogMessage("Jolt version ID: %\n", FormatInt.{value=Jolt.GetJoltVersionID(), base=16});

    Jolt.CheckVersionID();
    Jolt.RegisterDefaultAllocator();
    Jolt.RegisterDefaultTraceHandler();
    #if Jolt.ENABLE_ASSERTS {
        Jolt.RegisterDefaultAssertFailedHandler();
    }

    Jolt.CreateFactory();

    Jolt.RegisterTypes();

    LogMessage("Initialized Jolt");
}

ShutdownJolt :: () {
    LogSectionScope(*Log_Physics);

    Jolt.UnregisterTypes();
    Jolt.DestroyFactory();

    LogMessage("Shut down Jolt");
}
