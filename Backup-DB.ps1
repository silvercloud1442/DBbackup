#Читаем данные из конфига
$ini = C:\project\Get-iniFile.ps1 C:\project\config.ini

#пихаем конфиг в переменные
$sqlServerInstance = $ini["Server1"]["sqlServerInstance"]
$sourceDatabase = $ini["Server1"]["sourceDatabase"] 
$sourceServer = $ini["Server1"]["sourceServer"]
$backupPath = $ini["Server1"]["backupPath"]

$targetServer = $ini["Server2"]["targetServer"]
$targetPath = $ini["Server2"]["targetPath"]

#если папок нет, то создаем
if (!(Test-Path $sourceServer\$backupPath)) {
    New-Item -Path $sourceServer\$backupPath -ItemType Directory
}

if (!(Test-Path $targetServer\$targetPath)) {
    New-Item -Path $targetServer\$targetPath -ItemType Directory
}

# бэкап
Backup-SqlDatabase -ServerInstance $sqlServerInstance -Database $sourceDatabase -BackupFile $sourceServer\$backupPath\backup.bak

# копия на другой сервер
Copy-Item -Path $sourceServer\$backupPath\backup.bak -Destination $targetServer\$targetPath\backup.bak



#ПРОБЛЕМЫ 

#1) Если бэкап и копирование в 1 потоке - нихера не работает
#Решения: два потока? починить в 1 потоке?

#2) Везде используются абсолютные пути
#Решения: смириться?
