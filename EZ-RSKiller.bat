:Head
title 启动中...
@echo off
mode con cols=66 lines=30
setlocal enabledelayedexpansion
set version=6.3

for /f "tokens=2 delims=[" %%a in ('ver') do for /f "tokens=2" %%b in ("%%a") do for /f "tokens=1-2 delims=." %%c in ("%%b") do set windowsVersion=%%c
if %windowsVersion% LEQ 5 goto NoAdmin

title 获取管理员权限...
echo,
echo     /////     该脚本需要使用管理员权限才能正常运行。     /////
echo     /////               请允许管理员权限！               /////
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit >nul
:NoAdmin

title 红蜘蛛杀手 V%version%
cls
echo                          红蜘蛛杀手 V%version%
echo                        ez.yxsw1802.com.cn
echo                     Copyright %date:~0,4% SummonHIM.
if exist "%~dp0REDLocal.cfg" (
    goto CheckRedAgentStatus
) else (
    goto RegSearch
)

:RegSearch
color 4E
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo 首次启动，正在查找红蜘蛛具体位置。请稍候...
echo REDLocal.cfg 文件尽量不要删除，该文件用于定位红蜘蛛具体位置！
echo,
echo 尝试查找注册表路径“HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\3000soft\Red Spider\AgentCommand”中的红蜘蛛路径...
for /f "tokens=1,2,*" %%i in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\3000soft\Red Spider" /v "AgentCommand" ^| find /i "AgentCommand"') do set RedAgentPath=%%~dpk
echo 尝试查找注册表路径“HKEY_LOCAL_MACHINE\SOFTWARE\3000soft\Red Spider\AgentCommand”中的红蜘蛛路径...
for /f "tokens=1,2,*" %%i in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\3000soft\Red Spider" /v "AgentCommand" ^| find /i "AgentCommand"') do set RedAgentPath=%%~dpk
echo 注册表查询到路径“%RedAgentPath%”。正在检查是否可用...
if not exist "%RedAgentPath%REDAgent.exe" (
    if not exist "%RedAgentPath%REDAgent.disabled" goto RedAgentNotFound
)
echo 该路径有效。
echo %RedAgentPath%>"%~dp0REDLocal.cfg"
if not exist "%~dp0REDLocal.cfg" goto NoAccess
goto CheckRedAgentStatus

:FullDiskSearch
color 4E
echo,
echo 请输入欲扫描的盘符。
echo 注：请不要将“:\”填入。若想扫描 C 盘则直接输入：C
echo,
set /p FTRDisk=请输入欲扫描的盘符：
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo 正在查找位于“%FTRDisk%:\”盘的红蜘蛛具体位置。请稍候...
echo 查找速度可能较慢，请耐心等待！
echo,
echo REDLocal.cfg 文件尽量不要删除，该文件用于定位红蜘蛛具体位置！
echo,
set FDSPass=0

:FullDiskSearching
for /r %FTRDisk%:\ %%i in (REDAgent*)do (
    echo 正在检查 “%%~dpi” 文件夹...
    if exist "%%~dpiREDAgent.exe" (
        if exist "%%~dpiAdapter.exe" (
            set /a FDSPass+=1
        )
        if exist "%%~dpiedpaper.exe" (
            set /a FDSPass+=1
        )
        if exist "%%~dpirepview.exe" (
            set /a FDSPass+=1
        )
    )
    if exist "%%~dpiREDAgent.disabled" (
        if exist "%%~dpiAdapter.exe" (
            set /a FDSPass+=1
        )
        if exist "%%~dpiedpaper.exe" (
            set /a FDSPass+=1
        )
        if exist "%%~dpirepview.exe" (
            set /a FDSPass+=1
        )
    )
    if !FDSPass! GEQ 3 (
        echo 查找完成！红蜘蛛软件运行路径为：%%~dpi
        echo,
        echo 正在将路径保存到 REDLocal.cfg
        echo %%~dpi>"%~dp0REDLocal.cfg"
        if not exist "%~dp0REDLocal.cfg" (
            goto NoAccess
        ) else (
            echo 保存成功！
        )
        goto CheckRedAgentStatus
    )
)
goto RedAgentNotFound

:CheckRedAgentStatus
set /P RedAgentPath=<"%~dp0REDLocal.cfg"
if exist "%RedAgentPath%REDAgent.exe" goto ShutdownRedAgent
if exist "%RedAgentPath%REDAgent.disabled" (
    goto StartRedAgent
) else (
    goto RedAgentNotFound
)

:RedAgentNotFound
cls
color 4E
echo                          红蜘蛛杀手 V%version%
echo                        ez.yxsw1802.com.cn
echo                     Copyright %date:~0,4% SummonHIM.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo 该路径未找到红蜘蛛软件：%RedAgentPath%
echo,
echo 本脚本未查找到红蜘蛛软件！
echo 是否重新搜索红蜘蛛所在位置？
echo （可以手动修改 REDLocal.cfg 路径文件。）
echo,
echo [1] 尝试使用注册表方式查找（较快）
echo [2] 尝试使用全盘扫描方式查找（较慢）
echo [3] 尝试直接编辑 REDLocal.cfg 路径文件
echo [e] 退出脚本
echo 输入完毕则按回车键继续。
set NotFoundYorN=
set /p NotFoundYorN=[1/2/3/e]:
if "%NotFoundYorN%" == "1" goto RegSearch
if "%NotFoundYorN%" == "2" goto FullDiskSearch
if "%NotFoundYorN%" == "3" goto EditRedLocal
if /i "%NotFoundYorN%" == "e" goto Exiting
echo,
echo 该命令 "%NotFoundYorN%" 不存在!
pause
cls
goto RedAgentNotFound

:EditRedLocal
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo 请将红蜘蛛软件的路径输入到此处。
echo 例：C:\Program Files\3000soft\Red Spider\
echo 请务必在路径最后面加一个下划线“\”，避免错误！
echo,
set /p RedAgentPath=请输入：
echo,
echo 正在将路径保存到 REDLocal.cfg
echo %RedAgentPath%>"%~dp0REDLocal.cfg"
if not exist "%~dp0REDLocal.cfg" (
    goto NoAccess
) else (
    echo 保存成功！
)
pause
goto Head

:ShutdownRedAgent
color 4E
cls
echo                          红蜘蛛杀手 V%version%
echo                        ez.yxsw1802.com.cn
echo                     Copyright %date:~0,4% SummonHIM.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo 正在执行一键关闭程序...
taskkill /f /im REDAgent.exe /t
rename "%RedAgentPath%REDAgent.exe" REDAgent.disabled
if errorlevel 1 goto NoAccess
echo 已将 REDAgent.exe 重命名为 REDAgent.disabled
set RedAgentStatus=Closed
goto Finish

:StartRedAgent
color 4E
cls
echo                          红蜘蛛杀手 V%version%
echo                        ez.yxsw1802.com.cn
echo                     Copyright %date:~0,4% SummonHIM.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo 确定要恢复红蜘蛛软件吗？
echo 否则关闭此脚本即可。
echo,
echo 按任意键继续操作...
pause >nul
echo,
rename "%RedAgentPath%REDAgent.disabled" REDAgent.exe
if errorlevel 1 goto NoAccess
echo 已将 REDAgent.disabled 重命名为 REDAgent.exe
echo 正在强制启动红蜘蛛软件...
start /d "%RedAgentPath%" REDAgent.exe
set RedAgentStatus=Started
goto Finish

:Finish
color 2F
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
echo 本脚本易被管理员删除，建议用纸笔记下永久网址：ez.yxsw1802.com.cn
echo 本脚本易被管理员删除，建议用纸笔记下永久网址：ez.yxsw1802.com.cn
echo 本脚本易被管理员删除，建议用纸笔记下永久网址：ez.yxsw1802.com.cn
msg * 本脚本易被管理员删除，建议用纸笔记下永久网址：ez.yxsw1802.com.cn
goto Exiting

:NoAccess
echo,
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo 错误！没有权限运行。可尝试：
echo 1. 使用右键〉以管理员身份运行。

:Exiting
echo,
echo 按任意键退出本脚本...
pause >nul
exit