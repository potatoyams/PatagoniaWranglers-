library(dplyr)
library(shiny)

my.ui <- fluidPage(
  navbarPage("crimeApp",
             tabPanel(
               "Introduction",
               titlePanel("Introduction"),
               mainPanel(
                 p("With the growth of Seattle to become a major metropolitan area over the 
                   last few years, more and more new people are moving into the area. 
                   Consequently, there are more and more people curious about the rates of 
                   crime in Seattle. Through this application, we seek to quantify and show the 
                   amount of crimes occurring in Seattle as well as where they are occurring. 
                   We feel that stakeholders in the greater Seattle area should be able to 
                   easily understand what kind of crimes are occurring where, and the amount 
                   of crimes that have occurred over the past four years."),
                 h3("Our Data"),
                 p(HTML("We discovered a data set containing information on crimes that have occurred 
                   in the City of Seattle between 2014 and 2017, see full dataset 
                   <a href = 'https://data.seattle.gov/Public-Safety/Seattle-Police-Department-Police-Report-Incident/7ais-f98f' target = '_blank'>here</a>. 
                   This dataset was originally created by XYZ, 
                   who collected the data from the City of Seattle to allow the public to be aware of what is going on in the city.")),
                 h3("Our Audience"),
                 p("Our primary target audience is people who live in Seattle and those who are curious 
                   about either traveling to Seattle or moving to Seattle. By providing people with this data, 
                   they can make decisions about where in Seattle they want to live or visit."),
                 h3("Inspirations to look deeper"),
                 p("With so many people moving into Seattle and now interested in Seattle, there were plenty of 
                   questions that we believed could be answered through our data sets. 
                   Some questions we believe could be answered and could provide valuable results include: "),
                 tags$ul("Which districts of Seattle had more crime than others?"),
                 tags$ul("How many crimes in total occurred over the course of the dataset?"),
                 tags$ul("Did certain years have greater prevalence of one crime than another crime?"),
                 tags$ul("What percentage did each crime constitute of total crime within the City of Seattle??"),
                 h3("Displaying our Findings/ Our Data Visualizations:"),
                 p("In order to answer the questions listed above, we created data visualizations that visually 
                   represent the answers."),
                 h4("Map of Crime & Data Table of Crime by District"),
                 p("We created a map of XYZ types of crime in Seattle between 2014 and 2017. Our aim was to see visible 
                   differences on our heatmap of the frequency of crimes as well as where they occurred. Additionally, 
                   we created a data table that revealed which crimes occurred in which district.  
                   From this, we will be able to derive insights into which crimes occurred where in the city and with 
                   what frequency. We will also be able to assess which district these crimes were most common in."),
                 h4("Data Table and Graph of All Crimes "),
                 p("We also created an interactive graph and table for the user allowing them to filter by amount of the 
                   types of a crime that has occurred. In addition, this will tell them what percentage of total crime the 
                   crimes above the number which they filtered out by constitute. From this, we can see the total number of 
                   crimes in the City of Seattle, as well as which crimes were the most common. ")
               )
             ),
             tabPanel(
               "Heatgraph",
               titlePanel("Notable Crimes in Seattle"),
               sidebarLayout(
                 sidebarPanel(
                   selectInput("crimes", "Notable Crimes", choices = 
                                 c("Homicide", "Prostitution", "Assault", "Robbery", 
                                   "Trespass", "Threats", "Stolen Property", "Narcotics", "Dui")),
                   sliderInput("year", "Select Year", min = 2014, max = 2017, value = 2015, sep = ""),
                   h5("District Sector: "),
                   img(src="http://seattlepolice.org/assets/img/precinctmap.png", 
                       height = "80%", width = "80%")
                   ),
                 mainPanel(
                   plotOutput("heatgraph"),
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
             ),
             tabPanel(
               "Conclusion",
               titlePanel("Our Findings"),
               h3("What We See"),
               p("We were able to discover trends across multiple sets of crimes that we’ve specifically chosen using intensity. 
                 As an example, if we look at the homicide data in our heat map, starting in 2014, the intensity of the data only
                 ranged up to around 150. As we continue the years to 2017, the intensity goes to roughly 250, 500, and lastly 600.
                 Homicide was not the only one subjected to this trend. Other crimes like prostitution, trespassing, threats, and 
                 narcotics saw a similar increase in intensity. Intensity is answered by the frequency of a crime in a general area. 
                 With this finding, it answers our first question of “how can this help future Seattle residents?”, 
                 by displaying how common a crime is in potentially a neighborhood that they are interested in, 
                 and thus helping their decision."),
               p("When talking about district, a graph displayed below our heat map determines the count of the crime selected in each 
                 district that year. With the graph, alongside with the year and crime selected, we are able to answer both, 
                 “which districts had more crimes than others?” and “did certain years have greater prevalence of one crime than 
                 another crime?”."),
               p("Using our crime count scatter plot, the frequencies of each crime that has been reported from 2014-2017 is totaled. 
                 Using the scatter plot, our question, “How many crimes in total occurred over the course of the dataset?” is answered: 
                 76,438 incidents of car prowl reported. However, with our selected group of “Notable Crimes”, assault takes first place 
                 with 33,720 incidents reported in 2014-2017."),
               h3("Notable Outliers"),
               p("A notable outlier that we saw in our data was that from 2014 to 2017, there is an increase in total reported incidents 
                 that is very noticeable; it can be concluded that either city has become a lot stricter in terms of law enforcement or 
                 there is a substantial increase in crime rate as the population continues to grow.")
             )
  )
)

shinyUI(my.ui)

