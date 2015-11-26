IMPORT FGL wc_svg

FUNCTION input(s)
DEFINE s wc_svg.strokeType
DEFINE init wc_svg.strokeType

    OPEN WINDOW wc_svg_stroke_dialog WITH FORM "wc_svg_stroke_dialog"
    LET init.* = s.*
    INPUT BY NAME s.* ATTRIBUTES(WITHOUT DEFAULTS=TRUE, UNBUFFERED)
        AFTER INPUT
            IF int_flag THEN
                EXIT INPUT
            END IF
    END INPUT
    CLOSE WINDOW wc_svg_stroke_dialog
    IF int_flag THEN
        LET int_flag = FALSE
        RETURN init.*
    END IF
    RETURN s.*
END FUNCTION

FUNCTION label(s)
DEFINE s wc_svg.strokeType

    RETURN SFMT("Colour=%1, DashArray=%2, DashOffset=%3, Linecap=%4, Linejoin=%5, MiterLimit=%6,Opacity=%7, Width=%8", s.colour, s.dasharray, s.dashoffset, s.linecap, s.linejoin, s.miterlimit, s.opacity, s.width)
END FUNCTION