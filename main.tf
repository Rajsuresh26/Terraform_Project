# DEFINING RESOURCE GROUPS:
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# DEFINING STORAGE ACCOUNT:
resource "azurerm_storage_account" "storage" {
  name                     = "storageacmyaz"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# DEFINING CONTAINER
resource "azurerm_storage_container" "container" {
  name                  = "azcontainer"
  storage_account_name = azurerm_storage_account.storage.name
  container_access_type = "private"
}

# DEFINING VIRTUAL NETWORKS:
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# DEFINING SUBNETS:
# frontend subnet:
resource "azurerm_subnet" "frontendsn" {
  name                 = "frontendsn"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# backend subnet:
resource "azurerm_subnet" "backendsn" {
  name                 = "backendsn"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# middle subnet:
resource "azurerm_subnet" "middlesn" {
  name                 = "middlesn"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.3.0/24"]
}

# DEFINING LOAD BALANCER:
# defining Azure public IP address:
resource "azurerm_public_ip" "pip" {
  name                = "pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method  = var.public_ip_allocation_method
}

# defining the load balancer configuring the frontend IP:
resource "azurerm_lb" "lb" {
  name                = "lb"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.pip.id
  }
}

# DEFINING VIRTUAL MACHINE AND AVAILABITY SET:
# Availability set
resource "azurerm_availability_set" "avset" {
  name                = "avset"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# virtual machine:
resource "azurerm_virtual_machine" "vm" {
  name                  = "vm"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  availability_set_id   = azurerm_availability_set.avset.id
  vm_size               = var.vm_size

   storage_os_disk {
    name              = "osdisk"
    caching           = "ReadWrite"
    create_option    = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "vmwindowsaz"
    admin_username = "azadminuser"
    admin_password = "AzureVM@12345"
  }

  os_profile_windows_config {
  }
  
  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

# DEFINING NETWORK INTERFACE CARD
resource "azurerm_network_interface" "nic" {
  name                      = "nic"
  location                  = azurerm_resource_group.rg.location
  resource_group_name       = azurerm_resource_group.rg.name
  enable_accelerated_networking = true

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.backendsn.id
    private_ip_address_allocation = "Dynamic"
    primary                       = true
  }
}

output "vm_ip_address" {
  value = azurerm_network_interface.nic.private_ip_address
}