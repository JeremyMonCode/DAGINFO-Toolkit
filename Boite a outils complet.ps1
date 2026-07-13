#Requires -Version 5.0
<#
    Console Maitre de Maintenance
    Conversion PowerShell du script batch original
#>

# ===================== Verification des droits administrateur =====================
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Permissions Administrateur Requises." -ForegroundColor Red
    Write-Host "Relance du script en tant qu'administrateur..." -ForegroundColor Yellow
    try {
        Start-Process powershell.exe -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    } catch {
        Write-Host "Impossible d'obtenir les droits administrateur." -ForegroundColor Red
        Read-Host "Appuyez sur Entree pour quitter"
    }
    exit
}

Set-Location -Path $PSScriptRoot
$Host.UI.RawUI.WindowTitle = "DAGINFO Toolkit"

function Pause-Script {
    Read-Host "`nAppuyez sur Entree pour continuer"
}

# ===================== MENU PRINCIPAL =====================
function Show-MainMenu {
    do {
        Clear-Host
        Write-Host "======================================================================="
        Write-Host "          		CONSOLE MAITRE DE MAINTENANCE"
        Write-Host "======================================================================="
        Write-Host ""
        Write-Host "    1. Outils de Maintenance Globale"
        Write-Host "    2. Outils de Depannage Imprimantes"
        Write-Host "    3. Outils d'Analyse Hardware et BIOS"
        Write-Host "    4. Outils de Diagnostic et Reparation Reseau"
        Write-Host "    5. Generer un rapport de Batterie"
        Write-Host "    6. Nettoyage du magasin des composants WinSxS"
        Write-Host "    7. Quitter"
        Write-Host ""
        Write-Host "======================================================================="
        $choice = Read-Host "Entrez votre selection (1-7)"

        switch ($choice) {
            "1" { Show-GlobalMenu }
            "2" { Show-PrinterMenu }
            "3" { Show-BiosMenu }
            "4" { Show-NetworkMenu }
            "5" { New-BatteryReport }
            "6" { Invoke-WinSxSCleanup }
            "7" { return }
            default { }
        }
    } while ($true)
}

# ===================== MAINTENANCE GLOBALE =====================
function Show-GlobalMenu {
    do {
        Clear-Host
        Write-Host "1. Analyse Antivirus Windows Defender"
        Write-Host "2. S.M.A.R.T: Sante des disques"
        Write-Host "3. Systeme: Reparation Image DISM"
        Write-Host "4. Systeme: Verification Fichiers SFC"
        Write-Host "5. Disque: Verification CHKDSK"
        Write-Host "6. Interface: Relancer l'Explorateur"
        Write-Host "7. Logiciels: Mise a jour Winget"
        Write-Host "8. Nettoyage: Caches et Temp"
        Write-Host "9. Retour"
        $choice = Read-Host "Votre choix ?"

        switch ($choice) {
            "1" {
                Clear-Host
                & "$env:ProgramFiles\Windows Defender\MpCmdRun.exe" -Scan -ScanType 1
                Pause-Script
            }
            "2" {
                Clear-Host
                Get-CimInstance -Namespace root\wmi -ClassName MSStorageDriver_FailurePredictStatus -ErrorAction SilentlyContinue |
                    Select-Object InstanceName, PredictFailure
                Get-PhysicalDisk | Select-Object DeviceId, FriendlyName, OperationalStatus, HealthStatus
                Pause-Script
            }
            "3" {
                Clear-Host
                dism /Online /Cleanup-Image /RestoreHealth
                Pause-Script
            }
            "4" {
                Clear-Host
                sfc /scannow
                Pause-Script
            }
            "5" {
                Clear-Host
                chkdsk C: /f
                Pause-Script
            }
            "6" {
                Clear-Host
                Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
                Start-Process explorer.exe
                Pause-Script
            }
            "7" {
                Clear-Host
                winget upgrade --all --include-unknown
                Pause-Script
            }
            "8" {
                Clear-Host
                ipconfig /flushdns | Out-Null
                Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
                Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
                Remove-Item -Path "$env:SystemDrive\`$Recycle.Bin" -Recurse -Force -ErrorAction SilentlyContinue
                Write-Host "Nettoyage termine."
                Pause-Script
            }
            "9" { return }
            default { }
        }
    } while ($true)
}

# ===================== IMPRIMANTES =====================
function Show-PrinterMenu {
    do {
        Clear-Host
        Write-Host "1. Redemarrage du Spooler"
        Write-Host "2. Effacer les impressions en attente"
        Write-Host "3. Ouvrir les parametres des imprimantes"
        Write-Host "4. Ouvrir Peripheriques et imprimantes"
        Write-Host "5. Verifier l'etat via requete systeme"
        Write-Host "6. Retour"
        $choice = Read-Host "Entrez votre choix"

        switch ($choice) {
            "1" {
                Restart-Service -Name Spooler -Force -ErrorAction SilentlyContinue
                Pause-Script
            }
            "2" {
                Stop-Service -Name Spooler -Force -ErrorAction SilentlyContinue
                Remove-Item -Path "$env:SystemRoot\System32\spool\PRINTERS\*.*" -Force -ErrorAction SilentlyContinue
                Start-Service -Name Spooler -ErrorAction SilentlyContinue
                Pause-Script
            }
            "3" { Start-Process "ms-settings:printers" }
            "4" { control printers }
            "5" {
                Clear-Host
                Get-CimInstance -ClassName Win32_Printer | Select-Object Name, PrinterStatus | Format-Table -AutoSize
                Pause-Script
            }
            "6" { return }
            default { }
        }
    } while ($true)
}

# ===================== HARDWARE / BIOS =====================
function Show-BiosMenu {
    do {
        Clear-Host
        Write-Host "1. Redemarrer dans le BIOS/UEFI"
        Write-Host "2. Options de demarrage avancees"
        Write-Host "3. Informations systeme"
        Write-Host "4. Gestion du TPM"
        Write-Host "5. Verifier le Secure Boot"
        Write-Host "6. Verifier la version du BIOS"
        Write-Host "7. Ouvrir la Gestion des disques"
        Write-Host "8. Ouvrir le Gestionnaire de peripheriques"
        Write-Host "9. Retour"
        $choice = Read-Host "Selectionner une option"

        switch ($choice) {
            "1" { shutdown /r /fw /t 3 }
            "2" { shutdown /r /o /t 3 }
            "3" {
                Clear-Host
                systeminfo
                Pause-Script
            }
            "4" { Start-Process tpm.msc }
            "5" {
                Clear-Host
                try {
                    $sb = Confirm-SecureBootUEFI
                    if ($sb) { Write-Host "Secure Boot: ACTIVE" } else { Write-Host "Secure Boot: DESACTIVE" }
                } catch {
                    Write-Host "Non supporte ou mode Legacy"
                }
                Pause-Script
            }
            "6" {
                Clear-Host
                Get-CimInstance -ClassName Win32_BIOS | Select-Object Name, SMBIOSBIOSVersion | Format-Table -AutoSize
                Pause-Script
            }
            "7" { Start-Process diskmgmt.msc }
            "8" { Start-Process devmgmt.msc }
            "9" { return }
            default { }
        }
    } while ($true)
}

# ===================== RESEAU =====================
function Show-NetworkMenu {
    do {
        Clear-Host
        Write-Host "1. Afficher la configuration IP"
        Write-Host "2. Vider le cache DNS"
        Write-Host "3. Liberer l'adresse IP"
        Write-Host "4. Renouveler l'adresse IP"
        Write-Host "5. Reinitialiser Winsock et TCP/IP"
        Write-Host "6. Tester la connexion (Ping Google)"
        Write-Host "7. Ouvrir les connexions reseau"
        Write-Host "8. Retour"
        $choice = Read-Host "Selectionner une option"

        switch ($choice) {
            "1" {
                Clear-Host
                ipconfig /all
                Pause-Script
            }
            "2" {
                ipconfig /flushdns
                Pause-Script
            }
            "3" {
                ipconfig /release
                Pause-Script
            }
            "4" {
                ipconfig /renew
                Pause-Script
            }
            "5" {
                netsh winsock reset
                netsh int ip reset
                Pause-Script
            }
            "6" {
                ping 8.8.8.8
                Pause-Script
            }
            "7" { Start-Process ncpa.cpl }
            "8" { return }
            default { }
        }
    } while ($true)
}

# ===================== RAPPORT BATTERIE =====================
function New-BatteryReport {
    Clear-Host
    $outputPath = Join-Path $env:USERPROFILE "Desktop\Rapport_Batterie.html"
    powercfg /batteryreport /output "$outputPath" | Out-Null
    if (Test-Path $outputPath) {
        Write-Host "Rapport sur le Bureau : Rapport_Batterie.html"
        Start-Process $outputPath
    } else {
        Write-Host "Erreur (PC Fixe ?)."
    }
    Pause-Script
}

# ===================== NETTOYAGE WINSXS =====================
function Invoke-WinSxSCleanup {
    Clear-Host
    Dism /Online /Cleanup-Image /StartComponentCleanup /ResetBase
    Pause-Script
}

# ===================== LANCEMENT =====================
Show-MainMenu
