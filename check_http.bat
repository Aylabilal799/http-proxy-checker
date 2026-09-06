@echo off
title HTTP/HTTPS Proxy Checker
color 0B
cd /d "%~dp0"

if not exist "IPs.txt" (
    echo.
    echo  [ERROR] IPs.txt not found in this folder!
    echo.
    timeout /t 4 >nul
    exit
)

echo.
echo  ========================================
echo     HTTP / HTTPS Proxy Checker
echo  ========================================
echo.
echo  Threads      : 100
echo  Timeout      : 10 seconds
echo  Test Target  : http://httpbin.org/ip
echo  Starting... Please wait.
echo.

(
echo $ErrorActionPreference = "SilentlyContinue"
echo $inputFile = "IPs.txt"
echo $workingFile = "working.txt"
echo $logFile = "results_log.txt"
echo $maxThreads = 100
echo $timeoutSec = 10
echo.
echo if ^(Test-Path $workingFile^) { Remove-Item $workingFile -Force }
echo if ^(Test-Path $logFile^) { Remove-Item $logFile -Force }
echo.
echo $proxies = Get-Content $inputFile ^| Where-Object { $_.Trim^(^) -ne "" }
echo $total = $proxies.Count
echo Write-Host "Total proxies: $total" -ForegroundColor Cyan
echo Write-Host "Testing HTTP/HTTPS proxies..." -ForegroundColor Cyan
echo Write-Host ""
echo.
echo $scriptBlock = {
echo     param^($proxyLine, $timeoutSec^)
echo     $result = "DEAD"
echo     try {
echo         $parts = $proxyLine.Trim^(^).Split^(":"^)
echo         if ^($parts.Count -lt 2^) { return "$proxyLine^|DEAD" }
echo         $ip = $parts[0]
echo         $port = $parts[1]
echo.
echo         $proxyUrl = "http://${ip}:${port}"
echo         $testUrl = "http://httpbin.org/ip"
echo.
echo         $request = [System.Net.HttpWebRequest]::Create^($testUrl^)
echo         $request.Proxy = New-Object System.Net.WebProxy^($proxyUrl^)
echo         $request.Timeout = $timeoutSec * 1000
echo         $request.ReadWriteTimeout = $timeoutSec * 1000
echo         $request.Method = "GET"
echo         $request.UserAgent = "Mozilla/5.0"
echo.
echo         $response = $request.GetResponse^(^)
echo         $stream = $response.GetResponseStream^(^)
echo         $reader = New-Object System.IO.StreamReader^($stream^)
echo         $content = $reader.ReadToEnd^(^)
echo         $reader.Close^(^)
echo         $response.Close^(^)
echo.
echo         if ^($content -match '"origin"' -or $content -match '\d+\.\d+\.\d+\.\d+'^) {
echo             $result = "LIVE"
echo         } else {
echo             $result = "FAIL"
echo         }
echo     } catch {
echo         $result = "DEAD"
echo     }
echo     return "$proxyLine^|$result"
echo }
echo.
echo $pool = [runspacefactory]::CreateRunspacePool^(1, $maxThreads^)
echo $pool.Open^(^)
echo $runspaces = New-Object System.Collections.ArrayList
echo.
echo foreach ^($p in $proxies^) {
echo     $ps = [powershell]::Create^(^)
echo     $ps.AddScript^($scriptBlock^) ^| Out-Null
echo     $ps.AddArgument^($p^) ^| Out-Null
echo     $ps.AddArgument^($timeoutSec^) ^| Out-Null
echo     $ps.RunspacePool = $pool
echo     [void]$runspaces.Add^([PSCustomObject]@{ Pipe = $ps; Status = $ps.BeginInvoke^(^) }^)
echo }
echo.
echo $live = 0
echo $done = 0
echo.
echo while ^($done -lt $total^) {
echo     foreach ^($rs in @^($runspaces.ToArray^(^)^)^) {
echo         if ^($rs.Status.IsCompleted^) {
echo             $output = $rs.Pipe.EndInvoke^($rs.Status^)
echo             $rs.Pipe.Dispose^(^)
echo             $runspaces.Remove^($rs^)
echo             $done++
echo.
echo             if ^($output^) {
echo                 $split = $output -split "\|"
echo                 $line = $split[0]
echo                 $status = $split[1]
echo.
echo                 if ^($status -eq "LIVE"^) {
echo                     Write-Host "[LIVE] $line" -ForegroundColor Green
echo                     Add-Content -Path $workingFile -Value $line
echo                     Add-Content -Path $logFile -Value "$line - LIVE"
echo                     $live++
echo                 }
echo                 else {
echo                     Write-Host "[DEAD] $line" -ForegroundColor DarkGray
echo                     Add-Content -Path $logFile -Value "$line - DEAD"
echo                 }
echo             }
echo.
echo             if ^($done %% 50 -eq 0 -or $done -eq $total^) {
echo                 Write-Host "----- Progress: $done / $total  ^|  Live: $live -----" -ForegroundColor Cyan
echo             }
echo         }
echo     }
echo     Start-Sleep -Milliseconds 150
echo }
echo.
echo $pool.Close^(^)
echo $pool.Dispose^(^)
echo.
echo Write-Host ""
echo Write-Host "========================================" -ForegroundColor Green
echo Write-Host "  FINISHED" -ForegroundColor Green
echo Write-Host "========================================" -ForegroundColor Green
echo Write-Host "Total Checked : $done"
echo Write-Host "Working       : $live" -ForegroundColor Green
echo Write-Host ""
echo Write-Host "Working proxies saved in: working.txt"
echo Write-Host ""
echo Write-Host "Window closes in 10 seconds..."
echo Start-Sleep -Seconds 10
) > "%TEMP%\http_proxy_check.ps1"

powershell -NoProfile -ExecutionPolicy Bypass -File "%TEMP%\http_proxy_check.ps1"
del "%TEMP%\http_proxy_check.ps1" >nul 2>&1
exit