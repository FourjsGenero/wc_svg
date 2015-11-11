IMPORT FGL wc_svg

PUBLIC DEFINE 
    x,y INTEGER,
    rx, ry INTEGER,
    title RECORD
        text STRING,
        x,y INTEGER,
        justify STRING,
        fill wc_svg.fillType,
        stroke wc_svg.strokeType,
        font wc_svg.fontType
    END RECORD,
    legend RECORD
        title RECORD
            text STRING,
            x,y INTEGER,
            justify STRING,
            fill wc_svg.fillType,
            stroke wc_svg.strokeType,
            font wc_svg.fontType
        END RECORD
    END RECORD,
    data om.DomNode,
    key_column STRING,
    value_column STRING,
    colour_column STRING



FUNCTION init()
    INITIALIZE x,y,rx,ry,title.*,legend.* TO NULL
END FUNCTION
 
    
    


FUNCTION draw(fieldname)
DEFINE fieldname STRING



DEFINE value, total FLOAT
DEFINE angle_total, angle_current FLOAT

DEFINE rec om.DomNode

DEFINE svg_root, slice, child wc_svg.svg_object
DEFINE i INTEGER

DEFINE fill wc_svg.fillType
DEFINE stroke wc_svg.strokeType

    LET svg_root = wc_svg.init()

    -- Calculate Total
    LET total = 0.0
    FOR i = 1 TO data.getChildCount()
        LET rec = data.getChildByIndex(i)
        LET value = get_field_value(rec,value_column)
        LET total = total + nvl(value,0)
    END FOR


    -- Draw each slice
    LET angle_total = 0.0
    FOR i = 1 TO data.getChildCount()
        LET rec = data.getChildByIndex(i)
        LET value = get_field_value(rec,value_column)

        LET angle_current = value / total * 360.0
        LET fill.colour = get_field_value(rec,colour_column)
        LET slice = wc_svg.add_slice(svg_root,x,y,rx,ry,angle_total,(angle_total+angle_current),fill.*, stroke.*)
        LET angle_total = angle_total + angle_current
    END FOR

    -- Draw Title
    IF title.text IS NOT NULL THEN
        LET child = wc_svg.add_text(svg_root,title.x, title.y,title.text, title.justify, title.fill.*, title.stroke.*, title.font.*)
    END IF

    -- Draw Legend Title
    IF legend.title.text IS NOT NULL THEN
        LET child = wc_svg.add_text(svg_root,legend.title.x, legend.title.y,legend.title.text, legend.title.justify, legend.title.fill.*, legend.title.stroke.*, legend.title.font.*)
    END IF

    CALL wc_svg.draw(fieldname, svg_root)

END FUNCTION

PRIVATE FUNCTION get_field_node(rec, fieldname)
DEFINE rec om.DomNode
DEFINE fieldname STRING

DEFINE fld om.DomNode

DEFINE i INTEGER

    FOR i = 1 TO rec.getChildCount()
        LET fld = rec.getChildByIndex(i)
        IF fld.getAttribute("name") = fieldname THEN
            RETURN fld
        END IF
    END FOR
    RETURN NULL
END FUNCTION

PRIVATE FUNCTION get_field_value(rec, fieldname)
DEFINE rec om.DomNode
DEFINE fieldname STRING

DEFINE value STRING
DEFINE fld om.DomNode

    LET fld = get_field_node(rec, fieldname)
    IF fld IS NOT NULL THEN
        LET value = fld.getAttribute("value")
    END IF
    RETURN value
END FUNCTION
    

    


