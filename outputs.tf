output "hub_vm_ip" {
  value = azurerm_windows_virtual_machine.vm_hub.private_ip_address
}

output "web1_ip" {
  value = azurerm_windows_virtual_machine.vm_web1.private_ip_address
}

output "web2_ip" {
  value = azurerm_windows_virtual_machine.vm_web2.private_ip_address
}

output "spoke2_linux_ip" {
  value = azurerm_linux_virtual_machine.vm_spoke2.private_ip_address
}

output "firewall_public_ip" {
  value = azurerm_public_ip.pip_fw.ip_address
}

output "firewall_private_ip" {
  value = azurerm_firewall.fw.ip_configuration[0].private_ip_address
}

output "vpn_gateway_public_ip" {
  value = azurerm_public_ip.pip_vng.ip_address
}