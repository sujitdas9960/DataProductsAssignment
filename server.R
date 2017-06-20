#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(caret)
library(Metrics)
library(ggplot2)

# Define server logic required to apply linear regression model based on input
# number of top predictors
shinyServer(function(input, output, session) {
        
        output$plotPred <- renderPlot({
                
                input$submit

                if (input$submit == 0)
                        return()
                
                isolate({getPlot()})
        })        

        getPlot <- function()   {
             
                lmModel <- lmModel()
                predMpg <- predMpg()
                
                g <- ggplot(data = data.frame(x = mtcars[-inTrain(), ]$mpg,
                                              y = predMpg),
                            aes(x = x, y = y))
                g <- g + xlab("Actual mpg of the test data set")
                g <- g + ylab("Predicted mpg of the test data set")
                g <- g + geom_point(size = 7, colour = "black", alpha = 0.5)
                g <- g + geom_point(size = 5, colour = "blue", alpha = 0.2)
                g <- g + xlim(0, 35) + ylim(0, 35)
                g <- g + geom_abline(intercept = 0, slope = 1)
                g
        }
        
        lmModel <- reactive({
                input$submit
                
                if (input$submit == 0)
                        return()
               
                isolate({ 
                        nbrPredictors <- as.integer(input$nbrPredictors)
                        
                        inTrain <- inTrain()
                        trainSet <- mtcars[inTrain, ]
                        testSet <- mtcars[-inTrain, ]
                        
                        predIndx <- pickTopPredictors(trainSet, nbrPredictors)
                        
                        subTrainSet <- subset(trainSet, select = predIndx)
                        
                        subTrainSet <- cbind(subTrainSet, mpg = trainSet[, "mpg"])
                        
                        train(mpg ~ ., data = subTrainSet, method = "lm")
                })
        })
        
        inTrain <- reactive({
                input$submit
                
                if (input$submit == 0)
                        return()
                
                isolate({
                        set.seed(1235)
                        createDataPartition(mtcars$mpg, p = 0.6, list = FALSE)
                })
        })
        
        predMpg <- reactive({
                input$submit
                
                if (input$submit == 0)
                        return()

                isolate({predict(lmModel(), newdata = mtcars[-inTrain(), ])})
        })
        
        pickTopPredictors <- function(df, nbrPredictors)  {

                if (nbrPredictors > 10)
                        stop("There are more than 10 predictors")
                
                allPredictors <- ncol(df)
                
                # pvalues contains significance level of each predictor in univariate
                # regression model
                pvalues <- numeric(allPredictors)
                for (i in seq_len(allPredictors))  {
                        if (colnames(df)[i] != "mpg")   {
                                fit <- lm(df$mpg ~ df[, i])
                                summ <- summary(fit)
                                pvalues[i] <- summ$coefficients[2, 4]
                        }
                }
                
                # rearrange in ascending order of p-value with the return of indices
                ord <- order(pvalues)
                
                # get top predictors based on the required number of top predictors
                ord <- ord[1:nbrPredictors]
                
                return(ord)
        }
        
        output$nbrPredictors <- renderText({
                input$submit
                
                if (input$submit == 0)
                        return()

                isolate({paste("Number of selected top predictors: ", input$nbrPredictors)})
        })
        
        
        output$lmFormula <- renderText({

                input$submit
                
                if (input$submit == 0)
                        return()
                
                isolate({                                                

                        if (!input$showFormula)
                                return()
                        
                        coeffDf <- summary(lmModel())$coeff
                        coeffVals <- coeffDf[, 1]
                        
                        lmFormula <- "mpg = "
                        for (i in seq_len(length(coeffVals))) {
                                if (i == 1) {
                                        lmFormula <- paste(lmFormula,
                                                           round(coeffVals[i], 2),
                                                           sep = "")
                                }
                                else  {
                                        lmFormula <- paste(lmFormula,
                                                           ifelse(coeffVals[i] < 0,
                                                                  " - ", " + "),
                                                           sep = "")
                                        lmFormula <- paste(lmFormula,
                                                           round(abs(coeffVals[i]), 2),
                                                           sep = "")
                                        lmFormula <- paste(lmFormula,
                                                           trimws(rownames(coeffDf)[i]),
                                                           sep = "")
                                }
                        }
                        
                        paste("Linear Model Formula:", lmFormula)
                })
        })
        
        output$rootMeanSqError <- renderText({
                
                input$submit
                
                if (input$submit == 0)
                        return()
                
                isolate({
                        if (!input$showRMSE)
                                return()
                        
                        rootMeanSqError <- round(rmse(mtcars[-inTrain(), ]$mpg,
                                              predMpg()), 4)
                        paste("Root Mean Square Error: ", rootMeanSqError)
                })
        })                        
})
