library(xml2)
library(tidyverse)


x <- read_xml("DataONE EML Template.xml")
y <- read_csv("KNBTranslations_For_R.csv")


xpath_pre <- "/eml:eml/dataset/"

y_keywords <- y[, c(26,27)]
y_sub <- select(y, -c(26,27))

# two ways to add keywords. Either add as many keyword child nodes as there are keywords, then iterate
# or iterate the second of these two commands of each keyword value. problem is, this errors but works!
xml_add_child(xml_find_all(x, xpath = "/eml:eml/dataset", xml_ns(x)), "keywordSet")
xml_set_text(xml_add_child(xml_find_all(x, xpath = "/eml:eml/dataset/keywordSet"), "keyword"),keyword)

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
