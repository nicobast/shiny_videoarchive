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

# #video files - add local video paths
# video_path<-"C:/Users/nico/Downloads/Archiv Psychische Störung"
# video_paths<-list.files(path=video_path,full.names = T,recursive = T)
#
# video_names<-list.files(path=video_path,recursive = T)
# video_names<-gsub(".*/","",video_names)
# video_names<-substr(video_names,1,nchar(video_names)-4)
#
# video_data<-data.frame(video_names,video_paths)
#
# #merge data
# adata<-merge(adata,video_data,by.x='Videotitel',by.y='video_names',all.x=T)
# names(adata)[9]<-'lokaler Pfad'



function(input, output) {

  # Filter data based on selections
  output$table <- DT::renderDataTable(DT::datatable({
    data <- adata
    if (input$theme != "All") {
      data <- data[data$Hauptthema == input$theme,]
    }
    if (input$type != "All") {
      data <- data[data$Art == input$type,]
    }
    if (input$key != "All") {
      data <- data[grepl(input$key,data$Stichwörter),]
    }
    data
  },escape=F, #read html code

  options = list(
    pageLength = 20, autoWidth = TRUE,
    columnDefs = list(list(targets = 3, width = '300px')),scrollX=T))) #set width of column 3

}
