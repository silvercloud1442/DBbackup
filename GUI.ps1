<# 
.NAME
    Untitled
#>

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$ver = "0.1"
$dt = Get-Date -Format "dd-MM-yyyy"
New-Item -ItemType directory log -Force | out-null # Создаю директорию для логов

$global:logfilename = "log\" + $dt + "_LOG.log"
[int]$global:errorcount = 0 # Ведем подсчет ошибок
[int]$global:warningcount = 0 # Ведем подсчет предупреждений

try {
    Write-Log "Get ini : start"
    $ini = C:\project\Get-iniFile.ps1 C:\project\config.ini
    $sqlServerInstance = $ini["Server1"]["sqlServerInstance"]
    $sourceDatabase = $ini["Server1"]["sourceDatabase"]
    $backupPath = $ini['Server1']['backupPath']
    $global:targetServer = $ini['Server2']['targetServer']
    $targetPath = $ini['Server2']['targetPath']
}
catch
{
    Write-Log "Get ini : $_" 'error'
    Exit
}
Write-Log "Get ini : completed" 'completed'

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = New-Object System.Drawing.Point(368,425)
$Form.text                       = "Form"
$Form.TopMost                    = $false

$Button1                         = New-Object system.Windows.Forms.Button
$Button1.text                    = "button"
$Button1.width                   = 118
$Button1.height                  = 68
$Button1.location                = New-Object System.Drawing.Point(110,345)
$Button1.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$Server1Gruop                    = New-Object system.Windows.Forms.Groupbox
$Server1Gruop.height             = 164
$Server1Gruop.width              = 346
$Server1Gruop.text               = "Server1"
$Server1Gruop.location           = New-Object System.Drawing.Point(5,13)

$Server2Group                    = New-Object system.Windows.Forms.Groupbox
$Server2Group.height             = 148
$Server2Group.width              = 340
$Server2Group.text               = "Server2"
$Server2Group.location           = New-Object System.Drawing.Point(12,187)

$sqlServerInstanceLabel          = New-Object system.Windows.Forms.Label
$sqlServerInstanceLabel.text     = "sql Server Instance : $sqlServerInstance"
$sqlServerInstanceLabel.AutoSize = $true
$sqlServerInstanceLabel.width    = 25
$sqlServerInstanceLabel.height   = 10
$sqlServerInstanceLabel.location = New-Object System.Drawing.Point(9,32)
$sqlServerInstanceLabel.Font     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$sourceDatabaseLabel             = New-Object system.Windows.Forms.Label
$sourceDatabaseLabel.text        = "Database : $sourceDatabase"
$sourceDatabaseLabel.AutoSize    = $true
$sourceDatabaseLabel.width       = 25
$sourceDatabaseLabel.height      = 10
$sourceDatabaseLabel.location    = New-Object System.Drawing.Point(9,61)
$sourceDatabaseLabel.Font        = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$backupPathLabel                 = New-Object system.Windows.Forms.Label
$backupPathLabel.text            = "Local backup path: $backupPath"
$backupPathLabel.AutoSize        = $true
$backupPathLabel.width           = 25
$backupPathLabel.height          = 10
$backupPathLabel.location        = New-Object System.Drawing.Point(9,93)
$backupPathLabel.Font            = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$targetServerLabel               = New-Object system.Windows.Forms.Label
$targetServerLabel.text          = "Server 2 id/name: "
$targetServerLabel.AutoSize      = $true
$targetServerLabel.width         = 25
$targetServerLabel.height        = 10
$targetServerLabel.location      = New-Object System.Drawing.Point(13,25)
$targetServerLabel.Font          = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$targetTextBox                   = New-Object system.Windows.Forms.TextBox
$targetTextBox.multiline         = $false
$targetTextBox.width             = 100
$targetTextBox.text              = $targetServer.Substring(2)
$targetTextBox.height            = 20
$targetTextBox.location          = New-Object System.Drawing.Point(132,23)
$targetTextBox.Font              = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$targetPathLabel                 = New-Object system.Windows.Forms.Label
$targetPathLabel.text            = [string]::Concat("Target path: \\", $targetServer.Substring(2), "\$targetPath")
$targetPathLabel.AutoSize        = $true
$targetPathLabel.width           = 25
$targetPathLabel.height          = 10
$targetPathLabel.location        = New-Object System.Drawing.Point(15,60)
$targetPathLabel.Font            = New-Object System.Drawing.Font('Microsoft Sans Serif',10)


$Form.controls.AddRange(@($Button1,$Server1Gruop,$Server2Group))

$Server1Gruop.controls.AddRange(@($sqlServerInstanceLabel, $sourceDatabaseLabel, $backupPathLabel))
$Server2Group.controls.AddRange(@($targetServerLabel,$targetTextBox,$targetPathLabel))

Function global:Write-Log	# Функция пишет сообщения в лог-файл и выводит на экран.
{
	Param(
		$message,
		[string]$type = "info",
		[string]$logfile = $global:logfilename,
		[switch]$silent
	)
	
	$dt = Get-Date -Format "dd.MM.yyyy HH:mm:ss"	
	$msg = $dt + "`t" + $type + "`t" + $message # Формат: 01.01.2001 01:01:01 [tab] error [tab] Сообщение
	Out-File -FilePath "Microsoft.PowerShell.Core\FileSystem::$logfile" -InputObject $msg -Append -encoding unicode
	if (-not $silent.IsPresent){
		switch ( $type.toLower() ){
			"error"{			
				$global:errorcount++
				Write-Host $msg -ForegroundColor red			
			}
			"warning"{			
				$global:warningcount++
				Write-Host $msg -ForegroundColor yellow
			}
			"completed"{			
				Write-Host $msg -ForegroundColor green
			}
			"info"{			
				Write-Host $msg
			}			
			default{ 
				Write-Host $msg
			}
		}
	}
}

Function global:Backup-db
{
    $Button1.Text = "Backup..."
    if ((Test-Path "Microsoft.PowerShell.Core\FileSystem::$targetServer\$targetPath\")){
    Write-Log "backup : start"
        try {
            Backup-SqlDatabase -ServerInstance $sqlServerInstance -Database $sourceDatabase -BackupFile "$backupPath\backup.bak" -Initialize
    
        }
        catch {
            Write-Log $_ "error"
            return $_
        }
        Write-Log "backup : completed" "completed"

        Write-Log "Copy to target Server : start"
        try{
            Copy-Item -Path "Microsoft.PowerShell.Core\FileSystem::$backupPath\backup.bak" -Destination "Microsoft.PowerShell.Core\FileSystem::$targetServer\$targetPath\backup.bak" -Recurse -Force
        }
        catch{
            Write-Log $_ "error"
            return $_
        }
        Write-Log "Copy to target Server : completed" "completed"
        $ini['Server2']['targetServer'] = $global:targetServer
        $ini | C:\project\Out-IniFile.ps1 "C:\project\config.ini" -Force
        return 'completed'
    }
    else {
        Write-log "Invalid target path: $targetServer\$targetPath\" 'error'
        return "Invalid target path"
    }
}


$targetTextBox.Add_KeyUp({
    $global:targetServer = [string]::Concat("\\", $targetTextbox.Text)
    $targetPathLabel.text = [string]::Concat("Target path: \\", $targetServer.Substring(2), "\$targetPath")
})


$Button1.Add_Click({
    $Button1.Text = Backup-db
})

#region Logic 

#endregion

[void]$Form.ShowDialog()