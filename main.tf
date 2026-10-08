# =========================================================================
# IP Públicos e Placas de Rede (NICs)
# =========================================================================

# --- Hub ---
resource "azurerm_public_ip" "pip_hub" {
  name                = "pip-vm-hub"
  location            = var.loc_hub
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic" # Laboratório: Dynamic reduz custo quando desligada
}

resource "azurerm_network_interface" "nic_hub" {
  name                = "nic-vm-hub"
  location            = var.loc_hub
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.sub_hub.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip_hub.id
  }
}

# --- Spoke 1 (Web 01 e Web 02) ---
resource "azurerm_public_ip" "pip_web1" {
  name                = "pip-vm-web01"
  location            = var.loc_spoke1
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "nic_web1" {
  name                = "nic-vm-web01"
  location            = var.loc_spoke1
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.sub_spoke1.id
    private_ip_address_allocation = "Dynamic"

  }
}

resource "azurerm_public_ip" "pip_web2" {
  name                = "pip-vm-web02"
  location            = var.loc_spoke1
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "nic_web2" {
  name                = "nic-vm-web02"
  location            = var.loc_spoke1
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.sub_spoke1.id
    private_ip_address_allocation = "Dynamic"

  }
}

# --- Spoke 2 (Linux) ---
resource "azurerm_public_ip" "pip_spoke2" {
  name                = "pip-vm-spoke02"
  location            = var.loc_spoke2
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "nic_spoke2" {
  name                = "nic-vm-spoke02"
  location            = var.loc_spoke2
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.sub_spoke2.id
    private_ip_address_allocation = "Dynamic"

  }
}

# =========================================================================
# Máquinas Virtuais (Compute)
# =========================================================================

# --- VM Hub (Windows Server 2022) ---
resource "azurerm_windows_virtual_machine" "vm_hub" {
  name                = "vm-hub-01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.loc_hub
  size                = "Standard_B2s"
  admin_username      = var.admin_user
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.nic_hub.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS" # Standard SSD para equilibrar custo/performance no lab
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }
}

# --- VM Web 01 (Windows Server 2022) ---
resource "azurerm_windows_virtual_machine" "vm_web1" {
  name                = "vm-web-01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.loc_spoke1
  size                = "Standard_B2s"
  admin_username      = var.admin_user
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.nic_web1.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }
}

# --- VM Web 02 (Windows Server 2022) ---
resource "azurerm_windows_virtual_machine" "vm_web2" {
  name                = "vm-web-02"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.loc_spoke1
  size                = "Standard_B2s"
  admin_username      = var.admin_user
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.nic_web2.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }
}

# --- VM Spoke 02 (Ubuntu Linux 22.04 LTS) ---
resource "azurerm_linux_virtual_machine" "vm_spoke2" {
  name                            = "vm-spoke-02"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = var.loc_spoke2
  size                            = "Standard_B2s"
  admin_username                  = var.admin_user
  admin_password                  = var.admin_password
  disable_password_authentication = false # Autenticação por senha habilitada, conforme o lab
  network_interface_ids = [
    azurerm_network_interface.nic_spoke2.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}