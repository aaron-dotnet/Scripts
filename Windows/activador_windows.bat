@echo off

REM No me hago responsable por el mal uso, funcionamiento, o cualquier riesgo de seguridad de este script,
REM esto solo con fines educativos.

REM 'net session' solo es para validar permisos.
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Este script requiere permisos de administrador.
    pause
    exit
)

title Activador de Windows - by aaron-dotnet

ECHO _________________________________________________________
ECHO.
ECHO.
ECHO                 Activador de Windows 10/11                  
ECHO.
ECHO _________________________________________________________

REM  Obtiene los datos del S.O. y lo filtra para obtener el nombre.
ECHO.
SYSTEMINFO | FINDSTR /B /C:"OS Name" /C:"OS Version" /C:"Nombre del sistema operativo"
echo - - - - - - - - - - - - - - - - - - - - - - - -

echo (1) -  PROFESSIONAL (PRO)
echo (2) -  HOME
echo (3) -  ENTERPRISE
echo (4) -  EDUCATION
echo (5) -  ULTIMATE
echo.
echo (C) -  CANCELAR

echo - - - - - - - - - - - - - - - - - - - - - - - -

echo ADVERTENCIA: Esto borrara la clave actual e instalara una nueva clave KMS
echo.

REM Definir claves por versión (Usa Google lol)
set "key[1]=abc"
set "key[2]=abc"
set "key[3]=abc"
set "key[4]=abc"
set "key[5]=abc"

:inicio
set /p version=Selecciona tu edición de Windows:
if /i "%version%"=="c" goto cancelar
if "%version%"=="1" set "clave=%key[1]%" & goto activar
if "%version%"=="2" set "clave=%key[2]%" & goto activar
if "%version%"=="3" set "clave=%key[3]%" & goto activar
if "%version%"=="4" set "clave=%key[4]%" & goto activar
if "%version%"=="5" set "clave=%key[5]%" & goto activar
goto error


REM elimina la clave actual, instala la nueva clave y activa.
:activar
slmgr.vbs -upk
slmgr /ipk %clave%
slmgr /skms kms.digiboy.ir
slmgr /ato
if %errorLevel% neq 0 (
    echo Error en la activación. Intentalo de nuevo.
    pause
    goto inicio
)
echo Finalizado, presione cualquier tecla para salir.
pause>nul
exit

REM Finaliza el script.
:cancelar
exit

:error
echo Valor no válido.
goto inicio