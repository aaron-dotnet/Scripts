@echo off

REM Este script podría funcionar perfectamente con versiones LTSC 2021 y 2024,
REM desconozco si es posible con versiones más antiguas.
REM Este script es un complemento (propio) a la guia de implementación ofrecida por Microsoft:
REM https://learn.microsoft.com/es-es/office/ltsc/2024/

REM No me hago responsable por el mal uso, funcionamiento, o cualquier riesgo de seguridad de este script,
REM esto solo con fines educativos.

title Activador Office LTSC - aaron-dotnet

REM validar si se esta ejecutando como administrador
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Es necesario ejecutar este script como administrador.
    pause
    exit /b 1
)

ECHO.
ECHO *************************************************
ECHO *                Activador Office               *
ECHO *                by - aaron-dotnet              *
ECHO *************************************************
ECHO.

REM Variables.
REM En caso de que ya se haya instalado una key, solo hay que poner los ultimos 5 caracteres de la key,
REM en caso contrario se puede comentar la sección de REMOVE_KEY.
REM El puerto 1688 es el que se utiliza para la activación.
set REMOVE_KEY=abcde
set KEY=search-in-google-lol
set KMS_SERVER=search-in-google-lol
set KMS_PORT=1688

REM Revisa que carpeta de Office
if not exist "%ProgramFiles(x86)%\Microsoft Office\Office16" (
    cd /d %ProgramFiles%\Microsoft Office\Office16
	ECHO Sistema de 64 bits
) ELSE ( 
    cd /d "%ProgramFiles(x86)%\Microsoft Office\Office16"
    ECHO Sistema de 32 bits
)

REM Instala las licencias KMS encontradas en el directorio Licenses16
REM IMPORTANTE: aqui solo hay que remplazar la version de Office despues de \Licenses16\[AQUI]VL_KMS....
ECHO Instalando licencias KMS...
for /f %%x in ('dir /b ..\root\Licenses16\ProPlus2024VL_KMS*.xrm-ms') do (
    cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" >nul 2>&1
)

REM Asigna el puerto del servidor KMS.
ECHO Configurando el puerto del servidor KMS...
cscript ospp.vbs /setprt:%KMS_PORT% >nul 2>&1

REM Elimina la clave de producto existente.
ECHO Eliminando la clave de producto existente...
cscript ospp.vbs /unpkey:%REMOVE_KEY% >nul

REM Ingresa la nueva clave de producto correspondiente.
ECHO Ingresando la nueva clave de producto...
cscript ospp.vbs /inpkey:%KEY% >nul 2>&1

REM Establece el servidor KMS.
ECHO Estableciendo el servidor KMS...
cscript ospp.vbs /sethst:%KMS_SERVER% >nul 2>&1

REM Intenta activar Office (no se silencia el output para validar la activación)
ECHO Activando Office...
cscript //NoLogo ospp.vbs /act 


REM Bueno aqui termina el script, en lo personal yo bloquearia el puerto de activación,
REM pero eso podria bloquear todo el script por Defender.

ECHO.
ECHO.
ECHO ***************************
ECHO    Activacion completada  
ECHO ***************************

pause