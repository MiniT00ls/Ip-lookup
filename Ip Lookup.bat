@echo off
setlocal enabledelayedexpansion

set "TARGET_IP=%~1"
if "%TARGET_IP%"=="" (
    set /p "TARGET_IP=Enter an IP address (leave empty for your own public IP): "
)

if "%TARGET_IP%"=="" (
    set "API_URL=http://ip-api.com/json/?fields=status,message,country,countryCode,region,regionName,city,zip,lat,lon,timezone,isp,org,as,query"
) else (
    set "API_URL=http://ip-api.com/json/%TARGET_IP%?fields=status,message,country,countryCode,region,regionName,city,zip,lat,lon,timezone,isp,org,as,query"
)

echo.
echo Looking up information for: %TARGET_IP%
echo.

powershell -NoProfile -Command ^
    "$response = Invoke-RestMethod -Uri '%API_URL%' -ErrorAction Stop;" ^
    "if ($response.status -eq 'success') {" ^
    "  Write-Host '--- GEO INFORMATION ---';" ^
    "  Write-Host ('IP:           ' + $response.query);" ^
    "  Write-Host ('Country:      ' + $response.country + ' (' + $response.countryCode + ')');" ^
    "  Write-Host ('Region:       ' + $response.regionName + ' (' + $response.region + ')');" ^
    "  Write-Host ('City:         ' + $response.city);" ^
    "  Write-Host ('ZIP:          ' + $response.zip);" ^
    "  Write-Host ('Timezone:     ' + $response.timezone);" ^
    "  Write-Host ('ISP:          ' + $response.isp);" ^
    "  Write-Host ('Organization: ' + $response.org);" ^
    "  Write-Host ('AS:           ' + $response.as);" ^
    "  Write-Host '';" ^
    "  $lat = $response.lat; $lon = $response.lon;" ^
    "  Write-Host ('Coordinates:  ' + $lat + ', ' + $lon);" ^
    "  $mapsUrl = 'https://www.google.com/maps?q=' + $lat + ',' + $lon;" ^
    "  Write-Host '';" ^
    "  Write-Host '--- GOOGLE MAPS LINK ---';" ^
    "  Write-Host $mapsUrl;" ^
    "} else {" ^
    "  Write-Host 'Lookup failed: ' -ForegroundColor Red;" ^
    "  Write-Host $response.message -ForegroundColor Red;" ^
    "}"

if %errorlevel% neq 0 (
    echo.
    echo An unexpected error occurred. Make sure PowerShell and an internet connection are available.
)

echo.
pause
endlocal