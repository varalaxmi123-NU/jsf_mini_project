@echo off
setlocal enabledelayedexpansion

echo ========================================================
echo CityCare - Build and Deploy to Apache Tomcat 9
echo ========================================================

set "JAVA_HOME=C:\Program Files\Java\jdk-20"
if not exist "%JAVA_HOME%\bin\javac.exe" (
    set "JAVA_HOME=C:\Program Files\Java\jdk-25"
)

set "CATALINA_HOME=C:\tomcat"
set "APP_DIR=%~dp0"
set "WEBAPP_SRC=%APP_DIR%src\main\webapp"
set "CLASSES_DIR=%WEBAPP_SRC%\WEB-INF\classes"
set "LIB_DIR=%WEBAPP_SRC%\WEB-INF\lib"
set "TOMCAT_APP=%CATALINA_HOME%\webapps\CityCare"

echo [1/4] Checking Java and Tomcat paths...
echo Java Home: %JAVA_HOME%
echo Tomcat Home: %CATALINA_HOME%

if not exist "%CLASSES_DIR%" mkdir "%CLASSES_DIR%"
if not exist "%TOMCAT_APP%" mkdir "%TOMCAT_APP%"

echo [2/4] Compiling Java source files...
dir /s /b "%APP_DIR%src\main\java\*.java" > "%APP_DIR%sources.txt"

"%JAVA_HOME%\bin\javac.exe" --release 8 -cp "%CATALINA_HOME%\lib\servlet-api.jar;%CATALINA_HOME%\lib\jsp-api.jar;%LIB_DIR%\mysql-connector-java-8.0.26.jar;%CLASSES_DIR%" -d "%CLASSES_DIR%" @"%APP_DIR%sources.txt"

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Compilation failed! Please inspect error messages above.
    del "%APP_DIR%sources.txt"
    exit /b %ERRORLEVEL%
)
del "%APP_DIR%sources.txt"
echo [SUCCESS] Java Servlets, DAOs, and Models compiled successfully!

echo [3/4] Copying web assets to Tomcat webapps\CityCare...
xcopy /E /Y /I "%WEBAPP_SRC%\*" "%TOMCAT_APP%\" > nul

echo [4/4] Ensuring MySQL driver is in Tomcat lib...
if exist "%LIB_DIR%\mysql-connector-java-8.0.26.jar" (
    copy /Y "%LIB_DIR%\mysql-connector-java-8.0.26.jar" "%CATALINA_HOME%\lib\" > nul
)

echo ========================================================
echo Deployment Complete!
echo You can run 'start_server.bat' to launch Apache Tomcat.
echo URL: http://localhost:8080/CityCare/
echo ========================================================
