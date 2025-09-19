#module_parameters(Import_Mode := ModuleImportMode.API) {
    ModuleImportMode :: enum {
        API;
        Metaprogram;
        Program;
    }
}

#if Import_Mode == {
case .API;
    #load "module_api.jai";
    #load "api.jai";
case .Metaprogram;
    #load "build.jai";
case .Program;
    #load "main.jai";
}
