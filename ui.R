library(readxl)

#READ DATA
data_path<-paste0(getwd(),'/Uebersicht_ArchivPsychischeStoerung.xlsx')
data_path

adata <- read_xlsx(data_path,skip=6,
                   col_types = c('text','text','text','text','text','date','text','text'))

#CHANGE DATA
adata<-adata[!is.na(adata$Hauptthema),] #remove empty rows
adata$`Videolänge (mm:ss)`<-strftime(adata$`Videolänge (mm:ss)`, tz='UTC', format="%H:%M") #change format
adata$`Link zum originalen Video` <- paste0("<a href='",adata$`Link zum originalen Video`,"'>",adata$`Link zum originalen Video`,"</a>") #convert to link
adata$`Speicherort/Ordner in Hessenbox` <- paste0("<a href='",adata$`Speicherort/Ordner in Hessenbox`,"'>",adata$`Speicherort/Ordner in Hessenbox`,"</a>") #convert to link
names(adata)[3]<-'Beschreibung des Videos'



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
