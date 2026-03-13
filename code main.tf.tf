terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.114.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

variable "prefix" {
  default = "tpot"
}

###############################################################
# KEY VAULT — Pull secrets securely instead of hardcoding
# WHY: Hardcoding passwords in Terraform files is a major
#      security risk. Key Vault stores secrets encrypted
#      and audits every access attempt.
###############################################################

data "azurerm_key_vault" "tpot_kv" {
  name                = "tpot-keyvault"
  resource_group_name = "${var.prefix}-resources"
}

data "azurerm_key_vault_secret" "vm_password" {
  name         = "vm-admin-password"
  key_vault_id = data.azurerm_key_vault.tpot_kv.id
}

###############################################################
# RESOURCE GROUP
###############################################################

resource "azurerm_resource_group" "tpot-rg" {
  name     = "${var.prefix}-resources"
  location = "eastus"
}

###############################################################
# NETWORKING
###############################################################

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

###############################################################
# NETWORK SECURITY GROUP
# WHY: AllowALL is intentional for a HoneyPot — we WANT
#      attackers to connect so we can monitor them.
#      SSH (port 22) is also open to capture brute force attempts.
#      In a real production system this would be locked down.
###############################################################

resource "azurerm_network_security_group" "tpot-nsg" {
  depends_on          = [azurerm_resource_group.tpot-rg]
  name                = "linux-vm-nsg"
  location            = azurerm_resource_group.tpot-rg.location
  resource_group_name = azurerm_resource_group.tpot-rg.name

  # HoneyPot rule — allow all inbound traffic to attract attackers
  security_rule {
    name                       = "AllowALL"
    description                = "HoneyPot rule — intentionally allows all inbound traffic for attack monitoring"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  # SSH rule — captures brute force login attempts into Sentinel
  security_rule {
    name                       = "AllowSSH"
    description                = "Allow SSH — captures brute force attempts for Sentinel monitoring"
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

# Associate the NSG with the subnet
resource "azurerm_subnet_network_security_group_association" "tpot-vm-nsg-association" {
  depends_on                = [azurerm_resource_group.tpot-rg]
  subnet_id                 = azurerm_subnet.internal.id
  network_security_group_id = azurerm_network_security_group.tpot-nsg.id
}

###############################################################
# PUBLIC IP
###############################################################

resource "azurerm_public_ip" "tpot-vm-ip" {
  depends_on          = [azurerm_resource_group.tpot-rg]
  name                = "tpot-vm-ip"
  location            = azurerm_resource_group.tpot-rg.location
  resource_group_name = azurerm_resource_group.tpot-rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

###############################################################
# NETWORK INTERFACE
###############################################################

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

###############################################################
# VIRTUAL MACHINE — HoneyPot
# Password pulled from Key Vault — NOT hardcoded
###############################################################

resource "azurerm_virtual_machine" "main" {
  depends_on            = [azurerm_resource_group.tpot-rg]
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.tpot-rg.location
  resource_group_name   = azurerm_resource_group.tpot-rg.name
  network_interface_ids = [azurerm_network_interface.tpot-vm-nic.id]
  vm_size               = "Standard_DC1ds_v3"

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
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
    # Password pulled from Key Vault — never hardcoded in code
    admin_password = data.azurerm_key_vault_secret.vm_password.value
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

###############################################################
# OUTPUTS
###############################################################

output "public_ip" {
  value = azurerm_public_ip.tpot-vm-ip.ip_address
}
