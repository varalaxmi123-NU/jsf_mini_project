@echo off
setlocal

echo ========================================================
echo CityCare - MySQL Database Setup & Reset
echo ========================================================

set "MYSQL_BIN=C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe"

if not exist "%MYSQL_BIN%" (
    echo [ERROR] MySQL not found at %MYSQL_BIN%
    pause
    exit /b 1
)

echo Importing database schema from sql\schema.sql...
"%MYSQL_BIN%" -u root -proot123 --default-character-set=utf8 < "%~dp0sql\schema.sql"

if %ERRORLEVEL% EQU 0 (
    echo [SUCCESS] citycare_db created and initialized with seed data!
) else (
    echo [ERROR] Failed to run schema.sql. Please verify MySQL service is running.
)
pause
