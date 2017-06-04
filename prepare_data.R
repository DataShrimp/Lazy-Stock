library(data.table)

# prepare history stock data offline
dt <- fread('stock/0700.csv') # , sep="\t")
company.name <- "Tencent(HK)"

# set locale to support English Abbre.
Sys.setlocale("LC_TIME", "C")

#dt$Date <- as.Date(dt$Date, "%d-%b-%y")
dt$Date <- as.Date(dt$Date, "%b %d, %Y")
dt$Company <- company.name

fwrite(dt[order(Date, Company),.(Company, Date, Close)], 
       file="stock.csv", append=TRUE)
