@echo off
setlocal

echo ========================================================
echo Starting CityCare on Apache Tomcat 9
echo ========================================================

set "JAVA_HOME=C:\Program Files\Java\jdk-20"
if not exist "%JAVA_HOME%\bin\java.exe" (
    set "JAVA_HOME=C:\Program Files\Java\jdk-25"
)
set "CATALINA_HOME=C:\tomcat"

echo Using JAVA_HOME: %JAVA_HOME%
echo Using CATALINA_HOME: %CATALINA_HOME%
echo Opening application at: http://localhost:8080/CityCare/
echo.

cd /d "%CATALINA_HOME%\bin"
call startup.bat

echo Tomcat startup initiated in background.
echo Visit http://localhost:8080/CityCare/ in your browser.
