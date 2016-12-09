Function Get-MOTD {
<#
.NAME
    Get-MOTD
.SYNOPSIS
    Displays system information to a host.
    https://github.com/michalmillar/ps-motd
.DESCRIPTION
    The Get-MOTD cmdlet is a system information tool written in PowerShell. 
.EXAMPLE
#>

    # Perform CIM/WMI Queries
   #Set-Variable -Name Operating_System -Value $(Get-WmiObject -Query 'Select lastbootuptime,TotalVisibleMemorySize,FreePhysicalMemory,caption,version From win32_operatingsystem')
    Set-Variable -Name Operating_System -Value $(Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object -Property LastBootUpTime, TotalVisibleMemorySize, FreePhysicalMemory, Caption, Version, SystemDrive)
   #Set-Variable -Name Processor -Value $(Get-WmiObject -Query 'Select Name,LoadPercentage From Win32_Processor')
    Set-Variable -Name Processor -Value $(Get-CimInstance -ClassName Win32_Processor | Select-Object -Property Name, LoadPercentage)
   #Set-Variable -Name Logical_Disk -Value $(Get-WmiObject -Query "Select Size,FreeSpace From Win32_LogicalDisk Where DeviceID = '$(${Operating_System}.SystemDrive)'")
    Set-Variable -Name Logical_Disk -Value $(Get-CimInstance -ClassName Win32_LogicalDisk | Where-Object -Property DeviceID -eq -Value $(${Operating_System}.SystemDrive) | Select-Object -Property Size, FreeSpace)

    # Assign variables
    Set-Variable -Name Get_Date -Value $(Get-Date)
    Set-Variable -Name Get_OS_Name -Value $(${Operating_System}.Caption)
    Set-Variable -Name Get_Kernel_Info -Value $(${Operating_System}.Version)
   #Set-Variable -Name Get_Uptime -Value $("$((${Get_Uptime} = ${Get_Date} - ${Operating_System}.ConvertToDateTime(${Operating_System}.LastBootUpTime)).Days) days, $(${Get_Uptime}.Hours) hours, $(${Get_Uptime}.Minutes) minutes")
    Set-Variable -Name Get_Uptime -Value $("$((${Get_Uptime} = ${Get_Date} - $(${Operating_System}.LastBootUpTime)).Days) days, $(${Get_Uptime}.Hours) hours, $(${Get_Uptime}.Minutes) minutes")
    Set-Variable -Name Get_Shell_Info -Value $("{0}.{1}" -f ${PSVersionTable}.PSVersion.Major,${PSVersionTable}.PSVersion.Minor)
    Set-Variable -Name Get_CPU_Info -Value $(${Processor}.Name -replace '\(C\)', '' -replace '\(R\)', '' -replace '\(TM\)', '' -replace 'CPU', '' -replace '\s+', ' ')
    Set-Variable -Name Get_Process_Count -Value $((Get-Process).Count)
    Set-Variable -Name Get_Current_Load -Value $(${Processor}.LoadPercentage)
    Set-Variable -Name Get_Memory_Size -Value $("{0}mb/{1}mb Used" -f (([math]::round(${Operating_System}.TotalVisibleMemorySize/1KB))-([math]::round(${Operating_System}.FreePhysicalMemory/1KB))),([math]::round(${Operating_System}.TotalVisibleMemorySize/1KB)))
    Set-Variable -Name Get_Disk_Size -Value $("{0}gb/{1}gb Used" -f (([math]::round(${Logical_Disk}.Size/1GB))-([math]::round(${Logical_Disk}.FreeSpace/1GB))),([math]::round(${Logical_Disk}.Size/1GB)))

    # Write to the Console
    Write-Host -Object ("")
    Write-Host -Object ("")
    Write-Host -Object ("         ,.=:^!^!t3Z3z.,                  ") -ForegroundColor Red
    Write-Host -Object ("        :tt:::tt333EE3                    ") -ForegroundColor Red
    Write-Host -Object ("        Et:::ztt33EEE ") -NoNewline -ForegroundColor Red
    Write-Host -Object (" @Ee.,      ..,     ${Get_Date}") -ForegroundColor Green
    Write-Host -Object ("       ;tt:::tt333EE7") -NoNewline -ForegroundColor Red
    Write-Host -Object (" ;EEEEEEttttt33#     ") -ForegroundColor Green
    Write-Host -Object ("      :Et:::zt333EEQ.") -NoNewline -ForegroundColor Red
    Write-Host -Object (" SEEEEEttttt33QL     ") -NoNewline -ForegroundColor Green
    Write-Host -Object ("User: ") -NoNewline -ForegroundColor Red
    Write-Host -Object ("${env:UserName}") -ForegroundColor Cyan
    Write-Host -Object ("      it::::tt333EEF") -NoNewline -ForegroundColor Red
    Write-Host -Object (" @EEEEEEttttt33F      ") -NoNewline -ForeGroundColor Green
    Write-Host -Object ("Hostname: ") -NoNewline -ForegroundColor Red
    Write-Host -Object ("${env:ComputerName}") -ForegroundColor Cyan
    Write-Host -Object ("     ;3=*^``````'*4EEV") -NoNewline -ForegroundColor Red
    Write-Host -Object (" :EEEEEEttttt33@.      ") -NoNewline -ForegroundColor Green
    Write-Host -Object ("OS: ") -NoNewline -ForegroundColor Red
    Write-Host -Object ("${Get_OS_Name}") -ForegroundColor Cyan
    Write-Host -Object ("     ,.=::::it=., ") -NoNewline -ForegroundColor Cyan
    Write-Host -Object ("``") -NoNewline -ForegroundColor Red
    Write-Host -Object (" @EEEEEEtttz33QF       ") -NoNewline -ForegroundColor Green
    Write-Host -Object ("Kernel: ") -NoNewline -ForegroundColor Red
    Write-Host -Object ("NT ") -NoNewline -ForegroundColor Cyan
    Write-Host -Object ("${Get_Kernel_Info}") -ForegroundColor Cyan
    Write-Host -Object ("    ;::::::::zt33) ") -NoNewline -ForegroundColor Cyan
    Write-Host -Object ("  '4EEEtttji3P*        ") -NoNewline -ForegroundColor Green
    Write-Host -Object ("Uptime: ") -NoNewline -ForegroundColor Red
    Write-Host -Object ("${Get_Uptime}") -ForegroundColor Cyan
    Write-Host -Object ("   :t::::::::tt33.") -NoNewline -ForegroundColor Cyan
    Write-Host -Object (":Z3z.. ") -NoNewline -ForegroundColor Yellow
    Write-Host -Object (" ````") -NoNewline -ForegroundColor Green
    Write-Host -Object (" ,..g.        ") -NoNewline -ForegroundColor Yellow
    Write-Host -Object ("Shell: ") -NoNewline -ForegroundColor Red
    Write-Host -Object ("Powershell ${Get_Shell_Info}") -ForegroundColor Cyan
    Write-Host -Object ("   i::::::::zt33F") -NoNewline -ForegroundColor Cyan
    Write-Host -Object (" AEEEtttt::::ztF         ") -NoNewline -ForegroundColor Yellow
    Write-Host -Object ("CPU: ") -NoNewline -ForegroundColor Red
    Write-Host -Object ("${Get_CPU_Info}") -ForegroundColor Cyan
    Write-Host -Object ("  ;:::::::::t33V") -NoNewline -ForegroundColor Cyan
    Write-Host -Object (" ;EEEttttt::::t3          ") -NoNewline -ForegroundColor Yellow
    Write-Host -Object ("Processes: ") -NoNewline -ForegroundColor Red
    Write-Host -Object ("${Get_Process_Count}") -ForegroundColor Cyan
    Write-Host -Object ("  E::::::::zt33L") -NoNewline -ForegroundColor Cyan
    Write-Host -Object (" @EEEtttt::::z3F          ") -NoNewline -ForegroundColor Yellow
    Write-Host -Object ("Current Load: ") -NoNewline -ForegroundColor Red
    Write-Host -Object ("${Get_Current_Load}") -NoNewline -ForegroundColor Cyan
    Write-Host -Object ("%") -ForegroundColor Cyan
    Write-Host -Object (" {3=*^``````'*4E3)") -NoNewline -ForegroundColor Cyan
    Write-Host -Object (" ;EEEtttt:::::tZ``          ") -NoNewline -ForegroundColor Yellow
    Write-Host -Object ("Memory: ") -NoNewline -ForegroundColor Red
    Write-Host -Object ("${Get_Memory_Size}") -ForegroundColor Cyan
    Write-Host -Object ("             ``") -NoNewline -ForegroundColor Cyan
    Write-Host -Object (" :EEEEtttt::::z7            ") -NoNewline -ForegroundColor Yellow
    Write-Host -Object ("Disk: ") -NoNewline -ForegroundColor Red
    Write-Host -Object ("${Get_Disk_Size}") -ForegroundColor Cyan
    Write-Host -Object ("                 'VEzjt:;;z>*``           ") -ForegroundColor Yellow
    Write-Host -Object ("                      ````                  ") -ForegroundColor Yellow
    Write-Host -Object ("")
}