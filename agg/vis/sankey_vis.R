# Library
library(networkD3)
library(dplyr)
library(htmlwidgets)
library(webshot)



# A connection data frame is a list of flows with intensity for each flow
links <- read.csv("/Users/baselhussein/Projects/impossible_goals/agg/vis/sankey_data.csv")

# colnames(links) <- c("source", "target", "value")


# From these flows we need to create a node data frame: it lists every entities involved in the flow
nodes <- data.frame(
  name=c(as.character(links$source), 
         as.character(links$target)) %>% unique()
)

# With networkD3, connection must be provided using id, not using real name like in the links dataframe.. So we need to reformat it.
links$IDsource <- match(links$source, nodes$name)-1 
links$IDtarget <- match(links$target, nodes$name)-1

# Make sure the paths and values are correctly matched
print(head(nodes))
print(head(links))

# Adjusted Sankey diagram call
p <- sankeyNetwork(Links = links, Nodes = nodes,
                   Source = "IDsource", Target = "IDtarget",
                   Value = "value", NodeID = "name", 
                   sinksRight = FALSE, nodeWidth = 30, nodePadding = 40, 
                   iterations = 32)


p


