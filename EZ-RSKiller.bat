:Head
@echo off
set version=5.0
mode con cols=66 lines=30
ver|find "Windows XP" > NUL && set System=WinXP
if "%System%"=="WinXP" (
  set DocumentsLocale=C:\Documents and Settings\%username%\My Documents\
  set DesktopLocale=C:\Documents and Settings\%username%\����\
  copy %0 "C:\Documents and Settings\%username%\My Documents\EZ.bat"
  goto NoAdmin
) else (
  set DocumentsLocale=C:\Users\%username%\Documents\
  set DesktopLocale=C:\Users\%username%\Desktop\
  copy %0 "C:\Users\%username%\Documents\EZ.bat"
)
echo /////     ���������ԱȨ�ޣ�     /////
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit >nul
:NoAdmin
title ��֩��ɱ�� V%version%
cls
echo                            ��֩��ɱ��
echo                               V%version%
echo                     Copyright %date:~0,4% SummonHIM.
if exist "%DocumentsLocale%REDLocal.ini" (goto CheckRedAgentStatus) else (goto FirstTimeRun)

:FirstTimeRun
color 4E
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo �״����������ڲ��Һ�֩�����λ�á����Ժ�...
echo �����ٶȿ��ܽ����������ĵȴ���
echo,
echo λ�� %DocumentsLocale%REDLocal.ini ���ļ�������Ҫɾ�������ļ����ڶ�λ��֩�����λ�ã�
echo,
set FindData=0
:FTRReFind
for /r c:\ %%i in (NetTalk.exe*)do (
  set RedAgentPath=%%~dpi
  if "%FindData%"== "1" (
    set RedAgentPath1=%%~dpi
  )
  if "%FindData%"== "2" (
    set RedAgentPath2=%%~dpi
  )
  if "%FindData%" == "3" (
    if "%RedAgentPath1%" == "%RedAgentPath2%" (goto FTRFind7)
    set FindData=0
  )
  set /a FindData=%FindData%+1
  echo ��ѯ��·������֩�� 6.0����%%~dpi
  if not exist %%~dpiREDAgent.exe (
    if not exist %%~dpiREDAgent0.exe (goto FTRReFind) else (goto FTRContinue)
  ) else (
    goto FTRContinue
  )
)
:FTRFind7
for /r c:\ %%i in (edpaper.exe*)do (
  set RedAgentPath=%%~dpi
  if "%FindData%"== "1" (
    set RedAgentPath1=%%~dpi
  )
  if "%FindData%"== "2" (
    set RedAgentPath2=%%~dpi
  )
  if "%FindData%" == "3" (
    if "%RedAgentPath1%" == "%RedAgentPath2%" (goto RedAgentNotFound)
    set FindData=0
  )
  set /a FindData=%FindData%+1
  echo ��ѯ��·������֩�� 7.0����%%~dpi
  if not exist %%~dpiREDAgent.exe (
    if not exist %%~dpiREDAgent0.exe (goto FTRReFind) else (goto FTRContinue)
  ) else (
    goto FTRContinue
  )
)
:FTRContinue
echo,
echo ���ҽ�������֩�������·��Ϊ��
echo %RedAgentPath%
echo,
echo ���ڽ�·�����浽 %DocumentsLocale%REDLocal.ini
echo %RedAgentPath%>"%DocumentsLocale%REDLocal.ini"
if not exist "%DocumentsLocale%REDLocal.ini" (goto NoAccess) else (echo ����ɹ���)

:CheckRedAgentStatus
set /P RedAgentPath=<"%DocumentsLocale%REDLocal.ini"
if exist "%RedAgentPath%REDAgent.exe" goto ShutdownRedAgent
if exist "%RedAgentPath%REDAgent0.exe" (goto StartRedAgent) ELSE (goto RedAgentNotFound)

:RedAgentNotFound
cls
color 4E
echo                            ��֩��ɱ��
echo                               V%version%
echo                     Copyright %date:~0,4% SummonHIM.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo ��֩�����·����%RedAgentPath%
echo,
echo ������δ���ҵ���֩�������
echo �Ƿ�����������֩������λ�ã�
echo �������ֶ��޸� %DocumentsLocale%REDLocal.ini ·���ļ�����
echo,
echo Y���ǣ�N���˳���E=�Զ����֩��·������������򰴻س���������
set NotFoundYorN=
set /p NotFoundYorN=[Y/N/E]:
if "%NotFoundYorN%" == "y" set NotFoundYorN=Y
if "%NotFoundYorN%" == "n" set NotFoundYorN=N
if "%NotFoundYorN%" == "e" set NotFoundYorN=E
if "%NotFoundYorN%" == "Y" goto FirstTimeRun
if "%NotFoundYorN%" == "N" goto Exiting
if "%NotFoundYorN%" == "E" goto EditRedLocal
echo ������ "%NotFoundYorN%" ������!
echo ������ʾ:Y���ǣ�N���˳���E=�Զ����֩��·��(�����ִ�Сд)
pause
cls
goto RedAgentNotFound

:EditRedLocal
echo,
echo �뽫��֩�������·�����뵽�˴���
echo ����C:\Program Files\3000soft\Red Spider\
echo �������·��������һ���»��ߡ�\�����������
echo,
set /p RedAgentPath=
echo,
echo ���ڽ�·�����浽 %DocumentsLocale%REDLocal.ini
echo %RedAgentPath%>"%DocumentsLocale%REDLocal.ini"
if not exist "%DocumentsLocale%REDLocal.ini" (goto NoAccess) else (echo ����ɹ���)
pause
goto Head

:ShutdownRedAgent
color 4E
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo ����ִ��һ���رճ���...
taskkill /f /im REDAgent.exe /t
rename "%RedAgentPath%REDAgent.exe" REDAgent0.exe
if errorlevel 1 (goto NoAccess)
echo �ѽ� REDAgent.exe ������Ϊ REDAgent0.exe
echo ������ɣ�
set RedAgentStatus=Closed
goto Finish

:StartRedAgent
color 4E
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo ȷ��Ҫ�ָ���֩�������
echo ����رմ˳��򼴿ɡ�
echo,
echo ���������������...
pause >nul
rename "%RedAgentPath%REDAgent0.exe" REDAgent.exe
if errorlevel 1 (goto NoAccess)
echo �ѽ� REDAgent0.exe ������Ϊ REDAgent.exe
echo ����ǿ��������֩�����...
start /d "%RedAgentPath%" REDAgent.exe
echo ������ɣ�
set RedAgentStatus=Started
goto Finish

:Finish
color 2F
cls
echo                            ��֩��ɱ��
echo                               V%version%
echo                     Copyright %date:~0,4% SummonHIM.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if "%RedAgentStatus%" == "Closed" (
echo                         ��֩������ѹرգ�
echo �´���������Ϊ���ָ���֩�롣
) ELSE (
if "%RedAgentStatus%" == "Started" (
echo                         ��֩������ѻָ���
echo �´���������Ϊ���رպ�֩�롣
)
)
echo,
echo ���ű��ױ�����Ա���ƣ�������ֽ�ʼ���������ַ��https://summonhim.github.io/EZ-RSKiller/
echo ���ű��ױ�����Ա���ƣ�������ֽ�ʼ���������ַ��https://summonhim.github.io/EZ-RSKiller/
echo ���ű��ױ�����Ա���ƣ�������ֽ�ʼ���������ַ��https://summonhim.github.io/EZ-RSKiller/
msg * ���ű��ױ�����Ա���ƣ�������ֽ�ʼ���������ַ��https://summonhim.github.io/EZ-RSKiller/
if exist "%DesktopLocale%RSOKR.vbs" (
  goto Exiting
)
echo,
echo �Ƿ�����һ�����б��ű���Ctrl+Alt+F4����
echo Y���ǣ�N���˳�����������򰴻س���������
set OneKeyRunYorN=
set /p OneKeyRunYorN=[Y/N/E]:
if "%OneKeyRunYorN%" == "y" set OneKeyRunYorN=Y
if "%OneKeyRunYorN%" == "n" set OneKeyRunYorN=N
if "%OneKeyRunYorN%" == "Y" goto OneKeyRun
if "%OneKeyRunYorN%" == "N" goto Exiting
echo ������ "%OneKeyRunYorN%" ������!
echo ������ʾ:Y���ǣ�N���˳�(�����ִ�Сд)
pause
cls
goto Finish

:OneKeyRun
echo Set WshShell = Wscript.CreateObject("Wscript.Shell") > "%DesktopLocale%RSOKR.vbs"
echo, >> "%DesktopLocale%RSOKR.vbs"
echo Set oMyShortcut = WshShell.CreateShortcut("a_key.lnk") >> "%DesktopLocale%RSOKR.vbs"
echo OMyShortcut.TargetPath = "%DocumentsLocale%EZ.bat" >> "%DesktopLocale%RSOKR.vbs"
echo oMyShortCut.Hotkey = "Ctrl+Alt+F4" >> "%DesktopLocale%RSOKR.vbs"
echo oMyShortCut.Save >> "%DesktopLocale%RSOKR.vbs"
echo, >> "%DesktopLocale%RSOKR.vbs"
echo WshShell.run "attrib +h RSOKR.vbs",0 >> "%DesktopLocale%RSOKR.vbs"
echo WshShell.run "attrib +h a_key.lnk",0 >> "%DesktopLocale%RSOKR.vbs"

cd %DesktopLocale%
cscript //nologo RSOKR.vbs

echo ������ɣ��� Ctrl+Alt+F4 �������б��ű���
goto Exiting

:NoAccess
echo,
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo ����û��Ȩ�����С��ɳ��ԣ�
echo 1. ʹ���Ҽ����Թ���Ա������С�


:Exiting
echo,
echo ��������˳�������...
pause >nul
exit