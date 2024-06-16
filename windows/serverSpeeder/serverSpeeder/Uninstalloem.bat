@ECHO OFF
snetcfg.exe -u
del  uninstallappex.txt
findstr -m -c:"LotMobile" %windir%\inf\*.inf>uninstallappex.txt
FOR /f "tokens=1" %%I IN (uninstallappex.txt) DO del %%I 
del  uninstallappex.txt
cd  %USERPROFILE%\Local Settings\Application Data\
attrib IconCache.db -h
del IconCache.db
cd  %USERPROFILE%\AppData\Local\
attrib IconCache.db -h
del IconCache.db
