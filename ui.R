
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
packages <- c("dplyr", "knitr", "stringr", 
              "networkD3", "shiny", "png", "shinyjs", 
              "visNetwork", "DT", "rintrojs")

sapply(packages, require, character.only = TRUE)

library(rintrojs)
library(shinyLP)

source("carouselPanel.R")

shinyUI(navbarPage(title = "", id = "navBar",
                   theme = "paper.css",
                   collapsible = TRUE,
                   inverse = TRUE,
                   windowTitle = "Los Angeles County Career PathFinder",
                   position = "fixed-top",
                   footer = includeHTML("./www/include_footer.html"),
                   header = tags$style(
                       ".navbar-right {
                           float: right !important;
                       }",
                       "body {padding-top: 100px;}"),
                   
                   tabPanel("Home", value = "home",
                            
                            
                            tags$head(tags$script(HTML('
                                var fakeClick = function(tabName) {
                                  var dropdownList = document.getElementsByTagName("a");
                                  for (var i = 0; i < dropdownList.length; i++) {
                                    var link = dropdownList[i];
                                    if(link.getAttribute("data-value") == tabName) {
                                      link.click();
                                    };
                                  }
                                };
                              '))),
                            
                            fluidRow(
                                shiny::HTML("<br><br><center> <h1>Career PathFinder</h1> </center>
                                            <br>
                                            <br>"),
                                style = "height:250px;"),
                            
                            fluidRow(
                                
                                column(2),
                                
                                column(3,
                                       
                                       HTML("<h3>What <span style='font-weight:bold'>career planning</span> questions are you looking to answer?</h3>"),
                                       
                                       h5("Discover the right path for you by leveraging over 30 years of County career data")
                                ),
                                column(5,
                                       
                                       carouselPanel(auto.advance=F,
                                                     tags$a(href = "#FAQ", 
                                                            tags$img(src = "screen_capture_absenteeism_2.jpg", width = "615px")), # experiment diff size img - fixed height 1080px and width 1900px
                                                     
                                                     tags$a(href = "https://geom.shinyapps.io/word", tags$img(src = "screen_capture_word_2.jpg", width = "615px"))
                                                     
                                       )
                                )
                            ),
                            
                            fluidRow(
                                
                                style = "height:50px;"),
                            
                            tags$hr(),
                            
                            fluidRow(
                                shiny::HTML("<br><br><center> <h1>Career Planning Made Easy.</h1> </center>
                                            <br>")
                            ),
                            # Brief Instructions
                            fluidRow(
                                column(3),
                                
                                column(2,
                                       div(class="panel panel-default",
                                           div(class="panel-body",  width = "600px",
                                               tags$div( 
                                                   align = "center",
                                                   tags$img(src = "one.svg", 
                                                            width = "50px", height = "50px"),
                                                   "Pick your starting classification"
                                               )))
                                ),
                                column(2,
                                       div(class="panel panel-default",
                                           div(class="panel-body",  width = "600px",
                                               tags$div(
                                                   align = "center",
                                                   tags$img(src = "two.svg", 
                                                            width = "50px", height = "50px"),
                                                   "Review your choices and select your next career step"
                                               )))
                                ),
                                column(2,
                                       div(class="panel panel-default",
                                           div(class="panel-body",  width = "600px",
                                               tags$div(
                                                   align = "center",
                                                   tags$img(src = "three.svg", 
                                                            width = "50px", height = "50px"),
                                                   "Continue until you're ready to print out your personalized report"
                                               )))
                                ),
                                column(3),
                                
                                style = "height:250px;"),
                            
                            fluidRow(
                                column(3),
                                column(6,
                                       tags$embed(src = "https://player.vimeo.com/video/8419440",
                                                  width = "640", height = "360")
                                ),
                                column(3)
                            ),
                            
                            fluidRow(
                                
                                style = "height:50px;"),
                            
                            tags$hr(),
                            
                            fluidRow(
                                shiny::HTML("<br><br><center> <h1>Start Planning Today.</h1> </center>
                                            <br>")
                            ),
                            
                            fluidRow(
                                column(3),
                                column(6, 
                                       wellPanel("If you are unsure about how to start your career path, you can browse through job descriptions at", tags$a("governmentjobs.com", href = "https://www.governmentjobs.com/careers/lacounty/classspecs" )),
                                       textInput("searchTerm", label = "Search Jobs:",
                                                 value = "...",
                                                 width = "100%"
                                                 
                                       ),
                                       uiOutput("searchNeo")
                                ),
                                column(3)
                            ),
                            
                            fluidRow(style = "height:100px;"
                            ),
                            fluidRow(shiny::HTML("<br><br><center> <h1>Ready to Get Started?</h1> </center>
                                            <br>")
                            ),
                            fluidRow(
                                column(3),
                                column(6,
                                       tags$div(align = "center", 
                                                tags$a("Start", 
                                                       onclick="fakeClick('careerPF')", 
                                                       class="btn btn-primary btn-lg")
                                       )
                                ),
                                column(3)
                            ),
                            fluidRow(style = "height:250px;"
                            )
                            
                   ), # Closes the first tabPanel called "Home"
                   
                   tabPanel("Career PathFinder", value = "careerPF",
                            
                            sidebarLayout(
                                
                                sidebarPanel( width = 3,
                                              introjsUI(),
                                              
                                              tags$div(
                                                  actionButton("help", "Take a Quick Tour"),
                                                  style = "height:50px;"
                                              ),
                                              useShinyjs(),
                                              
                                              tags$div(
                                                  style = "height:50px;",
                                              radioButtons("selectData", 
                                                           label = "How many years of data do you want to include?",
                                                           choices = c("30 Years",
                                                                       "15 Years"),
                                                           inline = TRUE,
                                                           width = "100%"
                                              ),
                                              selectizeInput("changeAvatar", "Change Icon:",
                                                             choices = c("Circle" = "circle", 
                                                                         "Map Marker" = "map-marker", 
                                                                         "Rocket" = "rocket", 
                                                                         "Street View" = "street-view", 
                                                                         "Leaf" = "leaf")
                                              ),
                                              selectizeInput("changeColor", "Icon Color:",
                                                             choices = c("Blue" = "blue", 
                                                                         "Green" = "green", 
                                                                         "Red" = "red",
                                                                         "Black" = "black")
                                              ),
                                              textInput("userName", "Add your name:", value = ""),
                                              
                                              introBox(
                                                  tags$div(
                                                      style = "height:50px;",
                                                  actionLink("settings", "Settings", 
                                                             icon = icon("sliders", class = "fa-2x"))),
                                                  
                                                  tags$div(
                                                      style = "height:50px;",
                                                  
                                                  uiOutput("printInput1"),
                                                  uiOutput("printInput2"),
                                                  uiOutput("printInput3"),
                                                  uiOutput("printInput4"),
                                                  uiOutput("printInput5")
                                                  ),
                                                  data.step = 5,
                                                  data.intro = "Settings is where you can set options that affect the graph and career statistics."
                                              )
                                              )
                                ),
                                mainPanel( width = 8,
                                           fluidRow(
                                               wellPanel(uiOutput("displayName"),
                                                         tags$style(type="text/css",
                                                                    ".shiny-output-error { visibility: hidden; }",
                                                                    ".shiny-output-error:before { visibility: hidden; }"
                                                         ),
                                                         introBox(
                                                             
                                                             visNetwork::visNetworkOutput("visTest", height = "250px"),
                                                             data.step = 4,
                                                             data.intro = "Your selections will be displayed here in a graph."
                                                         )
                                               )
                                           ),
                                           fluidRow(
                                               div(class="panel panel-default",
                                                   div(class="panel-body",  width = "600px",
                                                       tags$div(class = "wrap",
                                                                div(class = "left", 
                                                                    style="display: inline-block;vertical-align:top; width: 150px;",
                                                                    uiOutput("stepNo")
                                                                ),
                                                                div(class = "right",
                                                                    style="display: inline-block;vertical-align:top; width: 150px;",
                                                                    checkboxInput('returnpdf', 'Save as PDF?', FALSE),
                                                                    uiOutput("download")
                                                                ),
                                                                div(class = "center",
                                                                    style="display: inline-block;vertical-align:top; width: 150px;",
                                                                    introBox(
                                                                        actionButton("goBack", 
                                                                                     label = "Back", 
                                                                                     icon = icon("arrow-circle-left", class = "fa-2x"),
                                                                                     width= "100px", height= "40px"),
                                                                        data.step = 3,
                                                                        data.intro = "Go back a step to edit your selection anytime."
                                                                    )
                                                                ),
                                                                # div(style="display: inline-block;vertical-align:top; width: 150px;",
                                                                #     uiOutput("clearBtns")
                                                                # ),
                                                                # actionButton("resetBtn", "Reset All", icon = icon("refresh", class = "fa-2x")),    
                                                                div(class = "center",
                                                                    style="display: inline-block;vertical-align:top; width: 150px;",
                                                                    introBox(
                                                                        actionButton("btn1", 
                                                                                     label = "Add", 
                                                                                     icon = icon("arrow-circle-right", class = "fa-2x"),
                                                                                     width= "100px", height= "40px"),
                                                                        data.step = 2,
                                                                        data.intro = "Confirm your selection by clicking here."
                                                                    )
                                                                )
                                                       ),
                                                       # Insert Table Output
                                                       introBox(
                                                           uiOutput("btns"),
                                                           data.step = 1, 
                                                           data.intro = "Start by selecting your first career choice from our list of over 2,000 current job classifications."
                                                       )
                                                   )
                                               ),
                                               fluidRow(
                                                   style = "height:150px;"),
                                               plotOutput("myplot")
                                           )
                                )
                            )
                   ),  # Closes the second tabPanel called "Career PathFinder"
                   
                   tabPanel("About", value = "about",
                            
                            fluidRow(
                                shiny::HTML("<br><br><center> 
                                            <h1>About Career PathFinder</h1> 
                                            <h4>What's behind the data.</h4>
                                            </center>
                                            <br>
                                            <br>"),
                                style = "height:250px;"),
                            fluidRow(
                                div(align = "center",
                                    tags$span(h4("A Brief History of Los Angeles County's Career PathFinder"), 
                                              style = "font-weight:bold"
                                    ))
                            ),
                            fluidRow(
                                column(3),
                                column(6,
                                       tags$ul(
                                           tags$li("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce at efficitur dui. Duis convallis facilisis pretium. Vestibulum maximus suscipit eleifend. Sed odio ex, tempor a mauris faucibus, vestibulum ullamcorper sapien. Sed ornare bibendum tortor, non venenatis neque placerat at."), 
                                           tags$li("Aliquam cursus pellentesque augue, eu sagittis nisi feugiat vel. Nunc a ultrices sapien, ac mollis velit. "), 
                                           tags$li("Sed laoreet turpis sit amet finibus pharetra. Ut congue, orci ut congue mollis, nisi turpis pretium augue, non lacinia augue ligula a dui. Aenean in neque vitae purus bibendum facilisis. ")
                                       )
                                ),
                                column(3)
                            ),
                            fluidRow(
                                column(2),
                                column(8,
                                       # Panel for WED
                                       div(class="panel panel-default",
                                           div(class="panel-body",  
                                               tags$div(
                                                   align = "center", 
                                                   "Workforce and Employee Development Team"
                                               )
                                           )
                                       ), # Closes div panel
                                       
                                       # Panel for Something else
                                       div(class="panel panel-default",
                                           div(class="panel-body", 
                                               tags$div(
                                                   align = "center", 
                                                   "Quality and Productivity Commission"
                                               )
                                           )
                                       ) # Closes div panel
                                ), # Closes column
                                column(2)
                            ),
                            fluidRow(style = "height:150px;")
                   )  # Closes About tab
                   
)

)

