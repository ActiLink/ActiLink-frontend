# ActiLink Frontend

![ActiLink-Mockup](https://github.com/user-attachments/assets/ea71d0e1-57f7-4189-936c-e6cbf8295417)

**ActiLink** to innowacyjna aplikacja, która pozwala użytkownikom nawiązywać kontakty z osobami o podobnych zainteresowaniach oraz organizować wspólne wydarzenia.

## 🎯 Cel projektu
Zapewnienie **intuicyjnego i responsywnego interfejsu użytkownika**, który umożliwia łatwe wyszukiwanie, filtrowanie i organizowanie wydarzeń. Aplikacja mobilna zapewnia użytkownikom możliwość zarządzania swoim profilem, interakcję z innymi użytkownikami oraz komentowanie wydarzeń.

## 🚀 Kluczowe funkcjonalności
- **Rejestracja i logowanie** – autoryzacja użytkowników (zwykłych oraz klientów biznesowych).
- **Tworzenie i zarządzanie wydarzeniami** – możliwość organizowania i edytowania aktywności.
- **Wyszukiwanie i zapisywanie się na wydarzenia** – filtrowanie wydarzeń według zainteresowań i lokalizacji.
- **Dodawanie obiektów** – klienci biznesowi mogą zarządzać obiektami do organizacji wydarzeń.
- **System znajomych** – dodawanie znajomych i interakcja z nimi.
- **Komentarze** – możliwość komentowania wydarzeń.

## 🛠 Technologie i narzędzia
- **Flutter** – framework do tworzenia aplikacji mobilnych.

## 📦 Instalacja i uruchomienie
Aby uruchomić aplikację lokalnie, wykonaj następujące kroki:
1. **Sklonuj repozytorium:**
   
    ```bash
    git clone https://github.com/ActiLink/Actilink-frontend.git
    cd actilink-frontend
    ```

2. **Zainstaluj wymagane narzędzia:**

   Upewnij się, że masz zainstalowane:
    
    - 🔧 Najnowszą wersję Flutter SDK – [Zainstaluj Flutter](https://docs.flutter.dev/get-started/install)  
    - 🤖 Android Studio (opcjonalnie także emulator) – [Pobierz Android Studio](https://developer.android.com/studio)

3. **Zainstaluj narzędzie Melos:**

    ```bash
    dart pub global activate melos
    ```

    Po zainstalowaniu Melos, możesz zainicjować projekt, uruchamiając:
    ```bash
    melos bootstrap
    ```

    Spowoduje to instalację wszystkich zależności i połączenie lokalnych pakietów.

4. **Ustaw zmienne środowiskowe**

   Utwórz plik `.env` w katalogu `apps/actilink` o następującej zawartości:
    
    ```
    GOOGLE_MAPS_API=<api_google_maps>
    ```
    
    > Zamień `<api_google_maps>` na swój rzeczywisty klucz API uzyskany z usługi Google Maps.  
    > Przechowuj plik `.env` w bezpiecznym miejscu i nie dodawaj go do systemu kontroli wersji.

5. **Aby uruchomić aplikację w środowisku `[development, staging, production]`:**

   ```bash
    melos run [dev, stage, prod]
    ```

## 🧹 Czyszczenie
Aby wyczyścić projekt użyj:
```bash
melos clean
```

## ❓ Rozwiązywanie problemów
Jeśli nie możesz uruchomić `melos` z terminala, a błąd brzmi podobnie do "command not found", upewnij się, że dodałeś odpowiednie katalogi do zmiennej środowiskowej PATH:
* w systemach Unix, dodaj `$HOME/.pub-cache/bin`
* w systemie Windows, dodaj `%USERPROFILE%\AppData\Local\Pub\Cache\bin`
