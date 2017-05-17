########################################################################################
########################################################################################
###########
###########   DEPLOY NEW VM FROM TEMPLATE SCRIPT
###########                     BY: Eric Neudorfer
###########                     Date: 04262017
###########                     Revision: 05172017
########################################################################################
########################################################################################
#####
#TO DO
# - ADD A TO DO
# - Send Email
# - Add Description Date and Signature
# - Computer name not being pushed in deployment
# - Network change at end of deployment (Detect finish)
# - 
## CHANGE LOG



# RUN BEFORE SCRIPT TO DISABLE ERRORS
#Set-ExecutionPolicy -ExecutionPolicy bypass
###set-PowerCLIConfiguration -invalidCertificateAction "ignore" -confirm:$false


### SET WINDOW SIZE
$pshost = Get-Host
$psWindow = $pshost.UI.RawUI
$newSize =$psWindow.BufferSize
$newSize.Height = 4000
$newSize.Width = 200
$psWindow.BufferSize = $newSize
$newSize = $psWindow.WindowSize
$newSize.Height = 24
$newSize.Width = 60
$psWindow.WindowSize= $newSize


 echo ""
 echo "  ############################################## "
 echo "            LOADING POWERSHELL MODULES"  
 echo "  ##############################################"  
 echo ""
 


 

##Request credentials
$mycredentials = Get-Credential
 
## Connect remote computer? 
## Load Snapins 
Add-PsSnapin VMware.VimAutomation.Core -ea "SilentlyContinue"

$array = "VCENTER"
for($count=0;$count -lt $array.length; $count++)
{
# Connect to vCenter
connect-viserver $array[$count] -credential $mycredentials
}
 

 #Areyousure function. Alows user to select y or n when asked to exit. Y exits and N returns to main menu.  
 function areyousure {$areyousure = read-host "Are you sure you want to exit? (y/n)"  
           if ($areyousure -eq "y"){exit}  
           if ($areyousure -eq "n"){mainmenu}  
           else {write-host -foregroundcolor red "Invalid Selection"   
                 areyousure  
                }  
                     }  
 #Mainmenu function. Contains the screen output for the menu and waits for and handles user input.  
 function mainmenu{   
 cls  
 echo "---------------------------------------------------------"  
 echo ""  
 echo ""
 echo "  ############################################## "
 echo "           VIRTUAL MACHINE CREATION TOOL"  
 echo "  ##############################################"  
 echo ""
 echo "" 
 echo "    1. Production "
 echo "    2. SD Vblock"
 echo "    3. AZ Vblock "    
 echo "    4. Developemnt "
 echo "    5. Developer Machine "    
 echo "    6. Staging "
 echo "    7. User Acceptance Testing "
 echo "    8. Quality Asurance "  
 echo "    9. Exit"  
 echo ""  
 echo ""  
 echo "---------------------------------------------------------"  
 $answer = read-host "Please Make a Selection"  
 $VM_name = Read-Host -Prompt 'Server Name'
 if ($answer -eq 1){New-VM -Name $VM_name -VMHost  -Template WIN2012_022717 -Datastore VNXNFS05}  
 if ($answer -eq 2){New-VM -Name $VM_name -VMHost -ResourcePool IT -Template -Datastore SDDSPROD }#-OSCustomizationspec }  
 if ($answer -eq 3){New-VM -Name $VM_name -VMHost -ResourcePool -Template   -Datastore AZDS04} 
 if ($answer -eq 4){New-VM -Name $VM_name -VMHost  -ResourcePool DEV -Template   -OSCustomizationspec DEV_11282016 -Datastore Hitachi_SAS} 
 if ($answer -eq 5){New-VM -Name $VM_name -VMHost -ResourcePool DEV MACHINE -Template  -OSCustomizationspec DEVELOPERS_102716 -Datastore Hitachi_SAS} 
 if ($answer -eq 6){New-VM -Name $VM_name -VMHost  -ResourcePool STG -Template  -OSCustomizationspec DEV_11282016 -Datastore Hitachi_SAS}
  if ($answer -eq 7){New-VM -Name $VM_name -VMHost -ResourcePool UAT -Template -OSCustomizationspec UAT_TEMPLATE_12232016 -Datastore Hitachi_SAS}
   if ($answer -eq 8){New-VM -Name $VM_name -VMHost -ResourcePool QA -Template -OSCustomizationspec DEV_11282016  -Datastore Hitachi_SAS}
 if ($answer -eq 9){areyousure}  
 else {write-host #-ForegroundColor red "Invalid Selection"  
       start-vm $VM_name
       sleep 5  
       mainmenu 
      }  
                }  
 mainmenu  
 

 ##WDSUTIL PRESTAGE DEVICE
<#
 $uuid = Get-VM $VM_name | %{(Get-View $_.Id).config.uuid}  
 WDSUtil /Add-Device `"/Device:$VM_name`" /ID:$uuid

$script = 'WDSUtil /Add-Device `"/Device:TEST`" /ID:42079590-d68d-176c-5023-dff55c20def3'
Invoke-VMScript -ScriptText $script -VM TCTS-WDS-1-1 -GuestCredential $mycredentials


runas /profile /user:'wdsutil /Add-Device /Server:################# `"/Device:TEST`" /ID:
#>
 ##############
 #SETUP Email notification 
# SIG # Begin signature block
# MIII0gYJKoZIhvcNAQcCoIIIwzCCCL8CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUrRuQNU7MB8zssFpSIcdj9EQ4
# 07ygggbFMIIGwTCCBKmgAwIBAgITbwAABbC9isxnja8sIAAIAAAFsDANBgkqhkiG
# 9w0BAQsFADBAMRUwEwYKCZImiZPyLGQBGRYFTE9DQUwxFjAUBgoJkiaJk/IsZAEZ
# FgZNWUJPRkkxDzANBgNVBAMTBk1ZQk9GSTAeFw0xNzA1MDQxODM5NTVaFw0xODA1
# MDQxODM5NTVaMIGCMRUwEwYKCZImiZPyLGQBGRYFTE9DQUwxFjAUBgoJkiaJk/Is
# ZAEZFgZNWUJPRkkxCzAJBgNVBAsTAkhRMQ4wDAYDVQQLEwVVc2VyczEWMBQGA1UE
# CxMNQWRtaW5BY2NvdW50czEcMBoGA1UEAxMTRXJpYyBOZXVkb3JmZXIgLUFETTCB
# nzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEA4SyCLjFNO3cq1buOZXwR/QoxW/VT
# YekASdY7zX93Y8c7gFG0qz2/aJXmkEpbrJwKA5NNJ0UpzyFwkEtGEHV1TTZk+14N
# KPYCWuEqKpFv7VmXILw2xPHQrv0SGYGUiRjwvUQQk/wGDC1SzeEtJI8s1a75bYa3
# shZMV2Q3bOtkSpsCAwEAAaOCAvMwggLvMCUGCSsGAQQBgjcUAgQYHhYAQwBvAGQA
# ZQBTAGkAZwBuAGkAbgBnMBMGA1UdJQQMMAoGCCsGAQUFBwMDMAsGA1UdDwQEAwIH
# gDAdBgNVHQ4EFgQUj/qfKyO+ryQW5LA0ZQQ/MBXmBP8wHwYDVR0jBBgwFoAUTp5t
# jwWt891PfVHc3BBq6iGGOmgwggEGBgNVHR8Egf4wgfswgfiggfWggfKGgbVsZGFw
# Oi8vL0NOPU1ZQk9GSSg4KSxDTj1CT0ZJLUhRLUVDQSxDTj1DRFAsQ049UHVibGlj
# JTIwS2V5JTIwU2VydmljZXMsQ049U2VydmljZXMsQ049Q29uZmlndXJhdGlvbixE
# Qz1NWUJPRkksREM9TE9DQUw/Y2VydGlmaWNhdGVSZXZvY2F0aW9uTGlzdD9iYXNl
# P29iamVjdENsYXNzPWNSTERpc3RyaWJ1dGlvblBvaW50hjhodHRwOi8vQk9GSS1I
# US1FQ0EuTVlCT0ZJLkxPQ0FML0NlcnRFbnJvbGwvTVlCT0ZJKDgpLmNybDCCARoG
# CCsGAQUFBwEBBIIBDDCCAQgwgaYGCCsGAQUFBzAChoGZbGRhcDovLy9DTj1NWUJP
# RkksQ049QUlBLENOPVB1YmxpYyUyMEtleSUyMFNlcnZpY2VzLENOPVNlcnZpY2Vz
# LENOPUNvbmZpZ3VyYXRpb24sREM9TVlCT0ZJLERDPUxPQ0FMP2NBQ2VydGlmaWNh
# dGU/YmFzZT9vYmplY3RDbGFzcz1jZXJ0aWZpY2F0aW9uQXV0aG9yaXR5MF0GCCsG
# AQUFBzAChlFodHRwOi8vQk9GSS1IUS1FQ0EuTVlCT0ZJLkxPQ0FML0NlcnRFbnJv
# bGwvQk9GSS1IUS1FQ0EuTVlCT0ZJLkxPQ0FMX01ZQk9GSSg4KS5jcnQwPAYDVR0R
# BDUwM6AxBgorBgEEAYI3FAIDoCMMIWVuZXVkb3JmZXJhZG1AYm9maWZlZGVyYWxi
# YW5rLmNvbTANBgkqhkiG9w0BAQsFAAOCAgEAiEcx2BklNYkhj0jpXBgUlc0ck2cW
# DPZpk8+00LkgHQtNtPcPP1JZgRb62/TqQXtum83AQabAUSvpgNr0UcB11z3J4S0G
# Ey1YkLJmsyzWabt9jtx+wdmwySvRJdnKjjiJ2Y7dYnmwqM6eBLpUT9X6afNP9thA
# U/7ZCCc4yEAeuuFoe5MJx7e5PHgCaPDhgXPq7ee7ucPRUL/IabOXy+S54K+PPOir
# r+c37xnu21QJCY0j/Cg+y4R8TyJ9B/olWSG1SqUomn/CloXUYfo8uFPMgR2yQ1EQ
# 09L2WZO6upGN6G2wuNyzt9a1GIKCQQUJpoO/bi36SFDlfZEbVe84oqmjNHUu9ILY
# X53fEDifpJoIZtzUh9wVE7tShQjujFWtzJsIXjgs62VFC8ikUhois2L29LOf2sqq
# maBHNGGCR2mW7zplT6qKE2n8435KOMUDBige2tkW+lZBFJqwYPCa/3rFuwgAY8HD
# vxpzuXZ09o20HvCMSHjEoK4zh/wBhBpq8OD5y+XNERWuwOR1JQPlCCsR4oZNJzV9
# 7QGTFYIgkh+E8cGFctX6oYNkVoamFLDReeuyX1TYvJKKB5Ae2hvYS9ThadxbIcue
# 3mMfB5T88HZQIZujCW6cxoq05j+vw9xPMy2FOVVGaYMxiU89ck2TuHHzAwnUSoPy
# /52ikxsLQQ73+n0xggF3MIIBcwIBATBXMEAxFTATBgoJkiaJk/IsZAEZFgVMT0NB
# TDEWMBQGCgmSJomT8ixkARkWBk1ZQk9GSTEPMA0GA1UEAxMGTVlCT0ZJAhNvAAAF
# sL2KzGeNrywgAAgAAAWwMAkGBSsOAwIaBQCgeDAYBgorBgEEAYI3AgEMMQowCKAC
# gAChAoAAMBkGCSqGSIb3DQEJAzEMBgorBgEEAYI3AgEEMBwGCisGAQQBgjcCAQsx
# DjAMBgorBgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBS2KLqjEDILLTSstgkIS1NN
# B8dw6jANBgkqhkiG9w0BAQEFAASBgJF5M3QLsJUjdgmXo9lhlOOtP4PNm5HZc9wk
# Pi6/NqdgJ+BfKS7OmbHbNK7nCTDyYWepSND4duVNZhIvxzg4EbkvcBdHX9IeBUy3
# w5mHmr/kojGsdZXmuoGHsD1B47Yr0/0O3XZx6u4SwDWbb+8iLV0sj3zNZjrAGk7t
# DR33u6We
# SIG # End signature block
