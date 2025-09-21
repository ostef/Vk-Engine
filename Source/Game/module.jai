#module_parameters(Import_Mode := ImportMode.Foreign) {
    ImportMode :: enum {
        Foreign;
        Main;
    }
}

#import "Core";
#import "Renderer";

#import "Common";
#import "Linalg";
#import "Hash_Map";
#import "Paged_Array";
#import "Random";
#import "Remap_Context"(VERBOSE=false);
#import "String";
#import "Compiler";
#import "Type_Utils";
#import "File";
#import "File_Utilities";

#load "API/world.jai";
#load "API/entity.jai";
#load "API/component.jai";

#if Import_Mode == .Foreign {
    #load "module_api.jai";
} else {
    #load "main.jai";
}
