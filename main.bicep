targetScope = 'subscription'
param rgName string = 'ip'
param location string = 'northeurope'
param storageAccount string = uniqueString(location)
param prefixName string = 'ievap'
param environmentName string = 'development'
var myStorage = '${prefixName}-storage'
var appService = '${prefixName}_appPlan-${environmentName}'
var appName = '${prefixName}_webApp-${environmentName}'
var appInsights = '${prefixName}_appInsights-${environmentName}'
resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: location
}

module storage 'Models/storage.bicep' = {
  scope: rg
  name: myStorage
  params: {
    storageAccount: storageAccount
    location: rg.location
  }
}
module appPlan 'Models/appServicePlan.bicep' = {
  scope: rg
  name: appService
  params: {
    location: rg.location
    environmentName: environmentName
  }
}
module webApp 'Models/app.bicep' = {
  scope: rg
  name: appName
  params: {
    appPlanId: appPlan.outputs.appPlanId
    prefixName: prefixName
    location: rg.location 
    environmentName: environmentName
  }
  dependsOn: [
    appPlan
  ]
}
module appInsight 'Models/appInsights.bicep' = {
  scope: rg
  name: appInsights
  params: {
    location: rg.location
    environmentName: environmentName
    prefixName: prefixName
  }
  dependsOn: [
    webApp
  ]
}
output websiteURL string = webApp.outputs.siteURL
output webName string = webApp.name
output appInsight string = appInsight.outputs.workState

