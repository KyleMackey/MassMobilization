##==============================================================##
##                                                              ##
##    Project:  Mass Mobilization Yearly Protests and Duration  ##
##                                                              ##
##    File:     server.R                                        ##
##    Author:   KM                                              ##
##    Purpose:  Reactive plot of each country's yearly protests ##
##              and yearly protest duration.                    ##
##    Updated:  May 28, 2015                                    ##
##                                                              ##
##    Requires: MM_protestnum.dta                               ##
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
url <- "https://raw.githubusercontent.com/KyleMackey/MassMobilization/master/Yearly_Mass_Mobilization_Protests/data/protestnum.csv"
protest.data <- getURL(url)                
mm <- read.csv(textConnection(protest.data))


##
##  Put MM data in a data frame for plotting
##
temp <- data.frame(mm)


##
##  Get world yearly average protests
##
w_year <- seq(1990,2014,1)
w_mean_protest <- matrix(NA, nrow=25, ncol=1, 
                                dimnames = list(NULL, "w_mean_protest"))	
w_temp <- data.frame(w_year, w_mean_protest)

for(i in 1:25){
  w_temp$w_mean_protest[i] <- mean(temp$protestnum[temp$year==i+1989])
}


##
##  Get world yearly average protest duration
##
d_year <- seq(1990,2014,1)
d_mean_dur <- matrix(NA, nrow=25, ncol=1, 
                         dimnames = list(NULL, "d_mean_dur"))  
d_temp <- data.frame(d_year, d_mean_dur)

for(i in 1:25){
  d_temp$d_mean_dur[i] <- mean(temp$v_duration_mean[temp$year==i+1989])
}


##
##  Start Shiny server
##
shinyServer(function(input, output) {

  
##########################################################
######            NUMBER OF PROTESTS                ######
##########################################################  
  
output$plot <- renderPlot({ 

  
##
##  Subset out the data that the user selects in the app
##
temp1 <- subset(temp, temp$country == input$country)


##
##  Plot a scatter plot of yearly protests for the 
##  user selected country
##
yp <- ggplot(temp1, aes(x=year, y=protestnumber)) +
              ggtitle(input$country) +
              geom_rug(aes(x=year), col='black', size=0.5, sides="b") +
              geom_point(size = 4) +
              labs(y = "Total Protests", x = "Year") +
              scale_y_continuous(breaks = seq(0, (max(temp1$protestnumber)), by = 2)) +
              scale_x_continuous(breaks = seq((min(temp1$year)), (max(temp1$year)), by = 5),
                                 labels = seq(min(temp1$year), max(temp1$year), by = 5)) +
              coord_cartesian(ylim = c(0.25 ,(max(temp1$protestnumber)+0.75)), 
                              xlim = c((min(temp1$year)-0.5), (max(temp1$year)+0.5))) 


##
##  If user selects the violent protests this will
##  plot only violent protests.
##
if(input$violent) {
yp <- ggplot(temp1, aes(x=year, y=protesterviolence)) +
              ggtitle(input$country) +
              geom_rug(aes(x=year), col='black', size=0.5, sides="b") +
              geom_point(size = 4) +
              labs(y = "Violent Protests", x = "Year") +
              scale_y_continuous(breaks = seq(0, (max(temp1$protesterviolence)), by = 2)) +
              scale_x_continuous(breaks = seq((min(temp1$year)), (max(temp1$year)), by = 5)) +
              coord_cartesian(ylim = c(0.25 ,(max(temp1$protesterviolence)+0.75)), 
                              xlim = c((min(temp1$year)-0.5), (max(temp1$year)+0.5))) 
}


##
##  If user selects the trend line option this will
##  plot a loess line of best fit.
##  Note: user will also be able to adjust the line
##  fit in the user interface
##
if(input$trend) {
yp <- yp + stat_smooth(se=FALSE, size=1, span = input$countryspan) +
              theme(legend.direction = "horizontal", legend.position = "bottom")
}


##
##  If user selects the world trend line option this 
##  will plot a loess line of best fit through all the data in dataset,
##  not just the selected country.
##  Note: user will not be able to adjust the fit of the world trend in the 
##  user interface.
##
if(input$world) {
yp <- yp + stat_smooth(data=w_temp, aes(x=w_year, y=w_mean_protest), colour="red", se=FALSE, size=1)  + 
              theme(legend.direction = "horizontal", legend.position = "bottom")
}  
 

##
##  Prints out the plot
##
print(yp)

})

##########################################################
######            PROTEST DURATION                  ######
##########################################################

output$plot_dur <- renderPlot({ 
  
  
##
##  Subset out the data that the user selects in the app
##
temp2 <- subset(temp, temp$country == input$country)


##
##  Plot a pointrange plot of yearly protest duration for the 
##  user selected country
##
dp <- ggplot(temp2, aes(x=year, y=ln_duration_mean)) +
        ggtitle(input$country) +
        geom_rug(aes(x=year), col='black', size=0.5, sides="b") +
        geom_point(size=4) +
        labs(y = "Protest Duration", x = "Year") +
        coord_cartesian(ylim = c(-0.12 ,(max(temp2$ln_duration_mean)+0.75))) 
  
  
##
##  If user selects the violent protests this will
##  plot only violent protests.
##
if(input$violent) {
dp <- ggplot(temp2, aes(x=year, y=ln_v_duration_mean)) +
            ggtitle(input$country) +
            geom_rug(aes(x=year), col='black', size=0.5, sides="b") +
            geom_point(size=4) +
            labs(y = "Protest Duration", x = "Year") +
            coord_cartesian(ylim = c(-0.12 ,(max(temp2$ln_v_duration_mean)+0.75))) 
}
  

##
##  If user selects the trend line option this will
##  plot a loess line of best fit.
##  Note: user will also be able to adjust the line
##  fit in the user interface
##
if(input$trend) {
dp <- dp + stat_smooth(se=FALSE, size=1, span = input$countryspan) +
            theme(legend.direction = "horizontal", legend.position = "bottom")
}
  

##
##  If user selects the world trend line option this 
##  will plot a loess line of best fit through all the data,
##  not just the country selected.
##  Note: user will not be able to adjust the fit of the world trend 
##  in the user interface.
##
if(input$world) {
dp <- dp + stat_smooth(data=temp2, aes(x=year, y=year_dur_mean), colour="red", se=FALSE, size=1)  + 
            theme(legend.direction = "horizontal", legend.position = "bottom")
}  
  

##
##  Prints out the plot
##
print(dp)


##
##  Download these data
##
output$downloadData <- downloadHandler(
          filename = function() { paste(input$country, '.csv', sep='') },
                      content = function(file) {
                        write.csv(subset(mm, mm$country == input$country), file)
                      }
)


})  # renderPlot end
})  # shinyServer end