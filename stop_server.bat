@echo off
setlocal

echo Stopping Apache Tomcat...
set "JAVA_HOME=C:\Program Files\Java\jdk-20"
if not exist "%JAVA_HOME%\bin\java.exe" (
    set "JAVA_HOME=C:\Program Files\Java\jdk-25"
)
set "CATALINA_HOME=C:\tomcat"

cd /d "%CATALINA_HOME%\bin"
call shutdown.bat
echo Tomcat shutdown command sent.
