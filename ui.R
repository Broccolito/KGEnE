ui = fluidPage(
  useShinyjs(),
  
  titlePanel("KGEnE"),
  helpText("Biological Knowledge Graph Embedding and Enrichment"),
  
  sidebarLayout(
    sidebarPanel(width = 4,
                 virtualSelectInput(
                   inputId = "selected_edges",
                   label = "Select Edges:",
                   choices = edge_list,
                   showValueAsTags = FALSE,
                   search = TRUE,
                   multiple = TRUE
                 ),
                 div(
                   style = "display: flex; gap: 10px; align-items: center; margin-bottom: 10px;",
                   actionButton(inputId = "examine_network", label = "Examine", class = "btn btn-outline-primary"),
                   actionButton(inputId = "generate_subnetwork", label = "Generate", class = "btn btn-outline-primary")
                 )
    ),
    
    mainPanel(
      tabsetPanel(
        
        tabPanel("Network Selection",
                 tags$div(style = "padding: 20px;",
                          uiOutput("message_upon_subnet_generation"),
                          
                          tags$div(
                            style = "background-color: #f8f9fa; padding: 20px; border-radius: 10px; border: 1px solid #dee2e6;",
                            h4("Selected Nodes"),
                            uiOutput("nodes_in_select"),
                            hr(),
                            h4("Selected Edges"),
                            uiOutput("edges_in_select"),
                            hr(),
                            actionButton("visualize_meta_graph", "Visualize Meta Graph", class = "btn btn-outline-info"),
                            br(), br(),
                            visNetworkOutput("meta_graph_network", height = "600px")
                          )
                 )
        ),
        
        tabPanel("Embed Nodes",
                 tags$div(style = "padding: 20px;",
                          tags$div(
                            style = "background-color: #f8f9fa; padding: 20px; border-radius: 10px; border: 1px solid #dee2e6;",
                            
                            uiOutput("message_upon_embedding_generation"),
                            
                            h4("Upload Node ID File"),
                            fileInput("embedding_input_file", "Choose a CSV, TSV, or Excel file",
                                      accept = c(".csv", ".tsv", ".xls", ".xlsx")),
                            
                            downloadButton("download_example_nodes", "Download Example Node ID File", 
                                           class = "btn btn-outline-secondary", style = "margin-bottom: 15px;"),
                            
                            tags$div(
                              style = "display: flex; gap: 10px;",
                              actionButton("generate_embeddings", "Generate Embeddings", 
                                           class = "btn btn-primary"),
                              downloadButton("download_embeddings", "Download Results", 
                                             class = "btn btn-success")
                            ),
                            
                            br(),
                            p("After uploading your node ID file, click 'Generate Embeddings' to compute node-level features. Once done, you can download the results as a CSV.")
                          )
                 )
        ),
        
        tabPanel("Embed Subjects",
                 
                 tags$div(style = "padding: 20px;",
                          tags$div(
                            style = "background-color: #f8f9fa; padding: 20px; border-radius: 10px; border: 1px solid #dee2e6;",
                            
                            uiOutput("message_upon_subject_embedding_generation"),
                            
                            h4("Upload Subject Properties File"),
                            fileInput("subject_properties_input_file", "Choose a CSV, TSV, or Excel file",
                                      accept = c(".csv", ".tsv", ".xls", ".xlsx")),
                            
                            downloadButton("download_example_subject_properties", "Download Example Subject Properties File", 
                                           class = "btn btn-outline-secondary", style = "margin-bottom: 15px;"),
                            
                            tags$div(
                              style = "display: flex; gap: 10px;",
                              actionButton("generate_subject_embeddings", "Generate Embeddings", 
                                           class = "btn btn-primary"),
                              downloadButton("download_subject_embeddings", "Download Results", 
                                             class = "btn btn-success")
                            ),
                            
                            br(),
                            p("After uploading your Subject Properties file, click 'Generate Embeddings' to compute subject-specific features. Once done, you can download the results as a CSV.")
                          )
                 )
        ),
        
        tabPanel("About")
        
      )
    )
    
  )
)
