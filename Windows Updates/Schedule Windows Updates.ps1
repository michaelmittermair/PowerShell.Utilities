function Create-Windows-Update-Task {
    param($name, $program, $programArguments)
    
    $service = New-Object -ComObject "Schedule.Service"
    $service.Connect($ENV:ComputerName)

    $rootFolder = $service.GetFolder("\")
    $taskDefinition = $service.NewTask(0)

    $regInfo = $taskDefinition.RegistrationInfo
    $regInfo.Description = 'Windows Update - start at 05:00 daily'
    $regInfo.Author = $taskRunAsuser
    $settings = $taskDefinition.Settings
    $settings.Enabled = $True
    $settings.StartWhenAvailable = $True
    $settings.Hidden = $False
      
    $trigger = $taskDefinition.Triggers.Create(2)
    $trigger.StartBoundary = (Get-Date 05:00AM).AddDays(1) | Get-Date -Format yyyy-MM-ddTHH:ss:ms
    $trigger.DaysInterval = 1
    $trigger.Id = "DailyTriggerId"
    $trigger.Enabled = $True
   
    $action = $taskDefinition.Actions.Create(0)
    $action.Path = $program
    $action.Arguments = $programArguments
    
    $principal = $taskDefinition.Principal
    $principal.RunLevel = 1 # 0=normal, 1=Highest Privileges
       
    $rootFolder.RegisterTaskDefinition($name, $taskDefinition, 2, "System", $null , 5)
}

$filePath = "c:\Update\WindowsUpdateViaPS.ps1"

Create-Windows-Update-Task ("Windows Update") ("powershell") ("-file " + $filePath)