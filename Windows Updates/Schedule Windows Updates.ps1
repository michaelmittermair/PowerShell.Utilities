function Create-Windows-Update-Task {
    param($taskName, $program, $programArguments)
    
    # connecting to local task scheduler
    $Service = New-Object -ComObject Schedule.Service
    $Service.Connect($ENV:ComputertaskName)
    $TaskFolder = $Service.GetFolder("\")

    # first delete the task, than create it new
    # get tasks in folder
    $Tasks = $TaskFolder.GetTasks(1)
    # step through all tasks in the folder
    foreach($Task in $Tasks){
        if($Task.Name -eq $taskName){
            $TaskFolder.DeleteTask($Task.Name,0)
        }
    }

    #creating the task
    $TaskDefinition = $Service.NewTask(0)

    $RegInfo = $TaskDefinition.RegistrationInfo
    $RegInfo.Description = 'Windows Update - start at 05:00 daily'
    $RegInfo.Author = $taskRunAsuser
    $Settings = $TaskDefinition.Settings
    $Settings.Enabled = $True
    $Settings.StartWhenAvailable = $True
    $Settings.Hidden = $False
      
    $Trigger = $TaskDefinition.Triggers.Create(2)
    $Trigger.StartBoundary = (Get-Date 05:00AM).AddDays(1) | Get-Date -Format yyyy-MM-ddTHH:ss:ms
    $Trigger.DaysInterval = 1
    $Trigger.Id = "DailyTriggerId"
    $Trigger.Enabled = $True
   
    $Action = $TaskDefinition.Actions.Create(0)
    $Action.Path = $program
    $Action.Arguments = $programArguments
    
    $Principal = $TaskDefinition.Principal
    $Principal.RunLevel = 1 # 0=normal, 1=Highest Privileges
       
    $TaskFolder.RegisterTaskDefinition($taskName, $TaskDefinition, 2, "System", $null , 5)
}

$FilePath = "c:\WindowsUpdate\WindowsUpdateViaPS.ps1"

Create-Windows-Update-Task ("PS Windows Update") ("powershell") ("-file " + $FilePath)