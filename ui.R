fluidPage(
  titlePanel("Videoarchiv Psychische Störungen"),

  # Create a new Row in the UI for selectInputs
  fluidRow(
    column(4,
        selectInput("theme",
                    "Störung:",
                    c("All",
                      unique(as.character(adata$Hauptthema))))
    ),
    column(4,
        selectInput("type",
                    "Videotyp:",
                    c("All",
                      unique(as.character(adata$Art))))
    ),
    column(4,
        selectInput("key",
                    "Stichwort:",
                    c("All",
                      unique(as.character(unlist(strsplit(adata$Stichwörter,","))))))
    )
  ),
  # Create a new row for the table.
  DT::dataTableOutput("table")
)
