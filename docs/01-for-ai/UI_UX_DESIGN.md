# SendBox UI/UX 디자인 시스템

## 🎨 디자인 철학

### 핵심 원칙

1. **미니멀리즘**: 불필요한 요소 제거, 핵심 기능에 집중
2. **애플 스타일**: 부드러운 애니메이션, 자연스러운 인터랙션
3. **일관성**: 통일된 디자인 언어와 컴포넌트 시스템
4. **접근성**: 모든 사용자가 쉽게 사용 가능

---

## 🎨 색상 시스템

### 기본 컬러 팔레트

```dart
class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF007AFF);      // iOS Blue
  static const Color primaryDark = Color(0xFF0051D5);
  static const Color primaryLight = Color(0xFF5AC8FA);
  
  // Secondary Colors
  static const Color secondary = Color(0xFF5856D6);
  static const Color accent = Color(0xFFFF9500);
  
  // Neutral Colors
  static const Color background = Color(0xFFF2F2F7);
  static const Color backgroundDark = Color(0xFF000000);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1C1C1E);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF8E8E93);
  static const Color textTertiary = Color(0xFFC7C7CC);
  
  // Status Colors
  static const Color success = Color(0xFF34C759);
  static const Color warning = Color(0xFFFF9500);
  static const Color error = Color(0xFFFF3B30);
  static const Color info = Color(0xFF007AFF);
  
  // Semantic Colors (Dark Mode)
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFF8E8E93);
  static const Color backgroundSecondaryDark = Color(0xFF2C2C2E);
}
```

### 다이나믹 컬러 (Material 3 스타일)

```dart
class DynamicColors {
  static ColorScheme lightColorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.light,
  );
  
  static ColorScheme darkColorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.dark,
  );
}
```

---

## ✍️ 타이포그래피

### 폰트 시스템

```dart
class AppTextStyles {
  // 폰트 패밀리: Pretendard
  static const String fontFamily = 'Pretendard';
  
  // Headline
  static const TextStyle headline1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 34,
    fontWeight: FontWeight.bold,
    height: 1.2,
    letterSpacing: -0.5,
  );
  
  static const TextStyle headline2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    height: 1.2,
    letterSpacing: -0.5,
  );
  
  static const TextStyle headline3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: 0,
  );
  
  // Body
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 17,
    fontWeight: FontWeight.normal,
    height: 1.4,
    letterSpacing: -0.4,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.normal,
    height: 1.4,
    letterSpacing: -0.2,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.normal,
    height: 1.4,
    letterSpacing: 0,
  );
  
  // Caption
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.3,
    letterSpacing: 0.2,
  );
  
  // Button
  static const TextStyle buttonLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: -0.4,
  );
  
  static const TextStyle buttonMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: -0.2,
  );
}
```

---

## 📐 레이아웃 시스템

### 스페이싱

```dart
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}
```

### Border Radius

```dart
class AppBorderRadius {
  static const double small = 8.0;
  static const double medium = 12.0;
  static const double large = 16.0;
  static const double xLarge = 24.0;
  static const double circular = 999.0;
}
```

### Shadows (Elevation)

```dart
class AppShadows {
  static const List<BoxShadow> small = [
    BoxShadow(
      color: Color(0x0A000000),
      offset: Offset(0, 2),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];
  
  static const List<BoxShadow> medium = [
    BoxShadow(
      color: Color(0x14000000),
      offset: Offset(0, 4),
      blurRadius: 8,
      spreadRadius: 0,
    ),
  ];
  
  static const List<BoxShadow> large = [
    BoxShadow(
      color: Color(0x1F000000),
      offset: Offset(0, 8),
      blurRadius: 16,
      spreadRadius: 0,
    ),
  ];
}
```

---

## 🎭 애니메이션 시스템

### 애니메이션 상수

```dart
class AppAnimations {
  // Duration
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  
  // Curves
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve spring = Curves.elasticOut;
  static const Curve smooth = Curves.easeOutCubic;
}
```

### 커스텀 애니메이션

#### 1. 페이드 인/아웃

```dart
class FadeTransition extends StatelessWidget {
  final Widget child;
  final Animation<double> animation;
  
  const FadeTransition({
    required this.child,
    required this.animation,
  });
  
  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
```

#### 2. 슬라이드 애니메이션

```dart
class SlideTransition extends StatelessWidget {
  final Widget child;
  final Animation<Offset> animation;
  final AxisDirection direction;
  
  const SlideTransition({
    required this.child,
    required this.animation,
    this.direction = AxisDirection.down,
  });
  
  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: animation,
      child: child,
    );
  }
}
```

#### 3. 스프링 애니메이션

```dart
class SpringAnimation extends StatefulWidget {
  final Widget child;
  final VoidCallback? onComplete;
  
  const SpringAnimation({
    required this.child,
    this.onComplete,
  });
  
  @override
  State<SpringAnimation> createState() => _SpringAnimationState();
}

class _SpringAnimationState extends State<SpringAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppAnimations.normal,
      vsync: this,
    );
    
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    
    _controller.forward();
  }
  
  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}
```

#### 4. 타이핑 효과 (AI 응답)

```dart
class TypingAnimation extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration speed;
  
  const TypingAnimation({
    required this.text,
    this.style,
    this.speed = const Duration(milliseconds: 30),
  });
  
  @override
  State<TypingAnimation> createState() => _TypingAnimationState();
}

class _TypingAnimationState extends State<TypingAnimation> {
  String _displayedText = '';
  int _index = 0;
  
  @override
  void initState() {
    super.initState();
    _startTyping();
  }
  
  void _startTyping() {
    Future.delayed(widget.speed, () {
      if (_index < widget.text.length && mounted) {
        setState(() {
          _displayedText += widget.text[_index];
          _index++;
        });
        _startTyping();
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Text(
      _displayedText,
      style: widget.style,
    );
  }
}
```

---

## 🧩 컴포넌트 시스템

### 1. 버튼

#### Primary Button

```dart
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  
  const PrimaryButton({
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  });
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.medium),
        ),
        elevation: 0,
      ),
      child: isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 20),
                  SizedBox(width: AppSpacing.sm),
                ],
                Text(text, style: AppTextStyles.buttonLarge),
              ],
            ),
    );
  }
}
```

#### Secondary Button

```dart
class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  
  const SecondaryButton({
    required this.text,
    this.onPressed,
    this.icon,
  });
  
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.medium),
        ),
        side: BorderSide(color: AppColors.primary, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20),
            SizedBox(width: AppSpacing.sm),
          ],
          Text(text, style: AppTextStyles.buttonLarge),
        ],
      ),
    );
  }
}
```

### 2. 입력 필드

```dart
class AppTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscureText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  
  const AppTextField({
    this.label,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.errorText,
    this.onChanged,
  });
  
  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _isFocused = false;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
        ],
        Focus(
          onFocusChange: (hasFocus) {
            setState(() => _isFocused = hasFocus);
          },
          child: TextField(
            controller: widget.controller,
            obscureText: widget.obscureText,
            onChanged: widget.onChanged,
            style: AppTextStyles.bodyLarge,
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
              prefixIcon: widget.prefixIcon != null
                  ? Icon(widget.prefixIcon, color: AppColors.textSecondary)
                  : null,
              suffixIcon: widget.suffixIcon,
              errorText: widget.errorText,
              filled: true,
              fillColor: _isFocused
                  ? AppColors.surface
                  : AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppBorderRadius.medium),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppBorderRadius.medium),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppBorderRadius.medium),
                borderSide: BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppBorderRadius.medium),
                borderSide: BorderSide(
                  color: AppColors.error,
                  width: 2,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.md,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
```

### 3. 카드

```dart
class AppCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  
  const AppCard({
    required this.child,
    this.onTap,
    this.padding,
    this.backgroundColor,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Material(
      color: backgroundColor ?? 
             (isDark ? AppColors.surfaceDark : AppColors.surface),
      borderRadius: BorderRadius.circular(AppBorderRadius.medium),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppBorderRadius.medium),
        child: Container(
          padding: padding ?? EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppBorderRadius.medium),
            border: Border.all(
              color: isDark
                  ? AppColors.backgroundSecondaryDark
                  : AppColors.background,
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
```

### 4. 로딩 인디케이터

```dart
class AppLoadingIndicator extends StatelessWidget {
  final String? message;
  
  const AppLoadingIndicator({this.message});
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          if (message != null) ...[
            SizedBox(height: AppSpacing.md),
            Text(
              message!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
```

---

## 📱 주요 화면 레이아웃

### 1. 메인 채팅 화면

```
┌─────────────────────────────────┐
│  [←] SendBox          [검색][설정]│
├─────────────────────────────────┤
│                                 │
│  ┌───────────────────────────┐ │
│  │ 프로필 이미지              │ │
│  │ 이름                      │ │
│  │ 최근 메시지 미리보기        │ │
│  └───────────────────────────┘ │
│                                 │
│  ┌───────────────────────────┐ │
│  │ ...                       │ │
│  └───────────────────────────┘ │
│                                 │
│  [ + 새 대화 ]                  │
└─────────────────────────────────┘
```

### 2. 대화 화면

```
┌─────────────────────────────────┐
│  [←] 이름                [프로필]│
├─────────────────────────────────┤
│                                 │
│      상대 메시지                 │
│  ┌────────────┐                │
│  │ 안녕하세요  │                │
│  └────────────┘                │
│                                 │
│  ┌────────────┐                │
│  │ 안녕하세요! │                │
│  └────────────┘      내 메시지  │
│                                 │
│  ┌───────────────────────┐     │
│  │ 💡 AI 추천 메시지      │     │
│  │ 1. 네, 안녕하세요      │     │
│  │ 2. 반가워요!          │     │
│  └───────────────────────┘     │
│                                 │
├─────────────────────────────────┤
│  [입력창]              [전송]    │
└─────────────────────────────────┘
```

---

## 🌓 다크 모드 지원

```dart
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: DynamicColors.lightColorScheme,
      scaffoldBackgroundColor: AppColors.background,
      // ... 기타 설정
    );
  }
  
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: DynamicColors.darkColorScheme,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      // ... 기타 설정
    );
  }
}
```

---

## 🌍 다국어 지원

```dart
// assets/l10n/ko/messages.arb
{
  "@appName": {
    "description": "앱 이름",
    "value": "SendBox"
  },
  "chatScreen": {
    "title": "대화",
    "newMessage": "새 메시지"
  },
  "aiRecommendation": {
    "title": "AI 추천 메시지",
    "loading": "추천 중..."
  }
}

// assets/l10n/en/messages.arb
{
  "@appName": {
    "description": "App name",
    "value": "SendBox"
  },
  "chatScreen": {
    "title": "Chat",
    "newMessage": "New Message"
  },
  "aiRecommendation": {
    "title": "AI Recommended Messages",
    "loading": "Loading recommendations..."
  }
}
```

---

## ✅ 다음 단계

1. 디자인 시스템 컴포넌트 구현
2. 화면별 와이어프레임 작성
3. 애니메이션 프로토타입 제작
4. 접근성 테스트
5. 사용자 테스트 계획


