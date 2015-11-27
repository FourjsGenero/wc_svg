IMPORT FGL wc_svg

IMPORT util

PUBLIC TYPE gaugeType RECORD
    x,y INTEGER,
    r1, r2 INTEGER,
    min_value, max_value FLOAT,
    arc_start, arc_end FLOAT,
    title RECORD
        text STRING,
        x,y INTEGER,
        justify STRING,
        fill wc_svg.fillType,
        stroke wc_svg.strokeType,
        font wc_svg.fontType
    END RECORD,
    value RECORD
        text STRING,
        x,y INTEGER,
        justify STRING,
        fill wc_svg.fillType,
        stroke wc_svg.strokeType,
        font wc_svg.fontType
    END RECORD,
    major_ticks RECORD
        number INTEGER,
        depth FLOAT,
        fill wc_svg.fillType,
        stroke wc_svg.strokeType
    END RECORD,
    minor_ticks RECORD
        number INTEGER,
        depth FLOAT,
        fill wc_svg.fillType,
        stroke wc_svg.strokeType
    END RECORD,
    band DYNAMIC ARRAY OF RECORD
        min, max FLOAT,
        depth1, depth2 FLOAT,
        fill wc_svg.fillType,
        stroke wc_svg.strokeType
    END RECORD
        
END RECORD

FUNCTION init()
DEFINE g gaugeType
    INITIALIZE g.* TO NULL
    RETURN g.*
END FUNCTION

FUNCTION draw(fieldname, g)
DEFINE fieldname STRING
DEFINE g gaugeType

DEFINE svg_root, child wc_svg.svg_object
DEFINE i,j INTEGER
DEFINE x,y INTEGER
DEFINE a, a1, a2 FLOAT

DEFINE fill wc_svg.fillType
DEFINE stroke wc_svg.strokeType

    LET svg_root = wc_svg.init()

    -- Draw Border
    LET stroke.colour = "black"
    LET stroke.width = 1
    LET fill.colour = "white"
    LET child = wc_svg.add_circle(svg_root, g.x, g.y, g.r1, fill.*, stroke.*) 

    -- Draw Arc
    LET stroke.colour = "black"
    LET stroke.width = 1
    LET fill.colour = "white"
    LET child = wc_svg.add_arc(svg_root, g.x, g.y, g.r2, g.r2, g.arc_start, g.arc_end, fill.*, stroke.*)

    -- Draw Colour Band
    FOR i = 1 TO g.band.getLength()
        LET a1 = g.arc_start + (g.arc_end-g.arc_start) * g.band[i].min/(g.max_value-g.min_value)
        LET a2 = g.arc_start + (g.arc_end-g.arc_start) * g.band[i].max/(g.max_value-g.min_value)
        LET child = wc_svg.add_donut(svg_root, g.x, g.y, g.band[i].depth1*g.r2, g.band[i].depth1*g.r2, g.band[i].depth2*g.r2, g.band[i].depth2*g.r2,a1, a2, g.band[i].fill.*,g.band[i].stroke.*)
    END FOR

    -- Draw Major Ticks
    FOR i = 1 TO g.major_ticks.number
        LET a = g.arc_start + (g.arc_end-g.arc_start) * (i-1)/(g.major_ticks.number-1)
        LET a = a * util.Math.pi()/180
        
        LET child = wc_svg.add_line(svg_root, g.x+0.8*g.r2*util.Math.cos(a), g.y+0.8*g.r2*util.Math.sin(a), g.x+g.r2*util.Math.cos(a), g.y+g.r2*util.Math.sin(a), g.major_ticks.stroke.*)
        IF i < g.major_ticks.number THEN
            FOR j = 1 TO g.minor_ticks.number
                LET a = g.arc_start + (g.arc_end-g.arc_start) * ((i-1)*(g.minor_ticks.number+1)+j)/((g.major_ticks.number-1)*(g.minor_ticks.number+1))
                LET a = a * util.Math.pi()/180
                LET child = wc_svg.add_line(svg_root, g.x+0.9*g.r2*util.Math.cos(a), g.y+0.9*g.r2*util.Math.sin(a), g.x+g.r2*util.Math.cos(a), g.y+g.r2*util.Math.sin(a), g.minor_ticks.stroke.*)
        
            END FOR
        END IF
    END FOR

     -- Draw Title
    IF g.title.text IS NOT NULL THEN
        LET child = wc_svg.add_text(svg_root,g.title.x, g.title.y, g.title.text, g.title.justify, g.title.fill.*, g.title.stroke.*, g.title.font.*)
    END IF

     -- Draw Value
    IF g.value.text IS NOT NULL THEN
        LET child = wc_svg.add_text(svg_root, g.value.x, g.value.y, g.value.text, g.value.justify, g.value.fill.*,g.value.stroke.*, g.value.font.*)
    END IF

    -- Draw Center

    -- Draw Needle
    LET a = g.arc_start + (g.arc_end-g.arc_start) * g.value.text/(g.max_value-g.min_value)
    LET a = a * util.Math.pi()/180
    LET stroke.colour = "black"
    LET child = wc_svg.add_line(svg_root, g.x, g.y, g.x+g.r2*util.Math.cos(a), g.y+g.r2*util.Math.sin(a), stroke.*)

    CALL wc_svg.draw(fieldname, svg_root)



END FUNCTION