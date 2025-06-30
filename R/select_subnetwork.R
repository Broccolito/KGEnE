select_edges_from_nodes = function(selected_nodes = c("Gene", "Protein")){
  selected_edge_types = (dplyr::filter(meta_graph, start_node_type %in% selected_nodes |
                                       end_node_type %in% selected_nodes))$edge_type
  return(selected_edge_types)
}

subset_network_from_edges = function(selected_edge_types, progress = NULL){
  message("Subsetting network edges...")
  if(!is.null(progress)){progress(detail = "Subsetting network edges...", value = 0.1)}
  selected_edges = dplyr::filter(spoke_edges, edge_type %in% selected_edge_types) |>
    dplyr::select(start_node, end_node, edge_type)
  names(selected_edges) = c("from", "to", "edge_type")
  
  message("Subsetting network nodes...")
  if (!is.null(progress)){progress(detail = "Subsetting network nodes...", value = 0.5)}
  selected_nodes = dplyr::filter(spoke_nodes, id %in% unique(c(selected_edges$from, selected_edges$to)))
  
  message("Generating subnetwork...")
  if (!is.null(progress)){progress(detail = "Generating subnetwork...", value = 0.9)}
  subnet = igraph::graph_from_data_frame(d = selected_edges, 
                                         vertices = selected_nodes[, c("id", "labels", "identifier")],
                                         directed = FALSE)
  subnet = igraph::delete_vertices(subnet, V(subnet)[degree(subnet) == 0])
  if (!is.null(progress)){progress(detail = "Validating subnetwork...", value = 0.95)}
  return(subnet)
}


