# always need admin password to runas
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value 1

# Set command prediction to ListView
Set-PSReadLineOption -PredictionViewStyle ListView

# use 'grep' wsl command
function wgrep {
    $input | wsl grep @args
}

# Modify Execution Police to RemoteSigned
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine


# Remove W11 bloatware 
irm christitus.com/win | iex

# Install scoop 
## -- old way, still working --
## irm get.scoop.sh | iex 
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
