library(shiny)
library(data.table)

dt <- fread('stock.csv')
dt$Date <- as.Date(dt$Date)

dates = seq(Sys.Date(), Sys.Date()-6,-1)
date1 = dates[weekdays(dates)=="Friday"]
date2 = date1 - 7

dt.display <- dt[Date==date1,.(Company, Close)]
dt.display$yoy <- 100*(dt.display$Close - dt[Date==date2]$Close)/dt[Date==date2]$Close
colnames(dt.display) <- c('公司', '股价($)', '增长率(%)')

filename <- paste(Sys.Date(), ".csv", sep="")
filelast <- paste(Sys.Date()-7, ".csv", sep="")

# Define UI for application 
ui <- fluidPage(
   
   # Application title
   h1("AGAFBAT本周股价及增长率", align='center'),
   
   fluidRow(
     column(3),
     column(6, dataTableOutput('table'))
   )
)

# Define server logic
server <- function(input, output) {
   output$table <- renderDataTable(dt.display,options=list(
     paging=FALSE, searching=FALSE, filtering=FALSE
   ))
}

# Run the application 
shinyApp(ui = ui, server = server)
