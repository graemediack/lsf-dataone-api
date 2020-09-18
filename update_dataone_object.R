

result <- query(testMn,solrQuery=list(q="metadataProvider:Graeme Diack"),as="data.frame")
result[1,c("id", "title")]
pid <- result[1,'id']

# Early lost in space PID's
# urn:uuid:2fa7fee3-02ad-4ada-8ffe-202498397906
# urn:uuid:e704bc2f-6e86-4d82-ae48-8ae0f11e5df9
# urn:uuid:57bd4390-664d-497e-96be-9e18df4f0222
# urn:uuid:e2ccecf9-ccbe-4e3d-b4c4-9e7044158720
# urn:uuid:6dd4a739-0784-4fab-902a-c0148aef1a80
# urn:uuid:1a59ba19-66a7-4067-a3e4-fea938247609


pid <- "urn:uuid:2fa7fee3-02ad-4ada-8ffe-202498397906"
pid <- "urn:uuid:67acdd00-3029-4b31-bd6a-3f2299e98cab"

pid <- "urn:uuid:a371dc1f-729f-445d-a38c-ec7d5d568381"

pid <- "urn:uuid:055dc66b-73ef-4873-9d5a-ad0b1baea0a3"
pid <- "doi:10.5063/F1S46Q9Z"

# Update access policy of DataONE objects
sysmeta <- getSystemMetadata(mn, pid)
sysmeta <- removeAccessRule(sysmeta, "public", "read")
sysmeta <- addAccessRule(sysmeta, "public", "read")
status <- updateSystemMetadata(mn, pid, sysmeta)


accessRules <- data.frame(
  subject=c("CN=knb-data-admins,DC=dataone,DC=org","CN=knb-data-admins,DC=dataone,DC=org","CN=knb-data-admins,DC=dataone,DC=org"),
  permission=c("read","write","changePermission"))

sysmeta <- addAccessRule(sysmeta, accessRules)
status <- updateSystemMetadata(mn, pid, sysmeta)

#retrieve and update/change package from dataone

pid <- "urn:uuid:a371dc1f-729f-445d-a38c-ec7d5d568381"
pkg <- getDataPackage(d1c,identifier = pid, lazyLoad=TRUE,limit="0MB", quiet=FALSE)


#ARCHIVE

pid <- "urn:uuid:3be7aac9-ef89-437c-8eee-1394b0a4aa50"

response <- archive(mn, pid)
sysmeta <- getSystemMetadata(mn, pid)
sysmeta@archived
sysmeta