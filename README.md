<img width="945" height="542" alt="image" src="https://github.com/user-attachments/assets/df4b471f-4a98-4462-aa2d-8940f54f7326" />Cały proces jest w pełni automatyczny – Twoim głównym zadaniem jest po prostu uruchomienie programu i zalogowanie się na swoje konto Carelink

---

## Instrukcja logowania do Medtronic CareLink

### Krok 1: Uruchomienie programu

1. Pobierz plik Carelink_pobierz_token.bat za pomocą linku:  https://github.com/jrkf/Carelink_get_jwt_token/releases/download/1.0/Carelink_pobierz_token.bat
1. Kliknij **prawym przyciskiem myszy** na plik `Carelink_pobierz_token.bat`.
2. Wybierz opcję **"Uruchom jako administrator"**.
3. Jeśli pojawi się okienko z pytaniem, czy pozwolić aplikacji na wprowadzanie zmian, kliknij **Tak**.

### Krok 2: Odpowiedź na pytanie (USA czy Europa)

Program zacznie pobierać i instalować potrzebne składniki. Po chwili w czarnym oknie pojawi się pytanie:

> <img width="1592" height="893" alt="image" src="https://github.com/user-attachments/assets/bc1d7c7a-6596-4375-b93f-14edbbbc10fc" />

> 
> 

* Wpisz literę **n** (lub po prostu naciśnij **Enter**), ponieważ Twoje konto jest zarejestrowane w Europie/Polsce.



### Krok 3: Logowanie w przeglądarce

1. Po udzieleniu odpowiedzi program automatycznie otworzy okno przeglądarki **Firefox**.


2. W otwartym oknie wpisz swój **login oraz hasło** do konta CareLink.
<img width="945" height="542" alt="image" src="https://github.com/user-attachments/assets/4596fa36-fdf9-4752-883b-35dc0b669bd2" />


3. Jeśli na ekranie pojawi się weryfikacja antybotowa (**reCAPTCHA**, np. zaznaczanie obrazków), rozwiąż ją ręcznie.


4. Po poprawnym zalogowaniu możesz zamknąć okno Firefoksa.

### Krok 4: Wysłanie pliku do fundacji

Po zakończeniu działania programu, w tym samym folderze, w którym znajduje się uruchamiany plik `.bat`, pojawi się nowy podfolder o nazwie:
📂 **`carelink-python-client-main`**

1. Wejdź do tego podfolderu (`carelink-python-client-main`).
2. Znajdź w nim nowo utworzony plik o nazwie **`logindata.json`**. Zmień jego nazwe na imie_nazwisko.json
3. Wyślij ten plik jako załącznik w wiadomości e-mail na adres fundacji.

---

> 💡 **Ważne:** Podczas działania programu, gdy zobaczysz komunikat *"Aby kontynuować, naciśnij dowolny klawisz..."*, po prostu naciśnij **Space (Spację)** lub **Enter** na klawiaturze. Nie zamykaj czarnego okna, dopóki program sam nie skończy pracy.
> 💡 **UWAGA:** Jeżeli udało Ci się wygenerować i podesłać plik to nie uruchamiaj tego programu ponownie, spowoduje to unieważninie poprzedniego hasła / pliku, co w takiej sytuacji bedzie skutkować potrzebą wysłania nowego pliku,oraz powtórzyć całą operacje konfigurcji od nowa.

