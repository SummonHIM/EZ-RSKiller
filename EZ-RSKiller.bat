:Head
@echo off
set version=6.1
mode con cols=66 lines=30

for /f "tokens=2 delims=[" %%a in ('ver') do for /f "tokens=2" %%b in ("%%a") do for /f "tokens=1-2 delims=." %%c in ("%%b") do set windowsVersion=%%c
if %windowsVersion% LEQ 5 goto NoAdmin

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
echo,
echo REDLocal.cfg 文件尽量不要删除，该文件用于定位红蜘蛛具体位置！

for /f "tokens=1,2,*" %%i in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\3000soft\Red Spider" /v "AgentCommand" ^| find /i "AgentCommand"') do set RedAgentPath=%%k
if "%regValue%"=="" for /f "tokens=1,2,*" %%i in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\3000soft\Red Spider" /v "AgentCommand" ^| find /i "AgentCommand"') do set RedAgentPath=%%k
set RedAgentPath=%RedAgentPath:~0,-12%
if not exist "%RedAgentPath%REDAgent.exe" (
    if not exist "%RedAgentPath%REDAgent.disabled" (
        goto RedAgentNotFound
    ) else (
        goto FTRContinue
    )
) else (
    goto FTRContinue
)
pause

:FullDiskSearch
color 4E
echo,
echo 请输入欲扫描的盘符：
echo 请不要将“:\”填入。
echo 例如我想扫描 C 盘则直接输入：C
echo,
set /p FTRDisk=请输入：
echo,
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo 正在查找位于 “%FTRDisk%:\” 盘的红蜘蛛具体位置。请稍候...
echo 查找速度可能较慢，请耐心等待！
echo,
echo REDLocal.cfg 文件尽量不要删除，该文件用于定位红蜘蛛具体位置！
echo,
set FindData=0

:FTRReFind
for /r %FTRDisk%:\ %%i in (NetTalk.exe*)do (
    set RedAgentPath=%%~dpi
    if "%FindData%"== "1" set RedAgentPath1=%%~dpi
    if "%FindData%"== "2" set RedAgentPath2=%%~dpi
    if "%FindData%" == "3" (
        if "%RedAgentPath1%" == "%RedAgentPath2%" (
            goto FTRFind
        )
        set FindData=0
    )
    set /a FindData=%FindData%+1
    echo 查询到路径（红蜘蛛 6.0）：%%~dpi
    if not exist %%~dpiREDAgent.exe (
        if not exist %%~dpiREDAgent.disabled ( 
            goto FTRReFind
        ) else ( 
            goto FTRContinue
        )
    ) else ( 
        goto FTRContinue 
    )
)

:FTRFind
for /r %FTRDisk%:\ %%i in (edpaper.exe*)do (
    set RedAgentPath=%%~dpi
    if "%FindData%"== "1" set RedAgentPath1=%%~dpi
    if "%FindData%"== "2" set RedAgentPath2=%%~dpi
    if "%FindData%" == "3" (
        if "%RedAgentPath1%" == "%RedAgentPath2%" goto RedAgentNotFound
        set FindData=0
    )
    set /a FindData=%FindData%+1
    echo 查询到路径（红蜘蛛 7.0）：%%~dpi
    if not exist %%~dpiREDAgent.exe (
        if not exist %%~dpiREDAgent.disabled (
            goto FTRReFind
        ) else (
            goto FTRContinue
        )
    ) else (
        goto FTRContinue
    )
)

:FTRContinue
echo,
echo 查找结束，红蜘蛛软件的路径为：
echo %RedAgentPath%
echo,
echo 正在将路径保存到 REDLocal.cfg
echo %RedAgentPath%>"%~dp0REDLocal.cfg"
if not exist "%~dp0REDLocal.cfg" (
    goto NoAccess
) else (
    echo 保存成功！
)

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
echo,
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
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo 正在执行一键关闭程序...
taskkill /f /im REDAgent.exe /t
rename "%RedAgentPath%REDAgent.exe" REDAgent.disabled
if errorlevel 1 goto NoAccess
echo 已将 REDAgent.exe 重命名为 REDAgent.disabled
echo 正在完成！
set RedAgentStatus=Closed
goto Finish

:StartRedAgent
color 4E
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo 确定要恢复红蜘蛛软件吗？
echo 否则关闭此脚本即可。
echo,
echo 按任意键继续操作...
pause >nul
rename "%RedAgentPath%REDAgent.disabled" REDAgent.exe
if errorlevel 1 goto NoAccess
echo 已将 REDAgent.disabled 重命名为 REDAgent.exe
echo 正在强制启动红蜘蛛软件...
start /d "%RedAgentPath%" REDAgent.exe
echo 正在完成！
set RedAgentStatus=Started
goto Finish

:Finish
color 2F
cls
echo                          红蜘蛛杀手 V%version%
echo                        ez.yxsw1802.com.cn
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