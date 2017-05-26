
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
library(dplyr)
library(stringr)
library(png)
library(shinyjs)
library(DT)
library(visNetwork)
library(rintrojs)

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
                            
                            shinyjs::useShinyjs(),
                            
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
                            
                            # A header level row for the title of the app (if needed)  
                            # fluidRow(
                            #     shiny::HTML("<br><br><center> <h1></h1> </center>
                            #                 <br>
                            #                 <br>"),
                            #     style = "height:250px;"),
                            
                            fluidRow(
                                
                                column(12,
                                       
                                       carouselPanel(
                                           # tags$a(href = "#FAQ", 
                                           #        tags$img(src = "screen_capture_absenteeism_2.jpg", width = "615px")), # experiment diff size img - fixed height 1080px and width 1900px
                                           tags$img(src = "Barbara.svg", width = "298px", height = "450px"),
                                           tags$img(src = "Dylan.svg", width = "298px", height = "450px"),
                                           tags$img(src = "Joseph.svg", width = "298px", height = "450px"),
                                           tags$img(src = "Matt.svg", width = "298px", height = "450px"),
                                           tags$img(src = "Parker.svg", width = "298px", height = "450px")
                                           # tags$a(href = "https://geom.shinyapps.io/word", tags$img(src = "screen_capture_word_2.jpg", width = "615px"))
                                           
                                       )
                                )
                            ),
                            
                            fluidRow(
                                
                                style = "height:50px;"),
                            
                            fluidRow(
                                style = "height:250px;",
                                shiny::HTML("<center> <h4><i>Are you looking to plan a career with the County?</i></h4> </center>"),
                                shiny::HTML("<center> <h4><i>Are you curious about the paths real County employees have taken?</i></h4></center>"),
                                shiny::HTML("<center> <h4><i>Then you're in the right place.</i></h4></center>"),
                                shiny::HTML("<center> <h1>Welcome to the Career PathFinder</h2></center>")
                            ),
                            
                            fluidRow(
                                
                                style = "height:50px;"),
                            
                            # PAGE BREAK
                            tags$hr(),
                            
                            # WHAT
                            fluidRow(
                                column(3),
                                column(6,
                                       shiny::HTML("<br><br><center> <h1>What you'll find here</h1> </center><br>"),
                                       shiny::HTML("<h5>An interactive tool to help you explore the actual paths employees 
                                            have taken during their County careers. With information about the 
                                            popularity of certain paths, salary differences, and more, you can 
                                            build your own path based on what is meaningful to you.</h5>")
                                ),
                                column(3)
                            ),
                            
                            fluidRow(
                                
                                style = "height:50px;"),
                            
                            # PAGE BREAK
                            tags$hr(),
                            
                            # HOW
                            fluidRow(
                                column(3),
                                column(6,
                                       shiny::HTML("<br><br><center> <h1>How it can help you</h1> </center><br>"),
                                       shiny::HTML("<h5>With most things, the more you know, the better your decisions 
                                                   will be. The Career PathFinder empowers you to make better decisions 
                                                   about a County career by being transparent about probable and 
                                                   possible career progressions here.</h5>")
                                ),
                                column(3)
                            ),
                            
                            fluidRow(
                                
                                style = "height:50px;"),
                            
                            # PAGE BREAK
                            tags$hr(),
                            
                            # WHERE
                            fluidRow(
                                column(3),
                                column(6,
                                       shiny::HTML("<br><br><center> <h1>Where it came from</h1> </center><br>"),
                                       shiny::HTML("<h5>Our team analyzed over 500 thousand County employee records 
                                                   from the past 30 years and transformed them into the information 
                                                   you will see in the Career PathFinder.</h5>")
                                ),
                                column(3)
                            ),
                            
                            fluidRow(
                                
                                style = "height:50px;"),
                            
                            # PAGE BREAK
                            tags$hr(),
                            
                            # HOW TO START
                            fluidRow(
                                column(3),
                                column(6,
                                       shiny::HTML("<br><br><center> <h1>How to get started</h1> </center><br>"),
                                       shiny::HTML("<h5>To launch the Career PathFinder, choose one of the options below. 
                                                   You will not be asked to provide any identifiable information, and 
                                                   you can revisit the Career PathFinder to chart a different course 
                                                   for yourself as needs arise.</h5>")
                                ),
                                column(3)
                            ),
                            
                            # BUTTONS TO START
                            fluidRow(
                                column(3),
                                column(6,
                                       
                                       tags$div(class = "wrap",
                                                div(class = "center", 
                                                    style="display: inline-block;vertical-align:top; width: 225px;",
                                                    tags$a("I need help finding a starting job to explore",
                                                           onclick = "window.open('https://www.governmentjobs.com/careers/lacounty/classspecs', '_blank')",
                                                           class="btn btn-primary btn-lg")
                                                ),
                                                div(class = "center",
                                                    style="display: inline-block;vertical-align:top; horizontal-align:middle; width: 75px;",
                                                    tags$br(), tags$h4("OR") ),
                                                div(class = "center",
                                                    style="display: inline-block;vertical-align:top; width: 225px;",
                                                    tags$a("I have a starting job I would like to explore", 
                                                           onclick="fakeClick('careerPF')", 
                                                           class="btn btn-primary btn-lg")
                                                )
                                       )
                                ),
                                column(3)
                            ),
                            
                            fluidRow(
                                
                                style = "height:50px;"),
                            
                            # PAGE BREAK
                            tags$hr(),
                            
                            # AFTERWARD
                            fluidRow(
                                column(3),
                                column(6,
                                       shiny::HTML("<br><br><center> <h1>What to do afterward</h1> </center><br>"),
                                       shiny::HTML("<h5>Building a career path is just one part of effective career 
                                                   planning and development. You should also establish a career plan 
                                                   to outline <i>how</i> you will achieve your professional goals. Our
                                                   Career Planning Guide provides information to help you establish 
                                                   a plan for making your career path a reality.</h5>")
                                ),
                                column(3)
                            ),
                            
                            fluidRow(
                                
                                style = "height:50px;"),
                            
                            # PAGE BREAK
                            tags$hr(),
                            
                            # TEAM BIO
                            fluidRow(
                                column(3),
                                column(6,
                                       shiny::HTML("<br><br><center> <h1>Who we are</h1> </center><br>"),
                                       shiny::HTML("<h5>The Career PathFinder is sponsored by the Los Angeles County 
                                                   Department of Human Resources, with financial support from the 
                                                   Quality and Productivity Commission. And here is a little information 
                                                   about the project team!</h5>")
                                ),
                                column(3)
                            ),
                            
                            fluidRow(
                                
                                style = "height:50px;"),
                            
                            fluidRow(
                                column(2),
                                
                                # Marc
                                column(2,
                                       div(class="panel panel-default", 
                                           div(class="panel-body",  width = "600px",
                                               align = "center",
                                               div(
                                                   tags$img(src = "man_beard(1).svg", 
                                                            width = "50px", height = "50px")
                                               ),
                                               div(
                                                   tags$h5("Marc"),
                                                   tags$h6( tags$i("Visionary & Project Lead"))
                                               ),
                                               div(
                                                   "My County career path started as a Human Resources Analyst."
                                               )
                                           )
                                       )
                                ),
                                # George
                                column(2,
                                       div(class="panel panel-default",
                                           div(class="panel-body",  width = "600px", 
                                               align = "center",
                                               div(
                                                   tags$img(src = "man.svg", 
                                                            width = "50px", height = "50px")
                                               ),
                                               div(
                                                   tags$h5("George"),
                                                   tags$h6( tags$i("Data Scientist & Programmer"))
                                               ),
                                               div(
                                                   "My County career path started as an Intermediate Typist Clerk."
                                               )
                                           )
                                       )
                                ),
                                # Angela
                                column(2,
                                       div(class="panel panel-default",
                                           div(class="panel-body",  width = "600px", 
                                               align = "center",
                                               div(
                                                   tags$img(src = "woman.svg", 
                                                            width = "50px", height = "50px")),
                                               div(
                                                   tags$h5("Angela"),
                                                   tags$h6( tags$i("Writer"))
                                               ),
                                               div(
                                                   "My County career path started as an Administrative Assistant."
                                               )
                                           )
                                       )
                                ),
                                # David
                                column(2,
                                       div(class="panel panel-default",
                                           div(class="panel-body",  width = "600px", 
                                               align = "center",
                                               div(
                                                   tags$img(src = "man_beard(1).svg", 
                                                            width = "50px", height = "50px")),
                                               div(
                                                   tags$h5("David"),
                                                   tags$h6( tags$i("Contributer"))
                                               ),
                                               div(
                                                   "My County career path started as a Human Resources Analyst."
                                               )
                                           )
                                       )
                                ),
                                column(2)
                                
                            ),
                            
                            # PAGE BREAK
                            tags$hr(),
                            
                            # Instructional Section
                            fluidRow(
                                shiny::HTML("<br><br><center> <h1>Career Planning Made Easy.</h1> </center>
                                            <br>")
                            ),
                            
                            fluidRow(
                                column(3),
                                
                                column(2,
                                       div(class="panel panel-default", 
                                           div(class="panel-body",  width = "600px",
                                               align = "center",
                                               div(
                                                   tags$img(src = "one.svg", 
                                                            width = "50px", height = "50px")
                                               ),
                                               div(
                                                   "Pick a job to start from. You may use your current job, or a job you're interested in."
                                               )
                                           )
                                       )
                                ),
                                column(2,
                                       div(class="panel panel-default",
                                           div(class="panel-body",  width = "600px", 
                                               align = "center",
                                               div(
                                                   tags$img(src = "two.svg", 
                                                            width = "50px", height = "50px")
                                               ),
                                               div(
                                                   "Then from that job, review other jobs that people have moved into during their careers. Review information about these choices and select your next career step."
                                               )
                                           )
                                       )
                                ),
                                column(2,
                                       div(class="panel panel-default",
                                           div(class="panel-body",  width = "600px", 
                                               align = "center",
                                               div(
                                                   tags$img(src = "three.svg", 
                                                            width = "50px", height = "50px")),
                                               div(
                                                   "Plan up to five steps out in your career. When you're ready, you may save or print out your personalized report."
                                               )
                                           )
                                       )
                                ),
                                column(3)
                                
                            ),
                            
                            
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
                            
                            # PAGE BREAK
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
                            fluidRow(style = "height:25px;"
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
                                                             
                                                             visNetwork::visNetworkOutput("visTest", height = "200px"),
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
                                           tags$li("The need for the Career PathFinder grew out of the fact that it is simply difficult to navigate the classification structure if you do not already know it or know someone who has gone through it."), 
                                           tags$li("The Workforce and Employee Development team wanted to help others help themselves by providing an online tool that sheds light on the otherwise invisible career paths in the County."), 
                                           tags$li("In 2016, the Los Angeles County Quality and Productivity Commission bestowed the seed money that got the ball rolling."),
                                           tags$li("We want to continue to provide training through the Los Angeles County University and help people see opportunity after taking a course to improve their skills."),
                                           tags$li("Now, and in the future, we want to be a magnet for top talent and be an employer of choice.")
                                       )
                                ),
                                column(3)
                            ),
                            fluidRow(
                                column(2),
                                column(8,
                                       # Panel for Background on Data
                                       div(class="panel panel-default",
                                           div(class="panel-body",  
                                               tags$div(
                                                   align = "center", 
                                                   "About the Data"
                                               ),
                                               tags$p("Over 30 years of data were collected, which resulted in nearly 500,000 records of career movement. Several business rules were developed to ensure the data reflected real opportunities in the current classification system."),
                                               tags$li("Any career movement within 30 days of a previous career movement was ignored. Although this represents a small percent of movement, these job transitions may have reflected data entry errors and may have skewed probabilities in jobs with a small number of incumbents."),
                                               tags$li("Multiple transfers within the same classification were ignored when there were 2 or more transfers to the same position. Although single transfers were counted, multiple transfers inflated the likelihood that the next step was a transfer."),
                                               tags$li("Expired classifications were removed from an individual's career path in the source data, because their path is no longer possible in the current system."),
                                               tags$li("Minor demotions were retained in the data to reflect deliberate career choices; however, demotions of a significant percent were excluded.")
                                           )
                                       ), # Closes div panel
                                       
                                       # Panel for Something else
                                       div(class="panel panel-default",
                                           div(class="panel-body", 
                                               tags$div(
                                                   align = "center", 
                                                   "Quality and Productivity Commission"
                                               ),
                                               tags$p("Sed laoreet turpis sit amet finibus pharetra. Ut congue, orci ut congue mollis, nisi turpis pretium augue, non lacinia augue ligula a dui. Aenean in neque vitae purus bibendum facilisis. ")
                                           )
                                       ) # Closes div panel
                                ), # Closes column
                                column(2)
                            ),
                            fluidRow(style = "height:150px;")
                   )  # Closes About tab
                   
)

)

