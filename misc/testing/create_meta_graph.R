library(data.table)
library(dplyr)

edges = fread("spoke/edges.tsv") |>
  as.data.frame()
nodes = fread("spoke/nodes.tsv") |>
  as.data.frame()

edge_types = names(table(edges$edge_type))

meta_graph = vector()
for(i in 1:length(edge_types)){
  edge_type = edge_types[i]
  edge_example = edges[edges$edge_type == edge_type,][1,]
  start_node = unlist(edge_example[,2])
  end_node = unlist(edge_example[,3])
  
  start_node_type = unlist(nodes[nodes$id == start_node,][,2])
  start_node_type = gsub("\\[|\\]|'", "", start_node_type)
  names(start_node_type) = NULL
  
  end_node_type = unlist(nodes[nodes$id == end_node,][,2])
  end_node_type = gsub("\\[|\\]|'", "", end_node_type)
  names(end_node_type) = NULL
  
  meta_snippet = data.frame(
    edge_type,
    start_node_type,
    end_node_type
  )
  
  meta_graph = rbind.data.frame(meta_graph, meta_snippet)
  message(paste0(edge_type, " parsed..."))
}

write.csv(meta_graph, file = "meta_graph/meta_graph.csv", 
          quote = FALSE, row.names = FALSE)
