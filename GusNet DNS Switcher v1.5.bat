@echo off
chcp 65001 >nul
title GusNet DNS Switcher v1.5
color 0B
setlocal EnableDelayedExpansion

set "adaptador=Wi-Fi"
set "activo="

:: Verificar si el adaptador tiene IPv4 activa usando ipconfig
for /f "tokens=1,* delims=:" %%A in ('ipconfig ^| findstr /C:"Adaptador de LAN inalámbrica %adaptador%" /C:"Dirección IPv4"') do (
    echo %%A | findstr /I "Adaptador" >nul && set "encontrado=1"
    echo %%A | findstr /I "Dirección IPv4" >nul && set "activo=1"
)

if not defined encontrado (
    echo [X] No se encontró el adaptador "%adaptador%".
    pause
    exit /b
)

if not defined activo (
    echo [X] El adaptador "%adaptador%" no tiene IPv4 activa.
    pause
    exit /b
)

:menu
cls
echo ================================
echo     GUSNET DNS SWITCHER v1.5
echo ================================
echo.
echo Adaptador detectado: %adaptador%
echo.
echo 1. Usar DNS de Cloudflare (1.1.1.1 / 1.0.0.1)
echo 2. Usar DNS de Google     (8.8.8.8 / 8.8.4.4)
echo 3. Volver a DHCP (automático)
echo 4. Salir
echo.
set /p opcion=Elige una opción [1-4]: 

if "%opcion%"=="1" goto cloudflare
if "%opcion%"=="2" goto google
if "%opcion%"=="3" goto dhcp
if "%opcion%"=="4" exit
goto menu

:cloudflare
echo Aplicando DNS de Cloudflare...
netsh interface ip set dnsservers name="%adaptador%" source=static address=1.1.1.1 register=none validate=no
netsh interface ip add dnsservers name="%adaptador%" address=1.0.0.1 index=2 validate=no
goto mostrar

:google
echo Aplicando DNS de Google...
netsh interface ip set dnsservers name="%adaptador%" source=static address=8.8.8.8 register=none validate=no
netsh interface ip add dnsservers name="%adaptador%" address=8.8.4.4 index=2 validate=no
goto mostrar

:dhcp
echo Restaurando DNS automático (DHCP)...
netsh interface ip set dnsservers name="%adaptador%" source=dhcp
goto mostrar

:mostrar
echo.
echo [OK] Configuración aplicada. DNS actual:
netsh interface ip show config name="%adaptador%" | findstr /i "DNS"
echo.
echo ---------------------------------------------
echo Hecho con amor, comprensión y cariño,
echo café, paciencia y Copilot al mando
echo Desarrollado por GusMathieu2025 - Argentina + Venezuela
echo Versión: GusNet DNS Switcher v1.5
echo ---------------------------------------------
pause
goto menu
