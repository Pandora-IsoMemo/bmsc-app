#' Start Application
#'
#' @param port port of web application
#'
#' @export
startApplication <- function(port = 4242) {
  shiny::runApp(
    system.file("app", package = environmentName(topenv())),
    port = port,
    host = "0.0.0.0"
  )
}
