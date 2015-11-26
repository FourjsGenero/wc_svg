IMPORT FGL wc_svg
IMPORT util

PRIVATE  DEFINE doc om.DomDocument
PRIVATE  DEFINE root om.DomNode
PRIVATE  DEFINE theCanvas om.DomNode
PRIVATE  DEFINE fillColor String
PRIVATE  DEFINE linesAreBlack INTEGER
PRIVATE  DEFINE anchor String
PRIVATE  DEFINE trans INTEGER
PRIVATE  DEFINE lineWidth INTEGER

PRIVATE DEFINE m_line_multiplier FLOAT

FUNCTION canvas_to_svg(l_canvas)
DEFINE l_canvas om.DomNode
DEFINE l_tagname STRING
DEFINE l_svg wc_svg.svg_object
DEFINE i INTEGER
DEFINE l_fill wc_svg.fillType
DEFINE l_stroke wc_svg.strokeType

DEFINE l_background wc_svg.svg_object

DEFINE l_width, l_height INTEGER

    IF l_canvas IS NULL THEN
        RETURN NULL
    END IF
    LET l_tagname = l_canvas.getTagName()
    IF l_tagname = "Canvas" THEN
        LET l_svg = wc_svg.init()
        CALL wc_svg.svg_viewBox(l_svg, 0, 0, 1000, 1000)

         
        CALL ui.Interface.frontCall("webcomponent","call",["formonly.c1","getWidth"],l_width)
        CALL ui.Interface.frontCall("webcomponent","call",["formonly.c1","getHeight"],l_height)
        IF l_width < l_height THEN
            LET m_line_multiplier = 1000 / l_width 
        ELSE
            LET m_line_multiplier = 1000 / l_height 
        END IF
        
        
        LET l_fill.colour = "rgb(240,240,240)"
        LET l_stroke.colour = "black"
        LET l_background =  wc_svg.add_rect(l_svg,0,0,1000,1000, l_fill.*, l_stroke.*)
        
        FOR i = 1 TO l_canvas.getChildCount()
            CALL append_canvas_node_to_svg(l_canvas.getChildByIndex(i), l_svg)
        END FOR
        CALL wc_svg.svg_viewBox(l_svg, 0, 0, 1000, 1000)
        CALL wc_svg.svg_preserveAspectRatio(l_svg, "none","none")
        RETURN l_svg
    ELSE
        RETURN NULL
    END IF
END FUNCTION



FUNCTION append_canvas_node_to_svg(l_canvas_node, l_svg)
DEFINE l_canvas_node om.DomNode
DEFINE l_svg, l_svg_child wc_svg.svg_object

DEFINE l_tagname STRING
DEFINE i INTEGER

DEFINE l_fill wc_svg.fillType
DEFINE l_stroke wc_svg.strokeType
DEFINE l_font wc_svg.fontType

DEFINE startX	        INTEGER 	
DEFINE startY	        INTEGER 	
DEFINE endX	            INTEGER 	
DEFINE endY	            INTEGER 	
DEFINE xyList	        STRING	
DEFINE width	        INTEGER	
DEFINE height	        INTEGER	
DEFINE diameter	        INTEGER	
DEFINE startDegrees	    INTEGER	
DEFINE extentDegrees	INTEGER	
DEFINE text	            STRING	
DEFINE anchor	        CHAR(2)
DEFINE fillColor	    STRING	
DEFINE acceleratorKey1	STRING	
DEFINE acceleratorKey3	STRING	
DEFINE radius INTEGER
DEFINE l_just STRING
DEFINE swap INTEGER

    LET l_tagname = l_canvas_node.getTagName()
    CASE l_tagname
        WHEN "CanvasArc"
            LET diameter = l_canvas_node.getAttribute("diameter")
            LET startX = l_canvas_node.getAttribute("startX")
            LET startY = 1000-l_canvas_node.getAttribute("startY") 
            
            LET startDegrees = l_canvas_node.getAttribute("startDegrees")
            LET extentDegrees = l_canvas_node.getAttribute("extentDegrees")
            LET diameter = l_canvas_node.getAttribute("diameter")
            IF diameter < 0 THEN
                LET startX = startX + diameter
                LET startY = startY + diameter
                LET diameter = -diameter
            END IF
            LET fillColor = l_canvas_node.getAttribute("fillColor")
            
            LET l_stroke.colour = "black"
            LET l_stroke.width = 1

            LET l_fill.colour = fillColor    
            LET radius = diameter/2
            LET startDegrees = startDegrees - 90
            LET l_svg_child = wc_svg.add_slice(l_svg, startX+radius,startY+radius,radius,radius,startDegrees,startDegrees+extentDegrees,l_fill.*, l_stroke.*)

        WHEN "CanvasCircle"
            LET diameter = l_canvas_node.getAttribute("diameter")
            LET startX = l_canvas_node.getAttribute("startX")
            LET startY = 1000-l_canvas_node.getAttribute("startY") 
            
            LET fillColor = l_canvas_node.getAttribute("fillColor")

            IF diameter < 0 THEN
                LET startX = startX + diameter
                LET startY = startY + diameter
                LET diameter = -diameter
            END IF
                
            LET l_stroke.colour = "black"
            LET l_stroke.width = 1
           
            LET l_fill.colour = fillColor   
            LET radius = diameter/2     
            LET l_svg_child = wc_svg.add_circle(l_svg,startX+radius,startY+radius,radius,l_fill.*,l_stroke.*) 
            
        WHEN "CanvasLine"
            LET startX = l_canvas_node.getAttribute("startX")
            LET startY = 1000-l_canvas_node.getAttribute("startY")
            LET endX = l_canvas_node.getAttribute("endX")
            LET endY = 1000-l_canvas_node.getAttribute("endY")
            LET width = l_canvas_node.getAttribute("width")
            LET fillColor = l_canvas_node.getAttribute("fillColor")
            LET l_stroke.colour = fillColor
            LET l_stroke.width = width * m_line_multiplier
            LET l_svg_child = wc_svg.add_line(l_svg, startX, startY, endX, endY, l_stroke.*)
            
        WHEN "CanvasOval"
            LET startX = l_canvas_node.getAttribute("startX")
            LET startY = 1000-l_canvas_node.getAttribute("startY")
            LET endX = l_canvas_node.getAttribute("endX")
            LET endY = 1000-l_canvas_node.getAttribute("endY")

            IF startX > endX THEN
                LET swap = endX
                LET endX = startX
                LET startX = swap
            END IF
            IF startY > endY THEN
                LET swap = endY
                LET endY = startY
                LET startY = swap
            END IF
            LET fillColor = l_canvas_node.getAttribute("fillColor")
            
            LET l_stroke.colour = "black"
            LET l_stroke.width = 1

            LET l_fill.colour = fillColor
            LET l_svg_child = wc_svg.add_ellipse(l_svg, (startX+endX)/2,(startY+endY)/2,(endX-startX)/2,(endY-startY)/2,l_fill.*, l_stroke.*)
        WHEN "CanvasPolygon"
            LET xylist = l_canvas_node.getAttribute("xyList")
            LET fillColor = l_canvas_node.getAttribute("fillColor")

            LET l_stroke.colour = "black"
            LET l_stroke.width = 1

            LET l_fill.colour = fillColor
            LET l_svg_child = wc_svg.add_polygon(l_svg, xylist_to_points(xylist), l_fill.*, l_stroke.*)
            
        WHEN "CanvasRectangle"
            LET startX = l_canvas_node.getAttribute("startX")
            LET startY = 1000-l_canvas_node.getAttribute("startY") 
            LET endX = l_canvas_node.getAttribute("endX")
            LET endY = 1000-l_canvas_node.getAttribute("endY")
            
            LET fillColor = l_canvas_node.getAttribute("fillColor")
            
            LET l_stroke.colour = "black"
            LET l_stroke.width = 1
            
            LET l_fill.colour = fillCOlor

            IF endX < startX THEN
                LET swap = endX
                LET endX = startX
                LET startX = swap
            END IF
            IF endY < startY THEN
                LET swap = endY
                LET endY = startY
                LET startY = swap
            END IF

            LET l_svg_child = wc_svg.add_rect(l_svg, startX, startY, endX-startX, endY-startY, l_fill.*, l_stroke.*)
           
        WHEN "CanvasText" 
            LET startX = l_canvas_node.getAttribute("startX")
            LET startY = 1000-l_canvas_node.getAttribute("startY")
            LET anchor = l_canvas_node.getAttribute("anchor")
            LET text = html_encode(l_canvas_node.getAttribute("text"))
            LET fillColor = l_canvas_node.getAttribute("fillColor")  

            LET l_fill.colour = fillColor
            LET l_stroke.colour = fillColor
            LET l_stroke.width = 1

            LET l_font.size = 12 * m_line_multiplier

            LET l_just = "start"
            IF anchor MATCHES "*e*" THEN
                LET l_just = "end"
            ELSE
                IF anchor = "n" OR anchor = "s" THEN
                    LET l_just = "middle"
                END IF
            END IF
            
            IF anchor MATCHES "*n*" THEN
                LET startY = startY + l_font.size
            ELSE
                IF anchor = "e" OR anchor = "w" THEN
                    LET startY = startY + (l_font.size/2)
                END IF
            END IF
            LET l_svg_child = wc_svg.add_text(l_svg, startX, startY,text,l_just,l_fill.*, l_stroke.*, l_font.*) 

    END CASE
    IF l_svg_child IS NOT NULL THEN
        FOR i = 1 TO l_canvas_node.getChildCount()
            CALL append_canvas_node_to_svg(l_canvas_node.getChildByIndex(i), l_svg_child)
        END FOR
    END IF
END FUNCTION

FUNCTION xylist_to_points(l_xylist)
DEFINE l_xylist STRING
DEFINE l_points STRING

DEFINE l_tok base.StringTokenizer
DEFINE l_x, l_y INTEGER
DEFINE l_sb base.StringBuffer

    LET l_sb = base.StringBuffer.create()
    
    LET l_tok = base.StringTokenizer.create(l_xylist," ")
    WHILE l_tok.hasMoreTokens()
        LET l_y = l_tok.nextToken()
        LET l_x = l_tok.nextToken()
        CALL l_sb.append(l_x)
        CALL l_sb.append(" ")
        CALL l_sb.append(1000-l_y)
        CALL l_sb.append(" ")
    END WHILE
    RETURN l_sb.toString()
END FUNCTION
        








# Property of Four Js*
# (c) Copyright Four Js 1995, 2015. All Rights Reserved.
# * Trademark of Four Js Development Tools Europe Ltd
#   in the United States and elsewhere

#+ Simple draw functions for Canvases.
#+



FUNCTION drawInit()
    LET doc = om.DomDocument.create("CanvasList")
    LET root = doc.getDocumentElement()
    LET theCanvas = NULL
    LET fillColor = "white"
    LET linesAreBlack = 0
    LET lineWidth = 1
    LET m_line_multiplier =1
END FUNCTION

#+ Selects a canvas.
#+ @param canvasName Canvas identifier.
#+
#+ The function initializes the fillColor to "white",
#+ the anchor to "s".
#+
#+ The selected canvas is the parent for all susequently created objects.
FUNCTION drawSelect(canvasName)
    DEFINE canvasName String
    
    DEFINE i INTEGER
    DEFINE  l_child om.DomNode

    FOR i = 1 TO root.getChildCount()
        LET l_child = root.getChildByIndex(i)
        IF l_child.getAttribute("canvasName") = canvasName THEN
            LET theCanvas = l_child
            EXIT FOR
        END IF
    END FOR
    IF i > root.getChildCount() THEN
        LET theCanvas = root.createChild("Canvas")
        CALL theCanvas.setAttribute("canvasName",canvasName)
    END IF
            
    LET fillColor = "white"
    LET trans = 0
    LET anchor = "s"
END FUNCTION

#+ Enable or Disable color mode for lines.
#+
#+ This is a global configuration.
#+ @param ColorLines FALSE:Lines are in color, TRUE:Lines are black.
FUNCTION drawDisableColorLines(ColorLines)
    DEFINE ColorLines SMALLINT
    IF ColorLines <> 1 THEN
        LET linesAreBlack = FALSE
    ELSE
        LET linesAreBlack = TRUE
    END IF
END FUNCTION

#+ Set fill color.
#+ @param color The name of the color for filling shapes.
FUNCTION drawFillColor(color)
    DEFINE color String
    LET fillColor = color.trim()
END FUNCTION

#+ Define the with of the lines.
#+ @param width Pen size for drawing.
FUNCTION drawLineWidth(width)
    DEFINE width  SMALLINT
    LET lineWidth = width
END FUNCTION

#+ Set anchor to draw a text.
#+ @param a One of: 'n','e','s','w'
FUNCTION drawAnchor(a)
    DEFINE a String
    LET anchor = a.trim()
    IF trans THEN
        CASE a
        WHEN "n" LET anchor = "e"
        WHEN "e" LET anchor = "n"
        WHEN "s" LET anchor = "w"
        WHEN "w" LET anchor = "s"
        END CASE
    END IF
END FUNCTION

#+ Draws a line.
#+ @param startX The x start position.
#+ @param startY The y start position.
#+ @param dy The relative y end position.
#+ @param dx The relative x end position.
#+ @return Item identifier in the canvas.
FUNCTION drawLine(startY, startX, dy, dx)
    DEFINE m om.DomNode
    DEFINE startY, startX, dy, dx INTEGER
    IF theCanvas IS NULL THEN
        RETURN NULL
    END IF
    LET m = theCanvas.createChild("CanvasLine")
    IF NOT linesAreBlack THEN
        CALL m.setAttribute("fillColor", fillColor);
    END IF
    CALL m.setAttribute("startY", startY);
    CALL m.setAttribute("startX", startX);
    CALL m.setAttribute("endY", startY + dy);
    CALL m.setAttribute("endX", startX + dx);
    CALL m.setAttribute("width", lineWidth);
    RETURN m.getId()
END FUNCTION

#+ Draws a text.
#+ @param startX The x start position.
#+ @param startY The y start position.
#+ @param text Text to draw.
#+ @return Item identifier in the canvas.
FUNCTION drawText(startY, startX, TEXT)
    DEFINE startY, startX INTEGER
    DEFINE TEXT String
    DEFINE m om.DomNode
    IF theCanvas IS NULL THEN
        RETURN NULL
    END IF
    LET m = theCanvas.createChild("CanvasText")
    CALL m.setAttribute("fillColor", fillColor);
    CALL m.setAttribute("startY", startY);
    CALL m.setAttribute("startX", startX);
    CALL m.setAttribute("text", text.trim());
    CALL m.setAttribute("anchor", anchor);
    RETURN m.getId()
END FUNCTION

#+ Draws a rectangle.
#+ @param startX The x start position.
#+ @param startY The y start position.
#+ @param width The rectangle width.
#+ @param height The rectangle height.
FUNCTION drawRectangle(startY, startX, height, width)
    DEFINE startY, startX, height, width INTEGER
    DEFINE m om.DomNode
    IF theCanvas IS NULL THEN
        RETURN NULL
    END IF
    LET m = theCanvas.createChild("CanvasRectangle")
    CALL m.setAttribute("fillColor", fillColor);
    CALL m.setAttribute("startY", startY);
    CALL m.setAttribute("startX", startX);
    CALL m.setAttribute("endY", startY + height);
    CALL m.setAttribute("endX", startX + width);
    RETURN m.getId()
END FUNCTION

#+ Draws an Circle from a bounding square.
#+ @returnType INTEGER
#+ @param startX The x start position of the boundig square.
#+ @param startY The y start position of the boundig square.
#+ @param diameter The diameter (the width of the bounding square).
#+ @return Item identifier in the canvas.
FUNCTION drawCircle(startY, startX, diameter)
    DEFINE m om.DomNode
    DEFINE startY, startX, diameter INTEGER
    IF theCanvas IS NULL THEN
        RETURN NULL
    END IF
    LET m = theCanvas.createChild("CanvasCircle")
    CALL m.setAttribute("fillColor", fillColor);
    CALL m.setAttribute("startY", startY);
    CALL m.setAttribute("startX", startX);
    CALL m.setAttribute("diameter", diameter);
    RETURN m.getId()
END FUNCTION

#+ Draws an Oval from a bounding rectangle.
#+ @returnType INTEGER
#+ @param startX The x start position of the bounding rectangle.
#+ @param startY The y start position of the bounding rectangle.
#+ @param width The width of the bounding rectangle.
#+ @param height The the height of the bounding rectangle.
#+ @return Item identifier in the canvas.
FUNCTION drawOval(startY, startX, height, width)
    DEFINE m om.DomNode
    DEFINE startY, startX, height, width INTEGER
    IF theCanvas IS NULL THEN
        RETURN NULL
    END IF
    LET m = theCanvas.createChild("CanvasOval")
    CALL m.setAttribute("fillColor", fillColor);
    CALL m.setAttribute("startY", startY);
    CALL m.setAttribute("startX", startX);
    CALL m.setAttribute("endY", startY + height);
    CALL m.setAttribute("endX", startX + width);
    RETURN m.getId()
END FUNCTION

#+ Draws a filled polygone.
#+ @param xyList A blank separated list of points.
#+ @return Item identifier in the canvas.
FUNCTION drawPolygon(xyList)
    DEFINE m om.DomNode
    DEFINE xyList String
    IF theCanvas IS NULL THEN
        RETURN NULL
    END IF
    LET m = theCanvas.createChild("CanvasPolygon")
    CALL m.setAttribute("fillColor", fillColor);
    CALL m.setAttribute("xyList", xyList);
    RETURN m.getId()
END FUNCTION

#+ Draws an arc in a bounding square.
#+ @param startX The x start position of the bounding quadrat.
#+ @param startY The y start position of the bounding quadrat.
#+ @param diameter The diameter (the with of the bounding quadrat).
#+ @param startDegrees  Specifies the beginning of the angular range occupied
#+ by the arc.
#+ @param extentDegrees Specifies the size of the angular range occupied by
#+ the arc.
#+ @return Item identifier in the canvas.
FUNCTION drawArc(startY, startX, diameter, startDegrees, extentDegrees)
    DEFINE m om.DomNode
    DEFINE startY, startX, diameter, startDegrees, extentDegrees INTEGER
    IF theCanvas IS NULL THEN
        RETURN NULL
    END IF
    LET m = theCanvas.createChild("CanvasArc")
    CALL m.setAttribute("fillColor", fillColor);
    CALL m.setAttribute("startY", startY);
    CALL m.setAttribute("startX", startX);
    CALL m.setAttribute("diameter", diameter);
    CALL m.setAttribute("startDegrees", startDegrees);
    CALL m.setAttribute("extentDegrees", extentDegrees);
    RETURN m.getId()
END FUNCTION

#+ Clears the drawing area.
FUNCTION drawClear()
    DEFINE c om.DomNode
    IF theCanvas IS NOT NULL THEN
        LET c = theCanvas.getFirstChild()
        WHILE c IS NOT NULL
            CALL theCanvas.removeChild(c)
            LET c = theCanvas.getFirstChild()
        END WHILE
    END IF
END FUNCTION

#+ Defines key to send when left button click on.
#+ @param id Item identifier.
#+ @param key Key to send.
FUNCTION drawButtonLeft(id, KEY)
    DEFINE id  INTEGER
    DEFINE KEY String
    DEFINE m om.DomNode
    DEFINE doc om.DomDocument
    LET doc = ui.Interface.getDocument()
    LET m = doc.getElementById(id)
    IF m IS NOT NULL THEN
        CALL m.setAttribute("acceleratorKey1", key.trim())
    END IF
END FUNCTION

#+ Defines key to send when right button click on.
#+ @param id Item identifier.
#+ @param key Key to send.
FUNCTION drawButtonRight(id, KEY)
    DEFINE id  INTEGER
    DEFINE KEY String
    DEFINE m om.DomNode
    DEFINE doc om.DomDocument
    LET doc = ui.Interface.getDocument()
    LET m = doc.getElementById(id)
    IF m IS NOT NULL THEN
        CALL m.setAttribute("acceleratorKey3", key.trim())
    END IF
END FUNCTION

#+ Removes key bindings between item and mouse.
#+ @param id Item identifier.
FUNCTION drawClearButton(id)
    DEFINE id  INTEGER
    DEFINE m om.DomNode
    DEFINE doc om.DomDocument
    LET doc = ui.Interface.getDocument()
    LET m = doc.getElementById(id)
    IF m IS NOT NULL THEN
        CALL m.setAttribute("acceleratorKey1", "")
        CALL m.setAttribute("acceleratorKey3", "")
    END IF
END FUNCTION

#+ Sets a comment for a canvas item.
#+ @param id Item identifier.
#+ @param comment Comment to set.
FUNCTION drawSetComment(id, COMMENT)
    DEFINE id INTEGER
    DEFINE COMMENT String
    DEFINE m om.DomNode
    DEFINE doc om.DomDocument
    LET doc = ui.Interface.getDocument()
    LET m = doc.getElementById(id)
    IF m IS NOT NULL THEN
        CALL m.setAttribute("comment", comment.trim())
    END IF
END FUNCTION

#+ Returns the id of the last clicked canvas item.
FUNCTION drawGetClickedItemId()
    DEFINE doc om.DomDocument
    DEFINE n om.DomNode

    LET doc = ui.Interface.getDocument()
    LET n = doc.getDocumentElement()
    RETURN n.getAttribute("clickedCanvasItemId")
END FUNCTION



FUNCTION getFglDrawCanvas(canvasName)
    DEFINE canvasName String
    DEFINE i INTEGER
    DEFINE  l_child om.DomNode

    FOR i = 1 TO root.getChildCount()
        LET l_child = root.getChildByIndex(i)
        IF l_child.getAttribute("canvasName") = canvasName THEN
            RETURN l_child
            EXIT FOR
        END IF
    END FOR
    RETURN NULL
END FUNCTION



PRIVATE FUNCTION html_encode(s) -- this should be in util.strings
DEFINE s STRING
DEFINE sb base.StringBuffer

    LET sb = base.StringBuffer.create()
    CALL sb.append(s)
    CALL sb.replace("&","&amp;",0)
    CALL sb.replace("<","&lt;",0)
    CALL sb.replace(">","&gt;",0)
    RETURN sb.toString()
END FUNCTION
