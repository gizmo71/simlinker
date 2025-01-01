# run using: powershell -command "& d:\simlinker\synclinks.ps1"

$root = "D:\simlinker"
$sourceRoot = [IO.Path]::GetFullPath("$($root)\Sources")
$targetRoot = [IO.Path]::GetFullPath("$($root)\Targets")
$sources = @{
	'*-2020' = 2020;
	'*-2024' = 2024;
	'*-Both' = 2020, 2024
}

Get-ChildItem -LiteralPath $targetRoot -Directory -Depth 2 -Attributes "ReparsePoint" -FollowSymlink |
	Where-Object {$_.Target.StartsWith($sourceRoot)} |
	ForEach-Object {
	$_.Delete()
}
Write-Host "Previous links removed; now making new links"

foreach ($entry in $sources.GetEnumerator()) {
	Get-ChildItem -Path $sourceRoot -Filter $entry.Key -Directory -PipelineVariable sourcePath | ForEach-Object {
		Get-ChildItem -LiteralPath $sourcePath.FullName -PipelineVariable sourceFolder | ForEach-Object {
			foreach ($targetFolder in $entry.Value) {
				$targetPath = [IO.Path]::GetFullPath("$($targetRoot)\$($targetFolder)\$($sourceFolder.Name)")
				New-Item -Path $targetPath -ItemType SymbolicLink -Value ([WildcardPattern]::Escape($sourceFolder.FullName))
			}
		}
	}
}

Read-Host -Prompt "Press any key to continue"
