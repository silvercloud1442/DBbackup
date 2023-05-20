<# 
.NAME
    Untitled
#>

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = New-Object System.Drawing.Point(152,85)
$Form.text                       = "Form"
$Form.TopMost                    = $false

$Button1                         = New-Object system.Windows.Forms.Button
$Button1.text                    = "Huyopka"
$Button1.width                   = 118
$Button1.height                  = 68
$Button1.location                = New-Object System.Drawing.Point(13,8)
$Button1.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$Form.controls.AddRange(@($Button1))

$Button1.Add_Click({
cd Microsoft.PowerShell.Core\FileSystem
$ini = C:\project\Get-iniFile.ps1 C:\project\config.ini

$sqlServerInstance = $ini["Server1"]["sqlServerInstance"]
$sourceDatabase = $ini["Server1"]["sourceDatabase"]
$backupPath = $ini['Server1']['backupPath']

$targetServer = $ini['Server2']['targetServer']
$targetPath = $ini['Server2']['targetPath']

$targetServer

if (!(Test-Path $backupPath)) {
    New-Item -Path $backupPath -ItemType Directory
}

if (!(Test-Path $targetServer\$targetPath)) {
    New-Item -Path $targetServer\$targetPath -ItemType Directory
}

Backup-SqlDatabase -ServerInstance $sqlServerInstance -Database $sourceDatabase -BackupFile "Microsoft.PowerShell.Core\FileSystem::$backupPath\backup.bak" -Initialize

Copy-Item -Path "Microsoft.PowerShell.Core\FileSystem::$backupPath\backup.bak" -Destination "Microsoft.PowerShell.Core\FileSystem::$targetServer\$targetPath\backup.bak" -Recurse -Force
  })

#region Logic 

#endregion

[void]$Form.ShowDialog()