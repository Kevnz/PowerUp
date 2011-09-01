
function ReplaceDirectory([string]$sourceDirectory, [string]$destinationDirectory)
{
	if (Test-Path $destinationDirectory -PathType Container)
	{
		Write-Host "Removing folder"
		Remove-Item $destinationDirectory -recurse -force
	}
	Write-Host "Copying files"
	Copy-Item $sourceDirectory\ -destination $destinationDirectory\ -container:$false -recurse -force
}

function RobocopyDirectory([string]$sourceDirectory, [string]$destinationDirectory)
{
	Write-Host "copying newer files from $sourceDirectory to $destinationDirectory"
	& "$PSScriptRoot\robocopy.exe" /E /np /njh /nfl /ns /nc $sourceDirectory $destinationDirectory 
	
	if ($lastexitcode -lt 8)
	{
		Write-Host "Successfully copied to $destinationDirectory "
		cmd /c #reset the lasterrorcode strangely set by robocopy to be non-0
	}		
}

function Copy-MirroredDirectory([string]$sourceDirectory, [string]$destinationDirectory)
{
	Write-Host "Mirroring $sourceDirectory to $destinationDirectory"
	& "$PSScriptRoot\robocopy.exe" /E /np /njh /nfl /ns /nc /mir $sourceDirectory $destinationDirectory 
	
	if ($lastexitcode -lt 8)
	{
		Write-Host "Successfully mirrored to $destinationDirectory "
		cmd /c #reset the lasterrorcode strangely set by robocopy to be non-0
	}
}

Set-Alias Copy-Directory RobocopyDirectory

Export-ModuleMember -function Copy-MirroredDirectory, RobocopyDirectory -alias Copy-Directory
