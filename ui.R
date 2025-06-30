ui = fluidPage(
  theme = shinytheme("journal"),
  
  tags$head(
    tags$title(glue::glue("KGEnE v{software_version}")),
    tags$link(rel = "icon", type = "image/x-icon", href = "kgene_favicon.png"),
    tags$style(HTML("
      body, label, input, button, select {
        font-family: Arial, sans-serif !important;
      }
    "))
  ),
  
  div(
    style = "display: flex; align-items: center; gap: 15px; padding-bottom: 2px; padding-top: 10px;",
    tags$img(src = "kgene_logo.png", height = "100px"),
    tags$h4("Biological Knowledge Graph Embedding and Enrichment", style = "margin: 0; color: #555; margin-top: 25px;")
  ),
  
  useShinyjs(),
  
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
        
        tabPanel("About",
                 tags$div(
                   style = "padding: 10px;",

                   h3("About KGEnE"),
                   p("The Biological Knowledge Graph Embedding and Enrichment (KGEnE) application is a graphical interface designed to enable users to interactively explore and compute embeddings from the SPOKE knowledge graph. Built for ease of use, KGEnE empowers biomedical researchers to generate feature-rich network representations of genes, diseases, drugs, symptoms, and other biological entities within a curated heterogeneous network."),

                   h4("Key Features"),
                   tags$ul(
                     tags$li(tags$strong("Network Selection:"), " Select relationship types (edges) from the SPOKE meta-graph to define a biologically meaningful subnetwork."),
                     tags$li(tags$strong("Meta-graph Visualization:"), " Visualize the node types and edge types selected to gain a quick overview of network structure."),
                     tags$li(tags$strong("Embedding Nodes:"), " Upload a list of node IDs and generate personalized embeddings using network propagation algorithms such as PageRank."),
                     tags$li(tags$strong("Embedding Subjects:"), " Upload individual-level subject features (e.g., traits, phenotypes) and compute subject-specific embeddings."),
                     tags$li(tags$strong("Download Results:"), " All embeddings can be downloaded for downstream use in machine learning models, statistical analyses, or biological interpretation.")
                   ),

                   h4("Underlying Network: SPOKE"),
                   p("KGEnE is powered by ", a(href = "https://spoke.rbvi.ucsf.edu/docs/index.html", "SPOKE", target = "_blank"),
                     ", a biomedical knowledge graph developed at UCSF that integrates multiple public datasets including GO, Reactome, DrugBank, OMIM, and many more. The graph consists of multiple node types (genes, diseases, symptoms, etc.) and over 20 types of biologically meaningful relationships."),

                   h4("Source Code & Contributions"),
                   p("KGEnE is an open-source project. The full source code is available on ",
                     a(href = "https://github.com/Broccolito/KGEnE", "GitHub", target = "_blank"),
                     ". Contributions and suggestions are welcome via pull requests or GitHub issues."),

                   h4("Contact & Acknowledgments"),
                   p("KGEnE was developed by researchers at the ",
                     a(href = "https://baranzinilab.ucsf.edu/", "Baranzini Lab", target = "_blank"),
                     " at the University of California, San Francisco (UCSF)."),
                   p("For support or questions, please contact:"),
                   tags$ul(
                     tags$li(tags$strong("Wanjun Gu"), ": ", a(href = "mailto:wanjun.gu@ucsf.edu", "wanjun.gu@ucsf.edu")),
                     tags$li(tags$strong("Gianmarco Bellucci"), ": ", a(href = "mailto:gianmarco.bellucci@ucsf.edu", "gianmarco.bellucci@ucsf.edu"))
                   ),

                   h4("Citation"),
                   p("If you use KGEnE in your work, please cite the associated publication (forthcoming) or the GitHub repository.")
                 )
        )
        
      )
    )
    
  )
)
