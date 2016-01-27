Param(
    [Parameter(Mandatory=$true)] [string] $repoRoot
)

$ErrorActionPreference = "Stop"

$toolsPackagesConfigPath = "$repoRoot\.nuget\tools\packages.config"
$packagesDirectory = "$repoRoot\packages"

# Restore NuGet tools packages, unless we're on a build machine
if ((Test-Path env:\BUILD_BUILDNUMBER) -eq $true)
{
    if (-not (Test-Path $packagesDirectory\*))
    {
        Write-Warning "To restore NuGet packages in your VS Team Services automated builds, add a NuGet Installer build task to your build definition."
    }
    
    return;
}

if (Test-Path $toolsPackagesConfigPath) {
    Write-Host "Restoring tool packages..."
    nuget restore -PackagesDirectory $packagesDirectory $toolsPackagesConfigPath
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to restore tool packages."
    } else {
        Write-Host "Restored tool packages"
    }
}
