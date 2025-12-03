# 빠른 시작 가이드

> Git 연동 완료! 이제 GitHub에 푸시하기

## ✅ 완료된 작업

- [x] Git 저장소 초기화
- [x] GitHub 원격 저장소 연결
- [x] 모든 파일 커밋 완료
- [ ] GitHub에 푸시 (다음 단계)

---

## 🚀 GitHub에 푸시하기

### Step 1: GitHub 인증 확인

GitHub에 푸시하려면 인증이 필요합니다.

#### 방법 1: Personal Access Token (권장)

1. **토큰 생성**
   - https://github.com/settings/tokens 접속
   - "Generate new token (classic)" 클릭
   - 토큰 이름: `sendbox-dev`
   - 권한 선택:
     - ✅ `repo` (전체)
     - ✅ `workflow` (GitHub Actions)
   - "Generate token" 클릭
   - **토큰 복사 (한 번만 보임!)**

2. **터미널에서 푸시**

```bash
# 푸시 명령어 실행
git push -u origin main
```

**비밀번호 입력 시**: GitHub 비밀번호가 아닌 **Personal Access Token**을 입력하세요!

#### 방법 2: GitHub CLI (선택)

```bash
# GitHub CLI 설치 (선택)
# https://cli.github.com/ 에서 다운로드

# 로그인
gh auth login

# 푸시
git push -u origin main
```

---

## 📤 푸시 명령어

### 첫 푸시

```bash
git push -u origin main
```

**설명:**
- `-u`: upstream 설정 (다음부터 `git push`만 사용 가능)
- `origin`: 원격 저장소 이름
- `main`: 브랜치 이름

### 이후 푸시

```bash
# 간단하게
git push
```

---

## 🔍 푸시 확인

### GitHub 웹사이트에서 확인

1. https://github.com/decmoon05/new_sendbox 접속
2. 모든 파일이 업로드되었는지 확인
3. README.md가 제대로 표시되는지 확인

### 로컬에서 확인

```bash
git log
git remote -v
```

---

## 📝 다음 단계

### 1. 프로젝트 설명 추가

GitHub 레포지토리 페이지에서:
1. Settings → General → Description
2. 설명 추가: "AI 기반 개인 맞춤형 메시지 추천 서비스"

### 2. Topics 추가

1. Repository 페이지 상단 "Add topics" 클릭
2. 다음 추가:
   - `flutter`
   - `dart`
   - `ai`
   - `mobile-app`
   - `messaging`

### 3. README 미리보기 확인

GitHub에서 README.md가 제대로 렌더링되는지 확인

---

## 🛠️ 일상적인 Git 작업

### 파일 변경 후 커밋

```bash
# 1. 상태 확인
git status

# 2. 변경사항 추가
git add .

# 3. 커밋
git commit -m "커밋 메시지"

# 4. 푸시
git push
```

### 새 파일 추가

```bash
git add 새파일.dart
git commit -m "새 파일 추가"
git push
```

### 변경사항 확인

```bash
git diff
git log --oneline
```

---

## 🚨 문제 해결

### "Authentication failed"

**해결:**
1. Personal Access Token 사용 확인
2. 토큰 권한 확인 (`repo` 체크)
3. 또는 GitHub CLI 사용

### "Repository not found"

**해결:**
1. 레포지토리 이름 확인: `new_sendbox`
2. GitHub 계정 확인: `decmoon05`
3. 레포지토리가 Private인지 확인

### "Everything up-to-date" (하지만 GitHub에 없음)

**해결:**
```bash
# 강제 푸시 (주의!)
git push -u origin main --force
```

---

## ✅ 체크리스트

### GitHub 푸시
- [ ] Personal Access Token 생성
- [ ] GitHub에 푸시 (`git push -u origin main`)
- [ ] GitHub 웹사이트에서 파일 확인
- [ ] README.md 미리보기 확인

### 레포지토리 설정
- [ ] 프로젝트 설명 추가
- [ ] Topics 추가
- [ ] README 확인

---

## 🎯 완료!

**이제 GitHub 레포지토리가 준비되었습니다!**

다음 단계:
1. GitHub에 푸시
2. 프로젝트 설명 추가
3. 개발 시작! 🚀


