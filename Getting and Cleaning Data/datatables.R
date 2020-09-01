library(data.table)

DF <- data.frame(x=rnorm(9),y=rep(c("a","b","c"), each=3), z=rnorm(9))
DT <- data.table(x=rnorm(9),y=rep(c("a","b","c"), each=3), z=rnorm(9))

head(DF)
head(DT)

DT[c(2,3)]

{
      x = 1
      y = 2
}
k = {print(10);5}

DT[,list(mean(x),sum(z))]

DT[,table(y)]

DT[,w:=z^2]

DT[,m:={tmp<- (x+z);log2(tmp+5)}]
head(DT, n = 2)

DT[,a:=x>0]
head(DT, n = 2)

DT[,b:= mean(x+w),by=a]

## Counting
set.seed(123)
DT <- data.table(x=sample(letters[1:3],1E5, TRUE))
DT[, .N, by=x]

## Keys
DT <- data.table(x=rep(c("a","b","c"),each=100), y=rnorm(300))
setkey(DT,x)
DT["a"]

## Joins
DT1 <- data.table(x=c("a","a","b","dt1"), y=1:4)
DT2 <- data.table(x=c("a","b","dt2"), z=5:7)
setkey(DT1,x); setkey(DT2,x)
merge(DT1,DT2)

frea