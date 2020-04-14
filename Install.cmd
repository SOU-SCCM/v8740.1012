:STEP1 
REM Check for SCCM Client Services
sc query "CCMEXEC"
echo %ERRORLEVEL%
SET var1=%ERRORLEVEL%
IF %var1% EQU 1060 (GOTO LOCALINSTALL)

:GETVERSION
REM Get SCCM Client Version
FOR /F "tokens=* USEBACKQ" %%F IN (`Powershell -Command "(Get-WMIObject -Namespace root\ccm -Class SMS_Client).ClientVersion"`) DO (
SET var=%%F
)
ECHO %var%
IF %var% EQU 5.00.8790.1025 (GOTO UNINSTALL) ELSE (GOTO DONE)

:UNINSTALL
REM Uninstall SCCM Client
start /wait c:\windows\ccmsetup\ccmsetup.exe /uninstall
START /WAIT TIMEOUT /T 15 /NOBREAK >NUL

:LOCALINSTALL
REM Install SCCM Client from local source file
start C:\Windows\Temp\v8740.1012-master\ccmsetup.exe /UsePKICert /NoCRLCheck /mp:ibcm2.dts.utah.gov CCMHOSTNAME=ibcm2.dts.utah.gov SMSSITECODE=P01 FSP=ibcm.dts.utah.gov

:DONE
echo SCCM Rollback Complete
exit

