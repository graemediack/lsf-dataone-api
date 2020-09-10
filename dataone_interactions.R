library(dataone)
library(datapack)
library(uuid)

#DataONE Authentication Token
options(dataone_token = "eyJhbGciOiJSUzI1NiJ9.eyJzdWIiOiJodHRwOlwvXC9vcmNpZC5vcmdcLzAwMDAtMDAwMy0xMDIzLTQ3MDAiLCJmdWxsTmFtZSI6IkdyYWVtZSBEaWFjayIsImlzc3VlZEF0IjoiMjAyMC0wOS0xMFQwOTozNjowMi45ODcrMDA6MDAiLCJjb25zdW1lcktleSI6InRoZWNvbnN1bWVya2V5IiwiZXhwIjoxNTk5Nzk1MzYyLCJ1c2VySWQiOiJodHRwOlwvXC9vcmNpZC5vcmdcLzAwMDAtMDAwMy0xMDIzLTQ3MDAiLCJ0dGwiOjY0ODAwLCJpYXQiOjE1OTk3MzA1NjJ9.pAo1rJPB-aOtkvq4dvmuhDkkEmJ_eQNEI9HFFCpFhzgLksgPMcC8FZNGMCmEpG5uZf_MeItY0MF89j2XHoZUAYMdczQKCVKWbdf_r0bIAWQwN4lDQBNvKQ0CslgmD0O2MqD3AYmCm9PDxMQdb42-XHx5e2NhaG7ALZHfEyC9JnXjvP9Ss3mZp8EgA_CodQekaT0hbqHFAVIHmVRHnpwrUsGqL4I6M8VYj-4rvXS-UmYTzGnXDJybESZ-HpeJbTshwZ26ZVz6cq5uTATYL18a-5BQ20Oy6SJ3VAFvZyXFzwuYoCfHvA_uQlWUULT4O86uWPrA-tjFli0IG3pT-mOBjw")
# Check Token
am <- AuthenticationManager()
getTokenInfo(am)

#List all member nodes (MN) in DataONE PROD environment
cn <- CNode("PROD")
unlist(lapply(listNodes(cn), function(x) x@subject))

# Create a DataPackage to be uploaded

dp <- new("DataPackage")

# A DataPackage will contain at least the EML metadata, but can contain data files, code files, output files, each defined as a "DataObject"
# and added to the DataPackage using addMember

emlFile <- system.file("eml.xml", package="dataone")
metadataObj <- new("DataObject", format="eml://ecoinformatics.org/eml-2.1.1", filename=emlFile)
dp <- addMember(dp, metadataObj)

# with an metadata object added the package can now be uploaded

d1c <- D1Client("PROD", "urn:node:KNB,DC=dataone,DC=org")
packageId <- uploadDataPackage(d1c, dp, public=FALSE,quiet=FALSE)
message(sprintf("Uploaded package with identifier: %s", packageId))

