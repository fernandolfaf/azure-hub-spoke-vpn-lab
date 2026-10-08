# ==================== Azure Firewall ====================
resource "azurerm_public_ip" "pip_fw" {
  name                = "pip-fw01"
  location            = var.loc_hub
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall_policy" "fw_policy" {
  name                = "pol-fw01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.loc_hub
  sku                 = "Premium"
}

resource "azurerm_firewall" "fw" {
  name                = "fw-01"
  location            = var.loc_hub
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Premium"
  firewall_policy_id  = azurerm_firewall_policy.fw_policy.id

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.fw_subnet.id
    public_ip_address_id = azurerm_public_ip.pip_fw.id
  }
}

# ==================== VPN Gateway ====================
resource "azurerm_public_ip" "pip_vng" {
  name                = "pip-vng01"
  location            = var.loc_hub
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_virtual_network_gateway" "vng" {
  name                = "vng-01"
  location            = var.loc_hub
  resource_group_name = azurerm_resource_group.rg.name
  type                = "Vpn"
  vpn_type            = "RouteBased"
  active_active       = false
  enable_bgp          = false
  sku                 = "VpnGw1AZ"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.pip_vng.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gw_subnet.id
  }
}

# ==================== Private DNS Zone ====================
resource "azurerm_private_dns_zone" "dns" {
  name                = "tftechcloud.com.br"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns_hub" {
  name                  = "link-vnet-hub"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.dns.name
  virtual_network_id    = azurerm_virtual_network.hub.id
  registration_enabled  = true
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns_spoke1" {
  name                  = "link-vnet-spoke01"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.dns.name
  virtual_network_id    = azurerm_virtual_network.spoke1.id
  registration_enabled  = true
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns_spoke2" {
  name                  = "link-vnet-spoke02"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.dns.name
  virtual_network_id    = azurerm_virtual_network.spoke2.id
  registration_enabled  = true
}