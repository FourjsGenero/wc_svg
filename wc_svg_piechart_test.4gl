IMPORT FGL wc_svg_piechart
IMPORT FGL wc_svg_font_dialog
IMPORT FGL wc_svg_stroke_dialog
IMPORT FGL wc_svg_fill_dialog
IMPORT util

DEFINE arr DYNAMIC ARRAY OF RECORD
    key STRING,
    qty1 DECIMAL(11,2),
    qty2 DECIMAL(11,2),
    colour STRING
END RECORD

DEFINE pie_chart STRING

DEFINE p wc_svg_piechart.pieChartType


FUNCTION pie_test()
DEFINE title_font STRING
DEFINE title_stroke STRING
DEFINE title_fill STRING

DEFINE legend_title_font STRING
DEFINE legend_title_stroke STRING
DEFINE legend_title_fill STRING

DEFINE legend_font STRING
DEFINE legend_stroke STRING
DEFINE legend_fill STRING

    OPEN WINDOW pie_test WITH FORM "wc_svg_piechart_test"
    
    CALL init_data()
    CALL init_pie()
    

    DIALOG ATTRIBUTES(UNBUFFERED)

        INPUT BY NAME p.x, p.y, p.rx, p.ry, p.key_column, p.value_column, p.colour_column ATTRIBUTES(WITHOUT DEFAULTS=TRUE)
        END INPUT

        INPUT p.title.text, p.title.x, p.title.y, p.title.justify, title_font, title_stroke, title_fill FROM title_text, title_x, title_y, title_justify, title_font, title_stroke, title_fill ATTRIBUTES(WITHOUT DEFAULTS=TRUE)
            ON ACTION font 
                CALL wc_svg_font_dialog.input(p.title.font.*) RETURNING p.title.font.*
                LET title_font =  wc_svg_font_dialog.label(p.title.font.*) 
            ON ACTION stroke 
                CALL wc_svg_stroke_dialog.input(p.title.stroke.*) RETURNING p.title.stroke.*
                LET title_stroke =  wc_svg_stroke_dialog.label(p.title.stroke.*) 
            ON ACTION fill 
                CALL wc_svg_fill_dialog.input(p.title.fill.*) RETURNING p.title.fill.*
                LET title_fill=  wc_svg_fill_dialog.label(p.title.fill.*) 
        END INPUT

        INPUT p.legend.title.text, p.legend.title.x, p.legend.title.y, p.legend.title.justify, legend_title_font, legend_title_stroke, legend_title_fill FROM legend_title_text, legend_title_x, legend_title_y, legend_title_justify, legend_title_font, legend_title_stroke, legend_title_fill ATTRIBUTES(WITHOUT DEFAULTS=TRUE)
            ON ACTION font 
                CALL wc_svg_font_dialog.input(p.legend.title.font.*) RETURNING p.legend.title.font.*
                LET legend_title_font =  wc_svg_font_dialog.label(p.legend.title.font.*)
            ON ACTION stroke 
                CALL wc_svg_stroke_dialog.input(p.legend.title.stroke.*) RETURNING p.legend.title.stroke.*
                LET legend_title_stroke =  wc_svg_stroke_dialog.label(p.legend.title.stroke.*) 
            ON ACTION fill 
                CALL wc_svg_fill_dialog.input(p.legend.title.fill.*) RETURNING p.legend.title.fill.*
                LET legend_title_fill=  wc_svg_fill_dialog.label(p.legend.title.fill.*) 
        END INPUT

        INPUT p.legend.x, p.legend.y, p.legend.width, p.legend.height, p.legend.format, p.legend.value_format, p.legend.perc_format, legend_font, legend_stroke, legend_fill FROM legend_x, legend_y, legend_width, legend_height, legend_format, legend_value_format, legend_perc_format, legend_font, legend_stroke, legend_fill ATTRIBUTES(WITHOUT DEFAULTS=TRUE)
            ON ACTION font 
                CALL wc_svg_font_dialog.input(p.legend.font.*) RETURNING p.legend.font.*
                LET legend_font =  wc_svg_font_dialog.label(p.legend.font.*)
            ON ACTION stroke 
                CALL wc_svg_stroke_dialog.input(p.legend.stroke.*) RETURNING p.legend.stroke.*
                LET legend_stroke =  wc_svg_stroke_dialog.label(p.legend.stroke.*) 
            ON ACTION fill 
                CALL wc_svg_fill_dialog.input(p.legend.fill.*) RETURNING p.legend.fill.*
                LET legend_fill=  wc_svg_fill_dialog.label(p.legend.fill.*) 
        END INPUT

        INPUT ARRAY arr FROM scr.* ATTRIBUTES(WITHOUT DEFAULTS=TRUE)
        END INPUT
        
        INPUT BY NAME pie_chart ATTRIBUTES(WITHOUT DEFAULTS=TRUE)
        END INPUT
        
        BEFORE DIALOG
            CALL combobox_column_list(ui.ComboBox.forName("formonly.key_column"),base.TypeInfo.create(arr))
            CALL combobox_column_list(ui.ComboBox.forName("formonly.value_column"),base.TypeInfo.create(arr))
            CALL combobox_column_list(ui.ComboBox.forName("formonly.colour_column"),base.TypeInfo.create(arr))
            LET title_font =  wc_svg_font_dialog.label(p.title.font.*) 
            LET title_stroke =  wc_svg_stroke_dialog.label(p.title.stroke.*) 
            LET title_fill=  wc_svg_fill_dialog.label(p.title.fill.*) 
            LET legend_title_font = wc_svg_font_dialog.label(p.legend.title.font.*) 
            LET legend_title_stroke =  wc_svg_stroke_dialog.label(p.legend.title.stroke.*) 
            LET legend_title_fill=  wc_svg_fill_dialog.label(p.legend.title.fill.*) 
            LET legend_font = wc_svg_font_dialog.label(p.legend.font.*) 
            LET legend_stroke =  wc_svg_stroke_dialog.label(p.legend.stroke.*) 
            LET legend_fill=  wc_svg_fill_dialog.label(p.legend.fill.*) 
            CALL draw_pie()

        ON ACTION draw_pie
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

    LET p.data = base.TypeInfo.create(arr)
    CALL wc_svg_piechart.draw("formonly.pie_chart",p.*)
END FUNCTION


FUNCTION init_data()
    LET arr[1].key = "North"
    LET arr[1].colour = "red"

    LET arr[2].key = "South"
    LET arr[2].colour = "blue"

    LET arr[3].key = "East"
    LET arr[3].colour = "green"

    LET arr[4].key = "West"
    LET arr[4].colour = "yellow"
    CALL refresh_data()
END FUNCTION



FUNCTION refresh_data()
DEFINE i INTEGER

    FOR i = 1 TO arr.getLength()
        LET arr[i].qty1 = util.Math.rand(1000)
        LET arr[i].qty2 = util.Math.rand(10)
    END FOR
END FUNCTION



FUNCTION init_pie()
    CALL wc_svg_piechart.init(p.*)
    LET p.x = 100
    LET p.y = 100
    LET p.rx = 100
    LET p.ry = 50

    LET p.title.text = "Example Pie"
    LET p.title.x = 100
    LET p.title.y = 25
    LET p.title.justify = "middle"
    LET p.title.fill.colour = "blue"
    LET p.title.font.size = 24

    LET p.legend.title.text = "Key"
    LET p.legend.title.x = 250
    LET p.legend.title.y = 50
    LET p.legend.title.fill.colour = "black"
    LET p.legend.title.font.size = 18

    LET p.legend.x = 250
    LET p.legend.y = 70
    LET p.legend.width = 12
    LET p.legend.height = 12
    LET p.legend.format = "%1 (%2-%3)"
    LET p.legend.value_format = "###,##&"
    LET p.legend.perc_format = "##&.&"
    LET p.legend.fill.colour = "black"
    LET p.legend.font.size = 12

    LET p.key_column = "key"
    LET p.value_column = "qty1"
    LET p.colour_column = "colour"
END FUNCTION