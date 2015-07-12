##==============================================================##
##                                                              ##
##    Project:  Mass Mobilization Yearly Protests and Duration  ##
##                                                              ##
##    File:     ui.R                                            ##
##    Author:   KM                                              ##
##    Purpose:  Reactive plot of each country's yearly protests ##
##              and yearly protest duration. This is the user   ##
##              interface.                                      ##
##    Updated:  May 28, 2015                                    ##
##                                                              ##
##    Requires: MM_protestnum.dta                               ##
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
url <- "https://raw.githubusercontent.com/KyleMackey/MassMobilization/master/Yearly_Mass_Mobilization_Protests/data/protestnum.csv"
protest.data <- getURL(url)                
mm <- read.csv(textConnection(protest.data))

temp <- data.frame(mm) 

##
##  Define user interface for application that draws a scatter plot
##
shinyUI(fluidPage(
  
## 
##  Application title
##
titlePanel(paste("Protests over Time", (min(temp$year)), " - ", (max(temp$year)))),

##
##  Sidebar panel
##
sidebarPanel(
  
##
##  Select which country you want to look at
##
selectInput("country", "Choose Country:",
            choices=as.character(unique(mm$country))),
br(),


##
##  Violent/non-violent protests (user optional)
##
checkboxInput("violent", "Violent Protests", FALSE),
br(),

##
##  Fit a line through the data points (user optional)
##
checkboxInput("trend", "Show Country Trend", FALSE),
br(),

##
##  Determine the fit of the line (user optional)
##
sliderInput("countryspan", 
            "Country Smoothness of Fit:", 
            min = 0.25,
            max = 1, 
            value = 0.75,
            step= 0.05),
br(), br(),

##
##  Create a checkbox to select the world trend 
##  in protests
##
checkboxInput("world", "Show World Trend", FALSE),
br(), br(),

##
##  Create a 'Download these data' button where
##  user can download the data used to make the
##  current plot.
##
downloadButton('downloadData', "Download these data"),
br(), br(),

##
##  Create a 'Replication code' button where
##  user can download the code used to generate
##  the current plot.
##
helpText(a("Replication code on", href="https://github.com/KyleMackey/MassMobilization"),
         img(src = "GitHub_Logo.png", height = 44, width = 44))
),

##
##  This is the main plot frame, where I
##  show a plot of the generated distribution
##  and post an image for University branding.
##
mainPanel( 

tabsetPanel(
  tabPanel("Yearly Protests", plotOutput("plot") ,

br(), br(),                     # This introduces line breaks that move the img file further down the mainPanel
img(src = "Binghamton.png",     # This inserts the Binghamton University logo in the mainPanel
    height = 200, 
    width = 200), 
align="center"                  # This aligns the .PNG in the center of the mainPanel
), # tabPanel end

tabPanel( "Protest Duration", plotOutput("plot_dur") ,
          
br(), br(),                     # This introduces line breaks that move the img file further down the mainPanel   
img(src = "Binghamton.png",     # This inserts the Binghamton University logo in the mainPanel
    height = 200, 
    width = 200), 
align="center"                  # This aligns the .PNG in the center of the mainPanel
) # tabPanel end
) # tabsetPanel end
) # mainPanel end

) # shinyUI end
) # fluidPage end