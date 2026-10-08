# ==================== NSGs ====================
resource "azurerm_network_security_group" "nsg_hub" {
  name                = "nsg-hub"
  location            = var.loc_hub
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "allow-any-RDP-inbound"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
resource "azurerm_subnet_network_security_group_association" "nsg_hub_assoc" {
  subnet_id                 = azurerm_subnet.sub_hub.id
  network_security_group_id = azurerm_network_security_group.nsg_hub.id
}

resource "azurerm_network_security_group" "nsg_spoke1" {
  name                = "nsg-spoke01"
  location            = var.loc_spoke1
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "allow-RDP-Spoke1"
    priority                   = 201
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
resource "azurerm_subnet_network_security_group_association" "nsg_spoke1_assoc" {
  subnet_id                 = azurerm_subnet.sub_spoke1.id
  network_security_group_id = azurerm_network_security_group.nsg_spoke1.id
}

resource "azurerm_network_security_group" "nsg_spoke2" {
  name                = "nsg-spoke02"
  location            = var.loc_spoke2
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "allow-SSH-Spoke2"
    priority                   = 202
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
resource "azurerm_subnet_network_security_group_association" "nsg_spoke2_assoc" {
  subnet_id                 = azurerm_subnet.sub_spoke2.id
  network_security_group_id = azurerm_network_security_group.nsg_spoke2.id
}

# ==================== Route Tables (UDR) ====================
resource "azurerm_route_table" "rt_spoke1" {
  name                = "rt-spoke01"
  location            = var.loc_spoke1
  resource_group_name = azurerm_resource_group.rg.name

  route {
    name                   = "rule01-internet"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.fw.ip_configuration[0].private_ip_address
  }
}
resource "azurerm_subnet_route_table_association" "rt_spoke1_assoc" {
  subnet_id      = azurerm_subnet.sub_spoke1.id
  route_table_id = azurerm_route_table.rt_spoke1.id
}

resource "azurerm_route_table" "rt_spoke2" {
  name                = "rt-spoke02"
  location            = var.loc_spoke2
  resource_group_name = azurerm_resource_group.rg.name

  route {
    name                   = "rule01-internet"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.fw.ip_configuration[0].private_ip_address
  }
}
resource "azurerm_subnet_route_table_association" "rt_spoke2_assoc" {
  subnet_id      = azurerm_subnet.sub_spoke2.id
  route_table_id = azurerm_route_table.rt_spoke2.id
}