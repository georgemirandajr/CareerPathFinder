
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
packages <- c("dplyr", "tidyr", "lubridate", "knitr", "stringr", 
              "igraph", "networkD3", "shiny", "png", "shinyjs", 
              "visNetwork", "DT", "shinyLP")

sapply(packages, require, character.only = TRUE)

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
                           margin-right: -15px;
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
                                       list_item("How to use this app")
                                ),
                                column(3)
                            ),
                            
                            fluidRow(style = "height:250px;"
                            )
                            
                   ), # Closes the first tabPanel called "Home"
                   
                   tabPanel("Career PathFinder",
                            sidebarLayout(
                                sidebarPanel( width = 3,
                                              useShinyjs(),
                                              
                                              radioButtons("selectData", 
                                                           label = "How many years of data do you want to include?",
                                                           choices = c("30 Years",
                                                                       "15 Years"),
                                                           inline = TRUE,
                                                           width = "100%"
                                              ),
                                              selectizeInput("changeAvatar", "Change Avatar:",
                                                             choices = c("Dot" = "circle", 
                                                                         "Map Marker" = "map-marker", 
                                                                         "Pin" = "map-pin", 
                                                                         "Street View" = "street-view", 
                                                                         "User" = "user")
                                              ),
                                              uiOutput("tstAvatar")
                                              ,
                                              
                                              actionLink("settings", "Settings", icon = icon("sliders", class = "fa-2x"))
                                ),
                                mainPanel( width = 8,
                                           fluidRow(
                                               wellPanel(
                                                   tags$style(type="text/css",
                                                              ".shiny-output-error { visibility: hidden; }",
                                                              ".shiny-output-error:before { visibility: hidden; }"
                                                   ),
                                                   visNetwork::visNetworkOutput("visTest", height = "300px")
                                               )
                                           ),
                                           fluidRow(
                                               div(class="panel panel-default",
                                                   div(class="panel-body", 
                                                       tags$div(
                                                           align = "center",
                                                           actionButton("goBack", label = "", icon = icon("arrow-circle-left", class = "fa-2x")),
                                                           # actionButton("resetBtn", "Reset All", icon = icon("refresh", class = "fa-2x")),    
                                                           actionButton("btn1", label = "", icon = icon("arrow-circle-right", class = "fa-2x")),
                                                           checkboxInput('returnpdf', 'Save as PDF?', FALSE),
                                                           conditionalPanel(
                                                               condition = "input.returnpdf == true",
                                                               downloadLink('pdflink')
                                                           )
                                                       ),
                                                       # Insert Table Output
                                                       uiOutput("btns")
                                                   )
                                               ),
                                               fluidRow(
                                                   style = "height:150px;")
                                           )
                                )
                            )
                   ),  # Closes the second tabPanel called "Career PathFinder"
                   
                   
                   tabPanel("FAQ",
                            
                            fluidRow(
                                style = "height:100px;"),
                            
                            fluidRow(
                                column(3),
                                column(7)
                            )
                   ),
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
