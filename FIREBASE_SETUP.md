# Firebase Kurulumu - Kes Zamanı

Bu projeyi tam olarak çalıştırmak için Firebase projesi kurmanız gerekiyor.

## 1. Firebase Projesi Oluşturma

1. [Firebase Console](https://console.firebase.google.com/) adresine gidin
2. "Add project" / "Proje ekle" butonuna tıklayın
3. Proje adı: `kes-zamani` (veya istediğiniz bir isim)
4. Google Analytics'i etkinleştirin (isteğe bağlı)
5. Projeyi oluşturun

## 2. Android Uygulaması Ekleme

1. Firebase konsolunda "Android" simgesine tıklayın
2. Android package name: `com.example.chop_time` 
   (Bu değer `android/app/build.gradle` dosyasında `applicationId` ile eşleşmelidir)
3. App nickname: `Kes Zamanı`
4. `google-services.json` dosyasını indirin
5. Bu dosyayı `android/app/` klasörüne koyun

## 3. iOS Uygulaması Ekleme (İsteğe bağlı)

1. Firebase konsolunda "iOS" simgesine tıklayın
2. iOS bundle ID: `com.example.chopTime`
3. `GoogleService-Info.plist` dosyasını indirin
4. Bu dosyayı `ios/Runner/` klasörüne koyun

## 4. Firebase Servislerini Etkinleştirme

### Firestore Database
1. Firebase konsolunda "Firestore Database" bölümüne gidin
2. "Create database" butonuna tıklayın
3. Test modunda başlayın (daha sonra kuralları güncelleyebilirsiniz)
4. Bölge olarak `europe-west1` veya size en yakın bölgeyi seçin

### Realtime Database
1. Firebase konsolunda "Realtime Database" bölümüne gidin
2. "Create database" butonuna tıklayın
3. Test modunda başlayın

### Authentication
1. Firebase konsolunda "Authentication" bölümüne gidin
2. "Get started" butonuna tıklayın
3. "Sign-in method" sekmesinde "Anonymous" seçeneğini etkinleştirin

## 5. main.dart'taki Firebase Yapılandırmasını Güncelleme

Firebase konsolundan "Project settings" > "General" > "Your apps" bölümünden 
Firebase yapılandırma değerlerini alın ve `lib/main.dart` dosyasındaki placeholder değerleri değiştirin:

```dart
await Firebase.initializeApp(
  options: const FirebaseOptions(
    apiKey: "BURAYA_API_KEY_GELECEK",
    authDomain: "PROJE_ADI.firebaseapp.com", 
    databaseURL: "https://PROJE_ADI-default-rtdb.firebaseio.com",
    projectId: "PROJE_ADI",
    storageBucket: "PROJE_ADI.appspot.com",
    messagingSenderId: "SENDER_ID",
    appId: "APP_ID",
  ),
);
```

## 6. Güvenlik Kuralları

### Firestore Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Oyun odaları için kurallar
    match /game_rooms/{roomId} {
      allow read, write: if true; // Test için, production'da daha kısıtlayıcı olmalı
    }
    
    // Oyuncu verileri için kurallar  
    match /players/{playerId} {
      allow read, write: if true; // Test için, production'da daha kısıtlayıcı olmalı
    }
  }
}
```

### Realtime Database Rules
```json
{
  "rules": {
    ".read": true,
    ".write": true
  }
}
```

## 7. Test Etme

1. Uygulamayı çalıştırın: `flutter run`
2. Ana ekranda "ÇOK OYUNCU" butonuna tıklayın
3. Oyuncu adı girin ve oda oluşturun
4. Başka bir cihazda/emülatörde uygulamayı çalıştırın ve odaya katılın

## Sorun Giderme

### Android build hatası
- `android/app/google-services.json` dosyasının doğru yerde olduğundan emin olun
- `android/app/build.gradle` dosyasında `applicationId`'nin Firebase'de kayıtlı package name ile eşleştiğinden emin olun

### iOS build hatası  
- `ios/Runner/GoogleService-Info.plist` dosyasının Xcode projesine eklendiğinden emin olun
- Bundle ID'nin Firebase'de kayıtlı ID ile eşleştiğinden emin olun

### Firebase bağlantı hatası
- Internet bağlantınızı kontrol edin
- Firebase projesinin aktif olduğundan emin olun
- API anahtarlarının doğru olduğunu kontrol edin
