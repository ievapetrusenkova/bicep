param prefixName string
param location string = resourceGroup().location
param appPlanId string
param environmentName string = 'dev'
var appName = '${prefixName}App-${environmentName}'
var currentStack = 'dotnet'
var netFrameworkVersion = 'v4.8'
var alwaysOn = false
var identityName = '${appName}-identity'

resource identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: identityName
  location: location
}

resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: appName
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${identity.id}': {
        
      }
    }
  }
  properties: {
    siteConfig: {
      appSettings: [
        {
          name: 'ASPNET_ENVIRONMENT'
          value: environmentName
        }
        {
          name: 'ApplicationInsightsAgent_EXTENSION_VERSION'
          value: '~2'
        }
        {
          name: 'XDT_MicrosoftApplicationInsights_Mode'
          value: 'default'
        }
        {
          name: 'DiagnosticServices_EXTENSION_VERSION'
          value: 'disabled'
        }
        {
          name: 'APPINSIGHTS_PROFILERFEATURE_VERSION'
          value: 'enabled'
        }
        {
          name: 'APPINSIGHTS_SNAPSHOTFEATURE_VERSION'
          value: 'enabled'
        }
        {
          name: 'InstrumentationEngine_EXTENSION_VERSION'
          value: 'disabled'
        }
        {
          name: 'SnapshotDebugger_EXTENSION_VERSION'
          value: 'disabled'
        }
        {
          name: 'XDT_MicrosoftApplicationInsights_BaseExtensions'
          value: 'disabled'
        }
        {
          name: 'CURRENT_STACK'
          value: currentStack
        }
      ]
      netFrameworkVersion: netFrameworkVersion
      alwaysOn: alwaysOn
  }
    serverFarmId: appPlanId
    clientAffinityEnabled: true
  }
}
output webAppName string = webApp.name
output siteURL string = webApp.properties.hostNames[0]
