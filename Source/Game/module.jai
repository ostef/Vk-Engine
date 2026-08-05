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
#import "String";
#import "Compiler";
#import "Type_Utils";
#import "File";
#import "File_Utilities";

#load "world.public.jai";
#load "entity.public.jai";
#load "component.public.jai";
#load "graphics.public.jai";
#load "physics.public.jai";
#load "misc.public.jai";

#if Import_Mode == .Foreign {
    #load "module_api.public.jai";
} else {
    #load "main.jai";
}
