
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

# Initialize the user selections and tooltip (title)
selections <- vector(mode = "character", length = 0)

# Initialize empty data.frames for nodes and edges
nodes <- data.frame(id = integer(), label = character(), title = character(), 
                    shape = character(), icon.face = character(), icon.code = character(), 
                    color = character(), stringsAsFactors = FALSE)

# Initialize edges data
edges <- data.frame(from = numeric(), to = numeric(), length = numeric())

# Load all datasets
load("./data/item_pairs_30.rda")  # Load data  - old files end in rds, e.g., "item_pairs.rds"
load("./data/item_pairs_15.rda")
# load("./data/item_ref.rds")  
load("./data/item_ref_30.rda")
item_ref <- item_ref_30; rm(item_ref_30)

source("./www/getLink.R")

shinyServer(function(input, output, session) {
    
    # DT Options
    options(DT.options = list( lengthMenu = c(10, 20) ))
    
    # Intro JS ----------------------------------------------------------------
    observeEvent(input$help,
                 introjs(session, options = list("nextLabel"="Next",
                                                 "prevLabel"="Back",
                                                 "skipLabel"="Exit"))
    )
    
    # Select dataset -----------------------------------------------------------
    item_pairs <- reactive({
        switch(input$selectData,
               "30 Years" = item_pairs_30,
               "15 Years" = item_pairs_15)
    })
    
    # Initialize a variable to count how many times "btn1" is clicked.
    values <- reactiveValues(data = 1) 
    
    # Btn1 ---------------------------------------------------------------------
    # React to "btn1" being pressed by adding 1 to the values$data variable
    observeEvent( input$btn1, {
        if ( input$item_name == "" ) {
            showModal(modalDialog(title = "Pick a starting job first.",
                                  "It looks like you forgot to select a starting job. Please select a job from the drop-down
                                  menu to begin your career path.",
                                  easyClose = FALSE, size = "s" ))
        } else { 
            values$data = values$data + 1 }
        
    })
    
    # Go Back Button -----------------------------------------------------------

    observeEvent( input$goBack, {
        
        if (values$data <= 5) {
            enable("btn1")
        }

        values$data = values$data - 1
        
    })
    
    # Disable btn1 when step 5 is reached
    useShinyjs()
    observeEvent( input$btn1, {
        if( values$data == 5 )
            shinyjs::disable("btn1")
    })
    
    # Disable goBack button at start of session
    observe( 
        if(values$data == 1){
            disable("goBack")
        } else {
            enable("goBack")    
        }
    )
    
    # Show/Hide Settings -----------------------------------------------------------------
    # Hide settings at start of new Shiny session
    observe(c(hide("selectData"),
            hide("changeAvatar"),
            hide("changeColor"),
            hide("userName")
            ))
    
    # Toggle visibility of settings
    observeEvent(input$settings, {
        shinyjs::toggle("selectData", anim = TRUE)  # toggle is a shinyjs function
        shinyjs::toggle("changeAvatar", anim = TRUE)
        shinyjs::toggle("changeColor", anim = TRUE)
        shinyjs::toggle("userName", anim = TRUE)
    })
    
    # Determine which 'select' options to display (Input choices)
    output$btns <- renderUI({
        if (values$data == 0) {
            return()
        } else if (values$data == 1) {
            uiOutput("select1")
        } else if (values$data == 2) {
            dataTableOutput("select2")
        } else if (values$data == 3) {
            dataTableOutput("select3")
        } else if (values$data == 4) {
            dataTableOutput("select4")
        } else if (values$data >= 5) {
            dataTableOutput("select5")
        } 
    })
    
    # Reset Button -------------------------------------------------------------
    useShinyjs()
    observeEvent( input$resetBtn, {
        values$data = 1
        shinyjs::enable("btn1")
        selections <- vector(mode = "character", length = 0)
    })
    
    # Search NeoGov ------------------------------------------------------------
    link <- eventReactive(input$searchTerm, {
        
        addr <- getLink(input$searchTerm)  # create a hyperlink based on the text input
        
        paste0( "window.open('", addr, "', '_blank')" )  # this code opens the link in a separate window
    })
    
    output$searchNeo <- renderUI({
        actionButton("srchNeo", 
                     label = "Search", 
                     onclick = link(),
                     icon = icon("external-link"))  # when clicked, the link() code executes
    })
    
    # Select Input (First Job) -------------------------------------------------
    output$select1 <- renderUI({
        selectizeInput("item_name", label = "Step 1:",
                       choices = item_ref$TitleLong,
                       width = "100%",
                       options = list(
                           placeholder = 'Select the start of your path:',
                           onInitialize = I('function() { this.setValue(""); }'))
        )
    })
    
    # Table Inputs (Next 2-5 Selections) ---------------------------------------
    
    # Table 1 (Step 2)
    # eventReactive( input$item_name,
    top1 <- reactive({
        
        top <- dplyr::filter(item_pairs(), Item1Name == input$item_name) %>%
            select(Item2Name, Item2, Prob, SalaryDiff, Incumbents, Hyperlink)
    })
    
    output$select2 <- DT::renderDataTable({
        datatable( top1(), escape = FALSE, 
                   options = list(
                       lengthMenu = c(10, 20)),
                   selection = list(mode = 'single', target = 'row'),
                   colnames = c("Title", "Item Number", "%", "Salary Difference", "Incumbents", "Job Description"),
                   rownames = FALSE, style = "bootstrap", caption = "Step 2:"
        ) %>%
            formatCurrency('SalaryDiff') %>% 
            formatPercentage('Prob', 1)
    })
    
    outputOptions(output, "select2", suspendWhenHidden = FALSE)
    
    proxy1 = dataTableProxy('select2')
    
    # observeEvent(input$goBack, {
    #     proxy1 <- proxy1 %>% selectRows(NULL)
    #     # values$data <- values$data - 1
    # })
    
    # Table 2 (Step 3)
    # eventReactive( input$select2_cell_clicked, 
    top2 <- reactive({
        
        itemName <- top1()[ input$select2_rows_selected,  "Item2Name"]
        
        top <- dplyr::filter(item_pairs(), Item1Name == itemName) %>%
            select(Item2Name, Item2, Prob, SalaryDiff, Incumbents, Hyperlink)
        top
    })
    
    output$select3 <- DT::renderDataTable({
        datatable( top2(), escape = FALSE, options = list(lengthMenu = c(10, 20)),
                   selection = list(mode = 'single', target = 'row'),
                   colnames = c("Title", "Item Number", "%", "Salary Difference", "Incumbents", "Job Description"),
                   rownames = FALSE, style = "bootstrap", caption = "Step 3:"
        ) %>%
            formatCurrency('SalaryDiff') %>% 
            formatPercentage('Prob', 1)
    })
    
    outputOptions(output, "select3", suspendWhenHidden = FALSE)
    
    proxy2 = dataTableProxy('select3')
    
    # observeEvent(input$goBack, {
    #     proxy2 %>% selectRows(NULL)
    #     # values$data <- values$data - 1
    # })
    
    # Table 3 (Step 4)
    top3 <- reactive({
        
        itemName <- top2()[ input$select3_rows_selected,  "Item2Name"]
        
        top <- dplyr::filter(item_pairs(), Item1Name == itemName) %>%
            select(Item2Name, Item2, Prob, SalaryDiff, Incumbents, Hyperlink)
        top
    })
    
    output$select4 <- DT::renderDataTable({
        datatable( top3(), escape = FALSE, options = list(lengthMenu = c(10, 20)),
                   selection = list(mode = 'single', target = 'row'),
                   colnames = c("Title", "Item Number", "%", "Salary Difference", "Incumbents", "Job Description"),
                   rownames = FALSE, style = "bootstrap", caption = "Step 4:"
        ) %>%
            formatCurrency('SalaryDiff') %>% 
            formatPercentage('Prob', 1)
    })
    
    outputOptions(output, "select4", suspendWhenHidden = FALSE)
    
    proxy3 = dataTableProxy('select4')
    
    # observeEvent(input$goBack, {
    #     proxy3 %>% selectRows(NULL)
    #     # values$data <- values$data - 1
    # })
    
    # Table 4 (Step 5)
    top4 <- reactive({
        
        itemName <- top3()[ input$select4_rows_selected,  "Item2Name"]
        
        top <- dplyr::filter(item_pairs(), Item1Name == itemName) %>%
            select(Item2Name, Item2, Prob, SalaryDiff, Incumbents, Hyperlink)
        top
    })
    
    output$select5 <- DT::renderDataTable({
        datatable( top4(), escape = FALSE, options = list(lengthMenu = c(10, 20)),
                   selection = list(mode = 'single', target = 'row'),
                   colnames = c("Title", "Item Number", "%", "Salary Difference", "Incumbents", "Job Description"),
                   rownames = FALSE, style = "bootstrap", caption = "Step 5:"
        ) %>%
            formatCurrency('SalaryDiff') %>% 
            formatPercentage('Prob', 1)
    })
    
    outputOptions(output, "select5", suspendWhenHidden = FALSE)
    
    proxy4 = dataTableProxy('select5')
    
    # observeEvent(input$goBack, {
    #     proxy4 <- proxy4 %>% selectRows(NULL)
    #     # values$data <- values$data - 1
    # })
    
    # Test the outputs by printing to screen -----------------------------------
    output$printSel <- renderPrint({
        paste("Value of Btn1 is:", values$data)
    })
    
    output$printInput1 <- renderText({
        paste("First selection is:", input$item_name)
    })
    
    output$printTbl1 <- renderPrint({
        paste("Row selected from Table 1 is:", input$select2_rows_selected,
              "and the selection is:", top1()[ input$select2_rows_selected,  "Item2Name"])
    })
    
    output$printTbl2 <- renderPrint({
        paste("Row selected from Table 2 is:", input$select3_rows_selected,
              "and the selection is:", top2()[ input$select3_rows_selected,  "Item2Name"])
    })
    
    output$printTbl3 <- renderPrint({
        paste("Row selected from Table 3 is:", input$select4_rows_selected,
              "and the selection is:", top3()[ input$select4_rows_selected,  "Item2Name"])
    })
    
    
    output$printTbl4 <- renderPrint({
        paste("Row selected from Table 4 is:", input$select5_rows_selected,
              "and the selection is:", top4()[ input$select5_rows_selected,  "Item2Name"])
    })
    
    output$printNodeTbl <- renderTable(visNode())
    output$printEdgeTbl <- renderTable(visEdge())
    
    
    # Visualization ------------------------------------------------------------
    
    # Avatar to use in the visualization
    avatar <- reactive({
        switch(input$changeAvatar,
               "circle" = "f2be",
               "map-marker" = "f041",
               "rocket" = "f135",
               "street-view" = "f21d",
               "leaf" = "f06c")
    })
    
    colorIcon <- reactive({
        switch(input$changeColor,
               "blue" = "#97C2FC",
               "green" = "#10d13a", 
               "red" = "#f44141",     
               "black" = "#000000")     
    })
    
    visNode <- reactive({
        
        item_name1 <- input$item_name  
        item_name2 <- try( top1()[ input$select2_rows_selected,  "Item2Name"], TRUE ) 
        item_name3 <- try( top2()[ input$select3_rows_selected,  "Item2Name"], TRUE ) 
        item_name4 <- try( top3()[ input$select4_rows_selected,  "Item2Name"], TRUE ) 
        item_name5 <- try( top4()[ input$select5_rows_selected,  "Item2Name"], TRUE ) 
        
        # Collect user selections
        selections <- append(selections,
                             c(item_name1, item_name2, item_name3,
                               item_name4, item_name5))
        
        # Add selections to data.frame
        nodes[1:length(selections),2] <- selections
        
        # Add id
        nodes$id <- 1:length(selections)
        
        # Add icons, which requires defining 3 properties
        nodes$shape <- rep("icon", length(selections))
        nodes$icon.face <- rep('fontAwesome', length(selections))
        nodes$icon.code <- rep(avatar(), length(selections))
        nodes$color <- rep(colorIcon(), length(selections))
        
        # Add shadow
        nodes$shadow <- TRUE
        
        # Keep only the rows that don't have errors
        nodes <- nodes[grep("Error", nodes$label, invert = TRUE),]
        
        # Keep rows that are not NA in Label column
        nodes <- nodes[ !is.na(nodes$label), ]  
        
    })
    
    visEdge <- reactive({
        
        num_selections <- nrow( visNode() )
        
        if ( num_selections > 0)
            for ( i in 1:(num_selections-1) ) {
                edges[i, ] <- c( i, i+1, 200)
            }
        edges
    })
    
    # Creating the dynamic graph
    output$visTest <- visNetwork::renderVisNetwork({
        
        visNetwork::visNetwork(visNode(), visEdge(), height = "100px", width = "100%") %>%
            addFontAwesome() %>%
            visNetwork::visEdges(dashes = TRUE, shadow = TRUE, 
                                 arrows = list(to = list(enabled = TRUE, scaleFactor = 2)),
                                 color = list(color = "#587fb4", highlight = "red")) %>%
            visNodes(shadow = list(enabled = TRUE, size = 15)) %>%
            visHierarchicalLayout(direction = "LR", levelSeparation = 220,
                                  parentCentralization = FALSE)
        # visLayout(randomSeed = 129)
    })
    
})
