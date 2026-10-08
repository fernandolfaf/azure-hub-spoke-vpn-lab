variable "rg_name" {
  default = "rg-labterraform"
}

variable "loc_hub" {
  default = "eastus"
}

variable "loc_spoke1" {
  default = "centralus"
}

variable "loc_spoke2" {
  default = "uksouth"
}

variable "admin_user" {
  default = "admin.luis" # Substitua pelo seu usuário padrão
}

variable "admin_password" {
  description = "Senha do administrador para as VMs"
  type        = string
  sensitive   = true
  default     = "Lf@f0108" # Altere em produção
}