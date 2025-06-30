# subnet = subset_network_from_edges_internal(c("ADVRESPONSE_TO_mGarC", "DOWNREGULATES_CdG", "DOWNREGULATES_GPdG", "ENCODES_GeP"))
# save(subnet, file = "subnet.rda")

source("global.R")
source("server.R")
source("ui.R")

load("testing/subnet.rda")
node_ids = example_node_id$node_id

progress = NULL

export_file_name = file.path("nodal_embeddings_export", 
                             paste0("NodalEmbedding_",
                                    format(Sys.time(), 
                                           "%Y-%m-%d_%H-%M-%S"), 
                                    ".csv"))

subnet_attr = vertex_attr(subnet)
subnet_attr = data.frame(
  id = subnet_attr$name,
  label = subnet_attr$labels,
  identifier = subnet_attr$identifier
)

nodes_by_id = dplyr::filter(subnet_attr, id %in% node_ids)
nodes_by_identifier = dplyr::filter(subnet_attr, identifier %in% node_ids)
selected_nodes = rbind.data.frame(
  nodes_by_id,
  nodes_by_identifier
) |>
  distinct(id, .keep_all = TRUE)

n_mapped = nrow(selected_nodes)

if(!is.null(progress)){
  progress(detail = paste0(n_mapped, " nodes mapped..."), value = 0)
}

target_node = selected_nodes$id[1]
personalized_vec = as.numeric(V(subnet)$name == target_node)
pr_result = page_rank(subnet, personalized = personalized_vec, directed = FALSE)$vector
header = names(pr_result)
header = c("id", "label", "identifier", header)
fwrite(as.list(header), file = export_file_name, append = FALSE, col.names = FALSE)


for(i in 1:nrow(selected_nodes)){
  target_node = selected_nodes$id[i]
  
  personalized_vec = rep(1e-5, length(V(subnet)))
  names(personalized_vec) = V(subnet)$name
  personalized_vec[target_node] = 1
  personalized_vec = personalized_vec / sum(personalized_vec)
  cat(paste0("Calculating pagerank for node ", i, "...\n"))
  pr_result = page_rank(subnet, personalized = personalized_vec, directed = FALSE)$vector
  pr_result = c(selected_nodes$id[i],
                selected_nodes$label[i],
                selected_nodes$identifier[i],
                pr_result)
  names(pr_result) = NULL
  fwrite(as.list(pr_result), file = export_file_name, append = TRUE, col.names = FALSE)
  if(!is.null(progress)){
    progress(detail = paste0("Generating embedding ", i, " of ", n_mapped, "..."), value = i / n_mapped)
  }
}

