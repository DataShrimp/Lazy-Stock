library(shiny)
library(data.table)

filename <- paste(Sys.Date(), ".csv", sep="")
filelast <- paste(Sys.Date()-7, ".csv", sep="")

dt1 <- fread(filename, col.names = c("symbol","price"))
dt2 <- fread(filelast, col.names = c("symbol","price"))

growth <- ((dt1$price - dt2$price)/dt2$price)*100
growth <- round(growth, 3)
company <- c('Apple', 'Google', 'Amazon', 'Facebook', 'Baidu', 'Alibaba', 'Tencent (HK)')

dt <- data.table(company, dt1$price, growth)
colnames(dt) <- c('公司', '股价($)', '增长率(%)')

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
   output$table <- renderDataTable(dt,options=list(
     paging=FALSE, searching=FALSE, filtering=FALSE
   ))
}

# Run the application 
shinyApp(ui = ui, server = server)

