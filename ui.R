#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that plots prediction of mpg v/s number of predictors
# that was selected by user
shinyUI(fluidPage(
        
        # Application title
        titlePanel("Prediction of mpg from mtcars data set using linear regression model"),
        
        # Sidebar with a slider input for mpg and check boxes to show models 
        sidebarLayout(
                sidebarPanel(
                        selectInput("nbrPredictors",
                                    label = "Select number of top predictors:",
                                    choices = list("2 - top predictors" = 2,
                                                   "3 - top predictors" = 3,
                                                   "4 - top predictors" = 4,
                                                   "5 - top predictors" = 5,
                                                   "6 - top predictors" = 6,
                                                   "7 - top predictors" = 7,
                                                   "8 - top predictors" = 8,
                                                   "9 - top predictors" = 9,
                                                   "10 - top predictors" = 10),
                                    width = "75%",
                                    selected = 5),
                        checkboxInput("showFormula", "Show lm Formula", value = TRUE),
                        checkboxInput("showRMSE", "Show Root Mean Square Error",
                                      value = TRUE),
                        # for delayed reactivity .i.e. reactivity only when
                        # "Submit" button is clicked
                        actionButton("submit", "Submit")
                ),
                
                # Show a plot of predicted v/s actual mpg
                mainPanel(
                        br(),
                        p("Linear regression model is fit based on number of top predictors chosen by user.If user choses to see then the linear model formula as well root mean square error (RMSE) value is displayed. A plot of actual v/s predicted mpg is shown. The prediction is more accurate if RMSE is low and the plot has points closer to the 45 degree line."),
                        br(),
                        h4(textOutput("nbrPredictors")),
                        h4(textOutput("lmFormula")),
                        h4(textOutput("rootMeanSqError")),
                        plotOutput("plotPred")
                        
                ) ## Closure of mainPanel
        ) ## closure of sidebarLayout
))
