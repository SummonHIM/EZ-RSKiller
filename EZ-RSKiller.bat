:Head
@echo off
set version=6.1
mode con cols=66 lines=30

for /f "tokens=2 delims=[" %%a in ('ver') do for /f "tokens=2" %%b in ("%%a") do for /f "tokens=1-2 delims=." %%c in ("%%b") do set windowsVersion=%%c
if %windowsVersion% LEQ 5 goto NoAdmin

echo,
echo     /////     �ýű���Ҫʹ�ù���ԱȨ�޲����������С�     /////
echo     /////               ���������ԱȨ�ޣ�               /////
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit >nul
:NoAdmin

title ��֩��ɱ�� V%version%
cls
echo                          ��֩��ɱ�� V%version%
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
echo �״����������ڲ��Һ�֩�����λ�á����Ժ�...
echo,
echo REDLocal.cfg �ļ�������Ҫɾ�������ļ����ڶ�λ��֩�����λ�ã�

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
echo ��������ɨ����̷���
echo �벻Ҫ����:\�����롣
echo ��������ɨ�� C ����ֱ�����룺C
echo,
set /p FTRDisk=�����룺
echo,
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo ���ڲ���λ�� ��%FTRDisk%:\�� �̵ĺ�֩�����λ�á����Ժ�...
echo �����ٶȿ��ܽ����������ĵȴ���
echo,
echo REDLocal.cfg �ļ�������Ҫɾ�������ļ����ڶ�λ��֩�����λ�ã�
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
    echo ��ѯ��·������֩�� 6.0����%%~dpi
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
    echo ��ѯ��·������֩�� 7.0����%%~dpi
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
echo ���ҽ�������֩�������·��Ϊ��
echo %RedAgentPath%
echo,
echo ���ڽ�·�����浽 REDLocal.cfg
echo %RedAgentPath%>"%~dp0REDLocal.cfg"
if not exist "%~dp0REDLocal.cfg" (
    goto NoAccess
) else (
    echo ����ɹ���
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
echo                          ��֩��ɱ�� V%version%
echo                        ez.yxsw1802.com.cn
echo                     Copyright %date:~0,4% SummonHIM.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo ��·��δ�ҵ���֩�������%RedAgentPath%
echo,
echo ���ű�δ���ҵ���֩�������
echo �Ƿ�����������֩������λ�ã�
echo �������ֶ��޸� REDLocal.cfg ·���ļ�����
echo,
echo [1] ����ʹ��ע���ʽ���ң��Ͽ죩
echo [2] ����ʹ��ȫ��ɨ�跽ʽ���ң�������
echo [3] ����ֱ�ӱ༭ REDLocal.cfg ·���ļ�
echo [e] �˳��ű�
echo ��������򰴻س���������
set NotFoundYorN=
set /p NotFoundYorN=[1/2/3/e]:
if "%NotFoundYorN%" == "1" goto RegSearch
if "%NotFoundYorN%" == "2" goto FullDiskSearch
if "%NotFoundYorN%" == "3" goto EditRedLocal
if /i "%NotFoundYorN%" == "e" goto Exiting
echo,
echo ������ "%NotFoundYorN%" ������!
pause
cls
goto RedAgentNotFound

:EditRedLocal
echo,
echo �뽫��֩�������·�����뵽�˴���
echo ����C:\Program Files\3000soft\Red Spider\
echo �������·��������һ���»��ߡ�\�����������
echo,
set /p RedAgentPath=�����룺
echo,
echo ���ڽ�·�����浽 REDLocal.cfg
echo %RedAgentPath%>"%~dp0REDLocal.cfg"
if not exist "%~dp0REDLocal.cfg" (
    goto NoAccess
) else (
    echo ����ɹ���
)
pause
goto Head

:ShutdownRedAgent
color 4E
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo ����ִ��һ���رճ���...
taskkill /f /im REDAgent.exe /t
rename "%RedAgentPath%REDAgent.exe" REDAgent.disabled
if errorlevel 1 goto NoAccess
echo �ѽ� REDAgent.exe ������Ϊ REDAgent.disabled
echo ������ɣ�
set RedAgentStatus=Closed
goto Finish

:StartRedAgent
color 4E
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo ȷ��Ҫ�ָ���֩�������
echo ����رմ˽ű����ɡ�
echo,
echo ���������������...
pause >nul
rename "%RedAgentPath%REDAgent.disabled" REDAgent.exe
if errorlevel 1 goto NoAccess
echo �ѽ� REDAgent.disabled ������Ϊ REDAgent.exe
echo ����ǿ��������֩�����...
start /d "%RedAgentPath%" REDAgent.exe
echo ������ɣ�
set RedAgentStatus=Started
goto Finish

:Finish
color 2F
cls
echo                          ��֩��ɱ�� V%version%
echo                        ez.yxsw1802.com.cn
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
echo ���ű��ױ�����Աɾ����������ֽ�ʼ���������ַ��ez.yxsw1802.com.cn
echo ���ű��ױ�����Աɾ����������ֽ�ʼ���������ַ��ez.yxsw1802.com.cn
echo ���ű��ױ�����Աɾ����������ֽ�ʼ���������ַ��ez.yxsw1802.com.cn
msg * ���ű��ױ�����Աɾ����������ֽ�ʼ���������ַ��ez.yxsw1802.com.cn
goto Exiting

:NoAccess
echo,
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo ����û��Ȩ�����С��ɳ��ԣ�
echo 1. ʹ���Ҽ����Թ���Ա������С�

:Exiting
echo,
echo ��������˳����ű�...
pause >nul
exit