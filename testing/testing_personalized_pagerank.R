subnet = subset_network_from_edges_internal(select_edges_between_nodes())
subject_properties = read_excel(path = "example_data/example_subject_properties_brief.xlsx")
  
generate_personalized_pagerank(subnet = subnet, subject_properties = subject_properties)