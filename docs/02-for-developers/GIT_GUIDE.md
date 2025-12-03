# Git 사용 가이드

> SendBox 프로젝트 Git 및 GitHub 사용 가이드

## 📋 목차

1. [Git 기본 설정](#git-기본-설정)
2. [Git 기본 사용법](#git-기본-사용법)
3. [GitHub 연동](#github-연동)
4. [커밋 메시지 규칙](#커밋-메시지-규칙)
5. [일상적인 Git 워크플로우](#일상적인-git-워크플로우)

---

## Git 기본 설정

### 사용자 정보 설정

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### 설정 확인

```bash
git config --global --list
```

---

## Git 기본 사용법

### 저장소 초기화

```bash
git init
git branch -M main
```

### 파일 상태 확인

```bash
git status
```

### 파일 추가

```bash
# 모든 파일 추가
git add .

# 특정 파일 추가
git add filename.dart

# 특정 패턴 추가
git add lib/**/*.dart
```

### 커밋

```bash
git commit -m "커밋 메시지"
```

### 커밋 히스토리 확인

```bash
# 간단한 로그
git log --oneline

# 그래프 포함
git log --oneline --graph

# 최근 N개만
git log --oneline -5
```

---

## GitHub 연동

### 원격 저장소 추가

```bash
git remote add origin https://github.com/decmoon05/new_sendbox.git
```

### 원격 저장소 확인

```bash
git remote -v
```

### 푸시 (업로드)

```bash
# 첫 푸시
git push -u origin main

# 이후 푸시
git push
```

### 풀 (다운로드)

```bash
git pull
```

### GitHub 인증

#### Personal Access Token 사용

1. https://github.com/settings/tokens 접속
2. "Generate new token (classic)" 클릭
3. 권한: `repo` (전체) 선택
4. 토큰 생성 및 복사
5. 푸시 시 비밀번호 대신 토큰 입력

---

## 커밋 메시지 규칙

**자세한 가이드:** [COMMIT_MESSAGES.md](COMMIT_MESSAGES.md)

### 형식

```
<type>: <subject>
```

### 주요 타입

- `feat`: 새로운 기능 추가
- `fix`: 버그 수정
- `docs`: 문서 변경
- `refactor`: 코드 리팩토링
- `test`: 테스트 코드
- `chore`: 유지보수 작업

### 예시

```bash
feat: Add SMS integration service
fix: Resolve notification listener crash
docs: Update README with setup guide
refactor: Extract message parsing logic
```

### 규칙

- ✅ 영어로 작성
- ✅ 명령형 사용 ("Add" not "Added")
- ✅ 첫 글자 대문자
- ✅ 50자 이내
- ✅ 마지막 마침표 없음

---

## 일상적인 Git 워크플로우

### 기본 워크플로우

```bash
# 1. 상태 확인
git status

# 2. 파일 추가
git add .

# 3. 커밋
git commit -m "feat: Add new feature"

# 4. 푸시
git push
```

### 브랜치 작업

```bash
# 새 브랜치 생성 및 전환
git checkout -b feature/new-feature

# 브랜치 목록
git branch

# 브랜치 전환
git checkout main

# 브랜치 병합
git merge feature/new-feature
```

### 변경사항 확인

```bash
# 변경된 내용 확인
git diff

# 스테이징된 변경사항 확인
git diff --staged
```

---

## 문제 해결

### 커밋 취소 (아직 푸시 안 함)

```bash
# 마지막 커밋 취소 (파일은 유지)
git reset --soft HEAD~1

# 커밋과 변경사항 모두 취소
git reset --hard HEAD~1
```

### 파일 되돌리기

```bash
# 특정 파일 되돌리기
git checkout -- filename.dart

# 모든 변경사항 되돌리기
git checkout -- .
```

### 원격과 동기화

```bash
# 원격 변경사항 가져오기
git fetch origin

# 병합
git merge origin/main

# 또는 한 번에
git pull origin main
```

---

## 🔒 보안 주의사항

### 절대 커밋하지 말아야 할 것

- API 키
- 비밀번호
- `.env` 파일
- `google-services.json` (Firebase)
- 개인정보

**확인:** `.gitignore` 파일이 제대로 설정되어 있는지 확인

---

**자세한 내용:** [COMMIT_MESSAGES.md](COMMIT_MESSAGES.md)

