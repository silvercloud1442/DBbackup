# Функция для Чтения Ini файла

# Get-IniFile.ps1
# Written by Albegov Kazbek (artist6481@gmail.com)
#

#requires -version 2

<#
.SYNOPSIS
Функция для Чтения Ini файла

.DESCRIPTION
Функция для Чтения Ini файла

.PARAMETER File
Имя файла для чтения

.INPUTS
System.String.

.OUTPUTS
System.String.

.LINK

.EXAMPLE
C:\>.\Get-IniFile.ps1 "C:\fileName.ini"
#>




  [cmdletbinding()]
  param(
    [parameter(Mandatory=$true,Position=0)]
    [String] $File
  )
  
  begin{}
  process{
    $ini = @{}
    # если секция отсутсвует
    $section = "NO_SECTION"
    $ini[$section] = @{}

    switch -regex -file $File {
        "^\[(.+)\]$" {
            $section = $matches[1].Trim()
            $ini[$section] = @{}
        }
        "^\s*([^#].+?)\s*=\s*(.*)" {
            $name,$value = $matches[1..2]
            # skip comments that start with semicolon:
            if (!($name.StartsWith(";"))) {
                $ini[$section][$name] = $value.Trim()
            }
        }
    }
    $ini
}
end{}
 