@description('Name of azure web app')
param prefixName string = 'ievap'
@description('Location for all resources.')
param location string = resourceGroup().location
param prefixName string
param location string = resourceGroup().location
param appPlanId string
param environmentName string = 'dev'
var appName = '${prefixName}App-${environmentName}'
var currentStack = 'dotnet'
var netFrameworkVersion = 'v4.8'
var alwaysOn = false
param appPlanId string 
@description('The language stack of the app.')
@allowed([
  '.net'
  'php'
  'node'
  'html'
])
param language string = '.net'

@description('Optional Git Repo URL, if empty a \'hello world\' app will be deploy from the Azure-Samples repo')
param repoUrl string = ''

var managedIdentity = '${prefixName}-identity'
var gitRepoReference = {
  '.net': 'https://github.com/Azure-Samples/app-service-web-dotnet-get-started'
  node: 'https://github.com/Azure-Samples/nodejs-docs-hello-world'
  php: 'https://github.com/Azure-Samples/php-docs-hello-world'
  html: 'https://github.com/Azure-Samples/html-docs-hello-world'
}
var gitRepoUrl = (empty(repoUrl) ? gitRepoReference[language] : repoUrl)
var configReference = {
  '.net': {
    comments: '.Net app. No additional configuration needed.'
  }
  html: {
    comments: 'HTML app. No additional configuration needed.'
  }
  php: {
    phpVersion: '7.4'
  }
  node: {
    appSettings: [
      {
        name: 'WEBSITE_NODE_DEFAULT_VERSION'
        value: '12.15.0'
      }
    ]
  }
}

resource mi 'Microsoft.ManagedIdentity/userAssignedIdentities@2022-01-31-preview' = {
  name: managedIdentity
  location: location
}

resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: appName
  location: location
  kind: 'web'
  identity: {
    type: 'UserAssigned'
  userAssignedIdentities: {
    '${mi.id}': {
    }
  }
}
  properties: {
    siteConfig: union(configReference[language],{
      minTlsVersion: '1.2'
      scmMinTlsVersion: '1.2'
      ftpsState: 'FtpsOnly'
    })
    httpsOnly: true
    serverFarmId:  appPlanId
  }
}

resource gitsource 'Microsoft.Web/sites/sourcecontrols@2022-03-01' = {
  parent: webApp
  name: 'web'
  kind: 'web'
  properties: {
    repoUrl: gitRepoUrl
    branch: 'master'
    isManualIntegration: true
  }
}

output webAppName string = webApp.name
output siteURL string = webApp.properties.hostNames[0]
