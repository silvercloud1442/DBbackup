<# 
.NAME
    Untitled
#>

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$ini = C:\project\Get-iniFile.ps1 C:\project\config.ini

$sqlServerInstance = $ini["Server1"]["sqlServerInstance"]
$sourceDatabase = $ini["Server1"]["sourceDatabase"]
$backupPath = $ini['Server1']['backupPath']

$targetServer = $ini['Server2']['targetServer']
$targetPath = $ini['Server2']['targetPath']


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

$Button1.Add_Click({


  })

#region Logic 

#endregion

[void]$Form.ShowDialog()