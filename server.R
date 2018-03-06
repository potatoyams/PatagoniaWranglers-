library(shiny)
library(ggplot2)
library(ggmap)
library(gridExtra)
source("keys.R")
police_data <- read.csv("./data/Seattle_Police_Incident_2014-2017.csv")
#have source for scripts that get the crimeInfo
#have source for scripts that gets the heatMap
#have source for scripts that gets the broken down info?
my.server <- function(input, output) {
  userPoliceData <- reactive({
    return(filter(police_data, Summarized.Offense.Description == toupper(input$crimes), 
                  Year == as.numeric(input$year), District.Sector != "NULL", District.Sector != 99))
  })
  
  output$heatgraph <- renderPlot({
    MyMap <- get_map(location = "Seattle, WA", 
                     source = "google", maptype = "roadmap", crop = FALSE, zoom = 12, api_key = google.key)
    ggmap(MyMap) +
      stat_density2d(data = userPoliceData(), aes(x = Longitude, y = Latitude, fill = ..level.., alpha = ..level..),
                     geom = "polygon", size = 0.01, bins = 10) +
      scale_fill_gradient(low = "blue", high = "green") 
  })
  
  output$distsect <- renderPlot({
    ggplot(userPoliceData()) + 
      geom_bar(mapping = aes(x = District.Sector))
  })
  
  output$crimFreq <- renderPlot({
    # Finds unique values of crimes
    uniqueValues <- unique(police_data$Summarized.Offense.Description)
    # Creates a dataframe out of these crimes
    dat <- data.frame(police_data$Summarized.Offense.Description)
    # Counts crimes by their frequency in sightings
    countedCrimes <- as.data.frame((table(dat)))
    # Filters to most common types of shapes. The larger the number, the less things will show up on graph.
    # Will have to make 0 equal to user input. I was thinking something using Numeric output
    # https://shiny.rstudio.com/reference/shiny/latest/numericInput.html
    # https://shiny.rstudio.com/reference/shiny/latest/updateNumericInput.html
    # http://shiny.rstudio.com/gallery/kmeans-example.html 
    

    countedCrimes <- filter(countedCrimes, Freq >= input$min)
    
    qplot(countedCrimes$dat, countedCrimes$Freq, main = "Frequency & Type of Crime", xlab = "Crime Type", ylab = "Amount of Crimes") + coord_flip()
  })
  output$crimeCount <- renderTable({
    uniqueValues <- unique(police_data$Summarized.Offense.Description)
    # Creates a dataframe out of these crimes
    Crimes <- data.frame(police_data$Summarized.Offense.Description)
    # Counts crimes by their frequency in sightings
    countedCrimes <- as.data.frame((table(Crimes)))
    countedCrimes <- filter(countedCrimes, Freq >= input$min)
    countedCrimes
  })
}

shinyServer(my.server)