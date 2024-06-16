@ECHO OFF&PUSHD %~DP0 &TITLE serverSpeeder -By Vicer
mode con cols=48 lines=20
color 87

cd.>%windir%\GetAdmin
if exist %windir%\GetAdmin (del /f /q "%windir%\GetAdmin") else (
del /s /q "%temp%\Admin.vbs" >nul 2>nul
echo CreateObject^("Shell.Application"^).ShellExecute "%~s0", "%*", "", "runas", 1 >> "%temp%\Admin.vbs"
"%temp%\Admin.vbs"
del /s /q "%temp%\Admin.vbs" >nul 2>nul
exit /b 2)

taskkill /f /im AppexAcceleratorUI.exe >nul 2>nul
if exist "%~DP0serverSpeeder.reg" start /wait %WINDIR%\regedit.exe /s "%~DP0serverSpeeder.reg"
del /f /q "%~DP0start.vbs" >nul 2>nul
del /f /q "%~DP0tools\check.etl" >nul 2>nul
del /f /q "%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\ServerSpeeder.lnk" >nul 2>nul
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\APXACC\Parameters" /f /v Params >nul 2>nul
cd /d "%~DP0\tools"
start /wait /min cmd /c "%~DP0tools\check.bat"
cd /d "%~DP0"
reg add "HKLM\SYSTEM\CurrentControlSet\Services\APXACC\Parameters" /f /v Params /t REG_BINARY /d "6b00690069007300400067006d00610069006c002e0063006f006d005b0032003000340038004d005d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000fc4430ffff010010000000000000fa02ed96ff52d760a094fb31e00ec4f67a6999c570ae415561eca0f27ab6d4781b4f352423011d29b3a66348910c168ad0e543595f46c8e6e0dcbbf95457074e1d266b46636b924a19fd5207f0e6465e5447dfc139a21b146f78d38f8fb465dca1c49fb0821e07c710b439301c6f6b7fed020ef2ec84c35e05849ef402ace4955679352693bd3e9862dbfbc24409bb2f0997cc66648ff46e8f0649c9d3915b76b740d1bbb1f19ce3d78f6e57c0f975e004cd7ed34cd5d3e58dc13f387a2922610d543a93e33b6caebf7189d3f4aad031a033a32c4c7f7c23601f87e1ceb98659eb7e1365390493072cc72b2b03a0640ab9c3a2178bd26252b33ed07513a3d60c69e98f8772f503f8e5e5d2a161c7ddfa1939f976e00418dbcf567c58a1e0093be2dea3a86e279042ef2354e714e046e7e437bfff52440e37dd2d5c29f17e3b44f0c84f4660e3c00f" >nul 2>nul
echo CreateObject("WScript.Shell").Run """%~DP0AppexAcceleratorUI.exe"" -professional",0 >start.vbs
start /wait /min start.vbs
taskkill /f /im AppexAcceleratorUI.exe >nul 2>nul
::wmic process where caption="explorer.exe" call terminate >nul 2>nul
start /wait /min start.vbs
reg add "HKCU\Software\AppEx Networks\Accelerator\Settings" /f /v NoAutoStart /t REG_DWORD /d "0x00000001" >nul 2>nul
del /f /q "%~DP0start.vbs" >nul 2>nul
exit 0