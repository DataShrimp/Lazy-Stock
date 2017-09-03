library(jsonlite)
library(curl)

getStrFromUrl <- function(url) {
  con <- curl(url)
  open(con, 'rb')
  bin <- readBin(con, raw(), 9999)
  close(con)
  ret <- rawToChar(bin)
  ret <- gsub("\n|//", "", ret)
}

url1 <- "http://finance.google.com/finance/info?client=ig&q=AAPL,GOOG,AMZN,FB,BIDU,BABA"
url2 <- "http://finance.google.com/finance/info?client=ig&q=HKG%3A0700"

df1 <- fromJSON(getStrFromUrl(url1))
Sys.sleep(3)
df2 <- fromJSON(getStrFromUrl(url2))
df3 <- rbind(df1[,c('l','lt_dts')], df2[,c('l','lt_dts')])

df3$Date <- as.Date(substr(df3$lt_dts, 1, 10))
df3$Company <- c('Apple','Google','Amazon','Facebook','Baidu',
                'Alibaba','Tencent(HK)')
df3$Close <- as.numeric(gsub(",","",df3$l))

# save or not
df1 <- read.csv('stock.csv')
df1$Date <- as.Date(df1$Date)
if (max(df3$Date) == max(df1$Date)) {
  print("no need to download")
} else {
  df1 <- rbind(df1, df3[,c('Company','Date','Close')])
  write.csv(df1, "stock.csv", row.names=FALSE)
}
