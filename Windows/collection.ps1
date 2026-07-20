# Modify Execution Policy to RemoteSigned
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine

# Always request Admin password to run as Admin
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value 1

# Set command prediction to ListView
Set-PSReadLineOption -PredictionViewStyle ListView


# Winget
winget update
winget install Microsoft.PowerShell --source winget
winget install --id Git.Git -e --source winget
winget install Microsoft.Coreutils
winget install hrkfdn.ncspot

# CoreUtils replace this
## use 'grep' wsl command
#function wgrep {
#    $input | wsl grep @args
#}

# Install scoop
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression

# Remove Windows Bloatware
Invoke-RestMethod -Uri https://christitus.com/win | Invoke-Expression
