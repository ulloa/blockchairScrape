blockHeight <- as.numeric(args[[1]])
qtyCores <- as.numeric(args[[2]])


maxHeightAt150 <- (498000 %/% (qtyCores * 150)) * qtyCores * 150
expBlocks <- (498000%/%(qtyCores * 150) * qtyCores) + ((blockHeight - maxHeightAt150) %/% 125)

receivedBlocks <- list.files(path="./data", full.names=TRUE)
goodBlocks <- receivedBlocks[sapply(receivedBlocks, file.size) >= 100] ## 99 and 47 are sizes of corruptBlocks
goodBlocksNum <- gsub("[^0-9]", "", goodBlocks) 


compareBlocks <- 0:expBlocks

compareBlocks[!(compareBlocks %in% goodBlocksNum)]
