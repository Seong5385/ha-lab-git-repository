# scripts/before_install.sh — 기존 파일 정리
#!/bin/bash
rm -rf /var/www/html/*
# scripts/after_install.sh — 권한 설정
#!/bin/bash
chown -R www-data:www-data /var/www/html
chmod -R 644 /var/www/html
# scripts/start_server.sh — Nginx 재로드
#!/bin/bash
nginx -t && systemctl reload nginx
# scripts/validate_service.sh — 배포 검증
#!/bin/bash
sleep 3
STATUS=$(curl -s -o /dev/null -w '%{http_code}' http://localhost/health)
if [ "$STATUS" = "200" ]; then
 echo "✅ 검증 성공: HTTP $STATUS"
 exit 0
else
 echo "❌ 검증 실패: HTTP $STATUS"
 exit 1
fi
# 실행 권한 부여 (로컬에서 실행)
chmod +x scripts/*.sh
git add scripts/ appspec.yml
git commit -m 'add: CodeDeploy 배포 스크립트 추가'
git push origin mai
