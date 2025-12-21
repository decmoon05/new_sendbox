# Gemini API 설정 가이드

## 🔑 API 키 발급

1. [Google AI Studio](https://makersuite.google.com/app/apikey)에 접속
2. "Create API Key" 클릭
3. API 키 복사

## 📝 환경 변수 설정

### 방법 1: Flutter 실행 시 설정 (권장)

**Windows (PowerShell):**
```powershell
$env:GEMINI_API_KEY="your-api-key-here"; flutter run
```

**Windows (CMD):**
```cmd
set GEMINI_API_KEY=your-api-key-here && flutter run
```

**macOS/Linux:**
```bash
export GEMINI_API_KEY="your-api-key-here"
flutter run
```

### 방법 2: VS Code launch.json 설정

`.vscode/launch.json` 파일 생성 또는 수정:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "SendBox (Debug)",
      "request": "launch",
      "type": "dart",
      "program": "lib/main.dart",
      "env": {
        "GEMINI_API_KEY": "your-api-key-here"
      }
    }
  ]
}
```

### 방법 3: Android Studio Run Configuration

1. Run → Edit Configurations
2. Environment variables에 추가:
   - Key: `GEMINI_API_KEY`
   - Value: `your-api-key-here`

## ⚠️ 주의사항

- API 키는 절대 Git에 커밋하지 마세요!
- `.gitignore`에 이미 API 키 관련 파일들이 제외되어 있습니다.
- API 키가 없어도 앱은 실행되지만, AI 추천 기능은 사용할 수 없습니다.

## ✅ 확인 방법

앱 실행 후 AI 추천 버튼을 눌렀을 때:
- API 키가 설정되어 있으면: 추천 메시지가 표시됩니다
- API 키가 없으면: "Gemini API 키가 설정되지 않았습니다" 에러 메시지가 표시됩니다

