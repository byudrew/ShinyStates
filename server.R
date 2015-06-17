# Prepare to run, and gather data
library(ggplot2)
data(state)
states <- data.frame(state.x77)

shinyServer(
    function(input, output) {
        
        # Dynamically create a slider for selecting a value of the input variable
        output$ui <- renderUI({
            xVals <- states[,input$axisX]

            sliderInput("dynamic",
                        paste("Select a Value for",input$axisX),
                        min = min(xVals),
                        max = max(xVals),
                        value = (min(xVals)+max(xVals))/2,
                        sep = "",
                        step = (max(xVals)-min(xVals))/100)
        })
        
        # Deal with initial null value of this dynamic variable by saving it elsewhere
        inputVal <- reactive({
            if (is.null(input$dynamic))
                0
            else
                input$dynamic
        })
        
        # Create a data frame for plotting and regression
        plotFrame <- reactive({data.frame(x=states[,input$axisX],
                                          y=states[,input$axisY])})
        
        # Create a linear regression model and send the coefficients to be printed
        mdl <- reactive({lm(y ~ x, data=plotFrame())})
        output$coef <- renderPrint({coef(mdl())})
        
        # Perform a prediction at the given input value
        prediction <- reactive({predict(mdl(), newdata=data.frame(x=inputVal()))})
        output$prediction <- renderPrint({as.numeric(prediction())})
        
        # Save the R squared value
        output$r2 <- renderPrint({summary(mdl())$r.squared})
        
        # Use ggplot to plot the data and possibly the regression and prediction
        output$myPlot <- renderPlot({
            
            # Plot the 50 data points using large red dots
            g <- ggplot(plotFrame(), aes(x=x, y=y)) + 
                geom_point(color="red",
                           size=5,
                           alpha=.5) + 
                ylab(input$axisY) +
                xlab(input$axisX) + 
                ggtitle(paste(input$axisY,"vs",input$axisX))
            
            # Plot the regression line if requested
            if ("regress" %in% input$extraPlots) {
                g <- g + 
                    geom_abline(intercept=coef(mdl())[1],
                                slope=coef(mdl())[2],
                                color="black",
                                size=2,
                                alpha=.5)
            }
            
            # Plot the prediction if desired
            if ("predict" %in% input$extraPlots) {
                g <- g +
                    geom_point(x=inputVal(),
                               y=prediction(),
                               color="black",
                               size=5)
            }
            
            # Display the plot
            g

        })
    }
)