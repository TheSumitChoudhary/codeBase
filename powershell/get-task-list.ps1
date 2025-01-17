$tasks = Get-ScheduledTask | ForEach-Object {
    $task = $_
    $taskInfo = Get-ScheduledTaskInfo -TaskName $task.TaskName -TaskPath $task.TaskPath
    $settings = $task.Settings

    [PSCustomObject]@{
        TaskName        = $task.TaskName
        TaskPath        = $task.TaskPath
        State           = $task.State  # State of the task (Running, Ready, Disabled)
        LastRunTime     = $taskInfo.LastRunTime
        NextRunTime     = $taskInfo.NextRunTime
        Author          = $task.Principal.UserId  # User who created the task
        Description     = $task.Description  # Task description
        ExecutionAction = ($task.Actions | ForEach-Object { $_.Execute + " " + $_.Arguments })
        Triggers        = ($task.Triggers | ForEach-Object { $_.StartBoundary + " -> " + $_.ScheduleType })
        StartWhenIdle   = $settings.StartWhenAvailable  # Starts when idle
        StopIfOverrun   = $settings.StopIfGoingOnBatteries  # Stops on battery
        AllowDemandStart = $settings.AllowDemandStart  # Allow task to start on demand
        Hidden          = $settings.Hidden  # Whether the task is hidden
        Priority        = $task.Priority  # Task priority
    }
}

$tasks | Export-Csv -Path "C:\Users\50241\OneDrive - Ricoh\Desktop\ScheduledTasksDetailed.csv" -NoTypeInformation


# SUMIT 