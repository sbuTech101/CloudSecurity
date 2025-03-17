terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.90.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {

  }
}

variable "prefix" {
  default = "tpot"
}

resource "azurerm_resource_group" "tpot-rg" {
  name     = "${var.prefix}-resources"
  location = "East US"
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.tpot-rg.location
  resource_group_name = azurerm_resource_group.tpot-rg.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.tpot-rg.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_virtual_machine" "main" {
  depends_on            = [azurerm_resource_group.tpot-rg]
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.tpot-rg.location
  resource_group_name   = azurerm_resource_group.tpot-rg.name
  network_interface_ids = [azurerm_network_interface.tpot-vm-nic.id]
  vm_size               = "Standard_A2m_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "minimal-gen1"
    version   = "latest"
  }
  storage_os_disk {
    name              = "tpot-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "azureuser"
    admin_password = "CyberNOW!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}
# Create Security Group to access linux
resource "azurerm_network_security_group" "tpot-nsg" {
  depends_on          = [azurerm_resource_group.tpot-rg]
  name                = "linux-vm-nsg"
  location            = azurerm_resource_group.tpot-rg.location
  resource_group_name = azurerm_resource_group.tpot-rg.name
  security_rule {
    name                       = "AllowALL"
    description                = "AllowALL"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "AllowSSH"
    description                = "Allow SSH"
    priority                   = 150
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
}
# Associate the linux NSG with the subnet
resource "azurerm_subnet_network_security_group_association" "tpot-vm-nsg-association" {
  depends_on                = [azurerm_resource_group.tpot-rg]
  subnet_id                 = azurerm_subnet.internal.id
  network_security_group_id = azurerm_network_security_group.tpot-nsg.id
}
# Get a Static Public IP
resource "azurerm_public_ip" "tpot-vm-ip" {
  depends_on          = [azurerm_resource_group.tpot-rg]
  name                = "tpot-vm-ip"
  location            = azurerm_resource_group.tpot-rg.location
  resource_group_name = azurerm_resource_group.tpot-rg.name
  allocation_method   = "Static"
}
# Create Network Card for linux VM
resource "azurerm_network_interface" "tpot-vm-nic" {
  depends_on          = [azurerm_resource_group.tpot-rg]
  name                = "tpot-vm-nic"
  location            = azurerm_resource_group.tpot-rg.location
  resource_group_name = azurerm_resource_group.tpot-rg.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.tpot-vm-ip.id
  }
}
output "public_ip" {
  value = azurerm_public_ip.tpot-vm-ip.ip_address
}
