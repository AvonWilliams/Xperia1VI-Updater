@echo off
cls
echo.
echo.
echo.
echo "Hello, welcome to Avons xperia updater!"
echo.
echo "First, as a precaution. Please backup everything on your phone, and remove it from the phone."
echo.
echo "Ensure this this .bat file is in the same folder as newflasher.exe and the firmware files should be in a folder, in this directory, called ROMS"
echo.
echo.
echo.
REM Determine the current directory
set "currentDir=%CD%"
echo Current directory is: %currentDir%
echo.
echo.
echo.
REM List the folders in the ROMS directory
echo Available folders in ROMS:
setlocal enabledelayedexpansion
set count=0
for /d %%D in ("%currentDir%\ROMS\*") do (
    set /a count+=1
    echo !count!. %%~nxD
    set "folder!count!=%%~nxD"
)
echo.
echo.
echo.
REM Ask the user to choose a folder
set /p choice="Enter the number of the folder you want to use: "

REM Validate the user's choice
if !choice! gtr !count! (
    echo Invalid choice.
    goto exit
)
echo.
echo.
echo.
REM Use the chosen folder
set "selectedFolder=%currentDir%\ROMS\!folder%choice%!"
cls
echo You selected: !selectedFolder!
echo.
REM Continue with the update process using the selected folder
echo "Continuing with the update process using !selectedFolder!..."
REM Add your update commands here
echo.
echo.
echo.
echo "Ensure USB cable is securely plugged into this PC"
echo "Ensure your phone is charged, and turned off"
echo "Press and hold vol down button on phone while plugging the usb cable into phone. You should be seeing a green asterisk."
echo.
choice /C YX /M "Once your phone is showing the green asterisk. Press Y to continue or X to exit"

if errorlevel 2 goto exit
if errorlevel 1 goto continue

:continue
cls
echo.
echo.
echo.
copy "%currentDir%\newflasher.exe" "!selectedFolder!"
cd "!selectedFolder!"
newflasher set_active:a
ECHO  "WARNING PRESSING CONTINUE WILL IMMEDIATLY FLASH YOUR PHONE WITH !selectedFolder! FIRMWARE"
choice /C FX /M "Press F to flash or X to exit"

if errorlevel 2 goto exit
if errorlevel 1 goto flash

:flash
echo.
echo.
echo "Flashing your phone with the firmware in !selectedFolder!... "

REM Countdown timer with exit feature
set /a countdown=10
:countdown_loop
if %countdown% leq 0 goto do_flash
echo Flashing in %countdown% seconds. Press Ctrl+C to cancel.
set /a countdown-=1
timeout /t 1 >nul
goto countdown_loop

:do_flash
REM  Flashing commands
cd "!selectedFolder!"
newflasher set_active:a
newflasher

goto exit

:exit
echo "Exiting the updater."
set /a countdown=3
:exit_loop
if %countdown% leq 0 goto end
REM echo Flashing in %countdown% seconds. Press Ctrl+C to cancel.
set /a countdown-=1
timeout /t 1 >nul
goto exit_loop
exit /B

:end
REM End of the script

REM 1. Download Newflasher and the latest ROM via xperifirm
REM 2. Extract the firmware and Newflasher.
REM 3. Copy Newflasher files into the same folder where you extracted the ROM
rem 4.0 "STEP 4 IS NOT NESSECARY. COMPLETED UPDATE ON 22/01/25 WITHOUT DOING THIS AND DIDNT LOOSE ANY USER DATA" - AW
REM 4. In the ROM folder I deleted the file "persist_X-FLASH-ALL-88DF.sin". Not sure if it is needed, but I wanted to make sure the persist partition is not being flashed.
REM 5. press and hold (power+ vol down) while plugging the usb cable. You should be seeing a green asterisk.
REM 6. From within the ROM folder open a terminal window and type
REM Code:

REM newflasher set_active:a

REM and then just
REM Code:

REM newflasher

REM 7. Follow the steps and when you are being asked to pull a dump select no, cause it doesn't work.