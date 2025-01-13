# Load necessary libraries
library(networkD3)
library(dplyr)

# Read in the connection data frame
links <- read.csv("/Users/baselhussein/Projects/impossible_goals/agg/data/transition_count_merged.csv")

colnames(links) <- c("source", "target", "value")

# Create a node data frame with unique nodes from 'source' and 'target'
nodes <- data.frame(
  name = unique(c(as.character(links$source), as.character(links$target)))
)

# Reformat the links to use IDs instead of real names
links$IDsource <- match(links$source, nodes$name) - 1
links$IDtarget <- match(links$target, nodes$name) - 1

# Define a JavaScript function for coloring nodes based on their labels
node_color_JS <- "
d3.scaleOrdinal()
  .domain(['high-returns_fast-reframe', 'low-returns_fast-reframe', 'low-returns_slow-reframe'])
  .range(['blue', 'yellow', 'green']);
"

# Create the Sankey diagram with custom node colors and larger label text
p <- sankeyNetwork(Links = links, Nodes = nodes,
                   Source = "IDsource", Target = "IDtarget",
                   Value = "value", NodeID = "name",  # Ensure labels are displayed
                   sinksRight = FALSE, nodeWidth = 40, nodePadding = 40, 
                   iterations = 32, colourScale = JS(node_color_JS))

# Increase the text size for the node labels using JavaScript injected into the sankeyNetwork object
p <- htmlwidgets::onRender(
  p,
  '
  function(el, x) {
    d3.selectAll(".node text")
      .style("font-size", 
      "0px");  // Adjust font size here
  }
  '
)

# Display the Sankey diagram
p

# Optionally, save the widget to an HTML file
# library(htmlwidgets)
# saveWidget(p, file=paste0(getwd(), "/HtmlWidget/sankeyBasic1.html"))