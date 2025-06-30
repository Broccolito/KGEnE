software_version = "0.1"

cran_packages = c(
  "data.table", "dplyr", "igraph", "shiny", "shinyWidgets", 
  "visNetwork", "readxl", "writexl", "tools", "shinyjs"
)

install_if_missing_cran = function(pkg){
  if(!requireNamespace(pkg, quietly = TRUE)){
    install.packages(pkg)
  }
  library(pkg, character.only = TRUE)
}

message("Loading pacakges from CRAN...")
invisible(lapply(cran_packages, install_if_missing_cran))

message("Loading support functions...\n")
source("select_subnetwork.R")
source("generate_pagerank.R")
source("generate_personalized_pagerank.R")
source("format_bytes.R")

message("Loading support datasets...")
cat("\n")
spoke_edges = fread("spoke/edges.tsv") |>
  as.data.frame()
spoke_nodes = fread("spoke/nodes.tsv") |>
  as.data.frame()
meta_graph = fread("meta_graph/meta_graph.csv") |>
  as.data.frame()
example_node_id = read_excel("example_data/example_node_ids.xlsx")
example_subject_properties = read_excel("example_data/example_subject_properties.xlsx")

message("Initializing edges...")
all_nodes = unique(c(meta_graph$start_node_type, meta_graph$end_node_type))
edge_list = purrr::map(as.list(all_nodes),
                       function(x){
                         select_edges_from_nodes(x)
                       })
names(edge_list) = all_nodes

message("Finalizing workspace...")
nodal_file_removal = file.remove(list.files(path = "nodal_embeddings_export", full.names = TRUE))
subject_file_removal = file.remove(list.files(path = "subject_embeddings_export", full.names = TRUE))
gc()

message("-----------------------------------")
cat("\n")

