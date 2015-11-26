IMPORT FGL wc_svg

FUNCTION input(f)
DEFINE f wc_svg.fontType
DEFINE init wc_svg.fontType

    OPEN WINDOW wc_svg_font_dialog WITH FORM "wc_svg_font_dialog"
    LET init.* = f.*
    INPUT BY NAME f.* ATTRIBUTES(WITHOUT DEFAULTS=TRUE, UNBUFFERED)
        AFTER INPUT
            IF int_flag THEN
                EXIT INPUT
            END IF
    END INPUT
    CLOSE WINDOW wc_svg_font_dialog
    IF int_flag THEN
        LET int_flag = FALSE
        RETURN init.*
    END IF
    RETURN f.*
END FUNCTION

FUNCTION label(f)
DEFINE f wc_svg.fontType

    RETURN SFMT("Family=%1, Size=%2, Style=%3, Weight=%4", f.family, f.size, f.style, f.weight)
END FUNCTION