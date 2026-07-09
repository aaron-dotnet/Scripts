@echo off
:: Asegurar que el script se ejecuta como Administrador
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [!] Por favor, ejecuta este script como Administrador.
    pause
    exit /b
)

title Configurar DNS over TLS (DoT)
cls

:menu
echo =======================================================
echo     Configuracion de DNS over TLS (DoT) en Windows
echo =======================================================
echo  1. Configurar Cloudflare  (1.1.1.1 / 1.0.0.1)
echo  2. Configurar Quad9       (9.9.9.9 / 149.112.112.112)
echo  3. Configurar Ambos       (Cloudflare + Quad9)
echo  4. Salir
echo =======================================================
set /p opcion="Selecciona una opcion (1-4): "

:: Definir las listas de IPs
set "cloudflare_ips=1.1.1.1 1.0.0.1 2606:4700:4700::1111 2606:4700:4700::1001"
set "quad9_ips=9.9.9.9 149.112.112.112 2620:fe::fe 2620:fe::9"

:: Habilitar DoT globalmente primero
if "%opcion%"=="1" (
    echo. & echo [+] Aplicando Cloudflare DoT...
    netsh dns add global dot=yes
    set "lista=%cloudflare_ips%"
    goto aplicar
)
if "%opcion%"=="2" (
    echo. & echo [+] Aplicando Quad9 DoT...
    netsh dns add global dot=yes
    set "lista=%quad9_ips%"
    goto aplicar
)
if "%opcion%"=="3" (
    echo. & echo [+] Aplicando Cloudflare y Quad9 DoT...
    netsh dns add global dot=yes
    set "lista=%cloudflare_ips% %quad9_ips%"
    goto aplicar
)

if "%opcion%"=="4" exit /b
goto menu

:aplicar
:: Un solo bucle FOR se encarga de recorrer todas las IPs guardadas en la variable %lista%
for %%i in (%lista%) do (
    netsh dns add encryption server=%%i dothost=: autoupgrade=yes
)

:finalizar
echo.
echo [+] Limpiando cache DNS...
ipconfig /flushdns

echo.
echo =======================================================
echo             ESTADO ACTUAL DE LA GLOBAL
echo =======================================================
netsh dns show global
echo -------------------------------------------------------
echo =======================================================
echo             ESTADO ACTUAL ENCRYPTION
echo =======================================================
netsh dns show encryption
echo =======================================================
pause