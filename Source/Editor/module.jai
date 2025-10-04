#module_parameters(Import_Mode := ImportMode.Foreign) {
    ImportMode :: enum {
        Foreign;
        Main;
    }
}

#import "Core";
#import "Game";
#import "Renderer";

#import "Common";
#import "Linalg";
#import "String";
#import "Compiler";
#import "Type_Utils";

#if Import_Mode == .Foreign {
    #load "module_api.jai";
} else {
    #load "main.jai";
}
