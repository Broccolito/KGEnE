subnet = subset_network_from_edges_internal(select_edges_between_nodes())

genes = dplyr::filter(spoke_nodes, labels == "['Gene']")$identifier 
proteins = dplyr::filter(spoke_nodes, labels == "['Protein']")$identifier 

genes_id = dplyr::filter(spoke_nodes, labels == "['Gene']")$id 
proteins_id = dplyr::filter(spoke_nodes, labels == "['Protein']")$id

generate_random_properties = function(subject_id){
  paste(c(sample(genes, size = sample(10:20, 1), replace = FALSE),
          sample(genes_id, size = sample(10:20, 1), replace = FALSE),
          sample(proteins, size = sample(10:20, 1), replace = FALSE),
          sample(proteins_id, size = sample(10:20, 1), replace = FALSE)),
        collapse = "; ")
}

example_subject_properties = data.frame(
  subject_id = paste0("subject", 1:50),
  properties = sapply(paste0("subject", 1:50), generate_random_properties)
)

write_xlsx(example_subject_properties, path = "example_subject_properties.xlsx")