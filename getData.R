library(RCurl)
options(scipen = 999)

args=(commandArgs(TRUE))
set <- as.numeric(args[[1]])
datasetNum <- set
blockHeight <- as.numeric(args[[2]])
qtyCores <- as.numeric(args[[3]])

print(paste("set:", set))
print(paste("blockheight:", blockHeight))
print(paste("qtyCores:", qtyCores))


inc <- 150
i <- 0 + inc * set
j <- 149 + inc * set

## maxSets adds one to account for our index of 0
maxHeightAt150 <- (498000 %/% (qtyCores * 150)) * qtyCores * 150

while (i < blockHeight) {
    if (j > blockHeight) {
        j <- blockHeight
    }
    
    myUrl <- paste0("https://api.blockchair.com/bitcoin/outputs?q=is_spent(0),block_id(", i, "..", j, ")&fields=recipient,value&export=csv")

    x <- getURL(myUrl)
    out <- read.csv(textConnection(x))
    write.csv(out, paste0('./data/data', datasetNum, '.csv'), row.names=FALSE)
    ## wrong
    ## set <- set + qtyCores ## the number of cores. should be a variable

    ## replaced set with qtyCores
    i <- i + inc * qtyCores
    j <- j + inc * qtyCores
    datasetNum <- datasetNum + qtyCores
    
    if (i >= maxHeightAt150 && inc == 150 ) {
        ## this condition should only be true once
        ## 498000 will be struck on set 0, otherwise we would need to make it more complex
        inc <- 125
        i <- i - 25 * set
        j <- j - 25 * (set + 1)
    }
}
