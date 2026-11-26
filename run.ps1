# ==================================================================
# KHỞI ĐỘNG HỆ THỐNG SPRING BOOT - BÀI TẬP 05
# Sinh viên: Võ Công Danh - MSSV: 24110010
# ==================================================================

$env:JAVA_HOME = "C:\Program Files\Java\jdk-27.0.1.0.3"
if (-not (Test-Path $env:JAVA_HOME)) { $env:JAVA_HOME = "C:\Program Files\Java\latest" }
$env:PATH = "$env:JAVA_HOME\bin;$env:PATH"

$warFile = "target\24110010_LTW_springtool-1.0.0.war"

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ">>> KHỞI ĐỘNG HỆ THỐNG SPRING BOOT BÀI TẬP 05 <<<" -ForegroundColor Green
Write-Host "Sinh viên: Võ Công Danh - MSSV: 24110010" -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan

Start-Process "http://localhost:8080/"

if (Test-Path $warFile) {
    Write-Host "[OK] Chạy trực tiếp file WAR: $warFile" -ForegroundColor Green
    & java -jar $warFile
} else {
    Write-Host "[OK] Chạy bằng Maven spring-boot:run..." -ForegroundColor Green
    & "C:\Users\Vo Cong Danh\apache-maven-3.9.9\bin\mvn.cmd" spring-boot:run
}
