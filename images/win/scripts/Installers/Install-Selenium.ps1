################################################################################
##  File:  Install-Selenium.ps1
##  Desc:  Install Selenium Server standalone
################################################################################

# Acquire latest Selenium release number from GitHub API
$latestReleaseUrl = "https://api.github.com/repos/SeleniumHQ/selenium/releases/latest"
try {
    $latestReleaseInfo = Invoke-RestMethod -Uri $latestReleaseUrl
} catch {
    Write-Error $_
    exit 1
}
Write-Debug $latestReleaseInfo
$seleniumVersionString = $latestReleaseInfo.name.Split(" ")[1]
Write-Debug $seleniumVersionString
$seleniumVersion = [version]::Parse($seleniumVersionString)

# Download Selenium
Write-Host "Downloading selenium-server-standalone v$seleniumVersion..."

$seleniumReleaseUrl = "https://selenium-release.storage.googleapis.com/$($seleniumVersion.ToString(2))/selenium-server-standalone-$($seleniumVersion.ToString(3)).jar"
New-Item -ItemType directory -Path "C:\selenium\"
$seleniumBinPath = "C:\selenium\selenium-server-standalone.jar"
try {
    Invoke-WebRequest -UseBasicParsing -Uri $seleniumReleaseUrl -OutFile $seleniumBinPath
} catch {
    Write-Error $_
    exit 1
}

Write-Host "Add selenium jar to the environment variables..."
setx "SELENIUM_JAR_PATH" "$($seleniumBinPath)" /M

exit 0