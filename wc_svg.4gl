IMPORT util

PUBLIC TYPE svg_object om.DomNode
PUBLIC TYPE fillType RECORD
    colour STRING,
    rule STRING,
    opacity STRING
END RECORD
PUBLIC TYPE strokeType RECORD
    colour STRING,
    width STRING,
    linecap STRING,
    linejoin STRING, 
    miterlimit STRING,
    dasharray STRING,
    dashoffset STRING,
    opacity STRING
END RECORD
PUBLIC TYPE fontType RECORD
    family STRING,
    size STRING,
    style STRING,
    weight STRING
    --underline
    --overline
    --strike through
END RECORD
PUBLIC TYPE transformType STRING
    
    

DEFINE svg_dom om.DomDocument


FUNCTION init()
DEFINE svg_root svg_object
    LET svg_dom = om.DomDocument.create("svg")
    LET svg_root = svg_dom.getDocumentElement()
    RETURN svg_root
END FUNCTION

FUNCTION svg_position(svg_root,x,y)
DEFINE svg_root svg_object
DEFINE x,y INTEGER

    CALL svg_root.setAttribute("x",x)
    CALL svg_root.setAttribute("y",y)
END FUNCTION

FUNCTION svg_size(svg_root, width, height)
DEFINE svg_root svg_object
DEFINE width, height INTEGER

    CALL svg_root.setAttribUTE("width",width)
    CALL svg_root.setAttribute("height", height)
END FUNCTION

FUNCTION svg_viewBox(svg_root, x,y,width, height)
DEFINE svg_root svg_object
DEFINE x,y, width, height INTEGER
    CALL svg_root.setAttribute("viewBox", SFMT("%1 %2 %3 %4", x,y, width, height))
END FUNCTION

FUNCTION svg_preserveAspectRatio(svg_root, x,y )
DEFINE svg_root svg_object
DEFINE x,y STRING

DEFINE s STRING

    LET s= "none"
    IF x MATCHES "m*" AND y MATCHES "m*" THEN
        LET s= SFMT("x%1Y%2",x,y)
    END IF
    CALL svg_root.setAttribute("preserveAspectRatio", s)
END FUNCTION



#viewBox="the points "seen" in this SVG drawing area. 4 values separated by white space or commas. (min x, min y, width, height)"
#preserveAspectRatio="'none' or any of the 9 combinations of 'xVALYVAL' where VAL is 'min', 'mid' or 'max'. (default xMidYMid)"

FUNCTION add_group(parent)
DEFINE parent svg_object
DEFINE g svg_object
    LET g = parent.createChild("g")
    RETURN g
END FUNCTION

FUNCTION add_rect(parent, x,y,width,height,f,s)
DEFINE parent svg_object
DEFINE x,y,width, height INTEGER
DEFINE f fillType
DEFINE s strokeType

DEFINE rect svg_object

    LET rect = parent.createChild("rect")
    CALL rect.setAttribute("x",x)
    CALL rect.setAttribute("y",y)
    CALL rect.setAttribute("width",width)
    CALL rect.setAttribute("height",height)
    CALL add_fill(rect,f.*)
    CALL add_stroke(rect,s.*)


    RETURN rect
END FUNCTION

FUNCTION add_roundrect(parent, x,y,width,height,rx,ry,f,s)
DEFINE parent svg_object
DEFINE x,y,width, height,rx,ry INTEGER
DEFINE f fillType
DEFINE s strokeType

DEFINE roundrect svg_object

    LET roundrect = parent.createChild("rect")
    CALL roundrect.setAttribute("x",x)
    CALL roundrect.setAttribute("y",y)
    CALL roundrect.setAttribute("width",width)
    CALL roundrect.setAttribute("height",height)
    CALL roundrect.setAttribute("rx",rx)
    CALL roundrect.setAttribute("ry",ry)
    CALL add_fill(roundrect,f.*)
    CALL add_stroke(roundrect,s.*)
    RETURN roundrect
END FUNCTION

FUNCTION add_circle(parent, cx,cy,r,f,s)
DEFINE parent svg_object
DEFINE cx,cy,r INTEGER
DEFINE f fillType
DEFINE s strokeType

DEFINE circle svg_object

    LET circle = parent.createChild("circle")
    CALL circle.setAttribute("cx",cx)
    CALL circle.setAttribute("cy",cy)
    CALL circle.setAttribute("r",r)
    CALL add_fill(circle,f.*)
    CALL add_stroke(circle,s.*)
    RETURN circle
END FUNCTION

FUNCTION add_ellipse(parent, cx,cy,rx, ry,f,s)
DEFINE parent svg_object
DEFINE cx,cy,rx, ry INTEGER
DEFINE f fillType
DEFINE s strokeType

DEFINE ellipse svg_object

    LET ellipse = parent.createChild("ellipse")
    CALL ellipse.setAttribute("cx",cx)
    CALL ellipse.setAttribute("cy",cy)
    CALL ellipse.setAttribute("rx",rx)
    CALL ellipse.setAttribute("ry",ry)
    CALL add_fill(ellipse,f.*)
    CALL add_stroke(ellipse,s.*)
    RETURN ellipse
END FUNCTION
 
FUNCTION add_slice(parent, cx,cy, rx, ry, a1, a2,f,s)
DEFINE parent svg_object
DEFINE cx,cy,rx, ry INTEGER
DEFINE a1, a2 FLOAT
DEFINE f fillType
DEFINE s strokeType

DEFINE d STRING
DEFINE x1,y1,x2,y2 FLOAT

DEFINE slice svg_object

    #M x,y L x,y Arx,ry 0 0,1  "Z" 
    LET x1 = cx + rx*util.Math.cos(util.Math.pi()*a1/180)
    LET y1 = cy + ry*util.Math.sin(util.Math.pi()*a1/180)

    LET x2 = cx + rx*util.Math.cos(util.Math.pi()*a2/180)
    LET y2 = cy + ry*util.Math.sin(util.Math.pi()*a2/180)
    LET d= SFMT("M%1,%2 L%3,%4 A%5,%6 0 %9,1 %7,%8 Z",cx,cy,x1,y1,rx,ry,x2,y2,IIF((a2-a1)>180,1,0))

    LET slice = add_path(parent,d,f.*,s.*)
    
    RETURN slice
END FUNCTION

FUNCTION add_arc(parent, cx,cy, rx, ry, a1, a2,f,s)
DEFINE parent svg_object
DEFINE cx,cy,rx, ry INTEGER
DEFINE a1, a2 FLOAT
DEFINE f fillType
DEFINE s strokeType

DEFINE d STRING
DEFINE x1,y1,x2,y2 FLOAT

DEFINE slice svg_object

    #M x,y L x,y Arx,ry 0 0,1  "Z" 
    LET x1 = cx + rx*util.Math.cos(util.Math.pi()*a1/180)
    LET y1 = cy + ry*util.Math.sin(util.Math.pi()*a1/180)

    LET x2 = cx + rx*util.Math.cos(util.Math.pi()*a2/180)
    LET y2 = cy + ry*util.Math.sin(util.Math.pi()*a2/180)
    LET d= SFMT("M%3,%4 A%5,%6 0 %9,1 %7,%8",cx,cy,x1,y1,rx,ry,x2,y2,IIF((a2-a1)>180,1,0))

    LET slice = add_path(parent,d,f.*,s.*)
    
    RETURN slice
END FUNCTION

FUNCTION add_donut(parent, cx,cy, rx1, ry1, rx2, ry2, a1, a2,f,s)
DEFINE parent svg_object
DEFINE cx,cy,rx1, ry1, rx2, ry2 INTEGER
DEFINE a1, a2 FLOAT
DEFINE f fillType
DEFINE s strokeType

DEFINE d STRING
DEFINE x1,y1,x2,y2, x3, y3, x4, y4 FLOAT

DEFINE slice svg_object

    LET x1 = cx + rx1*util.Math.cos(util.Math.pi()*a1/180)
    LET y1 = cy + ry1*util.Math.sin(util.Math.pi()*a1/180)

    LET x2 = cx + rx1*util.Math.cos(util.Math.pi()*a2/180)
    LET y2 = cy + ry1*util.Math.sin(util.Math.pi()*a2/180)

    LET x3 = cx + rx2*util.Math.cos(util.Math.pi()*a2/180)
    LET y3 = cy + ry2*util.Math.sin(util.Math.pi()*a2/180)

    LET x4 = cx + rx2*util.Math.cos(util.Math.pi()*a1/180)
    LET y4 = cy + ry2*util.Math.sin(util.Math.pi()*a1/180)

    #LET d= SFMT("M%1,%2 L%3,%4 A%5,%6 0 %9,1 %7,%8 Z",cx,cy,x1,y1,rx,ry,x2,y2,IIF((a2-a1)>180,1,0))

    LET d = SFMT("M%7,%8 L%1,%2 A%9,%10 0 %13,1 %3,%4 L%5,%6 A%11,%12 0 %13,0 %7,%8", x1,y1,x2,y2,x3,y3,x4,y4,rx1,ry1,rx2,ry2,IIF((a2-a1)>180,1,0))
    
    LET slice = add_path(parent,d,f.*,s.*)
    
    RETURN slice



END FUNCTION

FUNCTION add_polygon(parent, points, f, s)
DEFINE parent svg_object
DEFINE points STRING
DEFINE f fillType
DEFINE s strokeType

DEFINE polygon svg_object

    LET polygon = parent.createChild("polygon")
    CALL polygon.setAttribute("points", points)
    CALL add_fill(polygon, f.*)
    CALL add_stroke(polygon, s.*)
    
    RETURN polygon
END FUNCTION


FUNCTION add_polyline(parent, points, f, s)
DEFINE parent svg_object
DEFINE points STRING
DEFINE f fillType
DEFINE s strokeType

DEFINE polyline svg_object

    LET polyline = parent.createChild("polyline")
    CALL polyline.setAttribute("points", points)
    CALL add_fill(polyline, f.*)
    CALL add_stroke(polyline, s.*)
    
    RETURN polyline
END FUNCTION




FUNCTION add_path(parent, d, f, s)
DEFINE parent svg_object
DEFINE d STRING
DEFINE f fillType
DEFINE s strokeType

DEFINE path svg_object

    LET path = parent.createChild("path")
    CALL path.setAttribute("d", d)
    CALL add_fill(path, f.*)
    CALL add_stroke(path, s.*)
    
    RETURN path
END FUNCTION

FUNCTION add_image(parent, x,y, width, height, url)
DEFINE parent svg_object
DEFINE x,y,width, height INTEGER
DEFINE url STRING

DEFINE img svg_object

    LET img = parent.createChild("image")
    CALL img.setAttribute("x", x)
    CALL img.setAttribute("y", y)
    CALL img.setAttribute("width", width)
    CALL img.setAttribute("height", height)
    CALL img.setAttribute("xlink:href", url)
   
    RETURN img
END FUNCTION

FUNCTION add_line(parent,x1,y1,x2,y2,s)
DEFINE parent svg_object
DEFINE x1,y1,x2,y2 INTEGER
DEFINE s strokeType

DEFINE line svg_object

    LET line = parent.createChild("line")
    CALL line.setAttribute("x1",x1)
    CALL line.setAttribute("y1",y1)
    CALL line.setAttribute("x2",x2)
    CALL line.setAttribute("y2",y2)
    LET s.colour = nvl(s.colour,"black")
    LET s.width = nvl(s.width,1)
    CALL add_stroke(line,s.*)
    RETURN line
END FUNCTION



FUNCTION add_text(parent,x,y,t,j,f,s,ft)
DEFINE parent svg_object
DEFINE x,y INTEGER
DEFINE t STRING
DEFINE j STRING
DEFINE f fillType
DEFINE s strokeType
DEFINE ft fontType

DEFINE text svg_object
DEFINE text_node om.DomNode

    LET text = parent.createChild("text")
    CALL text.setAttribute("x",x)
    CALL text.setAttribute("y",y)
    IF j= "start" OR j="middle" OR j = "end" THEN
        CALL text.setAttribute("text-anchor",j)
    END IF
    
    -- child text element
    LET text_node = svg_dom.createChars(t)
    CALL text.appendChild(text_node)
    
    CALL add_fill(text,f.*)
    CALL add_stroke(text,s.*)
    CALL add_font(text,ft.*)
    RETURN text
END FUNCTION


FUNCTION add_fill(n,f)
DEFINE n svg_object
DEFINE f fillType
    IF f.colour IS NOT NULL THEN
        CALL n.setAttribute("fill", f.colour)
    END IF
    IF (f.rule = "nonzero" OR f.rule = "evenodd") THEN
        CALL n.setAttribute("fill-rule", f.rule)
    END IF
    IF f.opacity IS NOT NULL THEN
        CALL n.setAttribute("fill-opacity",f.opacity)
    END IF
END FUNCTION

FUNCTION add_stroke(n,s)
DEFINE n svg_object
DEFINE s strokeType

    IF s.colour IS NOT NULL THEN
        CALL n.setAttribute("stroke", s.colour)
    END IF
    IF s.width IS NOT NULL THEN
        CALL n.setAttribute("stroke-width", s.width)
    END IF
    IF (s.linecap = "butt" OR s.linecap = "round" OR s.linecap = "square") THEN
        CALL n.setAttribute("stroke-linecap", s.linecap)
    END IF
    IF (s.linejoin = "miter" OR s.linejoin = "round" OR s.linejoin = "bevel") THEN
        CALL n.setAttribute("stroke-linejoin", s.linejoin)
    END IF
    IF s.miterlimit IS NOT NULL THEN
        CALL n.setAttribute("stroke-miterlimit", s.miterlimit)
    END IF
    IF s.dasharray IS NOT NULL THEN
        CALL n.setAttribute("stroke-dasharray", s.dasharray)
    END IF
    IF s.dashoffset IS NOT NULL THEN
        CALL n.setAttribute("stroke-dashoffset", s.dashoffset)
    END IF
    IF s.opacity IS NOT NULL THEN
        CALL n.setAttribute("stroke-opacity",s.opacity)
    END IF
END FUNCTION

FUNCTION add_font(n, ft)
DEFINE n svg_object
DEFINE ft fontType

    IF ft.family IS NOT NULL THEN
        CALL n.setAttribute("font-family", ft.family)
    END IF
    CALL n.setAttribute("font-size", nvl(ft.size,12))
    IF ft.style IS NOT NULL THEN
        CALL n.setAttribute("font-style", ft.style)
    END IF
    IF ft.weight IS NOT NULL THEN
        CALL n.setAttribute("font-weight", ft.weight)
    END IF

END FUNCTION



FUNCTION add_rotate(n,r,x,y)
DEFINE n svg_object
DEFINE r FLOAT
DEFINE x,y INTEGER
DEFINE t STRING

    LET t = n.getAttribute("transform")
    IF t IS NOT NULL THEN
        LET t = ", ",t
    END IF
    LET t = SFMT("rotate(%1 %2 %3)", r,x,y),t
    CALL n.setAttribute("transform", t)
END FUNCTION

FUNCTION add_translate(n,x,y)
DEFINE n svg_object
DEFINE x,y INTEGER
DEFINE t STRING

    LET t = n.getAttribute("transform")
    IF t IS NOT NULL THEN
        LET t = ", ",t
    END IF
    LET t = SFMT("translate(%1 %2)",x,y),t
    CALL n.setAttribute("transform", t)
END FUNCTION

FUNCTION add_scale(n,sx,sy, ax, ay)
DEFINE n svg_object
DEFINE sx,sy FLOAT
DEFINE ax, ay FLOAT
DEFINE t STRING

    LET t = n.getAttribute("transform")
    IF t IS NOT NULL THEN
        LET t = ", ",t
    END IF
    LET t= SFMT("translate(%1 %2), scale(%3 %4), translate(%5 %6)",ax,ay,sx,sy,-ax,-ay),t
    CALL n.setAttribute("transform", t)
END FUNCTION

FUNCTION add_skewX(n,skx,ax,ay)
DEFINE n svg_object
DEFINE skx FLOAT
DEFINE ax FLOAT
DEFINE ay FLOAT
DEFINE t STRING

    LET t = n.getAttribute("transform")
    IF t IS NOT NULL THEN
        LET t = ", ",t
    END IF
    LET t = SFMT("translate(%1 %2), skewX(%3), translate(%4 %5)",ax,ay,skx,-ax,-ay),t
    CALL n.setAttribute("transform", t)
END FUNCTION

FUNCTION add_skewY(n,sky,ax,ay)
DEFINE n svg_object
DEFINE sky FLOAT
DEFINE ax FLOAT
DEFINE ay FLOAT
DEFINE t STRING

    LET t = n.getAttribute("transform")
    IF t IS NOT NULL THEN
        LET t = ", ",t
    END IF
    LET t= SFMT("translate(%1 %2), skewY(%3), translate(%4 %5)",ax,ay,sky,-ax,-ay),t
    CALL n.setAttribute("transform", t)
END FUNCTION


FUNCTION add_matrix(n,m1,m2,m3,m4,m5,m6)
DEFINE n svg_object
DEFINE m1,m2,m3,m4,m5,m6 FLOAT
    CALL n.setAttribute("transform", SFMT("matrix(%1 %2 %3 %4 %5 %6)",m1,m2,m3,m4,m5,m6))
END FUNCTION




FUNCTION add_action(n, action, value)
DEFINE n svg_object
DEFINE action STRING
DEFINE value STRING

    CALL n.setAttribute("onclick",SFMT("execAction('%1','%2')", action, value))
END FUNCTION



FUNCTION draw(fieldname, svg_root)
DEFINE fieldname STRING
DEFINE svg_root svg_object

DEFINE result STRING

    CALL ui.Interface.frontCall("webcomponent","call",[fieldname,"setById","svg",create_string(svg_root)],result)   
END FUNCTION

PRIVATE FUNCTION create_string(n)
DEFINE n,c om.DomNode
DEFINE sb base.StringBuffer
DEFINE i INTEGER

    IF n IS NULL THEN
        RETURN NULL
    END IF

    LET sb = base.StringBuffer.create()
    CALL sb.append("<")
    CALL sb.append(n.getTagName())
    CALL sb.append(" ")
    FOR i = 1 TO n.getAttributesCount()
        CALL sb.append(SFMT(" %1=\"%2\"", n.getAttributeName(i), n.getAttributeValue(i)))
    END FOR
    CALL sb.append(">")
    FOR i = 1 TO n.getChildCount()
        LET c = n.getChildByIndex(i)
        IF c.getTagName() = "@chars" THEN
            CALL sb.append(c.getAttribute("@chars"))
        ELSE
            CALL sb.append(create_string(c))
        END IF
    END FOR

    CALL sb.append("</")
    CALL sb.append(n.getTagName())
    CALL sb.append(">")
    RETURN sb.toString()
END FUNCTION