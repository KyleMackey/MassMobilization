##==============================================================##
##                                                              ##
##    Project:  Mass Mobilization Time in Street, Demand, and   ##
##              Type of Protest Violence                        ##
##                                                              ##
##    File:     server.R                                        ##
##    Author:   KM                                              ##
##    Purpose:  Reactive plot of each country's time in the     ##
##              street, protester demands, and type of violence.##
##    Updated:  June 19, 2015                                   ##
##                                                              ##
##    Requires: mm_App3.dta                                     ##
##              ui.R                                            ##
##                                                              ##
##==============================================================##

##
##  Load some packages
##
library(shiny)
library(ggplot2)
library(foreign)
library(ggthemes)
library(RCurl)


## 
##  Custom ggplot2 theme
##
theme_set(theme_classic())
custom <- theme_update(axis.text.x = element_text(colour="black", size=15),
                       axis.text.y = element_text(colour="black", size=15),
                       axis.title.x = element_text(size=20),
                       axis.title.y = element_text(size=20, angle=90),
                       title = element_text(size=20),
                       panel.grid = element_line(colour = NULL, linetype = 1), 
                       panel.grid.major = element_line(colour = "gray78"),
                       panel.grid.major.x = element_blank(), 
                       panel.grid.minor = element_blank()
)  


##
##  Load in the M&M data
##
url <- "https://raw.githubusercontent.com/KyleMackey/MassMobilization/master/Protest_Time_and_Type/data/Protest_Time_and_Type.csv"
protest.data2 <- getURL(url)                
mm <- read.csv(textConnection(protest.data2))


##
##  Put MM data in a data frame for plotting
##
temp <- data.frame(mm)


##
##  Start Shiny server
##
shinyServer(function(input, output) {
  
  
##########################################################
######            TIME IN THE STREET                ######
##########################################################  


output$timeinstreet <- renderPlot({ 
    
    
##
##  Subset out the data that the user selects in the app
##
temp1 <- subset(temp, temp$regionnm == input$regionnm & temp$year %in% seq(input$yearslider[1], input$yearslider[2], 1))


##
##  Plot a bar plot of yearly protests for the 
##  user selected region
##
tis <- ggplot(temp1, aes(x=factor(country), y=protestdays)) +
        ggtitle(paste("Time in the Street", "\n", "(", paste(input$regionnm, ":", sep=""), input$yearslider[1], "-", input$yearslider[2], ")")) +
        geom_bar(stat="identity") +
        labs(y = "Days", x = " ") +
        theme(axis.text.x = element_text(angle = 90, hjust = 1))
    
    
##
##  Prints out the plot
##
print(tis)
    
})  # renderPlot end
  

##########################################################
######            PROTESTER DEMAND                  ######
##########################################################  

output$typedemand <- renderPlot({ 
  
  
##
##  Subset out the data that the user selects in the app
##
temp1 <- subset(temp, temp$regionnm == input$regionnm & temp$year %in% seq(input$yearslider[1], input$yearslider[2], 1))
 
  
##
##  Plot a bar plot of yearly protests for the 
##  user selected region
##
md <- ggplot(temp1, aes(x=factor(country))) +
          labs(y = "Frequency", x = " ") +
          theme(axis.text.x = element_text(angle = 90, hjust = 1))
  
##
##  Land  
##
if(input$demand=='land'){
  md <- md + geom_bar(aes(y=demand_land), stat="identity") +
          ggtitle(paste("Land Protest", "\n", "(", paste(input$regionnm, ":", sep=""), 
                        input$yearslider[1], "-", input$yearslider[2], ")")) 
}
  
##
##  Labor
##
if(input$demand=='labor'){
  md <- md + geom_bar(aes(y=demand_labor), stat="identity") +
          ggtitle(paste("Labor Protest", "\n", "(", paste(input$regionnm, ":", sep=""), 
                        input$yearslider[1], "-", input$yearslider[2], ")")) 
}
  
##
##  Police
##
if(input$demand=='police'){
  md <- md + geom_bar(aes(y=demand_policebrutality), stat="identity") +
            ggtitle(paste("Police Brutality Protest", "\n", "(", paste(input$regionnm, ":", sep=""), 
                          input$yearslider[1], "-", input$yearslider[2], ")")) 
}
  
##
##  Political
##
if(input$demand=='political'){
  md <- md + geom_bar(aes(y=demand_political), stat="identity") +
            ggtitle(paste("Political Behavior, Process Protest", "\n", "(", paste(input$regionnm, ":", sep=""), 
                          input$yearslider[1], "-", input$yearslider[2], ")")) 
}
  
##
##  Prices
##
if(input$demand=='prices'){
  md <- md + geom_bar(aes(y=demand_price), stat="identity") +
            ggtitle(paste("Price and Wage Dispute Protest", "\n", "(", paste(input$regionnm, ":", sep=""), 
                          input$yearslider[1], "-", input$yearslider[2], ")")) 
}
  
##
##  Remove
##
if(input$demand=='remove'){
  md <- md + geom_bar(aes(y=demand_removal), stat="identity") +
            ggtitle(paste("Removal of Politician Protest", "\n", "(", paste(input$regionnm, ":", sep=""), 
                          input$yearslider[1], "-", input$yearslider[2], ")")) 
}
  
##
##  Social
##
if(input$demand=='social'){
  md <- md + geom_bar(aes(y=demand_social), stat="identity") +
            ggtitle(paste("Social Restrictions Protest", "\n", "(", paste(input$regionnm, ":", sep=""), 
                          input$yearslider[1], "-", input$yearslider[2], ")")) 
}
    
##
##  Prints out the plot
##
print(md)
  
})  # renderPlot end


##########################################################
######                VIOLENCE                      ######
##########################################################  

output$typeviolence <- renderPlot({ 
  
  
##
##  Subset out the data that the user selects in the app
##
temp1 <- subset(temp, temp$regionnm == input$regionnm & temp$year %in% seq(input$yearslider[1], input$yearslider[2], 1))
  
  
##
##  Plot a bar plot of yearly protests for the 
##  user selected region
##
vio <- ggplot(temp1, aes(x=factor(country))) +
          labs(y = "Frequency", x = " ") +
          theme(axis.text.x = element_text(angle = 90, hjust = 1)) 

##
##  Nonviolent
##
if(input$tvio=='nonviolent'){
  vio <- vio + geom_bar(aes(y=nonviolent), stat="identity") +
          ggtitle(paste("Nonviolent Protests", "\n", "(", paste(input$regionnm, ":", sep=""), 
                        input$yearslider[1], "-", input$yearslider[2], ")")) 
}
  
##
##  Protester Violence
##
if(input$tvio=='protester_violence'){
  vio <- vio + geom_bar(aes(y=protester_violence), stat="identity") +
          ggtitle(paste("Protester Violence", "\n", "(", paste(input$regionnm, ":", sep=""), 
                        input$yearslider[1], "-", input$yearslider[2], ")"))  
}
  
##
##  State Violence
##
if(input$tvio=='state_violence'){
  vio <- vio + geom_bar(aes(y=state_violence), stat="identity") +
          ggtitle(paste("State Violence", "\n", "(", paste(input$regionnm, ":", sep=""), 
                        input$yearslider[1], "-", input$yearslider[2], ")"))     
}
  
##
##  Both Violence
##
if(input$tvio=='both_violence'){
vio <- vio + geom_bar(aes(y=both_violence), stat="identity") +
          ggtitle(paste("Protester and State Violence", "\n", "(", paste(input$regionnm, ":", sep=""), 
                        input$yearslider[1], "-", input$yearslider[2], ")")) 
}

  
##
##  Prints out the plot
##
print(vio)
  
})  # renderPlot end

    
##
##  Download these data
##
output$downloadData <- downloadHandler(
      filename = function() { paste(input$regionnm, "_", input$yearslider[1], "-", input$yearslider[2], '.csv', sep='') },
      content = function(file) {
        write.csv(subset(mm, mm$regionnm == input$regionnm), file)
    }
)
     
})  # shinyServer end