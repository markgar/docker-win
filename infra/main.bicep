@description('location for all resources')
param location string = resourceGroup().location

var uniqueStr = substring(uniqueString(resourceGroup().id), 1, 4)

resource containerReg 'Microsoft.ContainerRegistry/registries@2019-05-01' = {
  location: location
  name: 'contreg${uniqueStr}'
  sku: {
    name: 'Basic'
  }
  properties:{
    adminUserEnabled: true
  }
}


resource svcplan 'Microsoft.Web/serverfarms@2020-06-01' = {
  location: location
  name: 'svcpln-${uniqueStr}'
  sku: {
    name: 'P1v3'
    tier: 'PremiumV3'
    size: 'P1v3'
    family: 'Pv3'
    capacity: 1
  }
  kind: 'windows'
}

resource web 'Microsoft.Web/sites@2020-06-01' = {
  location: location
  name: 'webapp-${uniqueStr}'
  kind: 'app,container,windows'
  dependsOn: [
    containerReg
  ]
  properties: {
    serverFarmId: svcplan.id
    siteConfig:{
      windowsFxVersion: 'DOCKER|mcr.microsoft.com/azure-app-service/windows/parkingpage:latest'
    }
  }
}