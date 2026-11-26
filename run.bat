@echo off
chcp 65001 > nul
echo ==================================================================
echo   KHOI DONG HE THONG SPRING BOOT - BAI TAP 05
echo   Sinh vien: Vo Cong Danh - MSSV: 24110010
echo ==================================================================
echo.

set JAVA_HOME=C:\Program Files\Java\jdk-27.0.1.0.3
if not exist "%JAVA_HOME%" set JAVA_HOME=C:\Program Files\Java\latest
set PATH=%JAVA_HOME%\bin;%PATH%

if exist "target\24110010_LTW_springtool-1.0.0.war" (
    echo [1/2] Tim thay ban build target\24110010_LTW_springtool-1.0.0.war
    echo [2/2] Dang chay Spring Boot tren cong 8080...
    start http://localhost:8080/
    java -jar target\24110010_LTW_springtool-1.0.0.war
) else (
    echo Dang bien dich va chay du an bang Maven...
    start http://localhost:8080/
    "C:\Users\Vo Cong Danh\apache-maven-3.9.9\bin\mvn.cmd" spring-boot:run
)

pause
