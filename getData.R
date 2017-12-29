library(RCurl)
options(scipen = 999)

args=(commandArgs(TRUE))
set <- as.numeric(args[[1]])
datasetNum <- set
blockHeight <- as.numeric(args[[2]])
qtyCores <- as.numeric(args[[3]])

inc <- 500

totalInc <- inc * qtyCores
i <- 0 + inc * set
j <- 499 + inc * set

## maxSets adds one to account for our index of 0
maxHeightAt500 <- (400000 %/% (qtyCores * 500)) * qtyCores * 500
maxHeightAt150 <- (498000 %/% (qtyCores * 150)) * qtyCores * 150

while (i < blockHeight) {
    
    myUrl <- paste0("https://api.blockchair.com/bitcoin/outputs?q=is_spent(0),block_id(", i, "..", j, ")&fields=recipient,value&export=csv")

    blockFile <- getURL(myUrl)
    headString <- substr(blockFile, 2, 10)
    if (headString == 'recipient') {
    
        write(blockFile, paste0('./data/data', datasetNum, '.csv'))

    } else {
        print(datasetNum)
        while (headString != 'recipient') {
            Sys.sleep(sample(1:10, 1) + 15)
            blockFile <- getURL(myUrl)
            headString <- substr(blockFile, 2, 10)
            
            if (headString == 'recipient') {
                write(blockFile, paste0('./data/data', datasetNum, '.csv'))
            }
        }      
    }

    i <- i + totalInc
    j <- j + totalInc
    datasetNum <- datasetNum + qtyCores
    
    if (i >= maxHeightAt500 && inc == 500 ) {
        ## this condition should only be true once
        ## 498000 will be struck on set 0, otherwise we would need to make it more complex
        inc <- 150
        totalInc <- inc * qtyCores
        i <- i - 350 * set
        j <- j - 350 * (set + 1)
    }

    if (i >= maxHeightAt150 && inc == 150 ) {
        ## this condition should only be true once
        ## 498000 will be struck on set 0, otherwise we would need to make it more complex
        inc <- 125
        totalInc <- inc * qtyCores
        i <- i - 25 * set
        j <- j - 25 * (set + 1)
    }
}
