##==============================================================##
##                                                              ##
##    Project:  Mass Mobilization Time in Street, Demand, and   ##
##              Type of Protest Violence                        ##
##                                                              ##
##    File:     ui.R                                            ##
##    Author:   KM                                              ##
##    Purpose:  Reactive plot of each country's time in the     ##
##              street, protester demands, and type of violence.##
##    Updated:  Feb 04, 2016                                    ##
##                                                              ##
##    Requires: Protest_Time_and_Type.csv                       ##
##              server.R                                        ##
##                                                              ##
##==============================================================##

##
##  Load in some packages
##
library(shiny)
library(foreign)
library(RCurl)


##
##  Load in the M&M data
##
url <- "https://raw.githubusercontent.com/KyleMackey/MassMobilization/master/Protest_Time_and_Type/data/Protest_Time_and_Type.csv"
protest.data2 <- getURL(url)                
mm <- read.csv(textConnection(protest.data2))

temp <- data.frame(mm) 


##
##  Define user interface for application that draws a scatter plot
##
shinyUI(fluidPage(
  
  
## 
##  Application title
##
titlePanel("Types of Violence"),
  

##
##  Sidebar panel
##
sidebarPanel(
    
  
##
##  Select which region you want to look at
##
selectInput("regionnm", "Choose Region:",
          choices=as.character(unique(mm$regionnm)),
          selected="South America"),
br(),
  
    
##
##  Slider for year
##
sliderInput("yearslider", "Choose Year",
            min = 1990, max = 2014, 
            value = c(1990, 2014),
            format = "0000", 
            animate=animationOptions(interval = 1000, 
                                     loop = TRUE, 
                                     playButton = "Play", 
                                     pauseButton = "Pause")
            ),
br(),
    
##
##  Create a 'Download these data' button where
##  user can download the data used to make the
##  current plot.
##
downloadButton('downloadData', "Download these data"),
br(), br(),

helpText("Note: Downloads user-selected region and year range."),
br()

), # sidebarPanel end
  

##
##  This is the main plot frame, where I
##  show a plot of the generated distribution
##  and post an image for University branding.
##
mainPanel( 
    
tabsetPanel(
  tabPanel("Time in Street", plotOutput("timeinstreet") ,
               
           br(), br(),                      # This introduces line breaks that move the img file 
                                            # further down the mainPanel
           align="center"                   # This aligns the .PNG in the center of the mainPanel
  ), # tabPanel end
      
  tabPanel("Demands", plotOutput("typedemand") ,
                             
           ##
           ##  Select which demand you want to look at
           ##
           selectInput("demand", "Type of Demand:",
                       c("Land" = 'land',
                         "Labor" = 'labor',
                         "Police Brutality" = 'police',
                         "Political" = 'political',
                         "Prices" = 'prices',
                         "Remove Politician" = 'remove',
                         "Social Restrictions" = 'social')),
               
            br(), br(),                     # This introduces line breaks that move the img file 
                                            # further down the mainPanel   
            align="center"                  # This aligns the .PNG in the center of the mainPanel
  ), # tabPanel end
      
  tabPanel("Violence", plotOutput("typeviolence") ,
               
           ##
           ##  Select which demand you want to look at
           ##
           selectInput("tvio", "Type of Violence:",
                       c("Nonviolent" = 'nonviolent',
                         "Protester Violence" = 'protester_violence',
                         "State Violence" = 'state_violence',
                         "Both Violence" = 'both_violence')),
                
            br(), br(),                     # This introduces line breaks that move the img file 
                                            # further down the mainPanel   
            align="center"                  # This aligns the .PNG in the center of the mainPanel
  ) # tabPanel end
) # tabsetPanel end
) # mainPanel end
  
) # shinyUI end
) # fluidPage end