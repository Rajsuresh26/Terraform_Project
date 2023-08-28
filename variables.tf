variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  default = "myazrg"
}

variable "location" {
  description = "Azure region for resources"
  default     = "East US"
}

variable "virtual_network_cidr" {
  description = "CIDR block for the Virtual Network"
  default = "10.0.0.0/16"
  type        = string
}

variable "frontend_subnet_cidr" {
  description = "CIDR block for the Frontend Subnet"
  default = "10.0.1.0/24"
  type        = string
}

variable "backend_subnet_cidr" {
  description = "CIDR block for the Backend Subnet"
  default = "10.0.2.0/24"
  type        = string
}

variable "middle_subnet_cidr" {
  description = "CIDR block for the Middle Subnet"
  default = "10.0.3.0/24"
  type        = string
}

variable "public_ip_allocation_method" {
  description = "Public IP Allocation Method"
  default = "Dynamic"
  type        = string
}

variable "vm_size" {
  description = "Azure VM Size"
  default = "Standard_DS1_v2"
}