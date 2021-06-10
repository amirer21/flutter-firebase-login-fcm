#버전 : Flutter 2.2.0, Dart 2.13.0

1.아이콘

- 설명 : assets폴더는 프로젝트 루트 하위폴더에 복사
- 경로 : 프로젝트ROOT\assets\icon.png

2. 플러터 라이브러리 추가 및 설치

- 파일명 : pubspce.yaml
- 설명 : 플러터 dependencies, image 경로 추가 후 pub get으로 라이브러리 다운로드


3.HTTP 에러방지 (빌드시 아래 에러가 발생하지 않는다면 무시하셔도 좋습니다.)

1)에러내용 : "Cleartext HTTP traffic not permitted~"
2)설명 : 안드로이드 28API 이상에서 네트워크 보안정책으로 발생되는 에러시 해결
3)파일명 : network_security_config.xml
4)경로 : 프로젝트ROOT\android\app\src\main\res\xml\network_security_config.xml
          (이 경로에 xml폴더를 복사해줍니다.)
5)소스코드 : 

<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <base-config cleartextTrafficPermitted="true">
        <trust-anchors>
            <certificates src="system" />
        </trust-anchors>
    </base-config>
</network-security-config>

1)파일 경로 : 프로젝트ROOT\android\app\src\main\AndroidManifest.xml
2)소스코드 :
 
<uses-permission android:name="android.permission.INTERNET" />
<activity
android:networkSecurityConfig="@xml/network_security_config"
android:usesCleartextTraffic="true">

참고 : https://developer.android.com/training/articles/security-config?hl=ko
참고 : https://mrgamza.tistory.com/639

#추가 

1.공통 
(1) 아이콘 추가
- 파일명 : icon.png
- 경로 : 프로젝트\assets\icon.png

(2) 디바이스 정보 가져오는 라이브러리 직접 수정 수정
- flutter pub get으로 라이브러리 설치를 한 후 
- 첨부파일 'platform_device_id.dart'의 소스코드로 수정

2.안드로이드 설정

(1) http 네트워크 설정 추가
- 파일명 :network_security_config.xml
- 경로 : 프로젝트\android\app\src\main\res\xml 추가

(2) AndroidManifest.xml 수정
- 파일명 : AndroidManifest.xml
- 경로 : 프로젝트\android\app\src\main\AndroidManifest.xml

(3) build.gradle 수정
- build.gradle 부분은 파이어베이스에서 연동할때 나오는 설명화면을 참고 부탁드립니다.

(4) 파이어베이스 fcm 채널 설정
- Android 8.0(API 수준 26) 이상부터는 알림 채널 설정을 권장
- 파일명 : strings.xml 추가
- 경로 : 프로젝트\android\app\src\main\res\values\strings.xml 추가
