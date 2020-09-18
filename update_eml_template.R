
# INPUT: csv of metadata to build eml.xml file
# OUPUT: eml.xml file 
# PLANNED OUTPUT: create datapackage and upload to KNB


#IMPORT METADATA TIBBLE
y <- read_csv("KNBTranslations_For_R_a.csv")
#SEPERATE keywords
y_keywords <- y[, c("commonKeywords","additionalKeywords")]
y_sub <- select(y, -c("commonKeywords","additionalKeywords"))

#IMPORT EML Template
x <- read_xml("DataONE EML Template.xml")

#SET BASE XML NODE PATH
xpath_base <- "/eml:eml/dataset/"

#FOR EACH TIBBLE ROW - SET NEW NODE VALUES AND EXPORT TO FILE
for(i in 1:nrow(y_sub)){ #rows ROWS CONTAIN NODE VALUES
  
  # REMOVE ALL KEYWORDS BEFORE MOVING TO NEXT ROW - AT BEGINNING OF ROUTINE TO CATCH AND REMOVE TEMPLATE KEYWORD
  xml_remove(xml_find_all(x, "//keyword"))
  
  for(z in 1:ncol(y_sub)){ #cols COL NAMES ARE NODE PATH (TAIL only)
    xpath_tail <- names(y_sub[z])
    xpath_full <- paste(xpath_base,xpath_tail,sep = "")
    node_value <- toString(y_sub[i,z])
    xml_set_text(xml_find_all(x, xpath = xpath_full,xml_ns(x)),node_value)
  }
  # keyword routine
  # Create keyword_vector of all keywords for ROW (TWO COLUMNS of KEYWORDS)
  # COLUMN 1
  commonKeywords_vector <- str_trim(str_split(y_keywords$commonKeywords[1],",")[[1]])
  # COLUMN 2
  additionalKeywords_vector <- str_trim(str_split(y_keywords$additionalKeywords[1],",")[[1]])
  # MERGE into keyword_vector
  keyword_vector <- c(commonKeywords_vector,additionalKeywords_vector)
  #CREATE keyword NODES, add the same number as there are keywords (length of keyword_vector)
  for(kw in 1:length(keyword_vector)){
    xml_add_child(xml_find_all(x, xpath = "/eml:eml/dataset/keywordSet", xml_ns(x)), "keyword")
  }
  # APPLY keyword values to new nodes
  xml_find_all(x, "//keyword") %>% xml_set_text(keyword_vector)
  # Create and Set PID
  id <- paste("urn:uuid:", UUIDgenerate(), sep="")
  xml_set_attr(x, "packageId", id)
  # set metadataProvider node id attribute so that CONTACT/REFERENCES node works
  xml_set_attr(xml_find_all(x, "//metadataProvider"),"id",y_sub[i,]$`metadataProvider/userId`)
  # export to xml file, with custom file name
  filename <- paste("eml_",i,".xml",sep = "")
  write_xml(x,filename)
  
  dp <- new("DataPackage")
  #x <- read_xml(filename)
  id <- xml_attr(x, "packageId")
  
  metadataObj <- new("DataObject", id, format="https://eml.ecoinformatics.org/eml-2.2.0", filename=filename)
  dp <- addMember(dp, metadataObj)
  
  # with a metadata object added the package can now be uploaded
  
  packageId <- uploadDataPackage(testClient, dp, public=FALSE, quiet=FALSE)
}

# EXAMPLE BUILD XML FROM SCRATCH
# x_root <- xml_new_root("eml")
# xml_set_attr(x_root, "xmlns:eml","https://eml.ecoinformatics.org/eml-2.2.0")
# xml_set_attr(x_root, "xmlns:stmml","http://www.xml-cml.org/schema/stmml-1.1")
# xml_set_attr(x_root, "xmlns:xsi","http://www.w3.org/2001/XMLSchema-instance")
# xml_set_attr(x_root, "xsi:schemaLocation","https://eml.ecoinformatics.org/eml-2.2.0 https://eml.ecoinformatics.org/eml-2.2.0/eml.xsd")
# xml_add_child(xml_find_all(x_root, xpath = "/eml"), "dataset")
# xml_add_child(xml_find_all(x_root, xpath = "/eml/dataset", xml_ns(x_root)), "keywordSet")
# xml_add_child(xml_find_all(x_root, xpath = "/eml/dataset/keywordSet", xml_ns(x_root)), "keyword")
