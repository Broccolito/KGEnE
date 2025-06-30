generate_personalized_pagerank = function(subnet, subject_properties, progress = NULL){
  
  export_file_name = file.path("subject_embeddings_export", 
                               paste0("SubjectEmbedding_",
                                      format(Sys.time(), 
                                             "%Y-%m-%d_%H-%M-%S"), 
                                      ".csv"))
  
  subnet_attr = vertex_attr(subnet)
  subnet_attr = data.frame(
    id = subnet_attr$name,
    label = subnet_attr$labels,
    identifier = subnet_attr$identifier
  )
  header = c("subject_id", subnet_attr$id)
  fwrite(as.list(header), file = export_file_name, append = FALSE, col.names = FALSE)
  
  n_mapped = nrow(subject_properties)
  
  if(!is.null(progress)){
    progress(detail = paste0(n_mapped, " subjects to be embedded..."), value = 0)
  }
  
  for(i in 1:n_mapped){
    subject_idx = subject_properties$subject_id[i]
    individual_properties = dplyr::filter(subject_properties, subject_id == subject_idx)$properties
    individual_properties = unlist(strsplit(individual_properties, split = "; "))
    
    nodes_by_id = dplyr::filter(subnet_attr, id %in% individual_properties)
    nodes_by_identifier = dplyr::filter(subnet_attr, identifier %in% individual_properties)
    selected_nodes = rbind.data.frame(
      nodes_by_id,
      nodes_by_identifier
    ) |>
      distinct(id, .keep_all = TRUE)
    
    personalized_vec = as.numeric(V(subnet)$name %in% selected_nodes$id)
    personalized_vec = personalized_vec/sum(personalized_vec)
    pr_result = page_rank(subnet, personalized = personalized_vec, directed = FALSE)$vector
    pr_result = c(subject_idx, pr_result)
    
    fwrite(as.list(pr_result), file = export_file_name, append = TRUE, col.names = FALSE)
    
    if(!is.null(progress)){
      progress(detail = paste0("Embedding generated for subject ", i, " out of ", n_mapped, "..."), value = i / n_mapped)
    }
    
  }
  return(export_file_name)
}

