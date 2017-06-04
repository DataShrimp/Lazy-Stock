# run the script every Sunday
library(data.table)

url <- "http://finance.yahoo.com/d/quotes.csv?s=AAPL+GOOG+AMZN+FB+BIDU+BABA+0700.HK&f=sp"
filename <- paste("date/", Sys.Date(), ".csv", sep="")
download.file(url, filename, quiet=TRUE)
