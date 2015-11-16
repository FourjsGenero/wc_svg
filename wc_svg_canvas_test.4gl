# Property of Four Js*
# (c) Copyright Four Js 1995, 2015. All Rights Reserved.
# * Trademark of Four Js Development Tools Europe Ltd
#   in the United States and elsewhere
# 
# Four Js and its suppliers do not warrant or guarantee that these
# samples are accurate and suitable for your purposes. Their inclusion is
# purely for information purposes only.

#IMPORT FGL fgldraw
IMPORT FGL wc_svg_canvas
IMPORT FGL wc_svg



FUNCTION test_wc_svg_canvas()
DEFINE result INTEGER
  CALL drawInit()
  OPEN WINDOW canvas WITH FORM "wc_svg_canvas_test"
  CALL drawAll()
  MENU "Test"
    ON ACTION resize
        CALL drawall()
   
    COMMAND KEY(f5) 
      DISPLAY "blue, left" TO action
    COMMAND KEY(f6) 
      DISPLAY "blue, right" TO action
    COMMAND KEY(f7) 
      DISPLAY "green, left" TO action
    COMMAND KEY(f8) 
      DISPLAY "green, right" TO action
    COMMAND KEY(f120) 
      DISPLAY "text, left" TO action
    COMMAND KEY(f121) 
      DISPLAY "text, right" TO action
    COMMAND KEY(f220) 
      DISPLAY "yellow, left" TO action
    COMMAND KEY(f221) 
      DISPLAY "yellow, right" TO action
    COMMAND "Clear"
      CALL clearAll()
    COMMAND "Draw"
      CALL clearAll()
      CALL drawAll()
    COMMAND KEY(INTERRUPT) "Exit"
      EXIT MENU
  END MENU
  CLOSE WINDOW canvas
END FUNCTION

FUNCTION testRectangle()
  DEFINE id integer
  LET id=drawrectangle(0,0,250,500)
#  CALL drawSetComment(id,"This is a rectangle")
  CALL DrawFillColor("red")
  LET id=drawRectangle(0,500,250,500)
#  CALL drawSetComment(id,"This is a red rectangle")
  CALL DrawFillColor("green")
  LET id=drawRectangle(500,0,250,500)
#  CALL drawSetComment(id,"This is a green rectangle")
  CALL DrawFillColor("blue")
  LET id=drawRectangle(500,500,250,500)
#  CALL drawSetComment(id,"This is a blue rectangle")
  CALL DrawFillColor("yellow")
  LET id=drawRectangle(900,900,-500,-250)
#  CALL drawSetComment(id,"This is a yello rectangle")
end FUNCTION

FUNCTION drawAll()
  DEFINE id integer
  CALL drawselect("c1")
  CALL testRectangle()
  

  CALL drawselect("c2")
  LET id=drawLine(0,0,250,500)
  CALL DrawFillColor("red")
  LET id=drawLine(0,500,250,500)
  CALL DrawFillColor("green")
  LET id=drawLine(500,0,250,500)
  CALL DrawFillColor("blue")
  LET id=drawLine(500,500,250,500)
  CALL DrawFillColor("yellow")
  LET id=drawLine(900,900,-500,-250)

  CALL drawselect("c3")
  LET id=drawCircle(500+0,0,500)
  CALL DrawFillColor("red")
  LET id=drawCircle(500+0,500,500)
  CALL DrawFillColor("green")
  LET id=drawCircle(500+500,0,500)
  CALL DrawFillColor("blue")
  LET id=drawCircle(500+500,500,500)
  CALL DrawFillColor("yellow")
  LET id=drawCircle(900-500,900,-500)

  CALL drawselect("c5")
  LET id=drawArc(500+0,0,500,90,270)
  CALL DrawFillColor("red")
  LET id=drawArc(500+0,500,500,90,270)
  CALL DrawFillColor("green")
  LET id=drawArc(500+500,0,500,90,270)
  CALL DrawFillColor("blue")
  LET id=drawArc(500+500,500,500,90,270)
  CALL DrawFillColor("yellow")
  LET id=drawArc(900-500,900,-500,90,270)

  CALL drawselect("c4")
  LET id=drawOval(0,0,250,500)
  CALL DrawFillColor("red")
  LET id=drawOval(0,500,250,500)
  CALL DrawFillColor("green")
  LET id=drawOval(500,0,250,500)
  CALL DrawFillColor("blue")
  LET id=drawOval(500,500,250,500)
  CALL DrawFillColor("yellow")
  LET id=drawOval(900,900,-500,-250)

  CALL drawselect("c6")
  CALL DrawAnchor("sw")
  LET id=DrawText(500,500,"/sw")
  CALL DrawAnchor("ne")
  LET id=DrawText(500,500,"ne/")
  CALL DrawAnchor("se")
  LET id=DrawText(500,500,"se\\")
  CALL DrawAnchor("nw")
  LET id=DrawText(500,500,"\\nw")
  LET id=DrawLine(500,0,0,1000)
  LET id=DrawLine(0,500,1000,0)

  CALL DrawAnchor("s")
  LET id=DrawText(200,200,"s s")
  CALL DrawAnchor("n")
  LET id=DrawText(200,200,"n n")
  LET id=DrawLine(200,0,0,400)
  LET id=DrawLine(0,200,400,0)

  LET id=DrawLine(200,600,0,400)
  LET id=DrawLine(0,800,400,0)
  CALL DrawAnchor("e")
  LET id=DrawText(200,800,"eeeee>")
  CALL DrawAnchor("w")
  LET id=DrawText(200,800,"<wwww")

  CALL drawselect("c7")
  CALL DrawFillColor("green")
  LET id=DrawPolygon("100 100 900 100 800 900 100 800 500 500 100 100")
  CALL DrawFillColor("green")
  LET id=DrawPolygon("100 100 900 100 800 900 100 800 500 500 100 100")

  CALL drawselect("c8")
  CALL DrawAnchor("s")

  CALL DrawFillColor("blue")
  LET id=DrawRectangle(100,100,120,400)
 # CALL DrawButtonLeft(id,"f5")
 # CALL DrawButtonRight(id,"f6")

  CALL DrawFillColor("green")
  LET id=DrawRectangle(300,500,220,450)
 # CALL DrawButtonLeft(id,"f7")
 # CALL DrawButtonRight(id,"f8")

  CALL DrawFillColor("black")
  LET id=DrawText(600,400,"ClickMe")
 # CALL DrawButtonLeft(id,"f120")
 # CALL DrawButtonRight(id,"f121")

  CALL DrawFillColor("yellow")
  LET id=DrawOval(200,350,250,400)
 # CALL DrawButtonLeft(id,"f220")
 # CALL DrawButtonRight(id,"f221")

   
    CALL wc_svg.draw("formonly.c1", wc_svg_canvas.canvas_to_svg(getFglDrawCanvas("c1")))
    CALL wc_svg.draw("formonly.c2", wc_svg_canvas.canvas_to_svg(getFglDrawCanvas("c2")))
    CALL wc_svg.draw("formonly.c3", wc_svg_canvas.canvas_to_svg(getFglDrawCanvas("c3")))
    CALL wc_svg.draw("formonly.c4", wc_svg_canvas.canvas_to_svg(getFglDrawCanvas("c4")))
    CALL wc_svg.draw("formonly.c5", wc_svg_canvas.canvas_to_svg(getFglDrawCanvas("c5")))
    CALL wc_svg.draw("formonly.c6", wc_svg_canvas.canvas_to_svg(getFglDrawCanvas("c6")))
    CALL wc_svg.draw("formonly.c7", wc_svg_canvas.canvas_to_svg(getFglDrawCanvas("c7")))
    CALL wc_svg.draw("formonly.c8", wc_svg_canvas.canvas_to_svg(getFglDrawCanvas("c8")))

    

END FUNCTION

FUNCTION clearAll()
  CALL drawSelect("c1") CALL drawClear()
  CALL drawSelect("c2") CALL drawClear()
  CALL drawSelect("c3") CALL drawClear()
  CALL drawSelect("c4") CALL drawClear()
  CALL drawSelect("c5") CALL drawClear()
  CALL drawSelect("c6") CALL drawClear()
  CALL drawSelect("c7") CALL drawClear()
  CALL drawSelect("c8") CALL drawClear()
  CALL wc_svg.draw("formonly.c1", wc_svg_canvas.canvas_to_svg(getFglDrawCanvas("c1")))
    CALL wc_svg.draw("formonly.c2", wc_svg_canvas.canvas_to_svg(getFglDrawCanvas("c2")))
    CALL wc_svg.draw("formonly.c3", wc_svg_canvas.canvas_to_svg(getFglDrawCanvas("c3")))
    CALL wc_svg.draw("formonly.c4", wc_svg_canvas.canvas_to_svg(getFglDrawCanvas("c4")))
    CALL wc_svg.draw("formonly.c5", wc_svg_canvas.canvas_to_svg(getFglDrawCanvas("c5")))
    CALL wc_svg.draw("formonly.c6", wc_svg_canvas.canvas_to_svg(getFglDrawCanvas("c6")))
    CALL wc_svg.draw("formonly.c7", wc_svg_canvas.canvas_to_svg(getFglDrawCanvas("c7")))
    CALL wc_svg.draw("formonly.c8", wc_svg_canvas.canvas_to_svg(getFglDrawCanvas("c8")))
END FUNCTION

