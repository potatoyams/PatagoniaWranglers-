library(shiny)
library(ggplot2)
library(ggmap)

#2014 - 2017 Police Data Used in Shiny App
police_data <- read.csv("./data/Seattle_Police_Incident_2014-2017.csv")
#Getting Map of Seattle using library(ggmap), using google as a source.
MyMap <- get_map(location = "Seattle, WA", 
                  source = "google", maptype = "roadmap", crop = FALSE, zoom = 12)
my.server <- function(input, output) {
  
  userPoliceData <- reactive({
    return(filter(police_data, Summarized.Offense.Description == toupper(input$crimes), 
                  Year == as.numeric(input$year), District.Sector != "NULL", District.Sector != 99))
  })
  
  countedCrimesData <- reactive({
    uniqueValues <- unique(police_data$Summarized.Offense.Description)
    # Creates a dataframe out of these crimes
    Crimes <- data.frame(police_data$Summarized.Offense.Description)
    # Counts crimes by their frequency in sightings
    countedCrimes <- as.data.frame((table(Crimes)))
    countedCrimes <- filter(countedCrimes, Freq >= input$min)
    return(countedCrimes)
  })
  
  output$heatgraph <- renderPlot({
    ggmap(MyMap) +
      stat_density2d(data = userPoliceData(), aes(x = Longitude, y = Latitude, fill = ..level.., alpha = ..level..),
                     geom = "polygon", size = 0.01, bins = 10) +
      scale_fill_gradient(low = "blue", high = "green") + labs(fill = "Intensity", alpha = "Gradient")
  })
  
  output$distsect <- renderPlot({
    ggplot(userPoliceData()) + 
      geom_bar(mapping = aes(x = District.Sector)) + ggtitle(paste("District Sector ", input$crimes, " Count", sep = "")) +
      ylab("Count") + xlab("District Sector")
  })
  
  output$crimFreq <- renderPlot({
    countedCrimes <- countedCrimesData()
    qplot(countedCrimes$Crimes, countedCrimes$Freq, main = "Frequency & Type of Crime", xlab = "Crime Type", ylab = "Amount of Crimes") + coord_flip()
  })
  
  output$crimeCount <- renderTable({
    countedCrimes <- countedCrimesData()
    countedCrimes <- arrange(countedCrimes, desc(Freq))
    totalCrime <- sum(countedCrimes$Freq)
    options(scipen = 999)
    countedCrimes <- mutate(countedCrimes, Percentage.Of.Crimes = paste(round((Freq/totalCrime * 100), 2), "%", sep = ""))
    countedCrimes
  })
}

shinyServer(my.server)