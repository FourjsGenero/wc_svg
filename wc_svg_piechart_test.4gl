IMPORT FGL wc_svg_piechart
IMPORT util

DEFINE arr DYNAMIC ARRAY OF RECORD
    major STRING,
    qty DECIMAL(11,2),
    colour STRING
END RECORD

DEFINE pie_chart STRING


FUNCTION pie_test()
    OPEN WINDOW pie_test WITH FORM "wc_svg_piechart_test"

    CALL init_data()

    DIALOG ATTRIBUTES(UNBUFFERED)

        DISPLAY ARRAY arr TO scr.*
        END DISPLAY
        
        INPUT BY NAME pie_chart ATTRIBUTES(WITHOUT DEFAULTS=TRUE)
        END INPUT
        BEFORE DIALOG
            CALL draw_pie()
            
        ON ACTION refresh
            CALL refresh_data()
            CALL draw_pie()
            
        ON ACTION close
            EXIT DIALOG

    END DIALOG
    CLOSE WINDOW pie_test

END FUNCTION

FUNCTION draw_pie()
    CALL wc_svg_piechart.init()
    LET wc_svg_piechart.x = 100
    LET wc_svg_piechart.y = 100
    LET wc_svg_piechart.rx = 50
    LET wc_svg_piechart.ry = 50

    LET wc_svg_piechart.title.text = "Example Pie"
    LET wc_svg_piechart.title.x = 100
    LET wc_svg_piechart.title.y = 25
    LET wc_svg_piechart.title.justify = "middle"
    LET wc_svg_piechart.title.fill.colour = "blue"
    LET wc_svg_piechart.title.font.size = 24

    LET wc_svg_piechart.legend.title.text = "Key"
    LET wc_svg_piechart.legend.title.x = 200
    LET wc_svg_piechart.legend.title.y = 50
    LET wc_svg_piechart.legend.title.fill.colour = "black"
    LET wc_svg_piechart.legend.title.font.size = 18

    LET wc_svg_piechart.data = base.TypeInfo.create(arr)

    LET wc_svg_piechart.key_column = "major"
    LET wc_svg_piechart.value_column = "qty"
    LET wc_svg_piechart.colour_column = "colour"

    CALL wc_svg_piechart.draw("formonly.pie_chart")

END FUNCTION


FUNCTION init_data()
    LET arr[1].major = "Red"
    LET arr[1].colour = "red"

    LET arr[2].major = "Blue"
    LET arr[2].colour = "blue"

    LET arr[3].major = "Green"
    LET arr[3].colour = "green"

    LET arr[4].major = "Yellow"
    LET arr[4].colour = "yellow"
    CALL refresh_data()
END FUNCTION


FUNCTION refresh_data()
DEFINE i INTEGER

    FOR i = 1 TO arr.getLength()
        LET arr[i].qty = util.Math.rand(1000)
    END FOR
END FUNCTION