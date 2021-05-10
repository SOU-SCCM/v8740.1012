echo %COMPUTERNAME%
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
IF %var% EQU 5.00.9040.1015 (GOTO UNINSTALL) ELSE (Echo Not 9040.1015)
IF %var% EQU 5.00.9040.1044 (GOTO UNINSTALL) ELSE (Echo Not 9040.1044)
IF %var% EQU 5.00.9012.1056 (GOTO UNINSTALL) ELSE (Echo Not 9012.1056)
IF %var% EQU 5.00.8790.1025 (GOTO UNINSTALL) ELSE (Echo Not 8790.1025)
IF %var% EQU 5.00.8692.1008 (GOTO UNINSTALL) ELSE (Echo Not 8692.2008)
IF %var% EQU 5.00.8634.1814 (GOTO UNINSTALL) ELSE (Echo Not 8634.1814)
IF %var% EQU 5.00.8790.1007 (GOTO UNINSTALL) ELSE (Echo Not 8790.1007)
IF %var% EQU 5.00.9012.1020 (GOTO UNINSTALL) ELSE (GOTO DONE)

:UNINSTALL
REM Uninstall SCCM Client
start /wait c:\windows\ccmsetup\ccmsetup.exe /uninstall
START /WAIT TIMEOUT /T 15 /NOBREAK >NUL

:LOCALINSTALL
REM Install SCCM Client from local source file
start C:\Windows\Temp\v8740.1012-master\ccmsetup.exe /UsePKICert /NoCRLCheck CCMHOSTNAME=ibcm2.dts.utah.gov SMSSITECODE=P01 FSP=ibcm.dts.utah.gov

:DONE
echo SCCM Rollback Complete
exit

