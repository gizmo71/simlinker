# run using: powershell -command "& d:\simlinker\synclinks.ps1"

$sources = @{
	'Aircraft-2020' = 2020;
	'Aircraft-2024' = 2024;
	'Aircraft-Both' = 2020, 2024
}
$sources

Read-Host -Prompt "Press any key to continue"
