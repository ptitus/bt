# Eingabesprache umstellen
Set-WinUserLanguageList -Force de-DE
# Benutzer für automatisierte Tests anlegen
$passwd = ConvertTo-SecureString 'Windoof2020' -AsPlainText -Force
New-LocalUser -Name 'user' -Password $passwd -Verbose
Set-LocalUser -Name 'user' -PasswordNeverExpires $true
Add-LocalGroupMember -Group 'Administrators' -Member 'user' -Verbose
