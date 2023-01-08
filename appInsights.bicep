@description('Name of azure web app')
param prefixName string = 'ievap'
param location string = resourceGroup().location
param environmentName string
var appInsight = '${prefixName}_appInsights-${environmentName}'

resource AppInsights_app 'Microsoft.Insights/components@2020-02-02-preview' = {
  name: appInsight
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
  }
}
output workState string = AppInsights_app.name
