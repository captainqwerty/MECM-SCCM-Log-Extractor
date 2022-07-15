<#
.SYNOPSIS
  Driver Export
.DESCRIPTION
  Exports drivers for the current machine, compresses the exported drivers and uploads the archive to the Drivers Share on the SCCM server
.NOTES
  Current Version : 1.0
  Author          : Antony Bragg
  Creation Date   : 07/07/2022
#>

<#-----[ Last Change Notes ]-----#

07/07/2022 - Antony Bragg
Initial Script Creation.

#>

#-----[ Requirements ]-----#

#requires -runasadministrator

#-----[ Configuration ]-----#

$model = (get-ciminstance -ClassName win32_computersystem).model
$destination = "C:\temp\Drivers"

$compress = @{
    Path = $destination
    CompressionLevel = "Fastest"
    DestinationPath = "C:\temp\Drivers.Zip"
}

#-----[    Classes    ]-----#

# No Classes

#-----[   Functions   ]-----#

# No Functions

#-----[   Execution   ]-----#

if(!(test-path "\\lhq-sccm-01\d$\Drivers\Source\$model")) {
  $choices  = '&Yes', '&No'
  $decision = $Host.UI.PromptForChoice("Pre-Check", "Have you made sure no drivers are missing and this device is on the latest drivers?", $choices, 1)
  if ($decision -eq 1) {
      Write-Host "Please complete a driver update then try again." -ForegroundColor red
      exit;
  }

  Export-WindowsDriver -online -Destination $destination
  Compress-Archive @compress
  new-item -ItemType Directory -path "\\lhq-sccm-01\d$\Drivers\Source\$model"
  Copy-Item -path "$destination.zip" -Destination "\\lhq-sccm-01\d$\Drivers\Source\$model\Drivers.zip"
} else {
  Write-Host "A driver package already exists for this device." -ForegroundColor Red
}