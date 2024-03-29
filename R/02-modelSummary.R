modelSummaryTab <- function(id) {
    ns <- NS(id)

    tabPanel(
        "Model Summary",
        value = "summaryTab",
        selectInput(ns("modelSelection"), "Select model", choices = ""),
        sliderInput(ns("quantileInt"), "Select quantile for credible intervals",
            min = 0.5, max = 0.999, step = 0.001, value = 0.95
        ),
        verbatimTextOutput(ns("summary")),
        textExportButton(ns("exportText"))
    )
}

modelSummary <- function(input, output, session, model, modelAVG) {
    observe({
        req(model())
        updateSelectInput(session, "modelSelection", choices = names(model()$models))
        req(modelAVG())
        updateSelectInput(session, "modelSelection", choices = c(names(model()$models), names(modelAVG())))
    })
    printFun <- reactive({
        req(model())
        req((input$modelSelection %in% names(model()$models)) || (input$modelSelection %in% names(modelAVG())))
        
        function() {
            if((input$modelSelection %in% names(model()$models))){
                print(model()$models[[input$modelSelection]], cLevel = input$quantileInt)
            } else {
                print(modelAVG()[[input$modelSelection]], cLevel = input$quantileInt)
            }
        }
    })

    output$summary <- renderPrint({
        req(model())
        printFun()()
    })

    callModule(textExport, "exportText", printFun = printFun, filename = "summary")
}