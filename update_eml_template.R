library(xml2)
library(tidyverse)


x <- read_xml("DataONE EML Template.xml")
y <- read_csv("KNBTranslations_For_R.csv")


xpath_pre <- "/eml:eml/dataset/"

y_keywords <- y[, c(26,27)]
y_sub <- select(y, -c(26,27))


#<keywordSet>
#<keyword>farmland birds</keyword>
#</keywordSet>


for(i in 1:nrow(y_sub)){ #rows
  for(z in 1:ncol(y_sub)){ #cols
    xpath_tail <- names(y_sub[z])
    xpath_full <- paste(xpath_pre,xpath_tail,sep = "")
    node_value <- toString(y_sub[i,z])
    xml_set_text(xml_find_all(x, xpath = xpath_full,xml_ns(x)),node_value)
  }
  filename <- paste("row_",i,".xml",sep = "")
  write_xml(x,filename)
}
