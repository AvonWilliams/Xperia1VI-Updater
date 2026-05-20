@echo off
setlocal EnableDelayedExpansion
title Sony Xperia XQ-EC72 Firmware Flasher - PROCEED WITH CAUTION

:: ============================================================
::  Sony Xperia 1 VI (XQ-EC72) Firmware Flash Script
::  Uses: newflasher.exe + XperiFirm downloaded firmware
::  DOUBLE CONFIRMATION required at every critical step
:: ============================================================

color 0A
cls

:: ===========================
:: STEP 0 - SAFETY HEADER
:: ===========================
echo ============================================================
echo   SONY XPERIA 1 VI (XQ-EC72) - FIRMWARE UPDATE UTILITY
echo ============================================================
echo.
echo  [!] WARNING: Flashing firmware can BRICK your device if
echo      done incorrectly. Read every instruction carefully.
echo.
echo  [!] This script will:
echo       - Detect available firmware in the current folder
echo       - Guide you through every step with phone instructions
echo       - Require YOU to confirm twice before any action
echo.
echo  [!] BEFORE YOU CONTINUE, make sure:
echo       1. Your phone battery is at least 50%% charged
echo       2. You have a working USB cable (data cable, not charge-only)
echo       3. USB Debugging is OFF (not needed for this method)
echo       4. You have read the READ_ME_FIRST.txt file
echo.
echo ============================================================
echo.
pause

:: ===========================
:: STEP 1 - LOCATE SCRIPT DIR
:: ===========================
cls
echo [STEP 1/7] Locating script and tools...
echo.

:: Set working directory to where this bat file lives
cd /d "%~dp0"
set "SCRIPT_DIR=%~dp0"

:: Check for newflasher.exe
if not exist "newflasher.exe" (
    color 0C
    echo  [ERROR] newflasher.exe NOT FOUND in:
    echo  %SCRIPT_DIR%
    echo.
    echo  Please place this .bat file in the same folder as newflasher.exe
    echo  and all your firmware folders.
    echo.
    pause
    exit /b 1
)
echo  [OK] newflasher.exe found.
echo.

:: ===========================
:: STEP 2 - DETECT FIRMWARE
:: ===========================
echo [STEP 2/7] Scanning for XQ-EC72 firmware folders...
echo.

set "FW_COUNT=0"
set "FW_LIST="

for /d %%D in ("XQ-EC72*") do (
    set /a FW_COUNT+=1
    set "FW_!FW_COUNT!=%%~nxD"
    echo  [!FW_COUNT!] %%~nxD
)

if %FW_COUNT%==0 (
    color 0C
    echo  [ERROR] No XQ-EC72 firmware folders found in:
    echo  %SCRIPT_DIR%
    echo.
    echo  Download firmware using XperiFirm.exe first.
    echo  Firmware folders should be named like:
    echo    XQ-EC72_Customized_TW_69.x.x.x
    echo.
    pause
    exit /b 1
)

echo.
echo  Found %FW_COUNT% firmware folder(s).
echo.

:: ===========================
:: STEP 3 - SELECT FIRMWARE
:: ===========================
:SELECT_FW
cls
echo [STEP 3/7] Select firmware to flash
echo ============================================================
echo.
for /L %%i in (1,1,%FW_COUNT%) do (
    echo   [%%i] !FW_%%i!
)
echo.
set /p "FW_CHOICE=  Enter the number of the firmware you want to flash: "

:: Validate input
set "SELECTED_FW="
for /L %%i in (1,1,%FW_COUNT%) do (
    if "!FW_CHOICE!"=="%%i" set "SELECTED_FW=!FW_%%i!"
)

if "!SELECTED_FW!"=="" (
    echo.
    echo  [!] Invalid selection. Please enter a number from the list.
    echo.
    pause
    goto SELECT_FW
)

echo.
echo  You selected: !SELECTED_FW!
echo.

:: --- FIRST CONFIRMATION ---
echo ============================================================
echo  [CONFIRM #1 of 2]
echo  Are you sure you want to flash:
echo    !SELECTED_FW!
echo ============================================================
echo.
set /p "CONF1=  Type YES (uppercase) to continue: "
if /i not "!CONF1!"=="YES" (
    echo.
    echo  Cancelled. Returning to selection...
    echo.
    pause
    goto SELECT_FW
)

:: --- SECOND CONFIRMATION ---
echo.
echo ============================================================
echo  [CONFIRM #2 of 2] - FINAL WARNING
echo.
echo  This will OVERWRITE the current firmware on your phone.
echo  This CANNOT be undone once started.
echo.
echo  Double-check: Is this the correct firmware for YOUR device?
echo    Device : Sony Xperia 1 VI (XQ-EC72)
echo    Firmware: !SELECTED_FW!
echo ============================================================
echo.
set /p "CONF2=  Type FLASH (uppercase) to proceed: "
if /i not "!CONF2!"=="FLASH" (
    echo.
    echo  Cancelled. Returning to selection...
    echo.
    pause
    goto SELECT_FW
)

:: ===========================
:: STEP 4 - PHONE PREP
:: ===========================
cls
echo [STEP 4/7] Prepare your phone - READ CAREFULLY
echo ============================================================
echo.
echo  You need to put your Xperia 1 VI into FLASH MODE.
echo  Follow these steps EXACTLY:
echo.
echo  -------------------------------------------------------
echo   PHONE INSTRUCTIONS - ENTERING FLASH MODE
echo  -------------------------------------------------------
echo.
echo   1. POWER OFF your phone completely.
echo      - Hold Power button and tap "Power off"
echo      - Wait until the screen is fully black
echo      - Wait an additional 10 seconds to be sure
echo.
echo   2. DO NOT connect the USB cable yet.
echo.
echo   3. Hold the VOLUME UP button on your phone.
echo      - Find the Volume Up button (top of the right side)
echo      - Press and HOLD it down firmly
echo.
echo   4. While holding Volume Up, plug in the USB cable
echo      to your computer.
echo.
echo   5. The phone should show a GREEN LED light near
echo      the top of the screen.
echo       - GREEN LED = Flash Mode (correct!)
echo       - BLUE LED  = Flash Mode but DRM keys may be wiped
echo       - No LED    = Not in flash mode, try again
echo.
echo   6. DO NOT release Volume Up until you see the LED.
echo.
echo  -------------------------------------------------------
echo.
echo  [!] If you see BLUE instead of GREEN LED:
echo      This means OEM unlock is active. Flashing will still
echo      work but DRM (Widevine L1/camera quality) keys may
echo      be at risk. Confirm you understand before continuing.
echo.
echo  -------------------------------------------------------
echo.

:: --- FIRST CONFIRMATION ---
echo ============================================================
echo  [CONFIRM #1 of 2]
echo  Is your phone showing a GREEN LED and connected via USB?
echo ============================================================
echo.
set /p "CONF3=  Type YES (uppercase) when ready: "
if /i not "!CONF3!"=="YES" (
    echo.
    echo  Please follow the phone instructions above, then run
    echo  this script again.
    echo.
    pause
    exit /b 0
)

:: --- SECOND CONFIRMATION ---
echo.
echo ============================================================
echo  [CONFIRM #2 of 2]
echo  One more check before we flash:
echo.
echo    - Phone is POWERED OFF (showing LED, not Android)  [Y/N]?
echo    - GREEN LED is visible on the phone               [Y/N]?
echo    - USB cable is firmly connected to PC             [Y/N]?
echo    - You are NOT in a hurry / will not unplug early  [Y/N]?
echo ============================================================
echo.
set /p "CONF4=  Type READY (uppercase) to begin flashing: "
if /i not "!CONF4!"=="READY" (
    echo.
    echo  Cancelled. Please make sure all conditions above are met.
    echo.
    pause
    exit /b 0
)

:: ===========================
:: STEP 5 - COPY + FLASH
:: ===========================
cls
echo [STEP 5/7] Starting firmware flash...
echo ============================================================
echo.
echo  Firmware : !SELECTED_FW!
echo  Tool     : newflasher.exe
echo.
echo  -------------------------------------------------------
echo   IMPORTANT - DO NOT do any of the following while
echo   flashing is in progress:
echo.
echo     - Unplug the USB cable
echo     - Move or jostle the cable
echo     - Turn off your computer
echo     - Put your computer to sleep
echo     - Close this window
echo  -------------------------------------------------------
echo.
echo  The flash process typically takes 5-15 minutes.
echo  A progress indicator will appear below.
echo.
echo  Starting in 5 seconds...
timeout /t 5 /nobreak >nul

echo.
echo ============================================================
echo  FLASHING NOW - DO NOT INTERRUPT
echo ============================================================
echo.

:: Run newflasher from the firmware folder
pushd "!SELECTED_FW!"
"..\newflasher.exe"
set "FLASH_EXIT=!ERRORLEVEL!"
popd

echo.
echo ============================================================

:: ===========================
:: STEP 6 - RESULT CHECK
:: ===========================
cls
echo [STEP 6/7] Flash result
echo ============================================================
echo.

if "!FLASH_EXIT!"=="0" (
    color 0A
    echo  [SUCCESS] newflasher.exe completed without errors.
    echo.
    echo  -------------------------------------------------------
    echo   PHONE INSTRUCTIONS - AFTER FLASHING
    echo  -------------------------------------------------------
    echo.
    echo   1. Your phone may restart automatically.
    echo      If it does NOT restart after 60 seconds:
    echo       - Hold Power + Volume Down for 10 seconds
    echo         to force a reboot.
    echo.
    echo   2. The FIRST BOOT after a firmware flash takes
    echo      3-10 minutes. This is NORMAL. Do not panic.
    echo      You will see the Sony logo for a long time.
    echo.
    echo   3. DO NOT unplug the phone until it has fully
    echo      booted into Android and you see the setup screen
    echo      or your home screen.
    echo.
    echo   4. After booting, go to:
    echo       Settings ^> About Phone ^> Build Number
    echo      and verify it matches the firmware you flashed.
    echo.
    echo  -------------------------------------------------------
) else (
    color 0C
    echo  [WARNING] newflasher.exe exited with code: !FLASH_EXIT!
    echo.
    echo  This may indicate an error occurred during flashing.
    echo.
    echo  What to check:
    echo   1. Was the GREEN LED visible on the phone?
    echo   2. Was the USB cable stable throughout?
    echo   3. Is the firmware folder complete (not corrupted)?
    echo   4. Try re-downloading the firmware via XperiFirm.
    echo.
    echo  DO NOT reboot your phone yet - check the output above
    echo  for any error messages before proceeding.
    echo.
    echo  If your phone is unresponsive, try holding
    echo  Power + Volume Down for 10-15 seconds to reboot.
)

echo.

:: ===========================
:: STEP 7 - DONE
:: ===========================
echo [STEP 7/7] All done
echo ============================================================
echo.
echo  Firmware flashed : !SELECTED_FW!
echo  Exit code        : !FLASH_EXIT!
echo  Completed at     : %DATE% %TIME%
echo.
echo  Keep this window open until your phone fully boots.
echo  You can close it once you see your Android home screen.
echo.
echo ============================================================
echo.
pause
endlocal
exit /b 0