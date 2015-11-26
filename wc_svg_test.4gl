IMPORT FGL wc_svg


IMPORT FGL wc_svg_canvas

DEFINE svg_root, grp, child wc_svg.svg_object

DEFINE fill wc_svg.fillType
DEFINE stroke wc_svg.strokeType
DEFINE font wc_svg.fontType
DEFINE transform wc_svg.transformType


MAIN
DEFINE svg_test STRING

    CLOSE WINDOW SCREEN

    OPEN WINDOW w WITH FORM "wc_svg_test"
    
    --CALL svg_html.append('<text x="200" y="175" >ABC<animateMotion path="M 0 0 L 100 100" dur="5s" fill="freeze"/></text>')

    INPUT BY NAME svg_test ATTRIBUTES(WITHOUT DEFAULTS=TRUE, UNBUFFERED)
        BEFORE INPUT
            LET svg_root = wc_svg.init()
            
            LET fill.colour = "red"
            LET stroke.colour = "black"
            LET stroke.width = 1
            
            LET child = wc_svg.add_rect(svg_root,0,0,100,100, fill.*, stroke.*)
            CALL wc_svg.add_action(child,"svg_click","Red Rectangle")

            
            
            LET fill.colour = "yellow"
            LET fill.opacity=0.5
            LET child = wc_svg.add_rect(svg_root,50,50,100,100, fill.*,stroke.*)
            CALL wc_svg.add_action(child,"svg_click","Yellow Rectangle")
            LET fill.opacity = 1
            
            LET fill.colour = "green"
            LET child = wc_svg.add_roundrect(svg_root,200,0,100,100,20,20, fill.*, stroke.*)
            
            CALL child.setAttribute("ontouchstart","execEvent(event,'mouse_down','')")
            CALL child.setAttribute("ontouchend","execEvent(event,'mouse_up','')")
            
            

            LET stroke.width = 0
            LET fill.colour = "cyan"
            LET child = wc_svg.add_circle(svg_root,200,200,50, fill.*, stroke.*)

            LET fill.colour = "magenta"
            LET child = wc_svg.add_ellipse(svg_root,100,200,50,25, fill.*, stroke.*)

            LET fill.colour = "orange"
            LET child = wc_svg.add_polygon(svg_root, "0,400 100,400 0,500", fill.*, stroke.*) 

            LET fill.colour = "none"
            LET stroke.colour = "black"
            LET stroke.width = 1
            LET child = wc_svg.add_polyline(svg_root, "200,300 300,300 200,400 200,300", fill.*, stroke.*) 

                     

            LET stroke.colour = "black"
            LET stroke.width = 5
            LET child = wc_svg.add_line(svg_root,100,100,200,200, stroke.*)



            LET stroke.colour = "black"
            LET stroke.width = 5
            LET stroke.linecap = "round"
            LET stroke.dasharray = "10,10"
            
            LET child = wc_svg.add_line(svg_root,100,200,200,100, stroke.*)

            INITIALIZE stroke.* TO NULL
            LET stroke.width = 1
            LET fill.colour = "lime"
            LET child = wc_svg.add_path(svg_root,"M100 400 L0 500 L100 500 Z", fill.*, stroke.*) 

            LET grp = wc_svg.add_group(svg_root)
            LET stroke.colour = "white"
            CALL wc_svg.add_stroke(grp,  stroke.*)

            INITIALIZE stroke.* TO NULL

            LET fill.colour = "red"
            LET child = wc_svg.add_slice(grp,200,400,50,50,0,36,fill.*, stroke.*)
            CALL wc_svg.add_action(child,"svg_click","10%")
            LET fill.colour = "green"
            LET child = wc_svg.add_slice(grp,200,400,50,50,36,108,fill.*, stroke.*)
            CALL wc_svg.add_action(child,"svg_click","20%")
            LET fill.colour = "blue"
            LET child = wc_svg.add_slice(grp,200,400,50,50,108,216,fill.*, stroke.*)
            CALL wc_svg.add_action(child,"svg_click","30%")
            LET fill.colour = "yellow"
            LET child = wc_svg.add_slice(grp,200,400,50,50,216,360,fill.*, stroke.*)
            CALL wc_svg.add_action(child,"svg_click","40%")
             
            INITIALIZE stroke.* TO NULL
            LET fill.colour = "black"
            LET child = wc_svg.add_text(svg_root,0,200,"Plain", "",fill.*, stroke.*, font.*)
            LET font.family = "Courier"
            LET child = wc_svg.add_text(svg_root,0,220,"Courier", "",fill.*, stroke.*, font.*)
            INITIALIZE font.family TO NULL
            LET font.weight = "bold"
            LET child = wc_svg.add_text(svg_root,0,240,"Bold", "",fill.*, stroke.*, font.*)
            INITIALIZE font.weight TO NULL
            LET font.style = "italic"
            LET child = wc_svg.add_text(svg_root,0,260,"Italic", "",fill.*, stroke.*, font.*)
            INITIALIZE font.style TO NULL
            LET font.size = "24"
            LET child = wc_svg.add_text(svg_root,0,280,"Big", "",fill.*, stroke.*, font.*)

            LET fill.colour = "yellow"
            LET stroke.colour = "black"
            LET stroke.width = 1
            LET font.family = "Courier"
            LET font.size = 48
            LET child = wc_svg.add_text(svg_root,0,320,"Fancy", "",fill.*, stroke.*, font.*)

            LET fill.colour = "black"
            INITIALIZE stroke.* TO NULL
            LET font.family = ""
            LET font.size = 9
            LET child = wc_svg.add_text(svg_root,40,340,"Start", "start",fill.*, stroke.*, font.*)
            LET child = wc_svg.add_text(svg_root,40,350,"Middle", "middle",fill.*, stroke.*, font.*)
            LET child = wc_svg.add_text(svg_root,40,360,"End", "end",fill.*, stroke.*, font.*)

            LET child = wc_svg.add_image(svg_root,50,200,100,100,"http://www.4js.com/templates/fourjs/images/fourjs_logo.png")

            LET fill.colour = "black"
            
            LET child = wc_svg.add_rect(svg_root,0,360,15,15, fill.*, stroke.*)
            
            LET child = wc_svg.add_rect(svg_root,20,360,15,15, fill.*, stroke.*)
            CALL wc_svg.add_translate(child,2,2)
          
            LET child = wc_svg.add_rect(svg_root,40,360,15,15, fill.*, stroke.*)
            CALL wc_svg.add_scale(child,0.5,2,40,360)
           
            LET child = wc_svg.add_rect(svg_root,60,360,15,15, fill.*, stroke.*)
            CALL wc_svg.add_rotate(child,45,60,360)
            
            LET child = wc_svg.add_rect(svg_root,80,360,15,15, fill.*, stroke.*)
            CALL wc_svg.add_skewX(child,10,80,360)

            LET child = wc_svg.add_rect(svg_root,100,360,15,15, fill.*, stroke.*)
            CALL wc_svg.add_skewY(child,10,100,360)

            LET child = wc_svg.add_rect(svg_root,120,360,15,15, fill.*, stroke.*)
            CALL wc_svg.add_scale(child,0.5,2,120,360)
            CALL wc_svg.add_rotate(child,-45,120,360)


          

            
            CALL wc_svg.draw("formonly.svg_test", svg_root)

        ON ACTION svg_click
            CALL FGL_WINMESSAGE("Info", svg_test,"info")

        ON ACTION mouse_down
            MESSAGE "Mouse Down",svg_test
        
            
        ON ACTION mouse_up
            MESSAGE "Mouse Up", svg_test

        ON ACTION pie_chart
            CALL pie_test()

        ON ACTION canvas_chart
            CALL test_wc_svg_canvas()
    END INPUT
END MAIN





