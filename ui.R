
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
packages <- c("dplyr", "tidyr", "lubridate", "knitr", "stringr", 
              "igraph", "networkD3", "shiny", "png", "shinyjs", 
              "visNetwork", "DT", "rintrojs")

sapply(packages, require, character.only = TRUE)

library(rintrojs)
library(shinyLP)

source("carouselPanel.R")

shinyUI(navbarPage(title = "",
                   theme = "paper.css",
                   collapsible = TRUE,
                   inverse = TRUE,
                   windowTitle = "Los Angeles County Career PathFinder",
                   position = "fixed-top",
                   header = tags$style(
                       ".navbar-right {
                           float: right !important;
                       }",
                       "body {padding-top: 100px;}"),
                   
                   tabPanel("Home",
                            
                            fluidRow(
                                shiny::HTML("<br><br><center> <h1>Career PathFinder</h1> </center>
                                            <br>
                                            <br>"),
                                style = "height:250px;"),
                            
                            fluidRow(
                                
                                column(2),
                                
                                column(3,
                                       
                                       h3("Explore Careers"),
                                       h5("Discover the right path for you by leveraging over 30 years of County career data")
                                ),
                                column(5,
                                       
                                       carouselPanel(auto.advance=F,
                                                     tags$a(href = "#FAQ", tags$img(src = "screen_capture_absenteeism_2.jpg", width = "615px")), # experiment diff size img - fixed height 1080px and width 1900px
                                                     
                                                     tags$a(href = "https://geom.shinyapps.io/word", tags$img(src = "screen_capture_word_2.jpg", width = "615px"))
                                                     
                                       )
                                )
                            ),
                            
                            fluidRow(
                                
                                style = "height:250px;"),
                            
                            tags$hr(),
                            
                            fluidRow(
                                shiny::HTML("<br><br><center> <h1>Career Planning Made Easy.</h1> </center>
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
                            
                            fluidRow(style = "height:250px;"
                            )
                            
                   ), # Closes the first tabPanel called "Home"
                   
                   tabPanel("Career PathFinder",
                            
                            sidebarLayout(
                                
                                sidebarPanel( width = 3,
                                              introjsUI(),
                                              
                                              useShinyjs(),
                                              
                                              radioButtons("selectData", 
                                                           label = "How many years of data do you want to include?",
                                                           choices = c("30 Years",
                                                                       "15 Years"),
                                                           inline = TRUE,
                                                           width = "100%"
                                              ),
                                              selectizeInput("changeAvatar", "Change Avatar:",
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
                                              
                                              uiOutput("tstAvatar")
                                              ,
                                              introBox(
                                                  actionLink("settings", "Settings", 
                                                             icon = icon("sliders", class = "fa-2x")),
                                                  br(),
                                                  actionButton("help", "Take a Quick Tour"),
                                                  uiOutput("printInput1"),
                                                  data.step = 5,
                                                  data.intro = "Settings is where you can set options that affect the graph and career statistics."
                                              )
                                ),
                                mainPanel( width = 8,
                                           fluidRow(
                                               wellPanel(
                                                   tags$style(type="text/css",
                                                              ".shiny-output-error { visibility: hidden; }",
                                                              ".shiny-output-error:before { visibility: hidden; }"
                                                   ),
                                                   introBox(
                                                       visNetwork::visNetworkOutput("visTest", height = "300px"),
                                                       data.step = 4,
                                                       data.intro = "Your selections will be displayed here in a graph."
                                                   )
                                               )
                                           ),
                                           fluidRow(
                                               div(class="panel panel-default",
                                                   div(class="panel-body",  width = "600px",
                                                       tags$div(
                                                           align = "center",
                                                           div(style="display: inline-block;vertical-align:top; width: 150px;",
                                                               introBox(
                                                                   actionButton("goBack", 
                                                                                label = "Step Back", 
                                                                                icon = icon("arrow-circle-left", class = "fa-2x")),
                                                                   data.step = 3,
                                                                   data.intro = "Clear your current selection and go back a step."
                                                               )
                                                           ),
                                                           # div(style="display: inline-block;vertical-align:top; width: 150px;",
                                                           #     uiOutput("clearBtns")
                                                           # ),
                                                           # actionButton("resetBtn", "Reset All", icon = icon("refresh", class = "fa-2x")),    
                                                           div(style="display: inline-block;vertical-align:top; width: 150px;",
                                                               introBox(
                                                                   actionButton("btn1", 
                                                                                label = "Add", 
                                                                                icon = icon("arrow-circle-right", class = "fa-2x")),
                                                                   data.step = 2,
                                                                   data.intro = "Confirm your selection by clicking here."
                                                               )
                                                           ),
                                                           checkboxInput('returnpdf', 'Save as PDF?', FALSE),
                                                           conditionalPanel(
                                                               condition = "input.returnpdf == true",
                                                               downloadLink('pdflink')
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
                                                   style = "height:150px;")
                                           )
                                )
                            )
                   ),  # Closes the second tabPanel called "Career PathFinder"
                   
                   tabPanel("About",
                            
                            fluidRow(
                                style = "height:100px;"),
                            
                            fluidRow(
                                column(5),
                                column(5,
                                       h3("Awards", icon("trophy", "fa-4x")),
                                       h5(em("Gold Eagle Award, 2018")), 
                                       h5("Quality & Productivity Commission")
                                       
                                )
                            )
                            
                   )
                   
)
)
