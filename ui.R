library(dplyr)
library(shiny)

my.ui <- fluidPage(
  navbarPage("crimeApp",
             tabPanel(
               "Introduction",
               titlePanel("Introduction"),
               mainPanel(
                 textOutput("introduction")
               )
             ),
             tabPanel(
               "Heatgraph",
               titlePanel("Notable Crimes in Seattle"),
               sidebarLayout(
                 sidebarPanel(
                   selectInput("crimes", "Notable Crimes", choices = 
                                 c("Homicide", "Prostitution", "Assault", "Robbery", 
                                   "Trespass", "Pornography", "Threats", "Stolen Property", "Narcotics", "Dui")),
                   sliderInput("year", "Select Year", min = 2014, max = 2017, value = 2015, sep = "")
                   ),
                 mainPanel(
                   plotOutput("heatgraph"),
                   textOutput("crimeInfo"),
                   plotOutput("distsect")
                   )
                 )
             ),
             tabPanel(
               "Crimecount",
               sidebarLayout(
               sidebarPanel(
                 numericInput("min", "Minimum Frequency Crime", 1000, min = 1000)
               ),
               mainPanel(
                 align = "center",
                 plotOutput("crimFreq"),
                 tableOutput("crimeCount")
               )
             )
             )
  )
)

shinyUI(my.ui)
