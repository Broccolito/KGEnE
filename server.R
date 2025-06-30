server = function(input, output, session){
  
  selected_meta_graph = reactiveVal(NULL)
  subnetwork = reactiveVal(NULL)
  embedding_file_path = reactiveVal(NULL)
  embedding_node_ids = reactiveVal(NULL)
  subject_embedding_file_path = reactiveVal(NULL)
  subject_properties = reactiveVal(NULL)

  output$download_subject_embeddings = downloadHandler(
    filename = function(){
      basename(subject_embedding_file_path())
    },
    content = function(file){
      file.copy(from = subject_embedding_file_path(), to = file)
    },
    contentType = "csv"
  )
  
  observeEvent(input$generate_subject_embeddings, {
    req(subnetwork())
    req(subject_properties())

    showModal(modalDialog(
      title = "Generating Subject Embeddings",
      "Generating subject-specific embeddings...",
      footer = NULL,
      easyClose = FALSE
    ))

    withProgress(message = "Processing", value = 0, {
      subject_embedding_export_file_path = generate_personalized_pagerank(subnet = subnetwork(),
                                                                          subject_properties = subject_properties(),
                                                                          progress = function(detail, value = NULL){
                                                                            setProgress(value = value, detail = detail)
                                                                          })
      subject_embedding_file_path(subject_embedding_export_file_path)
    })
    removeModal()
    showNotification("Embeddings successfully generated!", type = "message")
  })

  observeEvent(input$subject_properties_input_file, {
    subject_embedding_input_path = input$subject_properties_input_file$datapath
    ext = file_ext(subject_embedding_input_path)

    if(ext == "xlsx"){
      subject_embedding_df = read_excel(subject_embedding_input_path)
    }else if(ext == "xls"){
      subject_embedding_df = read_xls(subject_embedding_input_path)
    }else{
      subject_embedding_df = fread(subject_embedding_input_path) |>
        as.data.frame()
    }
    subject_properties(subject_embedding_df)
  })
  
  output$download_example_subject_properties = downloadHandler(
    filename = function(){
      paste0("example_subject_properties.xlsx")
    },
    content = function(file){
      write_xlsx(example_subject_properties, path = file)
    }
  )
  
  output$download_embeddings = downloadHandler(
    filename = function(){
      basename(embedding_file_path())
    },
    content = function(file){
      file.copy(from = embedding_file_path(), to = file)
    },
    contentType = "csv"
  )
  
  observeEvent(input$generate_embeddings, {
    req(subnetwork())
    req(embedding_node_ids())
    
    showModal(modalDialog(
      title = "Generating Node Embeddings",
      "Generating node embeddings for all the nodes uploaded...",
      footer = NULL,
      easyClose = FALSE
    ))
    
    withProgress(message = "Processing", value = 0, {
      nodal_embedding_export_file_path = generate_pagerank(subnet = subnetwork(),
                                                           node_ids = embedding_node_ids(),
                                                           progress = function(detail, value = NULL){
                                                             setProgress(value = value, detail = detail)
                                                           })
      embedding_file_path(nodal_embedding_export_file_path)
    })
    removeModal()
    showNotification("Embeddings successfully generated!", type = "message")
    
    output$message_upon_embedding_generation = renderUI({
      
      req(embedding_file_path())
      
      tags$div(
        style = "background-color: #f8f9fa; padding: 15px; border-radius: 10px; border: 1px solid #dee2e6;",
        tags$h5(style = "margin-top: 0; margin-bottom: 10px;", "Network Embedding Summary"),
        tags$div(
          style = "display: grid; grid-template-columns: max-content auto; row-gap: 6px; column-gap: 15px; align-items: baseline;",
          tags$div("Generated on:"), tags$div(format(Sys.time(), "%Y-%m-%d %H:%M:%S")),
          tags$div("Embedding file size:"),
          tags$div(format_bytes(file.info(embedding_file_path())$size))
          
        )
      )
    })
    
  })
  
  observeEvent(input$embedding_input_file, {
    nodal_embedding_input_path = input$embedding_input_file$datapath
    ext = file_ext(nodal_embedding_input_path)
    
    if(ext == "xlsx"){
      embedding_nodes_df = read_excel(nodal_embedding_input_path)
    }else if(ext == "xls"){
      embedding_nodes_df = read_xls(nodal_embedding_input_path)
    }else{
      embedding_nodes_df = fread(nodal_embedding_input_path) |>
        as.data.frame()
    }
    embedding_node_ids(embedding_nodes_df$node_id)
  })
  
  output$download_example_nodes = downloadHandler(
    filename = function(){
      paste0("example_node_ids.xlsx")
    },
    content = function(file){
      write_xlsx(example_node_id, path = file)
    }
  )
  
  observeEvent(input$generate_subnetwork, {
    req(selected_meta_graph())
    showModal(modalDialog(
      title = "Generating Subnetwork",
      "Please wait while the subnetwork is being generated...",
      footer = NULL,
      easyClose = FALSE
    ))
    
    subnet = NULL
    withProgress(message = "Processing", value = 0, {
      subnet = subset_network_from_edges(
        selected_meta_graph()$edge_type,
        progress = function(detail, value = NULL) {
          setProgress(value = value, detail = detail)
        }
      )
    })
    
    subnetwork(subnet)
    removeModal()
    showNotification("Subnetwork successfully generated!", type = "message")
    
    output$message_upon_subnet_generation = renderUI({
      g = subnetwork()
      
      tags$div(
        style = "background-color: #f8f9fa; padding: 15px; border-radius: 10px; border: 1px solid #dee2e6;",
        tags$h5(style = "margin-top: 0; margin-bottom: 10px;", "Active Subnetwork Summary"),
        tags$div(
          style = "display: grid; grid-template-columns: max-content auto; row-gap: 6px; column-gap: 15px; align-items: baseline;",
          tags$div("Generated on:"), tags$div(format(Sys.time(), "%Y-%m-%d %H:%M:%S")),
          tags$div("Total nodes:"), tags$div(vcount(g)),
          tags$div("Total edges:"), tags$div(ecount(g)),
          tags$div("Node types:"), tags$div(length(unique(V(g)$labels))),
          tags$div("Edge types:"), tags$div(length(unique(E(g)$edge_type)))
        )
      )
    })
    
    
  })
  
  observeEvent(input$visualize_meta_graph, {
    output$meta_graph_network = renderVisNetwork({
      req(selected_meta_graph())
      meta = selected_meta_graph()
      all_nodes = unique(c(meta$start_node_type, meta$end_node_type))
      
      meta_nodes = data.frame(
        id = all_nodes,
        label = all_nodes,
        group = all_nodes,
        stringsAsFactors = FALSE
      )
      
      meta_edges = data.frame(
        from = meta$start_node_type,
        to = meta$end_node_type,
        label = meta$edge_type,
        smooth = TRUE,
        shadow = FALSE,
        stringsAsFactors = FALSE
      )
      
      visNetwork(meta_nodes, meta_edges, height = "600px", width = "100%") %>%
        visEdges(smooth = TRUE) %>%
        visOptions(highlightNearest = TRUE, nodesIdSelection = TRUE) %>%
        visLayout(randomSeed = 42) %>%
        visPhysics(stabilization = TRUE)
    })
  })
  
  observeEvent(input$examine_network, {
    filtered_meta_graph = dplyr::filter(meta_graph, edge_type %in% input$selected_edges)
    selected_meta_graph(filtered_meta_graph)
  })
  
  observeEvent(input$examine_network, {
    output$nodes_in_select = renderUI({
      req(selected_meta_graph())
      node_types = unique(c(selected_meta_graph()$start_node_type, selected_meta_graph()$end_node_type))
      
      tags$div(
        style = "display: flex; flex-wrap: wrap; gap: 6px;",
        lapply(node_types, function(nt) {
          tags$span(nt, 
                    style = "background-color: #e1e5ea; padding: 5px 10px; 
                           border-radius: 15px; font-size: 13px; 
                           display: inline-block;")
        })
      )
    })
    
    output$edges_in_select = renderUI({
      req(selected_meta_graph())
      edge_types = unique(selected_meta_graph()$edge_type)
      tags$div(
        style = "display: flex; flex-wrap: wrap; gap: 6px;",
        lapply(edge_types, function(et) {
          tags$span(et, 
                    style = "background-color: #d9f2e6; padding: 5px 10px;
                           border-radius: 15px; font-size: 13px; 
                           display: inline-block;")
        })
      )
    })
  })
  
  
}