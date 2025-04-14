# Fond ecran - URL en ligne et en local
$DesktopImageURL = "https://github.com/betasown/Internship/blob/main/images/Wallpaper.png?raw=true" # Lien vers l'image pour le bureau, hébergé sur un cloud 
$LockscreenImageURL = "https://github.com/betasown/Internship/blob/main/images/Wallpaper.png?raw=true" # Lien vers l'image pour l'écran de verrouillage, hébergé sur un cloud 

# Chemin local pour stocker les images
$UserPicturesFolder = [Environment]::GetFolderPath("MyPictures")
$ImageBankFolder = Join-Path -Path $UserPicturesFolder -ChildPath "Banque d'image"

# Créer le dossier Banque d'image s'il n'existe pas
if (!(Test-Path $ImageBankFolder)) {
    New-Item -ItemType Directory -Path $ImageBankFolder | Out-Null
}

$DesktopLocalImage = Join-Path -Path $ImageBankFolder -ChildPath "Wallpaper.png"
$LockscreenLocalImage = Join-Path -Path $ImageBankFolder -ChildPath "Lockscreen.png"

# Registre - Chemin vers la cle (qui doit accueillir les valeurs)
$RegKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP"

# Télécharger les images en local
if (!(Test-Path $DesktopLocalImage)) {
    Start-BitsTransfer -Source $DesktopImageURL -Destination $DesktopLocalImage
}

if (!(Test-Path $LockscreenLocalImage)) {
    Start-BitsTransfer -Source $LockscreenImageURL -Destination $LockscreenLocalImage
}

# Modifier les clés de Registre (seulement si l'on parvient à accéder aux images en local)
if ((Test-Path $DesktopLocalImage) -and (Test-Path $LockscreenLocalImage)) {

    # Créer la clé PersonalizationCSP si elle n'existe pas
    if (!(Test-Path $RegKeyPath)) {
        New-Item -Path $RegKeyPath -Force | Out-Null
    }

    # Registre Windows - Configurer l'image de fond d'écran (wallpaper)
    New-ItemProperty -Path $RegKeyPath -Name DesktopImageStatus -Value 0 -PropertyType DWORD -Force | Out-Null
    New-ItemProperty -Path $RegKeyPath -Name DesktopImagePath -Value $DesktopLocalImage -PropertyType String -Force | Out-Null
    New-ItemProperty -Path $RegKeyPath -Name DesktopImageUrl -Value $DesktopLocalImage -PropertyType String -Force | Out-Null

    # Registre Windows - Configurer l'image de l'écran de verrouillage (lockscreen)
    New-ItemProperty -Path $RegKeyPath -Name LockScreenImageStatus -Value 0 -PropertyType DWORD -Force | Out-Null
    New-ItemProperty -Path $RegKeyPath -Name LockScreenImagePath -Value $LockscreenLocalImage -PropertyType String -Force | Out-Null
    New-ItemProperty -Path $RegKeyPath -Name LockScreenImageUrl -Value $LockscreenLocalImage -PropertyType String -Force | Out-Null
}
