:Head
@echo off
set version=5.0
mode con cols=66 lines=30
ver|find "Windows XP" > NUL && set System=WinXP
if "%System%"=="WinXP" (
  set DocumentsLocale=C:\Documents and Settings\%username%\My Documents\
  set DesktopLocale=C:\Documents and Settings\%username%\桌面\
  copy %0 "C:\Documents and Settings\%username%\My Documents\EZ.bat"
  goto NoAdmin
) else (
  set DocumentsLocale=C:\Users\%username%\Documents\
  set DesktopLocale=C:\Users\%username%\Desktop\
  copy %0 "C:\Users\%username%\Documents\EZ.bat"
)
echo /////     请允许管理员权限！     /////
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit >nul
:NoAdmin
title 红蜘蛛杀手 V%version%
cls
echo                            红蜘蛛杀手
echo                               V%version%
echo                     Copyright %date:~0,4% SummonHIM.
if exist "%DocumentsLocale%REDLocal.ini" (goto CheckRedAgentStatus) else (goto FirstTimeRun)

:FirstTimeRun
color 4E
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo 首次启动，正在查找红蜘蛛具体位置。请稍候...
echo 查找速度可能较慢，请耐心等待！
echo,
echo 位于 %DocumentsLocale%REDLocal.ini 的文件尽量不要删除，该文件用于定位红蜘蛛具体位置！
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
  echo 查询到路径（红蜘蛛 6.0）：%%~dpi
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
  echo 查询到路径（红蜘蛛 7.0）：%%~dpi
  if not exist %%~dpiREDAgent.exe (
    if not exist %%~dpiREDAgent0.exe (goto FTRReFind) else (goto FTRContinue)
  ) else (
    goto FTRContinue
  )
)
:FTRContinue
echo,
echo 查找结束，红蜘蛛软件的路径为：
echo %RedAgentPath%
echo,
echo 正在将路径保存到 %DocumentsLocale%REDLocal.ini
echo %RedAgentPath%>"%DocumentsLocale%REDLocal.ini"
if not exist "%DocumentsLocale%REDLocal.ini" (goto NoAccess) else (echo 保存成功！)

:CheckRedAgentStatus
set /P RedAgentPath=<"%DocumentsLocale%REDLocal.ini"
if exist "%RedAgentPath%REDAgent.exe" goto ShutdownRedAgent
if exist "%RedAgentPath%REDAgent0.exe" (goto StartRedAgent) ELSE (goto RedAgentNotFound)

:RedAgentNotFound
cls
color 4E
echo                            红蜘蛛杀手
echo                               V%version%
echo                     Copyright %date:~0,4% SummonHIM.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo 红蜘蛛软件路径：%RedAgentPath%
echo,
echo 本程序未查找到红蜘蛛软件！
echo 是否重新搜索红蜘蛛所在位置？
echo （可以手动修改 %DocumentsLocale%REDLocal.ini 路径文件。）
echo,
echo Y＝是，N＝退出，E=自定义红蜘蛛路径。输入完毕则按回车键继续。
set NotFoundYorN=
set /p NotFoundYorN=[Y/N/E]:
if "%NotFoundYorN%" == "y" set NotFoundYorN=Y
if "%NotFoundYorN%" == "n" set NotFoundYorN=N
if "%NotFoundYorN%" == "e" set NotFoundYorN=E
if "%NotFoundYorN%" == "Y" goto FirstTimeRun
if "%NotFoundYorN%" == "N" goto Exiting
if "%NotFoundYorN%" == "E" goto EditRedLocal
echo 该命令 "%NotFoundYorN%" 不存在!
echo 命令提示:Y＝是，N＝退出，E=自定义红蜘蛛路径(不区分大小写)
pause
cls
goto RedAgentNotFound

:EditRedLocal
echo,
echo 请将红蜘蛛软件的路径输入到此处。
echo 例：C:\Program Files\3000soft\Red Spider\
echo 请务必在路径最后面加一个下划线“\”，避免错误！
echo,
set /p RedAgentPath=
echo,
echo 正在将路径保存到 %DocumentsLocale%REDLocal.ini
echo %RedAgentPath%>"%DocumentsLocale%REDLocal.ini"
if not exist "%DocumentsLocale%REDLocal.ini" (goto NoAccess) else (echo 保存成功！)
pause
goto Head

:ShutdownRedAgent
color 4E
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo 正在执行一键关闭程序...
taskkill /f /im REDAgent.exe /t
rename "%RedAgentPath%REDAgent.exe" REDAgent0.exe
if errorlevel 1 (goto NoAccess)
echo 已将 REDAgent.exe 重命名为 REDAgent0.exe
echo 正在完成！
set RedAgentStatus=Closed
goto Finish

:StartRedAgent
color 4E
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo 确定要恢复红蜘蛛软件吗？
echo 否则关闭此程序即可。
echo,
echo 按任意键继续操作...
pause >nul
rename "%RedAgentPath%REDAgent0.exe" REDAgent.exe
if errorlevel 1 (goto NoAccess)
echo 已将 REDAgent0.exe 重命名为 REDAgent.exe
echo 正在强制启动红蜘蛛软件...
start /d "%RedAgentPath%" REDAgent.exe
echo 正在完成！
set RedAgentStatus=Started
goto Finish

:Finish
color 2F
cls
echo                            红蜘蛛杀手
echo                               V%version%
echo                     Copyright %date:~0,4% SummonHIM.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if "%RedAgentStatus%" == "Closed" (
echo                         红蜘蛛软件已关闭！
echo 下次启动内容为：恢复红蜘蛛。
) ELSE (
if "%RedAgentStatus%" == "Started" (
echo                         红蜘蛛软件已恢复！
echo 下次启动内容为：关闭红蜘蛛。
)
)
echo,
echo 本脚本易被管理员爆破，建议用纸笔记下永久网址：https://summonhim.github.io/EZ-RSKiller/
echo 本脚本易被管理员爆破，建议用纸笔记下永久网址：https://summonhim.github.io/EZ-RSKiller/
echo 本脚本易被管理员爆破，建议用纸笔记下永久网址：https://summonhim.github.io/EZ-RSKiller/
msg * 本脚本易被管理员爆破，建议用纸笔记下永久网址：https://summonhim.github.io/EZ-RSKiller/
if exist "%DesktopLocale%RSOKR.vbs" (
  goto Exiting
)
echo,
echo 是否设置一键运行本脚本（Ctrl+Alt+F4）？
echo Y＝是，N＝退出。输入完毕则按回车键继续。
set OneKeyRunYorN=
set /p OneKeyRunYorN=[Y/N/E]:
if "%OneKeyRunYorN%" == "y" set OneKeyRunYorN=Y
if "%OneKeyRunYorN%" == "n" set OneKeyRunYorN=N
if "%OneKeyRunYorN%" == "Y" goto OneKeyRun
if "%OneKeyRunYorN%" == "N" goto Exiting
echo 该命令 "%OneKeyRunYorN%" 不存在!
echo 命令提示:Y＝是，N＝退出(不区分大小写)
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

echo 设置完成！按 Ctrl+Alt+F4 即可运行本脚本。
goto Exiting

:NoAccess
echo,
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo 错误！没有权限运行。可尝试：
echo 1. 使用右键〉以管理员身份运行。


:Exiting
echo,
echo 按任意键退出本程序...
pause >nul
exit