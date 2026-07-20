@echo off
setlocal enabledelayedexpansion

:: Ensure the script is running with admin privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [!] Please run this script as Administrator.
    pause
    exit /b
)

title Windows 11 DNS over TLS (DoT)
cls

:: Define DNS server IPs and their validated hostnames (provider-wide)
set "cloudflare_ips=1.1.1.1 1.0.0.1 2606:4700:4700::1111 2606:4700:4700::1001"
set "cloudflare_host=one.one.one.one"

set "quad9_ips=9.9.9.9 149.112.112.112 2620:fe::fe 2620:fe::9"
set "quad9_host=dns.quad9.net"

:menu
set "option="
echo =======================================================
echo     Windows 11 DNS over TLS (DoT) Configuration
echo =======================================================
echo  1. Configure Cloudflare  (1.1.1.1 / 1.0.0.1)
echo  2. Configure Quad9       (9.9.9.9 / 149.112.112.112)
echo  3. Configure Both        (Cloudflare + Quad9)
echo  4. Restore / Remove DoT configuration
echo  5. Exit
echo =======================================================
set /p option="Select an option (1-5): "

if "%option%"=="1" goto cloudflare
if "%option%"=="2" goto quad9
if "%option%"=="3" goto ambos
if "%option%"=="4" goto restaurar
if "%option%"=="5" goto fin

echo.
echo [!] Invalid option, try again.
echo.
pause
cls
goto menu

:cloudflare
echo. & echo [+] Applying Cloudflare DoT...
netsh dns add global dot=yes
call :aplicar_lista "%cloudflare_ips%" "%cloudflare_host%"
goto finalizar

:quad9
echo. & echo [+] Applying Quad9 DoT...
netsh dns add global dot=yes
call :aplicar_lista "%quad9_ips%" "%quad9_host%"
goto finalizar

:ambos
echo. & echo [+] Applying Cloudflare and Quad9 DoT...
netsh dns add global dot=yes
call :aplicar_lista "%cloudflare_ips%" "%cloudflare_host%"
call :aplicar_lista "%quad9_ips%" "%quad9_host%"
goto finalizar

:restaurar
echo. & echo [+] Removing DoT configuration for known servers...
for %%i in (%cloudflare_ips% %quad9_ips%) do (
    netsh dns delete encryption server=%%i >nul 2>&1
)
netsh dns set global dot=no
echo [+] DoT disabled and entries removed.
goto finalizar

:aplicar_lista
:: %1 = list of IPs (quoted), %2 = hostname to validate (quoted)
set "ips=%~1"
set "host=%~2"
for %%i in (%ips%) do (
    netsh dns add encryption server=%%i dothost=%host%: autoupgrade=yes
)
exit /b

:finalizar
echo.
echo [+] Flushing DNS cache...
ipconfig /flushdns

echo.
echo =======================================================
echo             CURRENT GLOBAL STATUS
echo =======================================================
netsh dns show global
echo -------------------------------------------------------
echo =======================================================
echo             CURRENT ENCRYPTION STATUS
echo =======================================================
netsh dns show encryption
echo =======================================================
pause
cls
goto menu

:fin
exit /b