IMPORT FGL wc_svg

FUNCTION input(f)
DEFINE f wc_svg.fillType
DEFINE init wc_svg.fillType

    OPEN WINDOW wc_svg_fill_dialog WITH FORM "wc_svg_fill_dialog"
    LET init.* = f.*
    INPUT BY NAME f.* ATTRIBUTES(WITHOUT DEFAULTS=TRUE, UNBUFFERED)
        AFTER INPUT
            IF int_flag THEN
                EXIT INPUT
            END IF
    END INPUT
    CLOSE WINDOW wc_svg_fill_dialog
    IF int_flag THEN
        LET int_flag = FALSE
        RETURN init.*
    END IF
    RETURN f.*
END FUNCTION

FUNCTION label(f)
DEFINE f wc_svg.fillType

    RETURN SFMT("Colour=%1, Opacity=%2, Rule=%3", f.colour, f.opacity, f.rule)
END FUNCTION