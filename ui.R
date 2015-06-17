shinyUI(pageWithSidebar(
    headerPanel("Comparing Variables Across the 50 States"),
    sidebarPanel(
        tags$style(type='text/css', "body { background-color: #ccccff;}"),
        
        # Set up columns of radio buttons next to each other
        fluidRow(column(6,
                        radioButtons("axisY",
                                     "Output:",
                                     c("Population" = "Population",
                                       "Income" = "Income",
                                       "Illiteracy" = "Illiteracy",
                                       "Life.Exp" = "Life.Exp",
                                       "Murder" = "Murder",
                                       "HS.Grad" = "HS.Grad",
                                       "Frost" = "Frost",
                                       "Area" = "Area"),
                                     "Income")),
                 column(6,
                        radioButtons("axisX",
                                     "Input:",
                                     c("Population" = "Population",
                                       "Income" = "Income",
                                       "Illiteracy" = "Illiteracy",
                                       "Life.Exp" = "Life.Exp",
                                       "Murder" = "Murder",
                                       "HS.Grad" = "HS.Grad",
                                       "Frost" = "Frost",
                                       "Area" = "Area"),
                                     "Life.Exp"))),
        
        # Set up checkboxes for optional plotting
        checkboxGroupInput("extraPlots", 
                           "Extra Plots?",
                           c("Regression Line" = "regress",
                             "Predicted Value" = "predict"),
                           c("regress",
                             "predict")),
        
        # Add a dynamically-generated slider for choosing an input value
        uiOutput("ui")
    ),
    mainPanel(
        tabsetPanel(
            # Display plot and results
            tabPanel("Results",
                     h4("Plot of output vs input"),
                     plotOutput('myPlot'),
                     h4("Linear regression on output variable given input variable"),
                     verbatimTextOutput("coef"),
                     h4("Fraction of output variation explained by model (R squared)"),
                     verbatimTextOutput("r2"),
                     h4("Predicted output at given input"),
                     verbatimTextOutput("prediction")
            ),
            # Provide a data description and steps to use the app
            tabPanel("Documentation",
                     h4("Description of data"),
                     "Data for this app comes from the state dataset in R.
                     This dataset contains 50 rows with statistics from each state.
                     These statistics were computed at various times in the 1970s.
                     The columns in the data are:",
                     tags$ul(tags$li("Population"),
                             tags$li("Income (per capita)"),
                             tags$li("Illiteracy (rate)"),
                             tags$li("Life Expectancy"),
                             tags$li("Murder (rate)"),
                             tags$li("HS Grad (% who have graduated high school)"),
                             tags$li("Frost (avg # of days below freezing in capital)"),
                             tags$li("Area")
                             ),
                     h4("Instructions for running"),
                     "To run, choose the output (y-axis) and input (x-axis) variables.
                     The app will produce a plot of the output versus the input, and trends can be observed.
                     A linear regression on the output is performed with the input variable.
                     The slope and intercept are printed, along with the R squared value to 
                     indicate the explanatory power of the input variable on the output variable.
                     A slider is also created for the chosen input variable, and the user
                     can choose a value for that input between the minimum and maximum values
                     in the dataset. The linear regression result is used to predict the output value
                     at the chosen input value, and that result is printed.
                     The regression line and predicted output point can be plotted if desired,
                     based on the user's selection in a checkbox. All outputs are automatically
                     recalculated if any changes are made to the inputs."
            )
        )
    )
))