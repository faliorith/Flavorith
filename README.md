# Flavorith - Книга рецептов

Мобильное приложение для хранения и обмена рецептами, разработанное с использованием Flutter.

## Особенности

- 🔐 Аутентификация через Firebase
- 🌐 Многоязычный интерфейс (русский, английский, казахский)
- 🌙 Поддержка темной темы
- 📱 Адаптивный дизайн
- 🔔 Push-уведомления
- 💾 Локальное хранение данных
- 🔄 Синхронизация с Firebase

## Технологии

- Flutter
- Firebase (Authentication, Firestore, Cloud Messaging)
- BLoC для управления состоянием
- Dio для HTTP-запросов
- SharedPreferences для локального хранения
- GetIt для внедрения зависимостей

## Установка

1. Клонируйте репозиторий:
```bash
git clone https://github.com/yourusername/flavorith.git
```

2. Установите зависимости:
```bash
flutter pub get
```

3. Создайте проект в Firebase Console и добавьте конфигурацию:
- Android: `android/app/google-services.json`
- iOS: `ios/Runner/GoogleService-Info.plist`

4. Запустите приложение:
```bash
flutter run
```

## Структура проекта

```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── constants/
│   ├── localization/
│   ├── router/
│   └── theme/
├── data/
│   ├── models/
│   ├── repositories/
│   └── datasources/
├── logic/
│   ├── blocs/
│   └── cubits/
├── presentation/
│   ├── pages/
│   └── widgets/
└── services/
```

## Лицензия

MIT License
