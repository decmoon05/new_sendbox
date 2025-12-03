# Git Commit Message Guidelines (English)

> 영어로 커밋 메시지를 작성하기 위한 가이드

## 📝 커밋 메시지 형식

### 기본 형식
```
<type>: <subject>

<body>

<footer>
```

### 간단한 형식 (일반적으로 사용)
```
<type>: <subject>
```

---

## 🏷️ Type (타입)

### 주요 타입
- **feat**: 새로운 기능 추가
- **fix**: 버그 수정
- **docs**: 문서 변경
- **style**: 코드 포맷팅, 세미콜론 누락 등 (기능 변경 없음)
- **refactor**: 코드 리팩토링 (기능 변경 없음)
- **perf**: 성능 개선
- **test**: 테스트 코드 추가/수정
- **chore**: 빌드 업무 수정, 패키지 매니저 설정 등
- **build**: 빌드 시스템 변경
- **ci**: CI 설정 변경

---

## ✍️ Subject (제목) 규칙

1. **명령형 사용** ("Add" not "Added", "Fix" not "Fixed")
2. **첫 글자 대문자**
3. **마지막에 마침표 없음**
4. **50자 이내**
5. **영어로 작성**

---

## 📋 예시

### 좋은 예시 ✅

```
feat: Add AI message recommendation feature
fix: Resolve SMS notification listener crash
docs: Update README with setup instructions
style: Format code according to style guide
refactor: Extract message parsing logic to separate service
perf: Optimize database queries for faster loading
test: Add unit tests for message service
chore: Update Flutter dependencies to latest version
build: Configure GitHub Actions workflow
ci: Add Flutter CI pipeline
```

### 나쁜 예시 ❌

```
Added new feature  # 타입 없음, 과거형
fix bug            # 첫 글자 소문자
feat: add feature. # 마지막 마침표
feat: Add a really long commit message that exceeds the 50 character limit  # 너무 김
한글 커밋 메시지    # 영어 아님
```

---

## 🎯 SendBox 프로젝트 예시

### 계획/설계 단계
```
docs: Add project planning and architecture documentation
docs: Add database schema design document
docs: Add AI system design documentation
docs: Add platform integration strategy
docs: Add security architecture design
docs: Add UI/UX design system guide
docs: Add development roadmap
docs: Add advanced features design
docs: Add developer tools guide
docs: Add free setup guide
docs: Add KYS (Know Your System) guide
docs: Add security guide
docs: Add Flutter selection rationale
docs: Add Git setup guide
docs: Add FVM guide
```

### 개발 단계
```
feat: Add project structure with Clean Architecture
feat: Add Riverpod state management setup
feat: Add Isar local database integration
feat: Add Firebase authentication
feat: Add SMS integration service
feat: Add AI recommendation feature
feat: Add profile management feature
fix: Fix message parsing issue
refactor: Refactor repository pattern implementation
test: Add unit tests for message service
chore: Update dependencies
```

---

## 🔧 커밋 메시지 템플릿 설정

### Git 설정
```bash
git config --global commit.template .git_commit_template.txt
```

### VS Code 확장 프로그램 추천
- **Conventional Commits**: 커밋 메시지 자동 완성
- **GitLens**: Git 히스토리 확인

---

## 📚 참고 자료

- [Conventional Commits](https://www.conventionalcommits.org/)
- [Angular Commit Message Guidelines](https://github.com/angular/angular/blob/main/CONTRIBUTING.md#commit)

---

## ✅ 체크리스트

커밋 메시지 작성 전:
- [ ] Type 선택 (feat, fix, docs 등)
- [ ] 명령형 사용 (Add, Fix, Update)
- [ ] 첫 글자 대문자
- [ ] 50자 이내
- [ ] 마지막 마침표 없음
- [ ] 영어로 작성

---

**이제 영어로 깔끔한 커밋 메시지를 작성할 수 있습니다!** 📝✨


