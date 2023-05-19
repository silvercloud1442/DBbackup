#Читаем данные из конфига
﻿$ini = C:\project\Get-iniFile.ps1 C:\project\config.ini

#пихаем конфиг в переменные
$sqlServerInstance = $ini["Server1"]["sqlServerInstance"]
$sourceDatabase = $ini["Server1"]["sourceDatabase"]
$backupPath = $ini["Server1"]["backupPath"]

$targetServer = $ini["Server2"]["targetServer"]
$targetPath = $ini["Server2"]["targetPath"]

#если папок нет, то создаем
if (!(Test-Path $backupPath)) {
    New-Item -Path $backupPath -ItemType Directory
}

if (!(Test-Path $targetServer\$targetPath)) {
    New-Item -Path $targetServer\$targetPath -ItemType Directory
}

# бэкап
Backup-SqlDatabase -ServerInstance $sqlServerInstance -Database $sourceDatabase -BackupFile $backupPath\backup.bak -Initialize

# копия на другой сервер
#ПРОБЛЕМЫ 
#2) Везде используются абсолютные пути
cd $backupPath
Copy-Item -Path $backupPath\backup.bak -Destination $targetServer\$targetPath\backup.bak