$ini = C:\project\Get-iniFile.ps1 C:\project\config.ini

$sqlServerInstance = $ini["Server1"]["sqlServerInstance"]
$sourceDatabase = $ini["Server1"]["sourceDatabase"]
$backupPath = $ini["Server1"]["backupPath"]

$targetServer = $ini["Server2"]["targetServer"]
$targetPath = $ini["Server2"]["targetPath"]

if (!(Test-Path $backupPath)) {
    New-Item -Path $backupPath -ItemType Directory
}

if (!(Test-Path $targetServer\$targetPath)) {
    New-Item -Path $targetServer\$targetPath -ItemType Directory
}

Backup-SqlDatabase -ServerInstance $sqlServerInstance -Database $sourceDatabase -BackupFile $backupPath\backup.bak -Initialize

cd $backupPath
Copy-Item -Path $backupPath\backup.bak -Destination $targetServer\$targetPath\backup.bak