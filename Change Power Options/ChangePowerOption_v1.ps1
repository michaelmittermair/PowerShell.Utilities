# Changing the Power Saving Settings via PowerShell

$PowerOptionName= “High Performance” # You could use ‘Balanced’, ‘High Performance’, ‘Power Saver’, etc here

# Get the list of plans on the current machine.
$planList = powercfg.exe -l

$planRegEx = "(?<PlanGUID>[A-Fa-f0-9]{8}-(?:[A-Fa-f0-9]{4}\-){3}[A-Fa-f0-9]{12})" + ("(?:\s+\({0}\))" -f $PowerOptionName)

if ( ($planList | Out-String) -match $planRegEx )
{
    # Pull out the matching GUID and capture both stdout and stderr.
    $result = powercfg -s $matches["PlanGUID"] 2>&1
    
    # If there were any problems, show the error.
    if ( $LASTEXITCODE -ne 0)
    {
        $result
    }
}
else
{
    Write-Error ("The requested power scheme '{0}' does not exist on this machine" -f $Plan)
}
