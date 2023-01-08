@description('description')
param location string = resourceGroup().location
param prefixName string = 'ievap'
param environmentName string
var appService = '${prefixName}_appPlan-${environmentName}'

@description('Describes plan\'s pricing tier and instance size.')
@allowed([
  'B1'
  'B2'
  'B3'
  'S1'
  'S2'
  'S3'
  'P1'
  'P2'
  'P3'
  'P4'
])
param farmSkuName string = 'S1'

resource appPlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appService
  location: location
  sku: {
    name: farmSkuName
  }
}

output appPlanId string = appPlan.id
