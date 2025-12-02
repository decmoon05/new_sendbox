# Git 초기화 및 GitHub 연동 가이드

> SendBox 프로젝트 Git 설정 및 GitHub 연동

## 🎯 목표

1. 로컬 Git 저장소 초기화
2. GitHub 레포지토리와 연동
3. 초기 파일 커밋 및 푸시

---

## 📋 사전 확인

### 현재 상태
- ✅ VS Code 설치됨
- ✅ Git 설치됨
- ✅ GitHub 계정: decmoon05
- ✅ GitHub 레포지토리: https://github.com/decmoon05/new_sendbox.git

---

## Step 1: Git 사용자 정보 설정

### 1.1 Git 사용자 정보 확인

```bash
git config --global user.name
git config --global user.email
```

### 1.2 Git 사용자 정보 설정 (없으면)

```bash
git config --global user.name "decmoon05"
git config --global user.email "decmoon05@naver.com"
```

**확인:**
```bash
git config --global --list
```

---

## Step 2: 프로젝트 디렉토리로 이동

```bash
# 현재 디렉토리 확인
cd C:\Users\WannaGoHome\Desktop\new_sendbox

# 또는 원하는 위치에서
cd new_sendbox
```

---

## Step 3: Git 저장소 초기화

### 3.1 Git 초기화

```bash
git init
```

**결과:**
```
Initialized empty Git repository in C:/Users/WannaGoHome/Desktop/new_sendbox/.git/
```

### 3.2 현재 상태 확인

```bash
git status
```

**예상 결과:**
```
On branch main

No commits yet

Untracked files:
  (use "git add <file>..." to include in what will be committed)
        ADVANCED_FEATURES.md
        AI_SYSTEM_DESIGN.md
        ARCHITECTURE_DESIGN.md
        ...
```

---

## Step 4: .gitignore 확인

### 4.1 .gitignore 파일 확인

`.gitignore` 파일이 있는지 확인:

```bash
ls .gitignore
# 또는
dir .gitignore
```

### 4.2 .gitignore 파일 생성 (없으면)

이미 `SECURITY_GUIDE.md`에서 생성했지만, 다시 확인:

```bash
# VS Code에서 .gitignore 열기
code .gitignore
```

**내용 확인:**
- API 키 관련 파일 제외
- 환경 변수 파일 제외
- 빌드 산출물 제외

---

## Step 5: 모든 파일 스테이징

### 5.1 모든 파일 추가

```bash
git add .
```

### 5.2 스테이징 확인

```bash
git status
```

**예상 결과:**
```
On branch main

No commits yet

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)
        new file:   ADVANCED_FEATURES.md
        new file:   AI_SYSTEM_DESIGN.md
        ...
```

---

## Step 6: 첫 커밋

### 6.1 초기 커밋

```bash
git commit -m "Initial commit: 프로젝트 계획 문서 및 아키텍처 설계"
```

**또는 더 자세한 메시지:**

```bash
git commit -m "Initial commit: SendBox 프로젝트 재구축 계획

- 프로젝트 개요 및 요구사항 문서화
- Clean Architecture 설계
- 데이터베이스 스키마 설계
- AI 시스템 설계 (온라인/오프라인)
- 플랫폼 통합 전략 (14개 플랫폼)
- 보안 아키텍처 설계
- UI/UX 디자인 시스템
- 개발 로드맵
- 고급 기능 설계
- 개발자 도구 가이드
- 무료 도구 설정 가이드"
```

---

## Step 7: GitHub 레포지토리와 연동

### 7.1 원격 저장소 추가

```bash
git remote add origin https://github.com/decmoon05/new_sendbox.git
```

### 7.2 원격 저장소 확인

```bash
git remote -v
```

**예상 결과:**
```
origin  https://github.com/decmoon05/new_sendbox.git (fetch)
origin  https://github.com/decmoon05/new_sendbox.git (push)
```

### 7.3 브랜치 이름 확인 (필요시 main으로 변경)

```bash
# 현재 브랜치 확인
git branch

# main 브랜치로 이름 변경 (필요시)
git branch -M main
```

---

## Step 8: GitHub에 푸시

### 8.1 첫 푸시

```bash
git push -u origin main
```

**참고:** GitHub 인증 필요할 수 있음

### 8.2 인증 방법

#### 방법 1: Personal Access Token (권장)

1. GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. "Generate new token (classic)" 클릭
3. 권한 선택:
   - ✅ `repo` (전체)
   - ✅ `workflow` (GitHub Actions)
4. 토큰 생성 후 복사
5. 푸시 시 비밀번호 대신 토큰 입력

#### 방법 2: GitHub CLI (선택)

```bash
# GitHub CLI 설치 후
gh auth login
```

#### 방법 3: SSH 키 (고급, 선택)

```bash
# SSH 키 생성
ssh-keygen -t ed25519 -C "decmoon05@naver.com"

# GitHub에 SSH 키 추가
# Settings → SSH and GPG keys → New SSH key

# 원격 URL을 SSH로 변경
git remote set-url origin git@github.com:decmoon05/new_sendbox.git
```

---

## Step 9: 푸시 확인

### 9.1 GitHub 웹사이트에서 확인

브라우저에서 https://github.com/decmoon05/new_sendbox 접속:
- 모든 파일이 업로드되었는지 확인
- README.md가 제대로 표시되는지 확인

### 9.2 로컬에서 확인

```bash
git log
```

**예상 결과:**
```
commit abc123... (HEAD -> main, origin/main)
Author: decmoon05 <decmoon05@naver.com>
Date:   ...

    Initial commit: SendBox 프로젝트 재구축 계획
```

---

## Step 10: .gitignore 확인 및 민감한 파일 제외

### 10.1 커밋된 민감한 파일 확인

```bash
# .env 파일이 있는지 확인
git ls-files | grep -E "\.(env|key|pem|json)$"

# .env 파일이 있다면 제거
git rm --cached .env
git commit -m "Remove sensitive files from git"
```

### 10.2 .gitignore에 추가 (필요시)

```bash
# .gitignore 파일 확인
cat .gitignore
```

**확인해야 할 항목:**
- `.env`
- `.env.local`
- `google-services.json` (이미 포함되어야 함)
- `firebase_options.dart`
- API 키 파일들

---

## ✅ 체크리스트

### Git 설정
- [ ] Git 사용자 정보 설정
- [ ] Git 저장소 초기화 (`git init`)
- [ ] .gitignore 파일 확인

### 파일 관리
- [ ] 모든 파일 스테이징 (`git add .`)
- [ ] 초기 커밋 생성 (`git commit`)

### GitHub 연동
- [ ] 원격 저장소 추가 (`git remote add`)
- [ ] 원격 저장소 확인 (`git remote -v`)
- [ ] GitHub에 푸시 (`git push`)

### 보안
- [ ] 민감한 파일이 커밋되지 않았는지 확인
- [ ] .gitignore가 제대로 작동하는지 확인

---

## 🚨 문제 해결

### 문제 1: "Authentication failed"

**해결:**
1. Personal Access Token 사용
2. 또는 GitHub CLI 사용: `gh auth login`

### 문제 2: "Repository not found"

**해결:**
1. 레포지토리 이름 확인: `new_sendbox`
2. 레포지토리가 Private인지 확인
3. GitHub 계정 권한 확인

### 문제 3: "Branch 'main' does not exist"

**해결:**
```bash
git branch -M main
```

### 문제 4: "Everything up-to-date" (하지만 GitHub에 없음)

**해결:**
```bash
# 강제 푸시 (주의!)
git push -u origin main --force
```

---

## 📝 일반적인 Git 명령어

### 일상적인 작업

```bash
# 상태 확인
git status

# 변경사항 확인
git diff

# 파일 추가
git add <파일명>
git add .  # 모든 파일

# 커밋
git commit -m "커밋 메시지"

# 푸시
git push

# 풀 (다운로드)
git pull

# 브랜치 목록
git branch

# 새 브랜치 생성
git checkout -b feature/새기능

# 브랜치 전환
git checkout main
```

---

## 🎯 다음 단계

### 1. GitHub Actions 설정

`.github/workflows/` 폴더에 CI/CD 워크플로우 추가

### 2. 브랜치 전략 설정

- `main`: 프로덕션 코드
- `develop`: 개발 브랜치
- `feature/*`: 기능 브랜치

### 3. README 업데이트

GitHub 레포지토리 설명 추가:
- 프로젝트 소개
- 설치 방법
- 사용 방법

---

## 📚 참고 자료

- [Git 공식 문서](https://git-scm.com/doc)
- [GitHub 가이드](https://guides.github.com/)
- [Personal Access Token 생성](https://github.com/settings/tokens)

---

**준비 완료! 이제 Git과 GitHub이 연동되었습니다!** 🎉

