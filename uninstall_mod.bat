@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

set "SRC=%~dp0original"
if not exist "%SRC%\DarkSoulsII.exe" (
    echo Error: File cadangan original tidak ditemukan di folder "original".
    echo Jika Anda ingin mengembalikan game ke kondisi awal secara manual:
    echo Buka Steam, klik kanan Dark Souls II ^> Properties ^> Installed Files ^> pilih "Verify integrity of game files".
    pause
    exit /b 1
)

set "TARGET="

call :try_target "%~dp0"
if defined TARGET goto :found_target

pushd "%~dp0.." 2>nul
if not errorlevel 1 (
    call :try_target "!CD!"
    popd
)
if defined TARGET goto :found_target

pushd "%~dp0..\.." 2>nul
if not errorlevel 1 (
    call :try_target "!CD!"
    popd
)
if defined TARGET goto :found_target

for /f "tokens=2* skip=2" %%a in ('reg query "HKCU\Software\Valve\Steam" /v "SteamPath" 2^>nul') do (
    if not defined TARGET call :check_steampath "%%b"
)
if defined TARGET goto :found_target

for /f "tokens=2* skip=2" %%a in ('reg query "HKLM\SOFTWARE\WOW6432Node\Valve\Steam" /v "InstallPath" 2^>nul') do (
    if not defined TARGET call :check_steampath "%%b"
)
if defined TARGET goto :found_target

for /f "tokens=2* skip=2" %%a in ('reg query "HKLM\SOFTWARE\Valve\Steam" /v "InstallPath" 2^>nul') do (
    if not defined TARGET call :check_steampath "%%b"
)
if defined TARGET goto :found_target

for %%d in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if not defined TARGET call :check_drive %%d
)
if defined TARGET goto :found_target

echo Direktori game Dark Souls II tidak terdeteksi otomatis.
set "MANUAL_INPUT="
set /p "MANUAL_INPUT=Masukkan path folder Game Dark Souls II Scholar of the First Sin: "
if not defined MANUAL_INPUT (
    echo Error: Input kosong. Pembatalan uninstal.
    pause
    exit /b 1
)
set "MANUAL_INPUT=!MANUAL_INPUT:"=!"
call :try_target "!MANUAL_INPUT!"
if not defined TARGET (
    echo Error: Folder tersebut bukan instalasi resmi Dark Souls II SotFS.
    echo Pastikan folder berisi DarkSoulsII.exe beserta enc_regulation.bnd.dcx atau GameDataEbl.bdt.
    pause
    exit /b 1
)

:found_target
echo Mengembalikan file original ke: !TARGET!

copy /y "%SRC%\DarkSoulsII.exe" "!TARGET!\DarkSoulsII.exe" >nul
if errorlevel 1 (
    echo Error: Gagal mengembalikan DarkSoulsII.exe. Pastikan game dalam keadaan tertutup.
    pause
    exit /b 1
)

if exist "%SRC%\.mod_only_menu" (
    if exist "!TARGET!\menu\text\english" (
        rd /s /q "!TARGET!\menu\text\english" 2>nul
    )
) else (
    if exist "%SRC%\menu\text\english\" (
        xcopy /e /i /y "%SRC%\menu\text\english\*" "!TARGET!\menu\text\english\" >nul
        if errorlevel 1 (
            echo Error: Gagal mengembalikan folder teks original. Pastikan game tertutup dan jalankan sebagai Administrator.
            pause
            exit /b 1
        )
    )
)

if exist "%SRC%\.mod_only_tex" (
    if exist "!TARGET!\menu\tex\language\english.fetexbnd.dcx" (
        del /f /q "!TARGET!\menu\tex\language\english.fetexbnd.dcx" 2>nul
        if errorlevel 1 (
            echo Error: Gagal menghapus file tekstur mod. Pastikan game tertutup dan jalankan sebagai Administrator.
            pause
            exit /b 1
        )
    )
    rd "!TARGET!\menu\tex\language" 2>nul
    rd "!TARGET!\menu\tex" 2>nul
) else (
    if exist "%SRC%\menu\tex\language\english.fetexbnd.dcx" (
        if not exist "!TARGET!\menu\tex\language" mkdir "!TARGET!\menu\tex\language"
        copy /y "%SRC%\menu\tex\language\english.fetexbnd.dcx" "!TARGET!\menu\tex\language\" >nul
        if errorlevel 1 (
            echo Error: Gagal mengembalikan file tekstur original. Pastikan game tertutup dan jalankan sebagai Administrator.
            pause
            exit /b 1
        )
    )
)

rd "!TARGET!\menu\text" 2>nul
rd "!TARGET!\menu" 2>nul

if exist "%SRC%\ds2sc.dll" (
    if exist "!TARGET!\SeamlessCoop\" (
        copy /y "%SRC%\ds2sc.dll" "!TARGET!\SeamlessCoop\" >nul
        if errorlevel 1 (
            echo Error: Gagal mengembalikan ds2sc.dll. Pastikan game tertutup dan jalankan sebagai Administrator.
            pause
            exit /b 1
        )
    )
)

if exist "%SRC%\english.json" (
    if exist "!TARGET!\SeamlessCoop\locale\" (
        copy /y "%SRC%\english.json" "!TARGET!\SeamlessCoop\locale\" >nul
        if errorlevel 1 (
            echo Error: Gagal mengembalikan english.json Seamless Co-op. Pastikan game tertutup dan jalankan sebagai Administrator.
            pause
            exit /b 1
        )
    )
)

echo.
echo File original bahasa Inggris berhasil dikembalikan.
pause
exit /b 0

:try_target
if defined TARGET goto :eof
set "CAND=%~1"
if not defined CAND goto :eof
set "CAND=!CAND:/=\!"
:strip_cand_slash
if "!CAND:~-1!"=="\" (
    set "CAND=!CAND:~0,-1!"
    if defined CAND goto :strip_cand_slash
)
if not defined CAND goto :eof
if not exist "!CAND!\DarkSoulsII.exe" goto :eof
if exist "!CAND!\enc_regulation.bnd.dcx" set "TARGET=!CAND!" & goto :eof
if exist "!CAND!\GameDataEbl.bdt" set "TARGET=!CAND!" & goto :eof
goto :eof

:check_steampath
set "SP=%~1"
if not defined SP goto :eof
set "SP=!SP:/=\!"
if "!SP:~-1!"=="\" set "SP=!SP:~0,-1!"
call :try_target "!SP!\steamapps\common\Dark Souls II Scholar of the First Sin\Game"
if defined TARGET goto :eof
call :check_vdf "!SP!\steamapps\libraryfolders.vdf"
goto :eof

:check_vdf
set "VDF=%~1"
if not exist "!VDF!" goto :eof
for /f "usebackq tokens=1,* delims=	 " %%a in ("!VDF!") do (
    if /i "%%~a"=="path" (
        if not defined TARGET call :check_vdf_path "%%~b"
    ) else (
        set "VVAL=%%~b"
        if defined VVAL (
            if "!VVAL::=!" neq "!VVAL!" (
                if not defined TARGET call :check_vdf_path "!VVAL!"
            )
        )
    )
)
goto :eof

:check_vdf_path
set "LP=%~1"
if not defined LP goto :eof
set "LP=!LP:\\=\!"
set "LP=!LP:/=\!"
if "!LP:~-1!"=="\" set "LP=!LP:~0,-1!"
call :try_target "!LP!\steamapps\common\Dark Souls II Scholar of the First Sin\Game"
goto :eof

:check_drive
set "D=%~1"
call :try_target "%D%:\SteamLibrary\steamapps\common\Dark Souls II Scholar of the First Sin\Game"
call :try_target "%D%:\steamapps\common\Dark Souls II Scholar of the First Sin\Game"
call :try_target "%D%:\Program Files (x86)\Steam\steamapps\common\Dark Souls II Scholar of the First Sin\Game"
call :try_target "%D%:\Program Files\Steam\steamapps\common\Dark Souls II Scholar of the First Sin\Game"
call :try_target "%D%:\Games\SteamLibrary\steamapps\common\Dark Souls II Scholar of the First Sin\Game"
call :try_target "%D%:\Games\Dark Souls II Scholar of the First Sin\Game"
goto :eof
