library(shiny)
library(dplyr)
library(DT)

# Define the UI
ui <- fluidPage(
  headerPanel("Searching Annotations"),
  # Input for the search term
  textInput("search_term", "GO Biological Process Search term:"),
  
  # Table to display the search results
  DTOutput("search_results")
)

# Define the server
server <- function(input, output) {
  # Load the data
  data <- read.csv("https://raw.githubusercontent.com/sr320/course-fish546-2023/main/output/blast_annot_go.tab", sep = '\t', header = TRUE)
  
  # Define a reactive expression to filter the data based on the search term
  filtered_data <- reactive({
    subset(data, grepl(input$search_term, Gene.Ontology..biological.process., ignore.case = TRUE))
  })
  
  # Display the search results in a table
  output$search_results <- renderDT({
    datatable(
      filtered_data(),
      options = list(searchHighlight = TRUE),
      escape = FALSE
    )
  })
}

# Run the app
shinyApp(ui, server)


