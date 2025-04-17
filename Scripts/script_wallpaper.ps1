# Fond d'écran - URL en ligne
$DesktopImageURL = "https://github.com/betasown/Internship/blob/main/images/Wallpaper.png?raw=true"
$LockscreenImageURL = "https://github.com/betasown/Internship/blob/main/images/Wallpaper.png?raw=true"

# Chemin local pour stocker les images
$UserPicturesFolder = [Environment]::GetFolderPath("MyPictures")
$ImageBankFolder = Join-Path -Path $UserPicturesFolder -ChildPath "Banque d'image"

# Créer le dossier Banque d'image s'il n'existe pas
if (!(Test-Path $ImageBankFolder)) {
    New-Item -ItemType Directory -Path $ImageBankFolder | Out-Null
}

$DesktopLocalImage = Join-Path -Path $ImageBankFolder -ChildPath "Wallpaper.png"
$LockscreenLocalImage = Join-Path -Path $ImageBankFolder -ChildPath "Lockscreen.png"

# Télécharger les images en local
if (!(Test-Path $DesktopLocalImage)) {
    Invoke-WebRequest -Uri $DesktopImageURL -OutFile $DesktopLocalImage
}

if (!(Test-Path $LockscreenLocalImage)) {
    Invoke-WebRequest -Uri $LockscreenImageURL -OutFile $LockscreenLocalImage
}

# Registre - Chemin vers la clé
$RegKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP"

# Modifier les clés de Registre si les images existent
if ((Test-Path $DesktopLocalImage) -and (Test-Path $LockscreenLocalImage)) {

    # Créer la clé PersonalizationCSP si elle n'existe pas
    if (!(Test-Path $RegKeyPath)) {
        New-Item -Path $RegKeyPath -Force | Out-Null
    }

    # Configurer le fond d'écran
    New-ItemProperty -Path $RegKeyPath -Name DesktopImageStatus -Value 0 -PropertyType DWORD -Force | Out-Null
    New-ItemProperty -Path $RegKeyPath -Name DesktopImagePath -Value $DesktopLocalImage -PropertyType String -Force | Out-Null
    New-ItemProperty -Path $RegKeyPath -Name DesktopImageUrl -Value $DesktopLocalImage -PropertyType String -Force | Out-Null

    # Configurer l'écran de verrouillage
    New-ItemProperty -Path $RegKeyPath -Name LockScreenImageStatus -Value 0 -PropertyType DWORD -Force | Out-Null
    New-ItemProperty -Path $RegKeyPath -Name LockScreenImagePath -Value $LockscreenLocalImage -PropertyType String -Force | Out-Null
    New-ItemProperty -Path $RegKeyPath -Name LockScreenImageUrl -Value $LockscreenLocalImage -PropertyType String -Force | Out-Null

    # Forcer la mise à jour du fond d'écran sans redémarrage
    Add-Type -TypeDefinition @"
    using System;
    using System.Runtime.InteropServices;
    public class RefreshDesktop {
        [DllImport("user32.dll")]
        public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
    }
"@
    [RefreshDesktop]::SystemParametersInfo(20, 0, $DesktopLocalImage, 3)
}
