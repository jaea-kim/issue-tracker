#!/bin/bash

REPOSITORY=/home/ubuntu/app/BE
PROJECT_NAME=issue-tracker # 빌드하면 나오는 명칭으로 설정(권장) [ex: build.gradle(issue-tracker)]

echo "> Build 파일복사"
cp $REPOSITORY/zip/*.jar $REPOSITORY/

echo "> 현재 구동 중인 애플리케이션 pid 확인"
CURRENT_PID=$(pgrep -f ${PROJECT_NAME}.*.jar)
if [ -z "$CURRENT_PID" ]; then
  echo "> 현재 구동 중인 애플리케이션이 없으므로 종료하지 않습니다."
else
  echo "> 현재 구동 중인 애플리케이션 종료 PID: $CURRENT_PID"
  kill -15 $CURRENT_PID
  sleep 5
fi

echo "> 새 애플리케이션 배포"
JAR_NAME=$(ls -tr $REPOSITORY/*.jar | tail -n 1)

echo "> JAR NAME: $JAR_NAME"
echo "> $JAR_NAME 에 실행권한 추가"
chmod +x $JAR_NAME

echo  "> $JAR_NAME 실행"
# nohup 실행시 CodeDeploy는 무한대기
# 해결하기 위해 nohup.out 파일을 별도로 사용
nohup java -jar $JAR_NAME > $REPOSITORY/nohup.out 2>&1 &
