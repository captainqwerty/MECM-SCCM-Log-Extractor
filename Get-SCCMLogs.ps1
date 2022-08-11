Write-host "Starting SCCM OSD Log Export" -ForegroundColor green

$LogLocations = @(
    "X:\windows\temp\smstslog\", # 0 - Before the hard disk is formatted 
    "X:\smstslog\", # 1 - After the hard disk is formatted and then copied to location 2
    "C:\_SMSTaskSequence\", # 2 - Before the SCCM client is installed
    "C:\windows\ccm\logs\Smstslog\", # 3 - After the SCCM client is installed
    "C:\windows\ccm\logs\" # 4 - When the Task sequence is complete
)

$DebugLogLocation = "C:\Windows\debug\"

$choices  = '&Yes', '&No'
$decision = $Host.UI.PromptForChoice("Just get SMSTS Log?", "Would you like to only get the SMSTS.log?", $choices, 1)
if ($decision -eq 0) { $limitedToSMSTS = $true } else { $limitedToSMSTS = $false }

for ($i = 0; $i -lt $LogLocations.Count; $i++) {
    if (Test-Path $Loglocations[$i]) {
        Write-Host "$($Loglocations[$i]) found." -ForegroundColor Green
        
        $destination = "$PSScriptRoot\Exported Logs\$env:COMPUTERNAME\$i"
        if(!(Test-Path $destination)) {
            new-item $destination -ItemType Directory | out-null
        }

        if($limitedToSMSTS) {
            if(Test-path "$($Loglocations[$i])\smsts.log") {
                Copy-Item "$($Loglocations[$i])\smsts.log" $destination -Force
            }
        } else {
            Copy-Item "$($Loglocations[$i])\*.log" $destination -force
        }
    }
}

$choices  = '&Yes', '&No'
$decision = $Host.UI.PromptForChoice("Windows Debug Logs?", "Would you like to get the Windows Debug logs?", $choices, 1)
if ($decision -eq 0) { $GetDebugLogs = $true } else { $GetDebugLogs = $false }

if($GetDebugLogs) {
    if(Test-path $DebugLogLocation) {
        Write-Host "$DebugLogLocation found." -ForegroundColor Green
        
        $destination = "$PSScriptRoot\Exported Logs\$env:COMPUTERNAME\DebugLogs"
        
        if(!(Test-Path $destination)) {
            new-item $destination -ItemType Directory | out-null
        }

        Copy-Item "$($DebugLogLocation)\*.log" $destination -force
    }
}