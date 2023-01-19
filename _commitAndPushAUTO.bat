@echo off
rem 명령어 복창 끔

rem ### 버전정보	:	v0116_alpha
rem ### updated by LJS 

rem chcp 65001>nul
rem 참고 https://otrodevym.tistory.com/entry/windows-10-cmd-%EC%9D%B8%EC%BD%94%EB%94%A9-utf-8-%EC%84%A4%EC%A0%95-%EB%B0%A9%EB%B2%95-949-65001-1

setLocal EnableDelayedExpansion
rem 참고 https://kkamagistory.tistory.com/881

rem 0 = 검정색 8 = 회색
rem 1 = 파랑색 9 = 연한 파랑색
rem 2 = 초록색 A = 연한 초록색
rem 3 = 옥색 B = 연한 옥색
rem 4 = 빨강색 C = 연한 빨강색
rem 5 = 자주색 D = 연한 자주색
rem 6 = 노랑색 E = 연한 노랑색
rem 7 = 흰색 F = 밝은 흰색
rem color 09
rem 첫째 자리는 배경, 둘째 자리는 글자색

rem mode con cols=60 lines=30
rem 콘솔창 크기 지정

rem ####################################

cd /d %~dp0
rem 현재 파일 위치 경로를 작업 위치로


title 현재 경로 : %cd%
rem title AutoStaging & AutoCommit
:notice
rem 	230116 v0116_alpha
rem 		- add, restore, commit, push 구현
rem 	autoAddCommitPush
rem 		- 극단적으로 짧게 만든 버전.
rem 		- 모든 변경사항 스테이징, 자동커밋, 자동 푸시한다.

:makeDate
FOR /F "tokens=1-4 delims=- " %%i IN ('date /t') DO SET yyyymmdd=%%i%%j%%k
REM FOR /F "tokens=2-6 delims=/ " %%i IN ('date /t') DO SET yyyymmdd=%%k%%i%%j
rem ECHO %yyyymmdd%

set tm=%time%
set hh=%time:~0,2%
set mm=%time:~3,2%
set ss=%time:~6,2%
set hh1=%time:~0,1%
set hh2=%time:~1,1%
if "%hh1%" == " " set hh=0%hh2%
cls
rem
:start
echo 	[git add .]
echo 	[git commit -m "auto push %yyyymmdd% %hh%%mm%"]
echo 	[git push origin master]
echo 	위 명령어를 한꺼번에 실행하는 프로그램입니다.
echo 	실행하려면 엔터, 취소하려면 이 창을 닫아주세요
pause

git add .
git commit -m "auto push %yyyymmdd% %hh%%mm%"
git push origin master
echo 	----------------------------------------------
echo 	성공 여부와 무관하게, 작업이 완료되었습니다.
echo 	위의 로그를 참고해주세요.
echo 	----------------------------------------------
pause