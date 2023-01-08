param location string = resourceGroup().location
param storageAccountType string = 'Standard_LRS'
param storageAccount string 

resource storage 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: storageAccount
  location: location
  sku: {
    name: storageAccountType
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
    accessTier: 'Hot'
    encryption: {
      services: {
        blob: {
          enabled: true
        }
        file: {
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
  }
}

output storageUri string = storage.properties.primaryEndpoints.blob
