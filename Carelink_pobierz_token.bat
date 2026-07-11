@echo off
setlocal EnableDelayedExpansion
title Instalator - logowanie CareLink (ondrej1024/carelink-python-client)

REM =====================================================================
REM  KONFIGURACJA
REM =====================================================================
set "REPO_ZIP_URL=https://github.com/ondrej1024/carelink-python-client/archive/refs/heads/main.zip"
set "REPO_FOLDER_NAME=carelink-python-client-main"
set "WORKDIR=%~dp0"

REM =====================================================================
REM  1. Podniesienie uprawnien do administratora
REM =====================================================================
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Ten skrypt wymaga uprawnien administratora - uruchamiam ponownie...
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

cd /d "%WORKDIR%"

echo =========================================================
echo  Instalator: logowanie do Medtronic CareLink
echo  (repozytorium ondrej1024/carelink-python-client)
echo =========================================================
echo.
echo WAZNE: w kroku koncowym otworzy sie prawdziwe okno przegladarki
echo Firefox. Trzeba tam recznie wpisac login i haslo do CareLink oraz
echo rozwiazac test reCAPTCHA - tego nie da sie zautomatyzowac.
echo.
pause

REM =====================================================================
REM  2. Python - sprawdzenie / instalacja
REM =====================================================================
echo [1/6] Sprawdzanie czy Python jest zainstalowany...
where python >nul 2>&1
if %errorlevel% equ 0 goto :python_ok
py -3 --version >nul 2>&1
if %errorlevel% equ 0 goto :python_ok

echo       Python nie znaleziony - instaluje...
set "PYINSTALLER=%TEMP%\python-installer.exe"
set "PY_URL=https://www.python.org/ftp/python/3.12.7/python-3.12.7-amd64.exe"

curl -L -o "%PYINSTALLER%" "%PY_URL%"
if not exist "%PYINSTALLER%" (
    echo [BLAD] Nie udalo sie pobrac instalatora Pythona.
    pause & exit /b 1
)

"%PYINSTALLER%" /quiet InstallAllUsers=1 PrependPath=1 Include_test=0
timeout /t 5 /nobreak >nul
del /f /q "%PYINSTALLER%" >nul 2>&1

REM odswiezenie PATH w tej sesji
for /f "usebackq tokens=2,*" %%A in (`reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Path`) do set "SYS_PATH=%%B"
for /f "usebackq tokens=2,*" %%A in (`reg query "HKCU\Environment" /v Path 2^>nul`) do set "USR_PATH=%%B"
set "PATH=%SYS_PATH%;%USR_PATH%"

where python >nul 2>&1
if %errorlevel% neq 0 (
    echo [BLAD] Python zainstalowany, ale nie widac go w PATH.
    echo Zamknij okno i uruchom ten plik .bat ponownie z nowego terminala.
    pause & exit /b 1
)

:python_ok
echo       OK - python --version:
python --version
echo.

REM =====================================================================
REM  3. Firefox - sprawdzenie / instalacja (potrzebny do logowania)
REM =====================================================================
echo [2/6] Sprawdzanie czy Firefox jest zainstalowany...
set "FIREFOX_EXE="
if exist "%ProgramFiles%\Mozilla Firefox\firefox.exe" set "FIREFOX_EXE=%ProgramFiles%\Mozilla Firefox\firefox.exe"
if exist "%ProgramFiles(x86)%\Mozilla Firefox\firefox.exe" set "FIREFOX_EXE=%ProgramFiles(x86)%\Mozilla Firefox\firefox.exe"

if defined FIREFOX_EXE (
    echo       Firefox znaleziony: %FIREFOX_EXE%
    goto :firefox_ok
)

echo       Firefox nie znaleziony - instaluje (wersja PL)...
set "FF_INSTALLER=%TEMP%\firefox-installer.exe"
curl -L -o "%FF_INSTALLER%" "https://download.mozilla.org/?product=firefox-latest&os=win64&lang=pl"
if not exist "%FF_INSTALLER%" (
    echo [BLAD] Nie udalo sie pobrac instalatora Firefoksa.
    echo Zainstaluj Firefoksa recznie z https://www.mozilla.org/pl/firefox/new/ i uruchom ten plik ponownie.
    pause & exit /b 1
)

"%FF_INSTALLER%" /S
timeout /t 15 /nobreak >nul
del /f /q "%FF_INSTALLER%" >nul 2>&1

if exist "%ProgramFiles%\Mozilla Firefox\firefox.exe" set "FIREFOX_EXE=%ProgramFiles%\Mozilla Firefox\firefox.exe"
if exist "%ProgramFiles(x86)%\Mozilla Firefox\firefox.exe" set "FIREFOX_EXE=%ProgramFiles(x86)%\Mozilla Firefox\firefox.exe"

if not defined FIREFOX_EXE (
    echo [UWAGA] Nie udalo sie potwierdzic instalacji Firefoksa automatycznie.
    echo Jesli krok logowania sie nie powiedzie, zainstaluj Firefoksa recznie
    echo ze strony https://www.mozilla.org/pl/firefox/new/ i uruchom ten plik ponownie.
    pause
)

:firefox_ok
echo.

REM =====================================================================
REM  4. Pobranie repozytorium carelink-python-client
REM =====================================================================
echo [3/6] Pobieranie repozytorium carelink-python-client...
set "ZIP_PATH=%WORKDIR%carelink-python-client.zip"
curl -L -o "%ZIP_PATH%" "%REPO_ZIP_URL%"
if not exist "%ZIP_PATH%" (
    echo [BLAD] Nie udalo sie pobrac repozytorium. Sprawdz polaczenie z internetem.
    pause & exit /b 1
)

echo [4/6] Rozpakowywanie...
powershell -NoProfile -Command "Expand-Archive -Path '%ZIP_PATH%' -DestinationPath '%WORKDIR%' -Force"
if not exist "%WORKDIR%%REPO_FOLDER_NAME%" (
    echo [BLAD] Nie udalo sie rozpakowac repozytorium.
    pause & exit /b 1
)
del /f /q "%ZIP_PATH%" >nul 2>&1

cd /d "%WORKDIR%%REPO_FOLDER_NAME%"

REM =====================================================================
REM  5. Instalacja bibliotek Python
REM =====================================================================
echo [5/6] Instalowanie bibliotek z requirements.txt...
python -m pip install --upgrade pip >nul
if exist "requirements.txt" (
    python -m pip install -r requirements.txt
) else (
    echo       [UWAGA] Nie znaleziono requirements.txt w repozytorium - instaluje minimalny zestaw.
    python -m pip install selenium requests
)

REM =====================================================================
REM  6. Uruchomienie skryptu logowania
REM =====================================================================
echo.
set /p US_ACCOUNT="Czy to konto CareLink z USA? (t/N): "
set "US_FLAG="
if /i "%US_ACCOUNT%"=="t" set "US_FLAG=--us"

echo.
echo =========================================================
echo  Uruchamiam skrypt logowania - zaraz otworzy sie Firefox.
echo  Zaloguj sie na koncie CareLink (pacjenta lub follower/
echo  carepartner) i rozwiaz reCAPTCHA, jesli sie pojawi.
echo =========================================================
echo.

python carelink_carepartner_api_login.py %US_FLAG%

echo.
if exist "logindata.json" (
    echo =========================================================
    echo  Gotowe! Plik logindata.json zostal utworzony w:
    echo  %WORKDIR%%REPO_FOLDER_NAME%
    echo.
    echo  Skopiuj go w miejsce, na ktore wskazuje "carelink_token_file"
    echo  w Twoim config.json monitora cukru.
    echo =========================================================
) else (
    echo [UWAGA] Nie znaleziono pliku logindata.json - sprawdz powyzej,
    echo czy logowanie zakonczylo sie bez bledow.
)
echo.
pause