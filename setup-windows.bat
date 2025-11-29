@echo off
REM ==========================================================================
REM Zen Browser Config Setup - Windows
REM Run this as Administrator
REM ==========================================================================
REM Get the directory where this script is located

set "SCRIPT_DIR=%~dp0"
set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

REM Zen profile location on Windows
set "ZEN_DIR=%APPDATA%\zen\Profiles"

if not exist "%ZEN_DIR%" (
    echo Error: Zen directory not found at "%ZEN_DIR%"
    echo Make sure Zen Browser is installed and has been run at least once.
    pause
    exit /b 1
)

REM Find profile directory (look for .default folders)
set "PROFILE_DIR="
for /d %%i in ("%ZEN_DIR%\*.Default (release)") do (
    set "PROFILE_DIR=%%i"
    goto :found_profile
)

:found_profile
if "%PROFILE_DIR%"=="" (
    echo Error: Could not find Zen profile directory
    echo Check: "%ZEN_DIR%"
    pause
    exit /b 1
)

set "CHROME_DIR=%PROFILE_DIR%\chrome"
if not exist "%CHROME_DIR%" (
    echo Chrome directory not found at "%CHROME_DIR%"
    pause
    exit /b 1
)

call :ensure_symlink "%CHROME_DIR%\userChrome.css" "%SCRIPT_DIR%\userChrome.css"
call :ensure_symlink "%PROFILE_DIR%\user.js" "%SCRIPT_DIR%\user.js"
goto :done

:ensure_symlink
REM %1 = target path, %2 = source path

set "TARGET=%~1"
set "SOURCE=%~2"

if exist "%TARGET%" (
    fsutil reparsepoint query "%TARGET%" >nul 2>&1
    if errorlevel 1 (
        echo Error: existing "%TARGET%" is not a symlink
        pause
        exit /b 1
    ) else (
        echo Removing existing symlink "%TARGET%"...
        del "%TARGET%"
    )
) else (
    echo No existing file at "%TARGET%". Creating new link...
)

mklink "%TARGET%" "%SOURCE%"
if errorlevel 1 (
    echo Error: failed to create symlink "%TARGET%"
    echo Please run this script as Administrator or enable Developer Mode.
    pause
    exit /b 1
)

goto :eof

:done
echo Setup complete!
echo   userChrome.css -^> %CHROME_DIR%\userChrome.css
echo   user.js        -^> %PROFILE_DIR%\user.js
echo.
echo Restart Zen Browser to apply changes.
pause
