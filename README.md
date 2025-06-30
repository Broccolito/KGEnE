# KGEnE: Knowledge Graph Embedding and Enrichment

**KGEnE** (Knowledge Graph Embedding and Enrichment) is an interactive web application designed to allow researchers to generate node- and subject-level embeddings using a heterogeneous biomedical knowledge graph. It is powered by the **SPOKE** knowledge graph and developed by the [Baranzini Lab](https://baranzinilab.ucsf.edu/) at the University of California, San Francisco (UCSF).

This Shiny app provides a user-friendly interface for:

* Selecting relationships (edges) from a meta-level view of SPOKE
* Generating subnetworks based on selected node and edge types
* Embedding nodes using personalized PageRank
* Embedding subjects based on phenotypic traits or biological attributes
* Visualizing meta-graph structure and exporting results for downstream analysis



## Table of Contents

* [Features](#features)
* [Installation](#installation)
* [Getting Started](#getting-started)
* [Input File Formats](#input-file-formats)
* [Resources and Documentation](#resources-and-documentation)
* [Maintainers](#maintainers)
* [License and Citation](#license-and-citation)



## Features

### 1. Network Selection

Users can select edge types from a curated SPOKE meta-graph. This step defines which relationships (e.g., "gene–disease", "compound–targets") will be used in building a subnetwork.

### 2. Meta-Graph Visualization

Users can preview the structure of the selected edge types as a simplified meta-graph, showing the categories of nodes and edges involved.

### 3. Subnetwork Generation

Once edge types are selected, KGEnE extracts the relevant portion of SPOKE as a working subnetwork.

### 4. Node Embeddings

Users can upload a list of SPOKE node IDs (e.g., gene IDs, disease IDs) to compute personalized node embeddings using PageRank.

### 5. Subject Embeddings

Users can upload subject-specific information (e.g., phenotypes, clinical values) and compute subject-level embeddings through propagation over the subnetwork.

### 6. Downloadable Results

All results (node embeddings and subject embeddings) are available for download as CSV files.



## Installation

To run KGEnE locally, you will need:

* **R ≥ 4.0**
* The following R packages:

  * `shiny`, `shinyjs`, `shinyWidgets`, `data.table`, `igraph`, `readxl`, `writexl`, `visNetwork`, `tools`, `dplyr`, `purrr`

### Clone and Run

```bash
git clone https://github.com/Broccolito/KGEnE.git
cd KGEnE
Rscript -e 'shiny::runApp()'
```

> Alternatively, launch the app using `app.R` in an RStudio session.



## Getting Started

Once the app is running:

1. **Select Edge Types** from the left panel under "Network Selection".
2. Click **Examine** to view selected node and edge types.
3. Click **Generate** to build the subnetwork from SPOKE.
4. Under the **Embed Nodes** tab:

   * Upload a file containing a column named `node_id`.
   * Click **Generate Embeddings** to compute embeddings.
5. Under the **Embed Subjects** tab:

   * Upload a file with subject-specific variables (e.g., `subject_id`, `trait1`, `trait2`, etc.).
   * Click **Generate Subject Embeddings**.
6. Download the resulting embeddings in CSV format.



Based on the actual example files you provided, here is the revised **Input File Formats** section for your `README.md`:



## Input File Formats

### 1. Node ID File (for node embeddings)

This file should be in CSV, TSV, or Excel format, and must contain a column named `node_id` with each row representing a SPOKE node identifier. These identifiers are typically protein or gene IDs from UniProt.

**Example:**

| node\_id   |
| ---------- |
| A0A0N9W3D1 |
| A0A4J2CMI4 |
| A0A7C8FW18 |
| A0A2V4L8L1 |
| A0A6H1PBI5 |

You can find this example in: `example_data/example_node_ids.xlsx`



### 2. Subject Properties File (for subject embeddings)

This file should include:

* A column named `subject_id` (unique identifier for each subject)
* A column named `properties` containing a semicolon-separated list of SPOKE node identifiers relevant to that subject (e.g., associated genes, symptoms, or biological entities).

**Example:**

| subject\_id | properties                             |
| ----------- | -------------------------------------- |
| subject1    | 404785; 2969; 26509; 9542; 338321; ... |
| subject2    | 3172; 23348; 55589; 57488; 3840; ...   |
| subject3    | 142910; 80352; 26206; 389874; ...      |

These IDs should match valid node identifiers in SPOKE to enable correct embedding propagation.

You can find this example in: `example_data/example_subject_properties.xlsx`



## Resources and Documentation

* **SPOKE Knowledge Graph Documentation**:
  [https://spoke.rbvi.ucsf.edu/docs/index.html](https://spoke.rbvi.ucsf.edu/docs/index.html)

* **Baranzini Lab (UCSF)**:
  [https://baranzinilab.ucsf.edu/](https://baranzinilab.ucsf.edu/)

* **Project Source Code**:
  [https://github.com/Broccolito/KGEnE](https://github.com/Broccolito/KGEnE)



## Maintainers

* **Wanjun Gu**
  Email: [wanjun.gu@ucsf.edu](mailto:wanjun.gu@ucsf.edu)

* **Gianmarco Bellucci**
  Email: [gianmarco.bellucci@ucsf.edu](mailto:gianmarco.bellucci@ucsf.edu)

This project is actively maintained by the Baranzini Lab at UCSF.



## License and Citation

This software is made freely available for academic and non-commercial use. License terms will be updated upon publication.

If you use KGEnE in your work, please cite the upcoming manuscript or refer to the GitHub repository.



Let me know if you want this `README.md` as a downloadable file or need a version with installation scripts included.
