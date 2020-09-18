library(dataone)
library(datapack)
library(uuid)
library(xml2)

#DataONE Authentication Token
source("dataonetest.token.R")
#source("dataone.token.R")
am <- AuthenticationManager()
getTokenInfo(am)

testClient <- D1Client("STAGING2", "urn:node:mnTestKNB")
#prodClient <- D1Client("PROD", "urn:node:KNB")
# Create a DataPackage to be uploaded

dp <- new("DataPackage")

# A DataPackage will contain at least the EML metadata, but can contain data files, code files, output files, each defined as a "DataObject"
# and added to the DataPackage using addMember

#id <- paste("urn:uuid:", UUIDgenerate(), sep="")
x <- read_xml("eml_3.xml")
id <- xml_attr(x, "packageId")

metadataObj <- new("DataObject", id, format="https://eml.ecoinformatics.org/eml-2.2.0", filename="eml_3.xml")
dp <- addMember(dp, metadataObj)

# with a metadata object added the package can now be uploaded

packageId <- uploadDataPackage(testClient, dp, public=FALSE, quiet=FALSE)
message(sprintf("Uploaded package with identifier: %s", packageId))

