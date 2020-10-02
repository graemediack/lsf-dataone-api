# This script will contain methods to move data from KNB to the LSF graph on neo4j
# First use case is to update/synchronise URI and DOI for metadata in the graph with those on the KNB, KNB being the master version.

# get metadata information from neo4j

con <- neo4j_api$new(url = "http://172.17.0.3:7474", user = "neo4j", password = "aq1sw2de3")
metadataLabels <- call_neo4j("MATCH (n:Metadata) RETURN n.metadataLabel",con,type = 'row')

# search dataone for URI and DOI information

for (label in metadataLabels$n$value){
  
  # get new info from KNB
  queryParamList <- list(q=paste("title:",label,sep = ""), rows="1",fl="id,title,author,archived") # rows value just to override default of 10
  result <- query(mn,solrQuery=queryParamList,as="data.frame")
  
  # update neo4j with new URI
  
  newURI <- paste('https://knb.ecoinformatics.org/view/',result$id,sep = '')
  updateQuery <- paste("MATCH (n:Metadata) WHERE n.metadataLabel = '",result$title,"' SET n.URI = '",newURI,"', n.DOI = ''", sep = '')
  call_neo4j(updateQuery,con,include_stats = TRUE)
}