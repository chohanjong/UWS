# UWS Project Backup Script
# 사용법: .\backup.ps1 [설명]

# 현재 날짜와 시간을 포맷팅하여 백업 폴더 이름에 사용
$timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'

# 명령줄 인수로 설명을 받음
$description = $args[0]
if (-not $description) {
    $description = "backup"
}

# 특수문자 제거 및 공백을 밑줄로 변환
$safeDescription = $description -replace '[^\w\s]', '' -replace '\s+', '_'

# 백업 폴더 이름 생성
$backupDir = "UWS_Backup_${timestamp}_${safeDescription}"

# 백업 생성
Write-Host "UWS 프로젝트 백업 중... 설명: $description"
Write-Host "백업 폴더: $backupDir"

# 상위 디렉토리로 이동 후 robocopy 실행
Set-Location ..
robocopy UWS $backupDir /E /XD "node_modules" ".git" /NFL /NDL

Write-Host "백업 완료!"
Write-Host "백업 위치: D:\$backupDir"

# 백업 목록 기록 파일 업데이트
$backupInfo = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $backupDir - $description"
Add-Content -Path "UWS_backups.log" -Value $backupInfo

# 백업 목록 표시
Write-Host "`n최근 백업 목록:"
if (Test-Path "UWS_backups.log") {
    Get-Content "UWS_backups.log" -Tail 5
} 