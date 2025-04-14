# Chemin des icônes
$IconFolder = "C:\Company\Icons"
New-Item -ItemType Directory -Path $IconFolder -Force | Out-Null

# Liste des raccourcis à créer
$Shortcuts = @(
    @{ Name = "Support Entreprise"; Url = "https://app.mailinblack.com/mibc-fr-05/user-space/spool/list"; IconUrl = "" },
    @{ Name = "Intranet"; Url = "https://partnerinfo.sharepoint.com/sites/EspaceInfra"; IconUrl = "https://URL_TA_ICON_INTRANET.ico" }
)

$DesktopPath = "C:\Users\Public\Desktop"

foreach ($Shortcut in $Shortcuts) {
    $IconPath = Join-Path -Path $IconFolder -ChildPath "$($Shortcut.Name).ico"

    # Téléchargement de l'icone
    Invoke-WebRequest -Uri $Shortcut.IconUrl -OutFile $IconPath -UseBasicParsing

    # Création du raccourci .lnk
    $WshShell = New-Object -ComObject WScript.Shell
    $ShortcutPath = Join-Path -Path $DesktopPath -ChildPath "$($Shortcut.Name).lnk"
    $NewShortcut = $WshShell.CreateShortcut($ShortcutPath)
    $NewShortcut.TargetPath = "C:\Windows\System32\cmd.exe"
    $NewShortcut.Arguments = "/c start $($Shortcut.Url)"
    $NewShortcut.IconLocation = $IconPath
    $NewShortcut.Save()
}
