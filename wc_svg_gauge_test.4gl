IMPORT FGL wc_svg_gauge
DEFINE g wc_svg_gauge.gaugeType


FUNCTION gauge_test()
DEFINE gauge_chart STRING
DEFINE gauge_value INTEGER

    OPEN WINDOW gauge_test WITH FORM "wc_svg_gauge_test"
    CALL wc_svg_gauge.init() RETURNING g.*
    LET g.title.text = "Capacity (%)"
    LET g.title.fill.colour = "black"
    LET g.title.font.size = 18
    LET g.title.x = 200
    LET g.title.y = 150
    LET g.title.justify = "middle"

    LET g.x = 200
    LET g.y = 200
    LET g.r1 = 150
    LET g.r2 = 120
    LET g.min_value = 0
    LET g.max_value = 100
    LET g.arc_start = 135
    LET g.arc_end = 405

    LET g.value.text = 72
    LET g.value.fill.colour = "black"
    LET g.value.font.size = 18
    LET g.value.x = 200
    LET g.value.y = 300
    LET g.value.justify = "middle"

    LET g.major_ticks.number = 5
    LET g.major_ticks.fill.colour = "black"
    LET g.major_ticks.stroke.width = "5"

    LET g.minor_ticks.number = 4
    LET g.minor_ticks.fill.colour = "black"
    LET g.minor_ticks.stroke.width = "2"

    LET g.band[1].min = 75
    LET g.band[1].max = 90
    LET g.band[1].depth1 = 0.8
    LET g.band[1].depth2 = 1.0
    LET g.band[1].fill.colour = "orange"
    LET g.band[1].stroke.colour  = "orange"

    LET g.band[2].min = 90
    LET g.band[2].max = 100
    LET g.band[2].depth1 = 0.8
    LET g.band[2].depth2 = 1.0
    LET g.band[2].fill.colour = "red"
    LET g.band[2].stroke.colour  = "red"
    
 

    DIALOG ATTRIBUTES(UNBUFFERED)
        INPUT BY NAME gauge_chart, gauge_value ATTRIBUTES(WITHOUT DEFAULTS=TRUE)

            ON CHANGE gauge_value
                LET g.value.text = gauge_value
                CALL wc_svg_gauge.draw("formonly.gauge_chart", g.*)
        END INPUT
        
        BEFORE DIALOG
            LET gauge_value = g.value.text
            CALL wc_svg_gauge.draw("formonly.gauge_chart", g.*)
            



        ON ACTION close
            EXIT DIALOG
    END DIALOG
    CLOSE WINDOW gauge_test
    
END FUNCTION