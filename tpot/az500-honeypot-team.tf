###############################################################
# AZ-500 Lab — HoneyPot Security Team
#
# Creates 3 users who manage and monitor your HoneyPot
# through Azure Sentinel, protected by Conditional Access.
#
# Alice Admin   → full access, manages everything
# Bob Analyst   → investigates Sentinel alerts
# Carol Viewer  → reads reports and dashboards only
#
# HOW TO RUN:
#   1. Change "yourorg.onmicrosoft.com" to your domain (line 40)
#   2. Change the subscription_id to yours (line 41)
#   3. Set credentials in terminal:
#        export ARM_CLIENT_ID="..."
#        export ARM_CLIENT_SECRET="..."
#        export ARM_TENANT_ID="..."
#   4. Run: terraform init → terraform plan → terraform apply
###############################################################

terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.47.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.90.0"
    }
  }
  required_version = ">= 1.5.0"
}

provider "azuread" {}
provider "azurerm" {
  features {}
}

###############################################################
# ⚠️  CHANGE THESE TWO VALUES BEFORE RUNNING
###############################################################

locals {
  domain_name     = "yourorg.onmicrosoft.com"  # ← your Entra domain
  subscription_id = "your-subscription-id"      # ← your Azure subscription ID

  # Countries your team signs in from — everything else gets blocked
  allowed_countries = ["ZA", "GB", "US"]
}

###############################################################
# SECURITY GROUPS
# One group per role — makes it easy to manage permissions
###############################################################

resource "azuread_group" "admins" {
  display_name     = "honeypot-admins"
  security_enabled = true
  mail_enabled     = false
  description      = "Full access — manages HoneyPot infrastructure and Sentinel"
}

resource "azuread_group" "analysts" {
  display_name     = "honeypot-analysts"
  security_enabled = true
  mail_enabled     = false
  description      = "Investigates Sentinel alerts and HoneyPot attack data"
}

resource "azuread_group" "viewers" {
  display_name     = "honeypot-viewers"
  security_enabled = true
  mail_enabled     = false
  description      = "Read-only access to Sentinel dashboards and reports"
}

###############################################################
# USERS
# Each user has force_password_change = true so they must
# set their own password on first login — security best practice
###############################################################

# Alice — Security Administrator
# Role: Manages the HoneyPot VM, Sentinel workspace, and team access
resource "azuread_user" "alice" {
  display_name        = "Alice Admin"
  user_principal_name = "alice.admin@${local.domain_name}"
  mail_nickname       = "alice.admin"
  department          = "IT Security"
  job_title           = "Security Administrator"
  account_enabled     = true

  password                    = "TempP@ss!Alice1"
  force_password_change       = true
  disable_password_expiration = false
}

# Bob — SOC Analyst
# Role: Reviews Sentinel incidents, investigates attack patterns from HoneyPot
resource "azuread_user" "bob" {
  display_name        = "Bob Analyst"
  user_principal_name = "bob.analyst@${local.domain_name}"
  mail_nickname       = "bob.analyst"
  department          = "SOC"
  job_title           = "Security Analyst"
  account_enabled     = true

  password                    = "TempP@ss!Bob1234"
  force_password_change       = true
  disable_password_expiration = false
}

# Carol — Compliance Auditor
# Role: Views Sentinel dashboards and attack reports — read only
resource "azuread_user" "carol" {
  display_name        = "Carol Viewer"
  user_principal_name = "carol.viewer@${local.domain_name}"
  mail_nickname       = "carol.viewer"
  department          = "Compliance"
  job_title           = "Compliance Auditor"
  account_enabled     = true

  password                    = "TempP@ss!Carol1"
  force_password_change       = true
  disable_password_expiration = false
}

###############################################################
# GROUP ASSIGNMENTS
# Put each user in the right group
###############################################################

resource "azuread_group_member" "alice_to_admins" {
  group_object_id  = azuread_group.admins.id
  member_object_id = azuread_user.alice.id
}

resource "azuread_group_member" "bob_to_analysts" {
  group_object_id  = azuread_group.analysts.id
  member_object_id = azuread_user.bob.id
}

resource "azuread_group_member" "carol_to_viewers" {
  group_object_id  = azuread_group.viewers.id
  member_object_id = azuread_user.carol.id
}

###############################################################
# SENTINEL ROLE ASSIGNMENTS
# Gives each user the right level of access in Sentinel
# so they can actually do their jobs monitoring the HoneyPot
###############################################################

# Alice gets Sentinel Contributor — can manage everything in Sentinel
resource "azurerm_role_assignment" "alice_sentinel" {
  scope                = "/subscriptions/${local.subscription_id}"
  role_definition_name = "Microsoft Sentinel Contributor"
  principal_id         = azuread_user.alice.id
}

# Bob gets Sentinel Responder — can investigate and respond to incidents
resource "azurerm_role_assignment" "bob_sentinel" {
  scope                = "/subscriptions/${local.subscription_id}"
  role_definition_name = "Microsoft Sentinel Responder"
  principal_id         = azuread_user.bob.id
}

# Carol gets Sentinel Reader — can view dashboards and reports only
resource "azurerm_role_assignment" "carol_sentinel" {
  scope                = "/subscriptions/${local.subscription_id}"
  role_definition_name = "Microsoft Sentinel Reader"
  principal_id         = azuread_user.carol.id
}

###############################################################
# NAMED LOCATION — Allowed Countries (used by CA004 below)
###############################################################

resource "azuread_named_location" "allowed_countries" {
  display_name = "Allowed Sign-in Countries"

  country {
    countries_and_regions                 = local.allowed_countries
    include_unknown_countries_and_regions = false
  }
}

###############################################################
# CA001 — Require MFA for All Users
# WHY: Protects your security team's accounts from
#      credential attacks — essential for anyone with
#      access to Sentinel and HoneyPot data
###############################################################

resource "azuread_conditional_access_policy" "require_mfa" {
  display_name = "CA001 — Require MFA for All Users"
  state        = "enabled"

  conditions {
    users {
      included_users = ["All"]
      excluded_users = ["GuestsOrExternalUsers"]
    }
    applications {
      included_applications = ["All"]
    }
    client_app_types = ["browser", "mobileAppsAndDesktopClients"]
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["mfa"]
  }
}

###############################################################
# CA002 — Block Legacy Authentication
# WHY: Old protocols like IMAP and POP3 can't enforce MFA.
#      An attacker could use them to bypass CA001 entirely.
###############################################################

resource "azuread_conditional_access_policy" "block_legacy_auth" {
  display_name = "CA002 — Block Legacy Authentication"
  state        = "enabled"

  conditions {
    users {
      included_users = ["All"]
    }
    applications {
      included_applications = ["All"]
    }
    client_app_types = ["exchangeActiveSync", "other"]
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["block"]
  }
}

###############################################################
# CA003 — Require Compliant Device (Audit Mode)
# WHY: Ensures the devices your team uses to access Sentinel
#      are healthy — patched, encrypted, and AV protected.
# NOTE: Audit mode means it logs but doesn't block yet.
#       Change state to "enabled" once you've verified
#       all team devices are enrolled in Intune.
###############################################################

resource "azuread_conditional_access_policy" "require_compliant_device" {
  display_name = "CA003 — Require Compliant Device (Audit Mode)"
  state        = "enabledForReportingButNotEnforced"

  conditions {
    users {
      included_users = ["All"]
      excluded_users = ["GuestsOrExternalUsers"]
    }
    applications {
      included_applications = ["All"]
    }
    client_app_types = ["browser", "mobileAppsAndDesktopClients"]
    platforms {
      included_platforms = ["windows", "macOS", "iOS", "android"]
    }
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["compliantDevice", "domainJoinedDevice"]
  }
}

###############################################################
# CA004 — Block Sign-ins Outside Allowed Countries
# WHY: Your security team is based in ZA/GB/US. If someone
#      tries to log into Sentinel from anywhere else,
#      it's almost certainly an attacker — block them.
###############################################################

resource "azuread_conditional_access_policy" "restrict_by_location" {
  display_name = "CA004 — Block Sign-ins Outside Allowed Countries"
  state        = "enabled"

  conditions {
    users {
      included_users = ["All"]
      excluded_users = ["GuestsOrExternalUsers"]
    }
    applications {
      included_applications = ["All"]
    }
    client_app_types = ["all"]
    locations {
      included_locations = ["All"]
      excluded_locations = [azuread_named_location.allowed_countries.id]
    }
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["block"]
  }
}

###############################################################
# OUTPUTS — printed after terraform apply completes
###############################################################

output "alice_upn"  { value = azuread_user.alice.user_principal_name }
output "bob_upn"    { value = azuread_user.bob.user_principal_name }
output "carol_upn"  { value = azuread_user.carol.user_principal_name }

output "alice_sentinel_role" { value = "Microsoft Sentinel Contributor" }
output "bob_sentinel_role"   { value = "Microsoft Sentinel Responder" }
output "carol_sentinel_role" { value = "Microsoft Sentinel Reader" }
