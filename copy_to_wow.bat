@echo off
echo Copying SimpleQuestPlates to WoW Retail...

set SOURCE_DIR=C:\Users\Joey\simplequestplates
set DEST_DIR=C:\Program Files (x86)\World of Warcraft\_retail_\Interface\AddOns\SimpleQuestPlates

echo Source: %SOURCE_DIR%
echo Destination: %DEST_DIR%

if not exist "%DEST_DIR%" (
    echo Creating destination directory...
    mkdir "%DEST_DIR%"
)

echo Copying files...
xcopy "%SOURCE_DIR%\*" "%DEST_DIR%\" /E /Y /I

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ✓ SimpleQuestPlates successfully copied to WoW!
    echo ✓ All fixes have been applied
    echo.
    echo The addon is now ready to use in World of Warcraft.
) else (
    echo.
    echo ✗ Error occurred during copy operation
    echo Please check if WoW is installed at the expected location
    echo or run this script as Administrator
)

echo.
pause