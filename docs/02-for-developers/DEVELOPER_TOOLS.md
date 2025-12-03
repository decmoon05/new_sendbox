# SendBox 개발자 도구 추천 가이드

> Flutter 개발 효율을 높여주는 도구 및 서비스 추천

## 📋 목차

1. [개발 환경 도구](#1-개발-환경-도구)
2. [디자인 및 UI 도구](#2-디자인-및-ui-도구)
3. [API 개발 및 테스트](#3-api-개발-및-테스트)
4. [코드 생성 및 자동화](#4-코드-생성-및-자동화)
5. [배포 및 CI/CD](#5-배포-및-cicd)
6. [모니터링 및 분석](#6-모니터링-및-분석)
7. [데이터베이스 관리](#7-데이터베이스-관리)
8. [협업 및 프로젝트 관리](#8-협업-및-프로젝트-관리)

---

## 1. 개발 환경 도구

### 1.1 IDE 및 에디터

#### Visual Studio Code (무료) ⭐⭐⭐⭐⭐
**추천도**: 최고
- **장점**: 
  - Flutter 확장 프로그램 강력
  - 가볍고 빠름
  - 무료
  - 많은 확장 프로그램
- **단점**: 
  - 초기 설정 필요
- **가격**: 무료
- **링크**: https://code.visualstudio.com/
- **추천 확장**:
  - Flutter
  - Dart
  - GitLens
  - Error Lens
  - Bracket Pair Colorizer

#### Android Studio (무료) ⭐⭐⭐⭐
**추천도**: 높음
- **장점**: 
  - Google 공식 지원
  - Android 에뮬레이터 내장
  - 디버깅 도구 강력
  - UI 편집기
- **단점**: 
  - 무거움 (메모리 많이 사용)
  - 느린 시작
- **가격**: 무료
- **링크**: https://developer.android.com/studio

#### IntelliJ IDEA (유료, 무료 커뮤니티 버전) ⭐⭐⭐⭐
**추천도**: 높음
- **장점**: 
  - 강력한 리팩토링
  - 뛰어난 자동완성
  - 많은 플러그인
- **단점**: 
  - 유료 (Ultimate)
- **가격**: 
  - Community: 무료
  - Ultimate: $149/년
- **링크**: https://www.jetbrains.com/idea/

---

### 1.2 개발 보조 도구

#### FVM - Flutter Version Management (무료) ⭐⭐⭐⭐⭐
**추천도**: 필수 추천
- **기능**: 여러 Flutter 버전 관리
- **장점**: 
  - 프로젝트별 Flutter 버전 고정
  - 버전 전환 쉬움
  - 팀원 간 버전 동기화
- **설치**: 
  ```bash
  dart pub global activate fvm
  ```
- **링크**: https://fvm.app/
- **사용법**:
  ```bash
  fvm install 3.24.0
  fvm use 3.24.0
  ```

#### Figma (무료/유료) ⭐⭐⭐⭐⭐
**추천도**: 필수 추천
- **기능**: 디자인 및 프로토타이핑
- **장점**: 
  - UI 디자인
  - 프로토타입 제작
  - Flutter 코드 생성 플러그인 있음
- **가격**: 
  - 무료 (제한적)
  - Professional: $12/월
- **링크**: https://www.figma.com/
- **Flutter 플러그인**: Figma to Flutter

---

## 2. 디자인 및 UI 도구

### 2.1 UI 디자인

#### Figma (무료/유료) ⭐⭐⭐⭐⭐
**이미 위에서 설명**

#### Adobe XD (무료/유료) ⭐⭐⭐⭐
**추천도**: 높음
- **기능**: UI/UX 디자인
- **장점**: 
  - 인터랙션 프로토타입
  - Adobe 생태계 연동
- **가격**: 
  - 무료 (제한적)
  - $9.99/월
- **링크**: https://www.adobe.com/products/xd.html

#### Canva (무료/유료) ⭐⭐⭐
**추천도**: 보통
- **기능**: 간단한 그래픽 디자인
- **장점**: 
  - 사용 쉬움
  - 템플릿 많음
- **단점**: 
  - 고급 기능 제한
- **가격**: 
  - 무료
  - Pro: $12.99/월
- **링크**: https://www.canva.com/

---

### 2.2 아이콘 및 에셋

#### Flaticon (무료/유료) ⭐⭐⭐⭐⭐
**추천도**: 매우 높음
- **기능**: 아이콘 다운로드
- **장점**: 
  - 수백만 개의 아이콘
  - 커스터마이징 가능
- **가격**: 
  - 무료 (크레딧 필요)
  - Premium: $9.99/월
- **링크**: https://www.flaticon.com/

#### Icons8 (무료/유료) ⭐⭐⭐⭐⭐
**추천도**: 매우 높음
- **기능**: 아이콘, 일러스트, 사진
- **장점**: 
  - 다양한 스타일
  - Flutter용 다운로드 지원
- **가격**: 
  - 무료 (제한적)
  - $9.99/월
- **링크**: https://icons8.com/

#### Unsplash (무료) ⭐⭐⭐⭐⭐
**추천도**: 매우 높음
- **기능**: 고품질 무료 사진
- **장점**: 
  - 완전 무료
  - 고품질 이미지
- **가격**: 무료
- **링크**: https://unsplash.com/

---

### 2.3 Flutter UI 빌더

#### FlutterFlow (유료) ⭐⭐⭐⭐
**추천도**: 높음
- **기능**: 드래그 앤 드롭으로 Flutter 앱 제작
- **장점**: 
  - 코드 없이 UI 제작
  - 백엔드 연동 쉬움
  - Firebase 통합
- **단점**: 
  - 유료
  - 커스터마이징 제한
- **가격**: 
  - 무료 체험
  - $30/월
- **링크**: https://www.flutterflow.io/

#### Supernova (유료) ⭐⭐⭐
**추천도**: 보통
- **기능**: 디자인 시스템을 Flutter 코드로 변환
- **장점**: 
  - 디자인 → 코드 자동화
  - 디자인 시스템 관리
- **단점**: 
  - 높은 가격
- **가격**: $99/월
- **링크**: https://www.supernova.io/

---

## 3. API 개발 및 테스트

### 3.1 API 테스트 도구

#### Postman (무료/유료) ⭐⭐⭐⭐⭐
**추천도**: 필수 추천
- **기능**: API 테스트 및 개발
- **장점**: 
  - 직관적인 UI
  - 환경 변수 관리
  - 자동화 테스트
  - 팀 협업
- **가격**: 
  - 무료
  - Pro: $12/월
- **링크**: https://www.postman.com/
- **대안**: Insomnia (무료)

#### Insomnia (무료/유료) ⭐⭐⭐⭐
**추천도**: 높음
- **기능**: API 테스트
- **장점**: 
  - 가볍고 빠름
  - 사용 쉬움
- **가격**: 
  - 무료
  - Plus: $5/월
- **링크**: https://insomnia.rest/

#### Thunder Client (무료) ⭐⭐⭐⭐
**추천도**: 높음 (VS Code 확장)
- **기능**: VS Code 내 API 테스트
- **장점**: 
  - IDE 내에서 바로 테스트
  - 가벼움
- **가격**: 무료
- **VS Code 확장**: Thunder Client

---

### 3.2 API 모킹

#### Mockoon (무료) ⭐⭐⭐⭐⭐
**추천도**: 매우 높음
- **기능**: API 모킹 서버
- **장점**: 
  - 완전 무료
  - 로컬 실행
  - 다양한 응답 설정
- **가격**: 무료
- **링크**: https://mockoon.com/

#### JSONPlaceholder (무료) ⭐⭐⭐⭐
**추천도**: 높음
- **기능**: 간단한 REST API 모킹
- **장점**: 
  - 즉시 사용 가능
  - 온라인 서비스
- **단점**: 
  - 커스터마이징 제한
- **가격**: 무료
- **링크**: https://jsonplaceholder.typicode.com/

#### Prism (유료) ⭐⭐⭐
**추천도**: 보통
- **기능**: OpenAPI 기반 모킹
- **가격**: $49/월
- **링크**: https://stoplight.io/open-source/prism

---

### 3.3 GraphQL 도구

#### GraphQL Playground (무료) ⭐⭐⭐⭐⭐
**추천도**: 매우 높음
- **기능**: GraphQL API 테스트
- **가격**: 무료
- **링크**: https://github.com/graphql/graphql-playground

#### Apollo Studio (무료/유료) ⭐⭐⭐⭐
**추천도**: 높음
- **기능**: GraphQL 개발 도구
- **가격**: 
  - 무료
  - Team: $29/월
- **링크**: https://www.apollographql.com/docs/studio/

---

## 4. 코드 생성 및 자동화

### 4.1 코드 생성기

#### json_serializable (무료) ⭐⭐⭐⭐⭐
**추천도**: 필수 추천
- **기능**: JSON 직렬화 코드 자동 생성
- **장점**: 
  - 수동 코드 작성 불필요
  - 타입 안전성
- **설치**: 
  ```yaml
  dependencies:
    json_annotation: ^4.8.1
  dev_dependencies:
    json_serializable: ^6.7.1
    build_runner: ^2.4.0
  ```
- **링크**: https://pub.dev/packages/json_serializable

#### freezed (무료) ⭐⭐⭐⭐⭐
**추천도**: 매우 높음
- **기능**: 불변(immutable) 클래스 생성
- **장점**: 
  - 불변성 보장
  - copyWith, toString 자동 생성
- **설치**: 
  ```yaml
  dev_dependencies:
    freezed_annotation: ^2.4.1
    freezed: ^2.4.6
    build_runner: ^2.4.0
  ```
- **링크**: https://pub.dev/packages/freezed

#### go_router_builder (무료) ⭐⭐⭐⭐
**추천도**: 높음
- **기능**: 라우팅 코드 자동 생성
- **링크**: https://pub.dev/packages/go_router_builder

---

### 4.2 코드 품질

#### Dart Code Metrics (무료) ⭐⭐⭐⭐
**추천도**: 높음
- **기능**: 코드 품질 분석
- **장점**: 
  - 코드 복잡도 측정
  - 메트릭 제공
- **링크**: https://pub.dev/packages/dart_code_metrics

#### Very Good CLI (무료) ⭐⭐⭐⭐⭐
**추천도**: 매우 높음
- **기능**: Flutter 프로젝트 템플릿 생성
- **장점**: 
  - Best practice 프로젝트 구조
  - 테스트 설정 포함
- **설치**: 
  ```bash
  dart pub global activate very_good_cli
  ```
- **링크**: https://verygood.ventures/blog/very-good-cli

---

## 5. 배포 및 CI/CD

### 5.1 배포 플랫폼

#### Firebase Hosting (무료/유료) ⭐⭐⭐⭐⭐
**추천도**: 매우 높음 (Flutter Web)
- **기능**: 웹 앱 배포
- **장점**: 
  - Firebase 통합
  - 빠른 CDN
  - SSL 자동
- **가격**: 
  - 무료 (제한적)
  - Blaze: 사용량 기반
- **링크**: https://firebase.google.com/docs/hosting

#### Vercel (무료/유료) ⭐⭐⭐⭐⭐
**추천도**: 매우 높음
- **기능**: 프론트엔드 배포
- **장점**: 
  - 초간단 배포
  - 자동 CI/CD
  - Edge Functions
- **가격**: 
  - 무료 (개인)
  - Pro: $20/월
- **링크**: https://vercel.com/
- **특징**: GitHub 연동 시 자동 배포

#### Netlify (무료/유료) ⭐⭐⭐⭐⭐
**추천도**: 매우 높음
- **기능**: 웹사이트/앱 배포
- **장점**: 
  - Vercel과 유사
  - 폼 처리 기능
- **가격**: 
  - 무료
  - Pro: $19/월
- **링크**: https://www.netlify.com/

#### GitHub Pages (무료) ⭐⭐⭐⭐
**추천도**: 높음
- **기능**: 정적 사이트 호스팅
- **장점**: 
  - 완전 무료
  - GitHub 통합
- **단점**: 
  - 정적 사이트만
- **가격**: 무료
- **링크**: https://pages.github.com/

---

### 5.2 CI/CD

#### GitHub Actions (무료/유료) ⭐⭐⭐⭐⭐
**추천도**: 필수 추천
- **기능**: 자동화된 워크플로우
- **장점**: 
  - GitHub 통합
  - 무료 플랜 관대함
  - 커뮤니티 액션 많음
- **가격**: 
  - 무료 (퍼블릭 리포지토리)
  - $4/월 (프라이빗, 제한적)
- **링크**: https://github.com/features/actions
- **Flutter 액션 예시**:
  ```yaml
  - uses: subosito/flutter-action@v2
    with:
      flutter-version: '3.24.0'
  ```

#### Codemagic (무료/유료) ⭐⭐⭐⭐⭐
**추천도**: 매우 높음 (Flutter 특화)
- **기능**: Flutter 앱 빌드 및 배포
- **장점**: 
  - Flutter 최적화
  - 자동 테스트
  - 앱스토어 배포 자동화
- **가격**: 
  - 무료 (제한적)
  - $95/월
- **링크**: https://codemagic.io/

#### Bitrise (무료/유료) ⭐⭐⭐⭐
**추천도**: 높음
- **기능**: 모바일 CI/CD
- **장점**: 
  - 모바일 앱 특화
  - 많은 통합
- **가격**: 
  - 무료 (제한적)
  - $36/월
- **링크**: https://www.bitrise.io/

#### AppCircle (무료/유료) ⭐⭐⭐⭐
**추천도**: 높음
- **기능**: 모바일 CI/CD
- **장점**: 
  - 무료 플랜 좋음
  - 빠른 빌드
- **가격**: 
  - 무료
  - $29/월
- **링크**: https://appcircle.io/

---

### 5.3 앱 배포

#### Fastlane (무료) ⭐⭐⭐⭐⭐
**추천도**: 필수 추천
- **기능**: 앱스토어 배포 자동화
- **장점**: 
  - 스크린샷 자동 생성
  - 메타데이터 관리
  - 배포 자동화
- **가격**: 무료
- **링크**: https://fastlane.tools/

#### App Store Connect API (무료) ⭐⭐⭐⭐
**추천도**: 높음
- **기능**: Apple 앱스토어 관리
- **가격**: 무료 (Apple Developer 계정 필요)

---

## 6. 모니터링 및 분석

### 6.1 크래시 리포팅

#### Firebase Crashlytics (무료) ⭐⭐⭐⭐⭐
**추천도**: 필수 추천
- **기능**: 크래시 리포트
- **장점**: 
  - Firebase 통합
  - 실시간 알림
  - 스택 트레이스 분석
- **가격**: 무료
- **링크**: https://firebase.google.com/docs/crashlytics

#### Sentry (무료/유료) ⭐⭐⭐⭐⭐
**추천도**: 매우 높음
- **기능**: 에러 추적 및 성능 모니터링
- **장점**: 
  - 상세한 에러 정보
  - 성능 모니터링
  - 릴리스 추적
- **가격**: 
  - 무료 (제한적)
  - Team: $26/월
- **링크**: https://sentry.io/

#### Bugsnag (유료) ⭐⭐⭐⭐
**추천도**: 높음
- **기능**: 크래시 리포팅
- **가격**: $99/월
- **링크**: https://www.bugsnag.com/

---

### 6.2 애널리틱스

#### Firebase Analytics (무료) ⭐⭐⭐⭐⭐
**추천도**: 필수 추천
- **기능**: 사용자 행동 분석
- **장점**: 
  - Firebase 통합
  - 실시간 데이터
  - 이벤트 추적
- **가격**: 무료
- **링크**: https://firebase.google.com/docs/analytics

#### Mixpanel (무료/유료) ⭐⭐⭐⭐
**추천도**: 높음
- **기능**: 사용자 분석
- **장점**: 
  - 강력한 분석 도구
  - 사용자 세그먼트
- **가격**: 
  - 무료 (제한적)
  - $25/월
- **링크**: https://mixpanel.com/

#### Amplitude (무료/유료) ⭐⭐⭐⭐⭐
**추천도**: 매우 높음
- **기능**: 제품 분석
- **장점**: 
  - 무료 플랜 관대함
  - 강력한 분석
- **가격**: 
  - 무료 (1천만 이벤트/월)
  - Growth: $995/월
- **링크**: https://amplitude.com/

---

### 6.3 성능 모니터링

#### Firebase Performance Monitoring (무료) ⭐⭐⭐⭐⭐
**추천도**: 매우 높음
- **기능**: 앱 성능 모니터링
- **가격**: 무료
- **링크**: https://firebase.google.com/docs/perf-mon

#### New Relic (유료) ⭐⭐⭐⭐
**추천도**: 높음
- **기능**: APM (Application Performance Monitoring)
- **가격**: $99/월
- **링크**: https://newrelic.com/

---

## 7. 데이터베이스 관리

### 7.1 Firebase 관리

#### Firebase Console (무료) ⭐⭐⭐⭐⭐
**추천도**: 필수
- **기능**: Firebase 서비스 관리
- **링크**: https://console.firebase.google.com/

#### Firebase Emulator Suite (무료) ⭐⭐⭐⭐⭐
**추천도**: 필수 추천
- **기능**: 로컬 Firebase 서비스
- **장점**: 
  - 오프라인 개발
  - 테스트 용이
- **설치**: 
  ```bash
  firebase init emulators
  ```

---

### 7.2 데이터베이스 GUI

#### Firebase Admin SDK (무료) ⭐⭐⭐⭐
**추천도**: 높음
- **기능**: 프로그래밍 방식 관리

#### TablePlus (유료) ⭐⭐⭐⭐⭐
**추천도**: 매우 높음
- **기능**: 데이터베이스 GUI
- **장점**: 
  - 여러 DB 지원
  - 아름다운 UI
- **가격**: 
  - 무료 (제한적)
  - $89 (일회성)
- **링크**: https://tableplus.com/

#### DBeaver (무료) ⭐⭐⭐⭐
**추천도**: 높음
- **기능**: 범용 데이터베이스 도구
- **장점**: 
  - 완전 무료
  - 많은 DB 지원
- **가격**: 무료
- **링크**: https://dbeaver.io/

---

## 8. 협업 및 프로젝트 관리

### 8.1 버전 관리

#### GitHub (무료/유료) ⭐⭐⭐⭐⭐
**추천도**: 필수 추천
- **기능**: Git 호스팅
- **장점**: 
  - 가장 인기
  - 많은 통합
  - Actions 포함
- **가격**: 
  - 무료 (퍼블릭)
  - $4/월 (프라이빗)
- **링크**: https://github.com/

#### GitLab (무료/유료) ⭐⭐⭐⭐
**추천도**: 높음
- **기능**: Git 호스팅 + CI/CD
- **장점**: 
  - 무료 CI/CD 포함
  - 자체 호스팅 가능
- **가격**: 
  - 무료
  - Premium: $29/월
- **링크**: https://gitlab.com/

#### Bitbucket (무료/유료) ⭐⭐⭐
**추천도**: 보통
- **가격**: 
  - 무료 (5명까지)
  - Standard: $3/월
- **링크**: https://bitbucket.org/

---

### 8.2 프로젝트 관리

#### Linear (무료/유료) ⭐⭐⭐⭐⭐
**추천도**: 매우 높음
- **기능**: 이슈 트래킹 및 프로젝트 관리
- **장점**: 
  - 아름다운 UI
  - 빠른 속도
  - 키보드 단축키
- **가격**: 
  - 무료 (제한적)
  - Standard: $8/월
- **링크**: https://linear.app/

#### Notion (무료/유료) ⭐⭐⭐⭐⭐
**추천도**: 매우 높음
- **기능**: 올인원 워크스페이스
- **장점**: 
  - 문서, 데이터베이스, 위키
  - 협업 기능
- **가격**: 
  - 무료
  - Plus: $8/월
- **링크**: https://www.notion.so/

#### Jira (무료/유료) ⭐⭐⭐⭐
**추천도**: 높음
- **기능**: 프로젝트 관리
- **장점**: 
  - 강력한 기능
  - Agile 지원
- **가격**: 
  - 무료 (10명까지)
  - Standard: $7.75/월
- **링크**: https://www.atlassian.com/software/jira

#### Trello (무료/유료) ⭐⭐⭐⭐
**추천도**: 높음
- **기능**: 칸반 보드
- **장점**: 
  - 간단하고 직관적
- **가격**: 
  - 무료
  - Standard: $5/월
- **링크**: https://trello.com/

---

### 8.3 디자인 시스템

#### Storybook (무료) ⭐⭐⭐⭐⭐
**추천도**: 매우 높음
- **기능**: UI 컴포넌트 문서화
- **장점**: 
  - 컴포넌트 테스트
  - 문서화
- **가격**: 무료
- **링크**: https://storybook.js.org/
- **Flutter**: storybook_flutter 패키지

#### Zeroheight (무료/유료) ⭐⭐⭐⭐
**추천도**: 높음
- **기능**: 디자인 시스템 문서화
- **가격**: 
  - 무료
  - Pro: $33/월
- **링크**: https://www.zeroheight.com/

---

## 9. 추가 유용한 도구

### 9.1 문서화

#### Docusaurus (무료) ⭐⭐⭐⭐⭐
**추천도**: 매우 높음
- **기능**: 문서 사이트 생성
- **장점**: 
  - React 기반
  - 검색 기능
- **가격**: 무료
- **링크**: https://docusaurus.io/

#### GitBook (무료/유료) ⭐⭐⭐⭐
**추천도**: 높음
- **기능**: 문서 작성 및 공유
- **가격**: 
  - 무료
  - Plus: $6/월
- **링크**: https://www.gitbook.com/

---

### 9.2 코드 리뷰

#### Reviewable (유료) ⭐⭐⭐
**추천도**: 보통
- **가격**: $39/월
- **링크**: https://reviewable.io/

---

### 9.3 보안 스캔

#### Snyk (무료/유료) ⭐⭐⭐⭐⭐
**추천도**: 매우 높음
- **기능**: 보안 취약점 스캔
- **장점**: 
  - 종속성 스캔
  - 자동 수정 제안
- **가격**: 
  - 무료 (제한적)
  - Team: $52/월
- **링크**: https://snyk.io/

#### Dependabot (무료) ⭐⭐⭐⭐⭐
**추천도**: 필수 추천
- **기능**: GitHub 내장 보안 알림
- **장점**: 
  - GitHub 통합
  - 완전 무료
- **링크**: https://github.com/dependabot

---

## 📊 추천 도구 요약 (우선순위별)

### 필수 도구 (Must Have) ⭐⭐⭐⭐⭐
1. **VS Code** - IDE
2. **FVM** - Flutter 버전 관리
3. **Figma** - 디자인
4. **Postman** - API 테스트
5. **GitHub** - 버전 관리
6. **Firebase Crashlytics** - 크래시 리포팅
7. **GitHub Actions** - CI/CD
8. **Fastlane** - 앱 배포

### 매우 유용한 도구 (Highly Recommended) ⭐⭐⭐⭐
1. **Android Studio** - Android 개발
2. **FlutterFlow** - UI 빌더
3. **Sentry** - 에러 추적
4. **Codemagic** - Flutter CI/CD
5. **Vercel/Netlify** - 웹 배포
6. **Notion** - 문서화
7. **json_serializable** - 코드 생성

### 상황별 추천 (Nice to Have) ⭐⭐⭐
1. **TablePlus** - DB 관리
2. **Amplitude** - 고급 분석
3. **Linear** - 프로젝트 관리
4. **Storybook** - 컴포넌트 문서화

---

## 💰 비용별 추천

### 완전 무료로 시작
1. VS Code
2. FVM
3. GitHub
4. Firebase (대부분 무료)
5. Postman
6. GitHub Actions
7. Figma (무료 플랜)
8. Notion

### 초기 예산 ($50/월 이하)
1. Figma Pro ($12)
2. Vercel Pro ($20)
3. Sentry Team ($26)
4. **총: ~$58/월**

### 성장 단계 ($100-200/월)
1. 위 항목들 +
2. Codemagic ($95)
3. Amplitude (무료로 시작)
4. Linear Standard ($8)

---

## 🎯 SendBox 프로젝트에 추천하는 도구 조합

### 개발 단계
- **IDE**: VS Code + Android Studio
- **버전 관리**: GitHub
- **디자인**: Figma
- **API 테스트**: Postman
- **코드 생성**: json_serializable, freezed
- **프로젝트 관리**: Notion 또는 Linear

### 배포 단계
- **CI/CD**: GitHub Actions (무료) 또는 Codemagic
- **웹 배포**: Vercel 또는 Netlify
- **모바일 배포**: Fastlane
- **모니터링**: Firebase Crashlytics + Sentry

### 협업
- **문서**: Notion
- **이슈 관리**: GitHub Issues 또는 Linear
- **디자인 시스템**: Figma + Storybook

---

## 🔗 빠른 링크

### 무료로 시작하기 좋은 것들
1. VS Code: https://code.visualstudio.com/
2. GitHub: https://github.com/
3. Figma: https://www.figma.com/
4. Postman: https://www.postman.com/
5. Firebase: https://firebase.google.com/
6. Vercel: https://vercel.com/
7. Notion: https://www.notion.so/

### Flutter 특화
1. FVM: https://fvm.app/
2. Codemagic: https://codemagic.io/
3. Very Good CLI: https://verygood.ventures/blog/very-good-cli

---

## 📝 선택 가이드

**무엇을 선택해야 할까요?**

1. **예산이 제로** → 무료 도구만 사용
2. **초보자** → VS Code, GitHub, Figma, Postman
3. **팀 협업** → Notion, Linear, GitHub
4. **빠른 배포** → Vercel, Codemagic
5. **프로덕션 레벨** → Sentry, Amplitude 추가

---

**추가로 궁금한 도구나 특정 기능이 필요하면 알려주세요!** 🚀


