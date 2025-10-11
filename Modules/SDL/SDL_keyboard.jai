// SDL_keyboard.h

/*
SDL_Scancode :: enum s32 {
    Unknown :: 0;

    A :: 4;
    B :: 5;
    C :: 6;
    D :: 7;
    E :: 8;
    F :: 9;
    G :: 10;
    H :: 11;
    I :: 12;
    J :: 13;
    K :: 14;
    L :: 15;
    M :: 16;
    N :: 17;
    O :: 18;
    P :: 19;
    Q :: 20;
    R :: 21;
    S :: 22;
    T :: 23;
    U :: 24;
    V :: 25;
    W :: 26;
    X :: 27;
    Y :: 28;
    Z :: 29;

    // Number row
    Nr1 :: 30;
    Nr2 :: 31;
    Nr3 :: 32;
    Nr4 :: 33;
    Nr5 :: 34;
    Nr6 :: 35;
    Nr7 :: 36;
    Nr8 :: 37;
    Nr9 :: 38;
    Nr0 :: 39;

    Return :: 40;
    Escape :: 41;
    Backspace :: 42;
    Tab :: 43;
    Space :: 44;

    Minus :: 45;
    Equals :: 46;
    Leftbracket :: 47;
    Rightbracket :: 48;
    Backslash :: 49;
    Nonushash :: 50; // ??;
    Semicolon :: 51;
    Apostrophe :: 52;
    Grave :: 53;
    Comma :: 54;
    Period :: 55;
    Slash :: 56;

    Caps_Lock :: 57;

    F1 :: 58;
    F2 :: 59;
    F3 :: 60;
    F4 :: 61;
    F5 :: 62;
    F6 :: 63;
    F7 :: 64;
    F8 :: 65;
    F9 :: 66;
    F10 :: 67;
    F11 :: 68;
    F12 :: 69;

    Print_Screen :: 70;
    Scroll_Lock :: 71;
    Pause :: 72;
    Insert :: 73;
    Home :: 74;
    Page_Up :: 75;
    Delete :: 76;
    End :: 77;
    Page_Down :: 78;
    Right :: 79;
    Left :: 80;
    Down :: 81;
    Up :: 82;

    Num_Lock_Clear :: 83;
    Kp_Divide :: 84;
    Kp_Multiply :: 85;
    Kp_Minus :: 86;
    Kp_Plus :: 87;
    Kp_Enter :: 88;
    Kp_1 :: 89;
    Kp_2 :: 90;
    Kp_3 :: 91;
    Kp_4 :: 92;
    Kp_5 :: 93;
    Kp_6 :: 94;
    Kp_7 :: 95;
    Kp_8 :: 96;
    Kp_9 :: 97;
    Kp_0 :: 98;
    Kp_Period :: 99;

    Non_US_Backslash :: 100;
    Application :: 101;
    Power :: 102;
    Kp_Equals :: 103;
    F13 :: 104;
    F14 :: 105;
    F15 :: 106;
    F16 :: 107;
    F17 :: 108;
    F18 :: 109;
    F19 :: 110;
    F20 :: 111;
    F21 :: 112;
    F22 :: 113;
    F23 :: 114;
    F24 :: 115;
    Execute :: 116;
    Help :: 117;
    Menu :: 118;
    Select :: 119;
    Stop :: 120;
    Again :: 121;
    Undo :: 122;
    Cut :: 123;
    Copy :: 124;
    Paste :: 125;
    Find :: 126;
    Mute :: 127;
    Volume_Up :: 128;
    Volume_Down :: 129;
    Kp_Comma :: 133;
    Kp_Equals_AS400 :: 134;

    International1 :: 135;
    International2 :: 136;
    International3 :: 137;
    International4 :: 138;
    International5 :: 139;
    International6 :: 140;
    International7 :: 141;
    International8 :: 142;
    International9 :: 143;
    Lang1 :: 144;
    Lang2 :: 145;
    Lang3 :: 146;
    Lang4 :: 147;
    Lang5 :: 148;
    Lang6 :: 149;
    Lang7 :: 150;
    Lang8 :: 151;
    Lang9 :: 152;

    Alt_Erase :: 153;
    Sys_Req :: 154;
    Cancel :: 155;
    Clear :: 156;
    Prior :: 157;
    Return2 :: 158;
    Separator :: 159;
    Out :: 160;
    Oper :: 161;
    Clear_Again :: 162;
    Cr_Sel :: 163;
    Ex_Sel :: 164;

    Kp_00 :: 176;
    Kp_000 :: 177;
    Thousands_Separator :: 178;
    Decimal_Separator :: 179;
    Currency_Unit :: 180;
    Currency_Sub_Unit :: 181;
    Kp_Left_Paren :: 182;
    Kp_Right_Paren :: 183;
    Kp_Left_Brace :: 184;
    Kp_Right_Brace :: 185;
    Kp_Tab :: 186;
    Kp_Backspace :: 187;
    Kp_A :: 188;
    Kp_B :: 189;
    Kp_C :: 190;
    Kp_D :: 191;
    Kp_E :: 192;
    Kp_F :: 193;
    Kp_Xor :: 194;
    Kp_Power :: 195;
    Kp_Percent :: 196;
    Kp_Less :: 197;
    Kp_Greater :: 198;
    Kp_Ampersand :: 199;
    Kp_Dbl_Ampersand :: 200;
    Kp_Vertical_Bar :: 201;
    Kp_Dbl_Vertical_Bar :: 202;
    Kp_Colon :: 203;
    Kp_Hash :: 204;
    Kp_Space :: 205;
    Kp_At :: 206;
    Kp_Exclam :: 207;
    Kp_Mem_Store :: 208;
    Kp_Mem_Recall :: 209;
    Kp_Mem_Clear :: 210;
    Kp_Mem_Add :: 211;
    Kp_Mem_Subtract :: 212;
    Kp_Mem_Multiply :: 213;
    Kp_Mem_Divide :: 214;
    Kp_Plus_Minus :: 215;
    Kp_Clear :: 216;
    Kp_Clear_Entry :: 217;
    Kp_Binary :: 218;
    Kp_Octal :: 219;
    Kp_Decimal :: 220;
    Kp_Hexadecimal :: 221;

    LCtrl :: 224;
    LShift :: 225;
    LAlt :: 226;
    LGui :: 227;
    RCtrl :: 228;
    RShift :: 229;
    RAlt :: 230;
    RGui :: 231;

    Mode :: 257;

    Audio_Next :: 258;
    Audio_Prev :: 259;
    Audio_Stop :: 260;
    Audio_Play :: 261;
    Audio_Mute :: 262;
    Media_Select :: 263;
    WWW :: 264;
    Mail :: 265;
    Calculator :: 266;
    Computer :: 267;
    Ac_Search :: 268;
    Ac_Home :: 269;
    Ac_Back :: 270;
    Ac_Forward :: 271;
    Ac_Stop :: 272;
    Ac_Refresh :: 273;
    Ac_Bookmarks :: 274;

    Brightness_Down :: 275;
    Brightness_Up :: 276;
    Display_Switch :: 277;
    Kb_Dillum_Toggle :: 278;
    Kb_Dillum_Down :: 279;
    Kb_Dillum_Up :: 280;
    Eject :: 281;
    Sleep :: 282;

    App1 :: 283;
    App2 :: 284;

    Num_Scancodes :: 512;
}
*/

//SDLK_SCANCODE_MASK :: 1 << 30;
SDL_SCANCODE_TO_KEYCODE :: inline (scancode: SDL_Scancode) -> s32 {
    //return scancode | SDLK_SCANCODE_MASK;
    return (cast(s32)scancode) | (1 << 30);
} 

Hack :: struct {
    // This is a @Temporary hack to get around the circular dependency thing that
    // is happening with #run and overloads if you just call SDL_SCANCODE_TO_KEYCODE.
    // I need to do something to resolve this. My only idea so far is to have name-inclusion
    // be a separate phase from typechecking. (Right now we wait on something being inferred
    // to kick off a 'using', but this is not necessary if we know all the names and can
    // just insert import_links to them, and then we wait for those import links to typecheck.)

    K :: inline (scancode: SDL_Scancode) -> s32 {
        //return scancode | SDLK_SCANCODE_MASK;
        return (cast(s32)scancode) | (1 << 30);
    } 
}
    

using SDL_Keycode :: enum s32 {
    SDLK_UNKNOWN :: 0;

    SDLK_RETURN :: #char "\r";
    SDLK_ESCAPE :: 27; // 0o33
    SDLK_BACKSPACE :: 8; // '\b';
    SDLK_TAB :: #char "\t";
    SDLK_SPACE :: #char " ";
    SDLK_EXCLAIM :: #char "!";
    SDLK_QUOTEDBL ::  #char "\"";
    SDLK_HASH :: #char "#";
    SDLK_PERCENT :: #char "%";
    SDLK_DOLLAR :: #char "$";
    SDLK_AMPERSAND :: #char "&";
    SDLK_QUOTE :: #char "'";
    SDLK_LEFTPAREN :: #char "(";
    SDLK_RIGHTPAREN :: #char ")";
    SDLK_ASTERISK :: #char "*";
    SDLK_PLUS :: #char "+";
    SDLK_COMMA :: #char ",";
    SDLK_MINUS :: #char "-";
    SDLK_PERIOD :: #char ".";
    SDLK_SLASH :: #char "/";
    SDLK_0 :: #char "0";
    SDLK_1 :: #char "1";
    SDLK_2 :: #char "2";
    SDLK_3 :: #char "3";
    SDLK_4 :: #char "4";
    SDLK_5 :: #char "5";
    SDLK_6 :: #char "6";
    SDLK_7 :: #char "7";
    SDLK_8 :: #char "8";
    SDLK_9 :: #char "9";
    SDLK_COLON :: #char ":";
    SDLK_SEMICOLON :: #char ";";
    SDLK_LESS :: #char "<";
    SDLK_EQUALS :: #char "=";
    SDLK_GREATER :: #char ">";
    SDLK_QUESTION :: #char "?";
    SDLK_AT :: #char "@";
    /*
       Skip uppercase letters
     */
    SDLK_LEFTBRACKET :: #char "[";
    SDLK_BACKSLASH :: #char "\\";
    SDLK_RIGHTBRACKET :: #char "]";
    SDLK_CARET :: #char "^";
    SDLK_UNDERSCORE :: #char "_";
    SDLK_BACKQUOTE :: #char "`";
    SDLK_a :: #char "a";
    SDLK_b :: #char "b";
    SDLK_c :: #char "c";
    SDLK_d :: #char "d";
    SDLK_e :: #char "e";
    SDLK_f :: #char "f";
    SDLK_g :: #char "g";
    SDLK_h :: #char "h";
    SDLK_i :: #char "i";
    SDLK_j :: #char "j";
    SDLK_k :: #char "k";
    SDLK_l :: #char "l";
    SDLK_m :: #char "m";
    SDLK_n :: #char "n";
    SDLK_o :: #char "o";
    SDLK_p :: #char "p";
    SDLK_q :: #char "q";
    SDLK_r :: #char "r";
    SDLK_s :: #char "s";
    SDLK_t :: #char "t";
    SDLK_u :: #char "u";
    SDLK_v :: #char "v";
    SDLK_w :: #char "w";
    SDLK_x :: #char "x";
    SDLK_y :: #char "y";
    SDLK_z :: #char "z";

    SDLK_SCANCODE_MASK :: 1 << 30;

    //
    // Note: All this #run SDL_SCANCODE_TO_KEYCODE is crazy in terms of
    // expense required to do simple things. Eventually we will probably be
    // able to substitute a macro here (when we have macros) but that will
    // still be perhaps a bit more expensive than I'd like.
    //

    SDLK_CAPSLOCK :: #run Hack.K(SDL_SCANCODE_CAPSLOCK);

    SDLK_F1 :: #run Hack.K(SDL_SCANCODE_F1);
    SDLK_F2 :: #run Hack.K(SDL_SCANCODE_F2);
    SDLK_F3 :: #run Hack.K(SDL_SCANCODE_F3);
    SDLK_F4 :: #run Hack.K(SDL_SCANCODE_F4);
    SDLK_F5 :: #run Hack.K(SDL_SCANCODE_F5);
    SDLK_F6 :: #run Hack.K(SDL_SCANCODE_F6);
    SDLK_F7 :: #run Hack.K(SDL_SCANCODE_F7);
    SDLK_F8 :: #run Hack.K(SDL_SCANCODE_F8);
    SDLK_F9 :: #run Hack.K(SDL_SCANCODE_F9);
    SDLK_F10 :: #run Hack.K(SDL_SCANCODE_F10);
    SDLK_F11 :: #run Hack.K(SDL_SCANCODE_F11);
    SDLK_F12 :: #run Hack.K(SDL_SCANCODE_F12);

    SDLK_PRINTSCREEN :: #run Hack.K(SDL_SCANCODE_PRINTSCREEN);
    SDLK_SCROLLLOCK :: #run Hack.K(SDL_SCANCODE_SCROLLLOCK);
    SDLK_PAUSE :: #run Hack.K(SDL_SCANCODE_PAUSE);
    SDLK_INSERT :: #run Hack.K(SDL_SCANCODE_INSERT);
    SDLK_HOME :: #run Hack.K(SDL_SCANCODE_HOME);
    SDLK_PAGEUP :: #run Hack.K(SDL_SCANCODE_PAGEUP);
    SDLK_DELETE :: 127;// #run Hack.K(SDL_SCANCODE_DELETE); // 177? @@ Why is this one different ???
    SDLK_END :: #run Hack.K(SDL_SCANCODE_END);
    SDLK_PAGEDOWN :: #run Hack.K(SDL_SCANCODE_PAGEDOWN);
    SDLK_RIGHT :: #run Hack.K(SDL_SCANCODE_RIGHT);
    SDLK_LEFT :: #run Hack.K(SDL_SCANCODE_LEFT);
    SDLK_DOWN :: #run Hack.K(SDL_SCANCODE_DOWN);
    SDLK_UP :: #run Hack.K(SDL_SCANCODE_UP);


    SDLK_NUMLOCKCLEAR :: #run Hack.K(SDL_SCANCODE_NUMLOCKCLEAR);
    SDLK_KP_DIVIDE :: #run Hack.K(SDL_SCANCODE_KP_DIVIDE);
    SDLK_KP_MULTIPLY :: #run Hack.K(SDL_SCANCODE_KP_MULTIPLY);
    SDLK_KP_MINUS :: #run Hack.K(SDL_SCANCODE_KP_MINUS);
    SDLK_KP_PLUS :: #run Hack.K(SDL_SCANCODE_KP_PLUS);
    SDLK_KP_ENTER :: #run Hack.K(SDL_SCANCODE_KP_ENTER);
    SDLK_KP_1 :: #run Hack.K(SDL_SCANCODE_KP_1);
    SDLK_KP_2 :: #run Hack.K(SDL_SCANCODE_KP_2);
    SDLK_KP_3 :: #run Hack.K(SDL_SCANCODE_KP_3);
    SDLK_KP_4 :: #run Hack.K(SDL_SCANCODE_KP_4);
    SDLK_KP_5 :: #run Hack.K(SDL_SCANCODE_KP_5);
    SDLK_KP_6 :: #run Hack.K(SDL_SCANCODE_KP_6);
    SDLK_KP_7 :: #run Hack.K(SDL_SCANCODE_KP_7);
    SDLK_KP_8 :: #run Hack.K(SDL_SCANCODE_KP_8);
    SDLK_KP_9 :: #run Hack.K(SDL_SCANCODE_KP_9);
    SDLK_KP_0 :: #run Hack.K(SDL_SCANCODE_KP_0);
    SDLK_KP_PERIOD :: #run Hack.K(SDL_SCANCODE_KP_PERIOD);

    SDLK_APPLICATION :: #run Hack.K(SDL_SCANCODE_APPLICATION);
    SDLK_POWER :: #run Hack.K(SDL_SCANCODE_POWER);
    SDLK_KP_EQUALS :: #run Hack.K(SDL_SCANCODE_KP_EQUALS);
    SDLK_F13 :: #run Hack.K(SDL_SCANCODE_F13);
    SDLK_F14 :: #run Hack.K(SDL_SCANCODE_F14);
    SDLK_F15 :: #run Hack.K(SDL_SCANCODE_F15);
    SDLK_F16 :: #run Hack.K(SDL_SCANCODE_F16);
    SDLK_F17 :: #run Hack.K(SDL_SCANCODE_F17);
    SDLK_F18 :: #run Hack.K(SDL_SCANCODE_F18);
    SDLK_F19 :: #run Hack.K(SDL_SCANCODE_F19);
    SDLK_F20 :: #run Hack.K(SDL_SCANCODE_F20);
    SDLK_F21 :: #run Hack.K(SDL_SCANCODE_F21);
    SDLK_F22 :: #run Hack.K(SDL_SCANCODE_F22);
    SDLK_F23 :: #run Hack.K(SDL_SCANCODE_F23);
    SDLK_F24 :: #run Hack.K(SDL_SCANCODE_F24);
    SDLK_EXECUTE :: #run Hack.K(SDL_SCANCODE_EXECUTE);
    SDLK_HELP :: #run Hack.K(SDL_SCANCODE_HELP);
    SDLK_MENU :: #run Hack.K(SDL_SCANCODE_MENU);
    SDLK_SELECT :: #run Hack.K(SDL_SCANCODE_SELECT);
    SDLK_STOP :: #run Hack.K(SDL_SCANCODE_STOP);
    SDLK_AGAIN :: #run Hack.K(SDL_SCANCODE_AGAIN);
    SDLK_UNDO :: #run Hack.K(SDL_SCANCODE_UNDO);
    SDLK_CUT :: #run Hack.K(SDL_SCANCODE_CUT);
    SDLK_COPY :: #run Hack.K(SDL_SCANCODE_COPY);
    SDLK_PASTE :: #run Hack.K(SDL_SCANCODE_PASTE);
    SDLK_FIND :: #run Hack.K(SDL_SCANCODE_FIND);
    SDLK_MUTE :: #run Hack.K(SDL_SCANCODE_MUTE);
    SDLK_VOLUMEUP :: #run Hack.K(SDL_SCANCODE_VOLUMEUP);
    SDLK_VOLUMEDOWN :: #run Hack.K(SDL_SCANCODE_VOLUMEDOWN);
    SDLK_KP_COMMA :: #run Hack.K(SDL_SCANCODE_KP_COMMA);
    SDLK_KP_EQUALSAS400 :: #run Hack.K(SDL_SCANCODE_KP_EQUALSAS400);

    SDLK_ALTERASE :: #run Hack.K(SDL_SCANCODE_ALTERASE);
    SDLK_SYSREQ :: #run Hack.K(SDL_SCANCODE_SYSREQ);
    SDLK_CANCEL :: #run Hack.K(SDL_SCANCODE_CANCEL);
    SDLK_CLEAR :: #run Hack.K(SDL_SCANCODE_CLEAR);
    SDLK_PRIOR :: #run Hack.K(SDL_SCANCODE_PRIOR);
    SDLK_RETURN2 :: #run Hack.K(SDL_SCANCODE_RETURN2);
    SDLK_SEPARATOR :: #run Hack.K(SDL_SCANCODE_SEPARATOR);
    SDLK_OUT :: #run Hack.K(SDL_SCANCODE_OUT);
    SDLK_OPER :: #run Hack.K(SDL_SCANCODE_OPER);
    SDLK_CLEARAGAIN :: #run Hack.K(SDL_SCANCODE_CLEARAGAIN);
    SDLK_CRSEL :: #run Hack.K(SDL_SCANCODE_CRSEL);
    SDLK_EXSEL :: #run Hack.K(SDL_SCANCODE_EXSEL);

    SDLK_KP_00 :: #run Hack.K(SDL_SCANCODE_KP_00);
    SDLK_KP_000 :: #run Hack.K(SDL_SCANCODE_KP_000);
    SDLK_THOUSANDSSEPARATOR :: #run Hack.K(SDL_SCANCODE_THOUSANDSSEPARATOR);
    SDLK_DECIMALSEPARATOR :: #run Hack.K(SDL_SCANCODE_DECIMALSEPARATOR);
    SDLK_CURRENCYUNIT :: #run Hack.K(SDL_SCANCODE_CURRENCYUNIT);
    SDLK_CURRENCYSUBUNIT :: #run Hack.K(SDL_SCANCODE_CURRENCYSUBUNIT);
    SDLK_KP_LEFTPAREN :: #run Hack.K(SDL_SCANCODE_KP_LEFTPAREN);
    SDLK_KP_RIGHTPAREN :: #run Hack.K(SDL_SCANCODE_KP_RIGHTPAREN);
    SDLK_KP_LEFTBRACE :: #run Hack.K(SDL_SCANCODE_KP_LEFTBRACE);
    SDLK_KP_RIGHTBRACE :: #run Hack.K(SDL_SCANCODE_KP_RIGHTBRACE);
    SDLK_KP_TAB :: #run Hack.K(SDL_SCANCODE_KP_TAB);
    SDLK_KP_BACKSPACE :: #run Hack.K(SDL_SCANCODE_KP_BACKSPACE);
    SDLK_KP_A :: #run Hack.K(SDL_SCANCODE_KP_A);
    SDLK_KP_B :: #run Hack.K(SDL_SCANCODE_KP_B);
    SDLK_KP_C :: #run Hack.K(SDL_SCANCODE_KP_C);
    SDLK_KP_D :: #run Hack.K(SDL_SCANCODE_KP_D);
    SDLK_KP_E :: #run Hack.K(SDL_SCANCODE_KP_E);
    SDLK_KP_F :: #run Hack.K(SDL_SCANCODE_KP_F);
    SDLK_KP_XOR :: #run Hack.K(SDL_SCANCODE_KP_XOR);
    SDLK_KP_POWER :: #run Hack.K(SDL_SCANCODE_KP_POWER);
    SDLK_KP_PERCENT :: #run Hack.K(SDL_SCANCODE_KP_PERCENT);
    SDLK_KP_LESS :: #run Hack.K(SDL_SCANCODE_KP_LESS);
    SDLK_KP_GREATER :: #run Hack.K(SDL_SCANCODE_KP_GREATER);
    SDLK_KP_AMPERSAND :: #run Hack.K(SDL_SCANCODE_KP_AMPERSAND);
    SDLK_KP_DBLAMPERSAND :: #run Hack.K(SDL_SCANCODE_KP_DBLAMPERSAND);
    SDLK_KP_VERTICALBAR :: #run Hack.K(SDL_SCANCODE_KP_VERTICALBAR);
    SDLK_KP_DBLVERTICALBAR :: #run Hack.K(SDL_SCANCODE_KP_DBLVERTICALBAR);
    SDLK_KP_COLON :: #run Hack.K(SDL_SCANCODE_KP_COLON);
    SDLK_KP_HASH :: #run Hack.K(SDL_SCANCODE_KP_HASH);
    SDLK_KP_SPACE :: #run Hack.K(SDL_SCANCODE_KP_SPACE);
    SDLK_KP_AT :: #run Hack.K(SDL_SCANCODE_KP_AT);
    SDLK_KP_EXCLAM :: #run Hack.K(SDL_SCANCODE_KP_EXCLAM);
    SDLK_KP_MEMSTORE :: #run Hack.K(SDL_SCANCODE_KP_MEMSTORE);
    SDLK_KP_MEMRECALL :: #run Hack.K(SDL_SCANCODE_KP_MEMRECALL);
    SDLK_KP_MEMCLEAR :: #run Hack.K(SDL_SCANCODE_KP_MEMCLEAR);
    SDLK_KP_MEMADD :: #run Hack.K(SDL_SCANCODE_KP_MEMADD);
    SDLK_KP_MEMSUBTRACT :: #run Hack.K(SDL_SCANCODE_KP_MEMSUBTRACT);
    SDLK_KP_MEMMULTIPLY :: #run Hack.K(SDL_SCANCODE_KP_MEMMULTIPLY);
    SDLK_KP_MEMDIVIDE :: #run Hack.K(SDL_SCANCODE_KP_MEMDIVIDE);
    SDLK_KP_PLUSMINUS :: #run Hack.K(SDL_SCANCODE_KP_PLUSMINUS);
    SDLK_KP_CLEAR :: #run Hack.K(SDL_SCANCODE_KP_CLEAR);
    SDLK_KP_CLEARENTRY :: #run Hack.K(SDL_SCANCODE_KP_CLEARENTRY);
    SDLK_KP_BINARY :: #run Hack.K(SDL_SCANCODE_KP_BINARY);
    SDLK_KP_OCTAL :: #run Hack.K(SDL_SCANCODE_KP_OCTAL);
    SDLK_KP_DECIMAL :: #run Hack.K(SDL_SCANCODE_KP_DECIMAL);
    SDLK_KP_HEXADECIMAL :: #run Hack.K(SDL_SCANCODE_KP_HEXADECIMAL);

    SDLK_LCTRL :: #run Hack.K(SDL_SCANCODE_LCTRL);
    SDLK_LSHIFT :: #run Hack.K(SDL_SCANCODE_LSHIFT);
    SDLK_LALT :: #run Hack.K(SDL_SCANCODE_LALT);
    SDLK_LGUI :: #run Hack.K(SDL_SCANCODE_LGUI);
    SDLK_RCTRL :: #run Hack.K(SDL_SCANCODE_RCTRL);
    SDLK_RSHIFT :: #run Hack.K(SDL_SCANCODE_RSHIFT);
    SDLK_RALT :: #run Hack.K(SDL_SCANCODE_RALT);
    SDLK_RGUI :: #run Hack.K(SDL_SCANCODE_RGUI);

    SDLK_MODE :: #run Hack.K(SDL_SCANCODE_MODE);

    SDLK_AUDIONEXT :: #run Hack.K(SDL_SCANCODE_AUDIONEXT);
    SDLK_AUDIOPREV :: #run Hack.K(SDL_SCANCODE_AUDIOPREV);
    SDLK_AUDIOSTOP :: #run Hack.K(SDL_SCANCODE_AUDIOSTOP);
    SDLK_AUDIOPLAY :: #run Hack.K(SDL_SCANCODE_AUDIOPLAY);
    SDLK_AUDIOMUTE :: #run Hack.K(SDL_SCANCODE_AUDIOMUTE);
    SDLK_MEDIASELECT :: #run Hack.K(SDL_SCANCODE_MEDIASELECT);
    SDLK_WWW :: #run Hack.K(SDL_SCANCODE_WWW);
    SDLK_MAIL :: #run Hack.K(SDL_SCANCODE_MAIL);
    SDLK_CALCULATOR :: #run Hack.K(SDL_SCANCODE_CALCULATOR);
    SDLK_COMPUTER :: #run Hack.K(SDL_SCANCODE_COMPUTER);
    SDLK_AC_SEARCH :: #run Hack.K(SDL_SCANCODE_AC_SEARCH);
    SDLK_AC_HOME :: #run Hack.K(SDL_SCANCODE_AC_HOME);
    SDLK_AC_BACK :: #run Hack.K(SDL_SCANCODE_AC_BACK);
    SDLK_AC_FORWARD :: #run Hack.K(SDL_SCANCODE_AC_FORWARD);
    SDLK_AC_STOP :: #run Hack.K(SDL_SCANCODE_AC_STOP);
    SDLK_AC_REFRESH :: #run Hack.K(SDL_SCANCODE_AC_REFRESH);
    SDLK_AC_BOOKMARKS :: #run Hack.K(SDL_SCANCODE_AC_BOOKMARKS);

    SDLK_BRIGHTNESSDOWN :: #run Hack.K(SDL_SCANCODE_BRIGHTNESSDOWN);
    SDLK_BRIGHTNESSUP :: #run Hack.K(SDL_SCANCODE_BRIGHTNESSUP);
    SDLK_DISPLAYSWITCH :: #run Hack.K(SDL_SCANCODE_DISPLAYSWITCH);
    SDLK_KBDILLUMTOGGLE :: #run Hack.K(SDL_SCANCODE_KBDILLUMTOGGLE);
    SDLK_KBDILLUMDOWN :: #run Hack.K(SDL_SCANCODE_KBDILLUMDOWN);
    SDLK_KBDILLUMUP :: #run Hack.K(SDL_SCANCODE_KBDILLUMUP);
    SDLK_EJECT :: #run Hack.K(SDL_SCANCODE_EJECT);
    SDLK_SLEEP :: #run Hack.K(SDL_SCANCODE_SLEEP);
    SDLK_APP1 :: #run Hack.K(SDL_SCANCODE_APP1);
    SDLK_APP2 :: #run Hack.K(SDL_SCANCODE_APP2);

    //SDLK_AUDIOREWIND :: #run Hack.K(SDL_SCANCODE_AUDIOREWIND);
    //SDLK_AUDIOFASTFORWARD :: #run Hack.K(SDL_SCANCODE_AUDIOFASTFORWARD);
}

using SDL_Keymod :: enum u16 {
    KMOD_NONE :: 0x0000;
    KMOD_LSHIFT :: 0x0001;
    KMOD_RSHIFT :: 0x0002;
    KMOD_SHIFT :: KMOD_LSHIFT|KMOD_RSHIFT;
    KMOD_LCTRL :: 0x0040;
    KMOD_RCTRL :: 0x0080;
    KMOD_CTRL :: KMOD_LCTRL|KMOD_RCTRL;
    KMOD_LALT :: 0x0100;
    KMOD_RALT :: 0x0200;
    KMOD_ALT :: KMOD_LALT|KMOD_RALT;
    KMOD_LGUI :: 0x0400;
    KMOD_RGUI :: 0x0800;
    KMOD_GUI :: KMOD_LGUI|KMOD_RGUI;
    KMOD_NUM :: 0x1000;
    KMOD_CAPS :: 0x2000;
    KMOD_MODE :: 0x4000;
    KMOD_RESERVED :: 0x8000;
}



SDL_Keysym :: struct {
    scancode: SDL_Scancode;     // SDL physical key code - see ::SDL_Scancode for details 
    sym: SDL_Keycode;           // SDL virtual key code - see ::SDL_Keycode for details 
    mod: SDL_Keymod;            // current key modifiers 
    unused: u16;
}


SDL_GetKeyboardFocus :: () -> *SDL_Window #foreign SDL2;
SDL_GetKeyboardState :: (numkeys: *s32) -> *u8 #foreign SDL2;
SDL_GetModState :: () -> SDL_Keymod #foreign SDL2;
SDL_SetModState :: (modstate: SDL_Keymod) #foreign SDL2;
SDL_GetKeyFromScancode :: (scancode: SDL_Scancode) -> SDL_Keycode #foreign SDL2;
SDL_GetScancodeFromKey :: (key: SDL_Keycode) -> SDL_Scancode #foreign SDL2;
SDL_GetScancodeName :: (scancode: SDL_Scancode) -> *u8 #foreign SDL2;
SDL_GetScancodeFromName :: (name: *u8) -> SDL_Scancode #foreign SDL2;
SDL_GetKeyName :: (key: SDL_Keycode) -> *u8 #foreign SDL2;
SDL_GetKeyFromName :: (name: *u8) -> SDL_Keycode #foreign SDL2;
SDL_StartTextInput :: () #foreign SDL2;
SDL_IsTextInputActive :: () -> SDL_bool #foreign SDL2;
SDL_StopTextInput :: () #foreign SDL2;
SDL_SetTextInputRect :: (rect: *SDL_Rect) #foreign SDL2;
SDL_HasScreenKeyboardSupport :: () -> SDL_bool #foreign SDL2;
SDL_IsScreenKeyboardShown :: (window: *SDL_Window) -> SDL_bool #foreign SDL2;



