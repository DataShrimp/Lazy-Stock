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

url1 <- "http://finance.google.com/finance/info?client=ig&q=NASDAQ%3AAAPL,GOOG,AMZN,FB,BIDU,BABA"
url2 <- "http://finance.google.com/finance/info?client=ig&q=HKG%3A0700"

df1 <- fromJSON(getStrFromUrl(url1))
Sys.time(3)
df2 <- fromJSON(getStrFromUrl(url2))
df <- rbind(df1, df2)

df$Date <- as.Date(substr(df$lt_dts, 1, 10))
df$Company <- c('Apple','Google','Amazon','Facebook','Baidu',
                'Alibaba','Tencent(HK)')
df$Close <- as.numeric(gsub(",","",df$l))

# save or not
df1 <- read.csv('stock.csv')
df1$Date <- as.Date(df1$Date)
if (max(df$Date) == max(df1$Date)) {
  print("no need to download")
} else {
  df1 <- rbind(df1, df[,c('Company','Date','Close')])
  write.csv(df1, "stock.csv", row.names=FALSE)
}
