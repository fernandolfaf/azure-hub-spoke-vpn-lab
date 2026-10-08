resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.loc_hub
}

# ==================== VNets & Subnets ====================
resource "azurerm_virtual_network" "hub" {
  name                = "vnet-hub"
  location            = var.loc_hub
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.100.0.0/16"]
}

resource "azurerm_subnet" "sub_hub" {
  name                 = "sub-hub"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.100.1.0/24"]
}

resource "azurerm_subnet" "fw_subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.100.2.0/26"]
}

resource "azurerm_subnet" "gw_subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.100.3.0/27"]
}

resource "azurerm_virtual_network" "spoke1" {
  name                = "vnet-spoke-01"
  location            = var.loc_spoke1
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.101.0.0/16"]
}

resource "azurerm_subnet" "sub_spoke1" {
  name                 = "sub-spoke-01"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.spoke1.name
  address_prefixes     = ["10.101.1.0/24"]
}

resource "azurerm_virtual_network" "spoke2" {
  name                = "vnet-spoke-02"
  location            = var.loc_spoke2
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.102.0.0/16"]
}

resource "azurerm_subnet" "sub_spoke2" {
  name                 = "sub-spoke-02"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.spoke2.name
  address_prefixes     = ["10.102.1.0/24"]
}

# ==================== VNet Peerings ====================
resource "azurerm_virtual_network_peering" "hub_to_spoke1" {
  name                         = "hub-to-spoke01"
  resource_group_name          = azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.hub.name
  remote_virtual_network_id    = azurerm_virtual_network.spoke1.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
}

resource "azurerm_virtual_network_peering" "spoke1_to_hub" {
  name                         = "spoke01-to-hub"
  resource_group_name          = azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.spoke1.name
  remote_virtual_network_id    = azurerm_virtual_network.hub.id
  allow_virtual_network_access = true
  use_remote_gateways          = true
  depends_on                   = [azurerm_virtual_network_gateway.vng] # Necessário ter o GW antes
}

resource "azurerm_virtual_network_peering" "hub_to_spoke2" {
  name                         = "hub-to-spoke02"
  resource_group_name          = azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.hub.name
  remote_virtual_network_id    = azurerm_virtual_network.spoke2.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
}

resource "azurerm_virtual_network_peering" "spoke2_to_hub" {
  name                         = "spoke02-to-hub"
  resource_group_name          = azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.spoke2.name
  remote_virtual_network_id    = azurerm_virtual_network.hub.id
  allow_virtual_network_access = true
  use_remote_gateways          = true
  depends_on                   = [azurerm_virtual_network_gateway.vng]
}