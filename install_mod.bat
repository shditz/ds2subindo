@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

set "SRC="
if exist "%~dp0menu\text\english\common.fmg" (
    set "SRC=%~dp0menu\text\english"
)
if not defined SRC (
    if exist "%~dp0DS2Subindo\menu\text\english\common.fmg" (
        set "SRC=%~dp0DS2Subindo\menu\text\english"
    )
)
if not defined SRC (
    if exist "%~dp0dist\menu\text\english\common.fmg" (
        set "SRC=%~dp0dist\menu\text\english"
    )
)

if not defined SRC (
    echo Error: Folder teks terjemahan "menu\text\english" tidak ditemukan.
    echo Pastikan install_mod.bat berada di folder yang sama dengan folder menu.
    pause
    exit /b 1
)

set "SRC_TEX="
if exist "%~dp0menu\tex\language\english.fetexbnd.dcx" (
    set "SRC_TEX=%~dp0menu\tex\language\english.fetexbnd.dcx"
) else if exist "%~dp0DS2Subindo\menu\tex\language\english.fetexbnd.dcx" (
    set "SRC_TEX=%~dp0DS2Subindo\menu\tex\language\english.fetexbnd.dcx"
) else if exist "%~dp0dist\menu\tex\language\english.fetexbnd.dcx" (
    set "SRC_TEX=%~dp0dist\menu\tex\language\english.fetexbnd.dcx"
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
    echo Error: Input kosong. Instalasi dibatalkan.
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
echo Lokasi game terdeteksi: !TARGET!

if not exist "%~dp0original" mkdir "%~dp0original"

if not exist "%~dp0original\DarkSoulsII.exe" (
    if exist "!TARGET!\DarkSoulsII.exe" (
        copy /y "!TARGET!\DarkSoulsII.exe" "%~dp0original\" >nul
        if errorlevel 1 (
            del /f /q "%~dp0original\DarkSoulsII.exe" 2>nul
            echo Error: Gagal membuat cadangan DarkSoulsII.exe di folder "original".
            echo Pastikan folder mod dapat ditulis dan jalankan sebagai Administrator.
            pause
            exit /b 1
        )
    )
)

set "SAME_MENU=0"
if /i "!SRC!"=="!TARGET!\menu\text\english" set "SAME_MENU=1"

if "!SAME_MENU!"=="1" (
    if not exist "%~dp0original\.mod_only_menu" (
        if not exist "%~dp0original\menu\text\english" (
            type nul > "%~dp0original\.mod_only_menu" 2>nul
        )
    )
) else (
    if not exist "%~dp0original\.mod_only_menu" (
        if not exist "!TARGET!\menu\text\english" (
            type nul > "%~dp0original\.mod_only_menu" 2>nul
        ) else if not exist "%~dp0original\menu\text\english" (
            mkdir "%~dp0original\menu\text\english"
            xcopy /e /i /y "!TARGET!\menu\text\english\*" "%~dp0original\menu\text\english\" >nul
            if errorlevel 1 (
                rmdir /s /q "%~dp0original\menu\text\english" 2>nul
                echo Error: Gagal membuat cadangan folder "menu\text\english" di folder "original".
                echo Pastikan folder mod dapat ditulis dan jalankan sebagai Administrator.
                pause
                exit /b 1
            )
        )
    )
)

set "SAME_TEX=0"
if defined SRC_TEX (
    if /i "!SRC_TEX!"=="!TARGET!\menu\tex\language\english.fetexbnd.dcx" set "SAME_TEX=1"
    if "!SAME_TEX!"=="1" (
        if not exist "%~dp0original\.mod_only_tex" (
            if not exist "%~dp0original\menu\tex\language\english.fetexbnd.dcx" (
                type nul > "%~dp0original\.mod_only_tex" 2>nul
            )
        )
    ) else (
        if not exist "%~dp0original\.mod_only_tex" (
            if not exist "!TARGET!\menu\tex\language\english.fetexbnd.dcx" (
                type nul > "%~dp0original\.mod_only_tex" 2>nul
            ) else if not exist "%~dp0original\menu\tex\language\english.fetexbnd.dcx" (
                if not exist "%~dp0original\menu\tex\language" mkdir "%~dp0original\menu\tex\language"
                copy /y "!TARGET!\menu\tex\language\english.fetexbnd.dcx" "%~dp0original\menu\tex\language\" >nul
                if errorlevel 1 (
                    del /f /q "%~dp0original\menu\tex\language\english.fetexbnd.dcx" 2>nul
                    echo Error: Gagal membuat cadangan english.fetexbnd.dcx di folder "original".
                    echo Pastikan folder mod dapat ditulis dan jalankan sebagai Administrator.
                    pause
                    exit /b 1
                )
            )
        )
    )
)

set "SC_SRC="
if exist "!TARGET!\SeamlessCoop\" (
    if not exist "%~dp0original\ds2sc.dll" (
        if exist "!TARGET!\SeamlessCoop\ds2sc.dll" (
            copy /y "!TARGET!\SeamlessCoop\ds2sc.dll" "%~dp0original\" >nul
            if errorlevel 1 (
                del /f /q "%~dp0original\ds2sc.dll" 2>nul
                echo Error: Gagal membuat cadangan ds2sc.dll di folder "original".
                echo Pastikan folder mod dapat ditulis dan jalankan sebagai Administrator.
                pause
                exit /b 1
            )
        )
    )
    if exist "%~dp0SeamlessCoop\locale\english.json" (
        set "SC_SRC=%~dp0SeamlessCoop\locale\english.json"
    ) else if exist "%~dp0DS2Subindo\SeamlessCoop\locale\english.json" (
        set "SC_SRC=%~dp0DS2Subindo\SeamlessCoop\locale\english.json"
    ) else if exist "%~dp0dist\SeamlessCoop\locale\english.json" (
        set "SC_SRC=%~dp0dist\SeamlessCoop\locale\english.json"
    )
    if defined SC_SRC (
        if /i not "!SC_SRC!"=="!TARGET!\SeamlessCoop\locale\english.json" (
            if not exist "%~dp0original\english.json" (
                if exist "!TARGET!\SeamlessCoop\locale\english.json" (
                    copy /y "!TARGET!\SeamlessCoop\locale\english.json" "%~dp0original\" >nul
                    if errorlevel 1 (
                        del /f /q "%~dp0original\english.json" 2>nul
                        echo Error: Gagal membuat cadangan english.json di folder "original".
                        echo Pastikan folder mod dapat ditulis dan jalankan sebagai Administrator.
                        pause
                        exit /b 1
                    )
                )
            )
        )
    )
)

if not "!SAME_MENU!"=="1" (
    if not exist "!TARGET!\menu\text\english" mkdir "!TARGET!\menu\text\english"
    xcopy /e /i /y "!SRC!\*.fmg" "!TARGET!\menu\text\english\" >nul
    if errorlevel 1 (
        echo Error: Gagal menyalin file teks mod.
        echo Pastikan game dalam keadaan tertutup dan jalankan sebagai Administrator.
        pause
        exit /b 1
    )
)

if defined SRC_TEX (
    if not "!SAME_TEX!"=="1" (
        if not exist "!TARGET!\menu\tex\language" mkdir "!TARGET!\menu\tex\language"
        copy /y "!SRC_TEX!" "!TARGET!\menu\tex\language\" >nul
        if errorlevel 1 (
            echo Error: Gagal menyalin file tekstur menu mod.
            echo Pastikan game dalam keadaan tertutup dan jalankan sebagai Administrator.
            pause
            exit /b 1
        )
    )
)

if defined SC_SRC (
    if /i not "!SC_SRC!"=="!TARGET!\SeamlessCoop\locale\english.json" (
        if not exist "!TARGET!\SeamlessCoop\locale" mkdir "!TARGET!\SeamlessCoop\locale"
        copy /y "!SC_SRC!" "!TARGET!\SeamlessCoop\locale\" >nul
        if errorlevel 1 (
            echo Error: Gagal menyalin file lokalisasi Seamless Co-op.
            echo Pastikan game dalam keadaan tertutup dan jalankan sebagai Administrator.
            pause
            exit /b 1
        )
    )
)

echo Menerapkan patch teks dan Seamless Co-op...
setlocal disabledelayedexpansion
rem DS2_PATCH_BEGIN
powershell -NoProfile -ExecutionPolicy Bypass -EncodedCommand JABQAHIAbwBnAHIAZQBzAHMAUAByAGUAZgBlAHIAZQBuAGMAZQA9ACcAUwBpAGwAZQBuAHQAbAB5AEMAbwBuAHQAaQBuAHUAZQAnADsAJABFAHIAcgBvAHIAQQBjAHQAaQBvAG4AUAByAGUAZgBlAHIAZQBuAGMAZQA9ACcAUwB0AG8AcAAnAAoAdAByAHkAewAKACQAdAA9ACQAZQBuAHYAOgBUAEEAUgBHAEUAVAA7AGkAZgAoAC0AbgBvAHQAJAB0ACAALQBvAHIAIAAtAG4AbwB0ACgAVABlAHMAdAAtAFAAYQB0AGgAIAAtAEwAaQB0AGUAcgBhAGwAUABhAHQAaAAgACQAdAApACkAewBlAHgAaQB0ACAAMQB9AAoAJABlAD0AWwBUAGUAeAB0AC4ARQBuAGMAbwBkAGkAbgBnAF0AOgA6AEcAZQB0AEUAbgBjAG8AZABpAG4AZwAoADIAOAA1ADkAMQApADsAJAB1AD0AWwBUAGUAeAB0AC4ARQBuAGMAbwBkAGkAbgBnAF0AOgA6AFUAbgBpAGMAbwBkAGUAOwAkAG8APQBbAFMAdAByAGkAbgBnAEMAbwBtAHAAYQByAGkAcwBvAG4AXQA6ADoATwByAGQAaQBuAGEAbAAKACQAeAA9AEoAbwBpAG4ALQBQAGEAdABoACAAJAB0ACAAJwBEAGEAcgBrAFMAbwB1AGwAcwBJAEkALgBlAHgAZQAnADsAaQBmACgALQBuAG8AdAAoAFQAZQBzAHQALQBQAGEAdABoACAALQBMAGkAdABlAHIAYQBsAFAAYQB0AGgAIAAkAHgAKQApAHsAZQB4AGkAdAAgADEAfQAKACQAcwA9AFsASQBPAC4ARgBpAGwAZQBdADoAOgBSAGUAYQBkAEEAbABsAFQAZQB4AHQAKAAkAHgALAAkAGUAKQAKACQAZwA9ACcAZwBhAG0AZQBkAGEAdABhADoALwAnADsAJABrAD0AJwBkAGwAYwBfAGQAYQB0AGEAOgAvACcAOwAkAHcAPQAnAC4ALwAvAC8ALwAvAC8ALwAvAC8AJwA7ACQAZgA9ACcAJQBzAC4AZgBlAHQAZQB4AGIAbgBkAC4AZABjAHgAJwA7ACQAdgA9ACcATQBlAG4AdQAvAFQAZQB4AHQALwAlAHMALwAnAAoAJABlAHAAPQBAACgAQAAoACcAdABlAHgAdAA6AC8AVABlAHgAdAAvACUAcwAvACUAcwAuAGYAbQBnACcALAAnAG0AZQBuAHUALwAvAHQAZQB4AHQALwAlAHMALwAlAHMALgBmAG0AZwAnACkALABAACgAJwB0AGUAeAB0ADoALwBUAGUAeAB0AC8AJQBzAC8AUwB0AGEAZgBmAHIAbwBsAGwALgBmAG0AZwAnACwAJwBtAGUAbgB1AC8ALwB0AGUAeAB0AC8AJQBzAC8AUwB0AGEAZgBmAHIAbwBsAGwALgBmAG0AZwAnACkALABAACgAKAAnAG0AZQBuAHUAOgAvAHQAZQB4AC8AbABhAG4AZwB1AGEAZwBlAC8AJwArACQAZgApACwAKAAnAG0AZQBuAHUALwAvAHQAZQB4AC8AbABhAG4AZwB1AGEAZwBlAC8AJwArACQAZgApACkALABAACgAKAAkAGcAKwAnAG0AZQBuAHUALwB0AGUAeAAvAGwAYQBuAGcAdQBhAGcAZQAvACcAKwAkAGYAKQAsACgAJAB3ACsAJwBtAGUAbgB1AC8AdABlAHgALwBsAGEAbgBnAHUAYQBnAGUALwAnACsAJABmACkAKQAsAEAAKAAoACQAZwArACQAdgArACcAdABhAGwAawAvACUAcwAuAGYAbQBnACcAKQAsACgAJAB3ACsAJAB2ACsAJwB0AGEAbABrAC8AJQBzAC4AZgBtAGcAJwApACkALABAACgAKAAkAGcAKwAkAHYAKwAnAGIAbABvAG8AZABtAGUAcwAvACUAcwAuAGYAbQBnACcAKQAsACgAJAB3ACsAJAB2ACsAJwBiAGwAbwBvAGQAbQBlAHMALwAlAHMALgBmAG0AZwAnACkAKQAsAEAAKAAoACQAawArACQAdgArACcAdABhAGwAawAvACUAcwAuAGYAbQBnACcAKQAsACgAJAB3ACsAJAB2ACsAJwB0AGEAbABrAC8AJQBzAC4AZgBtAGcAJwApACkALABAACgAKAAkAGsAKwAkAHYAKwAnAGIAbABvAG8AZABtAGUAcwAvACUAcwAuAGYAbQBnACcAKQAsACgAJAB3ACsAJAB2ACsAJwBiAGwAbwBvAGQAbQBlAHMALwAlAHMALgBmAG0AZwAnACkAKQApAAoAJABtAD0AJABmAGEAbABzAGUAOwBmAG8AcgBlAGEAYwBoACgAJABwACAAaQBuACAAJABlAHAAKQB7ACQAYQA9ACQAZQAuAEcAZQB0AFMAdAByAGkAbgBnACgAJAB1AC4ARwBlAHQAQgB5AHQAZQBzACgAJABwAFsAMABdACsAWwBjAGgAYQByAF0AMAApACkAOwAkAGIAPQAkAGUALgBHAGUAdABTAHQAcgBpAG4AZwAoACQAdQAuAEcAZQB0AEIAeQB0AGUAcwAoACQAcABbADEAXQArAFsAYwBoAGEAcgBdADAAKQApADsAJABpAD0AJABzAC4ASQBuAGQAZQB4AE8AZgAoACQAYQAsACQAbwApADsAaQBmACgAJABpACAALQBnAGUAIAAwACkAewAkAHMAPQAkAHMALgBTAHUAYgBzAHQAcgBpAG4AZwAoADAALAAkAGkAKQArACQAYgArACQAcwAuAFMAdQBiAHMAdAByAGkAbgBnACgAJABpACsAJABhAC4ATABlAG4AZwB0AGgAKQA7ACQAbQA9ACQAdAByAHUAZQB9AH0ACgBpAGYAKAAkAG0AKQB7AFsASQBPAC4ARgBpAGwAZQBdADoAOgBXAHIAaQB0AGUAQQBsAGwAVABlAHgAdAAoACQAeAAsACQAcwAsACQAZQApAH0ACgBmAG8AcgBlAGEAYwBoACgAJABwACAAaQBuACAAJABlAHAAKQB7ACQAYwA9ACQAZQAuAEcAZQB0AFMAdAByAGkAbgBnACgAJAB1AC4ARwBlAHQAQgB5AHQAZQBzACgAJABwAFsAMQBdACsAWwBjAGgAYQByAF0AMAApACkAOwBpAGYAKAAkAHMALgBJAG4AZABlAHgATwBmACgAJABjACwAJABvACkAIAAtAGwAdAAgADAAKQB7AGUAeABpAHQAIAAyAH0AfQAKAGUAeABpAHQAIAAwAAoAfQBjAGEAdABjAGgAewBlAHgAaQB0ACAANAB9AA==
if errorlevel 1 goto :patch_fail
if not exist "%TARGET%\SeamlessCoop\ds2sc.dll" goto :patch_ok
powershell -NoProfile -ExecutionPolicy Bypass -EncodedCommand JABQAHIAbwBnAHIAZQBzAHMAUAByAGUAZgBlAHIAZQBuAGMAZQA9ACcAUwBpAGwAZQBuAHQAbAB5AEMAbwBuAHQAaQBuAHUAZQAnADsAJABFAHIAcgBvAHIAQQBjAHQAaQBvAG4AUAByAGUAZgBlAHIAZQBuAGMAZQA9ACcAUwB0AG8AcAAnAAoAdAByAHkAewAKACQAdAA9ACQAZQBuAHYAOgBUAEEAUgBHAEUAVAA7AGkAZgAoAC0AbgBvAHQAJAB0ACAALQBvAHIAIAAtAG4AbwB0ACgAVABlAHMAdAAtAFAAYQB0AGgAIAAtAEwAaQB0AGUAcgBhAGwAUABhAHQAaAAgACQAdAApACkAewBlAHgAaQB0ACAAMQB9AAoAJABkAD0ASgBvAGkAbgAtAFAAYQB0AGgAIAAkAHQAIAAnAFMAZQBhAG0AbABlAHMAcwBDAG8AbwBwAFwAZABzADIAcwBjAC4AZABsAGwAJwA7AGkAZgAoAC0AbgBvAHQAKABUAGUAcwB0AC0AUABhAHQAaAAgAC0ATABpAHQAZQByAGEAbABQAGEAdABoACAAJABkACkAKQB7AGUAeABpAHQAIAAwAH0ACgAkAGUAPQBbAFQAZQB4AHQALgBFAG4AYwBvAGQAaQBuAGcAXQA6ADoARwBlAHQARQBuAGMAbwBkAGkAbgBnACgAMgA4ADUAOQAxACkAOwAkAHUAPQBbAFQAZQB4AHQALgBFAG4AYwBvAGQAaQBuAGcAXQA6ADoAVQBuAGkAYwBvAGQAZQA7ACQAbwA9AFsAUwB0AHIAaQBuAGcAQwBvAG0AcABhAHIAaQBzAG8AbgBdADoAOgBPAHIAZABpAG4AYQBsADsAJAB6AD0AWwBzAHQAcgBpAG4AZwBdAFsAYwBoAGEAcgBdADAAKwBbAGMAaABhAHIAXQAwAAoAJABzAD0AWwBJAE8ALgBGAGkAbABlAF0AOgA6AFIAZQBhAGQAQQBsAGwAVABlAHgAdAAoACQAZAAsACQAZQApAAoAJABkAHAAPQBAACgAQAAoACcAIwBjAFsARgBGADUAQgBDAEUARgBBAF0AWwBBAG4AbgBvAHUAbgBjAGUAbQBlAG4AdAAgAC0ALQAgAFQAaABpAHMAIABpAHMAIABhACAAZgByAGUAZQAgAG0AbwBkAF0AIwBjACcALAAnACMAYwBbAEYARgA1AEIAQwBFAEYAQQBdAFsAUABlAG4AZwB1AG0AdQBtAGEAbgA6ACAATQBvAGQAIABJAG4AaQAgAEcAcgBhAHQAaQBzAF0AIwBjACcALAAiACMAYwBbAEYARgA1AEIAQwBFAEYAQQBdAFsAUABlAG4AZwB1AG0AdQBtAGEAbgA6ACAATQBvAGQAIABJAG4AaQAgAEcAcgBhAHQAaQBzAF0AIwBjAGAAbgAjAGMAWwBGAEYARgA1AEEAOQBCADgAXQBEAFMAMgA6ACAAUwBlAGEAbQBsAGUAcwBzACAAQwBvAC0AbwBwACAAfAAgAFMAdQBiACAASQBuAGQAbwA6ACAAUwBoAEQAaQB0AHoAIwBjAGAAbgAjAGMAWwBGAEYARgBGAEYARgBGAEYAXQBKAGkAawBhACAAbQBlAG0AYgBhAHkAYQByACAAdQBuAHQAdQBrACAAbQBvAGQAIABpAG4AaQAsACAAQQBuAGQAYQAgAHQAZQBsAGEAaAAgAGQAaQB0AGkAcAB1ACEAIwBjACIALAAxADgANAApACwAQAAoACcAIwBjAFsARgBGADIAQgBCAEEANwBEAF0AVABoAGkAcwAgAG0AbwBkACAAaABhAHMAIABuAG8AIABhAG4AdABpAC0AYwBoAGUAYQB0AC4AJwAsACcAIwBjAFsARgBGADIAQgBCAEEANwBEAF0ATQBvAGQAIABpAG4AaQAgAHQAaQBkAGEAawAgAG0AZQBtAGkAbABpAGsAaQAgAGEAbgB0AGkALQBjAGgAZQBhAHQALgAnACwAIgAjAGMAWwBGAEYAMgBCAEIAQQA3AEQAXQBNAG8AZAAgAGkAbgBpACAAdABpAGQAYQBrACAAbQBlAG0AaQBsAGkAawBpACAAYQBuAHQAaQAtAGMAaABlAGEAdAAuACMAYwBgAG4AIwBjAFsARgBGADIAQgBCAEEANwBEAF0ASABhAHIAYQBwACAAaABvAHIAbQBhAHQAaQAgAHAAZQBtAGEAaQBuACAAbABhAGkAbgAgAHMAYQBhAHQAIABvAG4AbABpAG4AZQAuACMAYwBgAG4AIwBjAFsARgBGADIAQgBCAEEANwBEAF0ASgBhAG4AZwBhAG4AIABjAHUAcgBhAG4AZwAgAHMAYQBhAHQAIABpAG4AdgBhAHMAaQAgAGEAbgB0AGEAcgAgAHAAZQBtAGEAaQBuAC4AIwBjACIALAAxADUANwApACwAQAAoACcAIwBjAFsARgBGAEYARgBGAEYARgBGAF0ARABhAHIAawAgAFMAbwB1AGwAcwAgADIAIABTAGUAYQBtAGwAZQBzAHMAIABDAG8ALQBvAHAAIAB2ADAALgAwAC4AOAAgAGIAeQAgAFkAdQBpACAAWwAgAEEATABQAEgAQQAgAFYARQBSAC4AIABdACcALAAnACMAYwBbAEYARgBGAEYARgBGAEYARgBdAEQAYQByAGsAIABTAG8AdQBsAHMAIAAyACAAUwBlAGEAbQBsAGUAcwBzACAAQwBvAC0AbwBwACAAdgAwAC4AMAAuADgAIABiAHkAIABZAHUAaQAgAFsASQBuAGQAbwA6ACAAUwBoAEQAaQB0AHoAXQAnACwAIgAjAGMAWwBGAEYARgBGAEYARgBGAEYAXQBEAGEAcgBrACAAUwBvAHUAbABzACAAMgAgAFMAZQBhAG0AbABlAHMAcwAgAEMAbwAtAG8AcAAgAHYAMAAuADAALgA4ACAAYgB5ACAAWQB1AGkAIABbAEkAbgBkAG8AOgAgAFMAaABEAGkAdAB6AF0AIgAsADYAOAApACkACgAkAG0APQAkAGYAYQBsAHMAZQA7AGYAbwByAGUAYQBjAGgAKAAkAHAAIABpAG4AIAAkAGQAcAApAHsAJAByAGIAPQAkAHUALgBHAGUAdABCAHkAdABlAHMAKAAkAHAAWwAyAF0AKQA7ACQAbQBsAD0AJABwAFsAMwBdACoAMgA7AGkAZgAoACQAcgBiAC4ATABlAG4AZwB0AGgAIAAtAGcAdAAgACQAbQBsACkAewBlAHgAaQB0ACAAMwB9ADsAJABwAGQAPQBOAGUAdwAtAE8AYgBqAGUAYwB0ACAAYgB5AHQAZQBbAF0AIAAkAG0AbAA7AFsAQQByAHIAYQB5AF0AOgA6AEMAbwBwAHkAKAAkAHIAYgAsADAALAAkAHAAZAAsADAALAAkAHIAYgAuAEwAZQBuAGcAdABoACkAOwAkAHIAcwA9ACQAZQAuAEcAZQB0AFMAdAByAGkAbgBnACgAJABwAGQAKQA7AGkAZgAoACQAcwAuAEkAbgBkAGUAeABPAGYAKAAkAHIAcwAsACQAbwApACAALQBnAGUAIAAwACkAewBjAG8AbgB0AGkAbgB1AGUAfQA7ACQAaQA9ACQAcwAuAEkAbgBkAGUAeABPAGYAKAAkAGUALgBHAGUAdABTAHQAcgBpAG4AZwAoACQAdQAuAEcAZQB0AEIAeQB0AGUAcwAoACQAcABbADAAXQApACkALAAkAG8AKQA7AGkAZgAoACQAaQAgAC0AbAB0ACAAMAApAHsAJABpAD0AJABzAC4ASQBuAGQAZQB4AE8AZgAoACQAZQAuAEcAZQB0AFMAdAByAGkAbgBnACgAJAB1AC4ARwBlAHQAQgB5AHQAZQBzACgAJABwAFsAMQBdACkAKQAsACQAbwApAH0AOwBpAGYAKAAkAGkAIAAtAGcAZQAgADAAIAAtAGEAbgBkACAAKAAkAGkAKwAkAG0AbAArADIAKQAgAC0AbABlACAAJABzAC4ATABlAG4AZwB0AGgAIAAtAGEAbgBkACAAJABzAC4AUwB1AGIAcwB0AHIAaQBuAGcAKAAkAGkAKwAkAG0AbAAsADIAKQAgAC0AZQBxACAAJAB6ACkAewAkAHMAPQAkAHMALgBTAHUAYgBzAHQAcgBpAG4AZwAoADAALAAkAGkAKQArACQAcgBzACsAJABzAC4AUwB1AGIAcwB0AHIAaQBuAGcAKAAkAGkAKwAkAG0AbAApADsAJABtAD0AJAB0AHIAdQBlAH0AfQAKAGkAZgAoACQAbQApAHsAWwBJAE8ALgBGAGkAbABlAF0AOgA6AFcAcgBpAHQAZQBBAGwAbABUAGUAeAB0ACgAJABkACwAJABzACwAJABlACkAfQAKAGUAeABpAHQAIAAwAAoAfQBjAGEAdABjAGgAewBlAHgAaQB0ACAANAB9AA==
if errorlevel 1 goto :patch_fail
set "DS2_SC_TEX=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"
powershell -NoProfile -ExecutionPolicy Bypass -EncodedCommand JABQAHIAbwBnAHIAZQBzAHMAUAByAGUAZgBlAHIAZQBuAGMAZQA9ACcAUwBpAGwAZQBuAHQAbAB5AEMAbwBuAHQAaQBuAHUAZQAnADsAJABFAHIAcgBvAHIAQQBjAHQAaQBvAG4AUAByAGUAZgBlAHIAZQBuAGMAZQA9ACcAUwB0AG8AcAAnAAoAdAByAHkAewAKACQAdAA9ACQAZQBuAHYAOgBUAEEAUgBHAEUAVAA7AGkAZgAoAC0AbgBvAHQAJAB0ACAALQBvAHIAIAAtAG4AbwB0ACgAVABlAHMAdAAtAFAAYQB0AGgAIAAtAEwAaQB0AGUAcgBhAGwAUABhAHQAaAAgACQAdAApACkAewBlAHgAaQB0ACAAMQB9AAoAJABkAD0ASgBvAGkAbgAtAFAAYQB0AGgAIAAkAHQAIAAnAFMAZQBhAG0AbABlAHMAcwBDAG8AbwBwAFwAZABzADIAcwBjAC4AZABsAGwAJwA7AGkAZgAoAC0AbgBvAHQAKABUAGUAcwB0AC0AUABhAHQAaAAgAC0ATABpAHQAZQByAGEAbABQAGEAdABoACAAJABkACkAKQB7AGUAeABpAHQAIAAwAH0ACgAkAHQAeAA9ACQAZQBuAHYAOgBEAFMAMgBfAFMAQwBfAFQARQBYADsAaQBmACgALQBuAG8AdAAkAHQAeAApAHsAZQB4AGkAdAAgADUAfQAKACQAZQA9AFsAVABlAHgAdAAuAEUAbgBjAG8AZABpAG4AZwBdADoAOgBHAGUAdABFAG4AYwBvAGQAaQBuAGcAKAAyADgANQA5ADEAKQA7ACQAbwA9AFsAUwB0AHIAaQBuAGcAQwBvAG0AcABhAHIAaQBzAG8AbgBdADoAOgBPAHIAZABpAG4AYQBsAAoAJABtAHMAPQBOAGUAdwAtAE8AYgBqAGUAYwB0ACAASQBPAC4ATQBlAG0AbwByAHkAUwB0AHIAZQBhAG0AKAAsAFsAQwBvAG4AdgBlAHIAdABdADoAOgBGAHIAbwBtAEIAYQBzAGUANgA0AFMAdAByAGkAbgBnACgAJAB0AHgAKQApAAoAJABkAGYAPQBOAGUAdwAtAE8AYgBqAGUAYwB0ACAASQBPAC4AQwBvAG0AcAByAGUAcwBzAGkAbwBuAC4ARABlAGYAbABhAHQAZQBTAHQAcgBlAGEAbQAoACQAbQBzACwAWwBJAE8ALgBDAG8AbQBwAHIAZQBzAHMAaQBvAG4ALgBDAG8AbQBwAHIAZQBzAHMAaQBvAG4ATQBvAGQAZQBdADoAOgBEAGUAYwBvAG0AcAByAGUAcwBzACkACgAkAGIAdQBmAD0ATgBlAHcALQBPAGIAagBlAGMAdAAgAGIAeQB0AGUAWwBdACAAOAAzADIAMAA7ACQAcgBkAD0AMAAKAHcAaABpAGwAZQAoACQAcgBkACAALQBsAHQAIAA4ADMAMgAwACkAewAkAG4APQAkAGQAZgAuAFIAZQBhAGQAKAAkAGIAdQBmACwAJAByAGQALAA4ADMAMgAwAC0AJAByAGQAKQA7AGkAZgAoACQAbgAgAC0AbABlACAAMAApAHsAYgByAGUAYQBrAH0AOwAkAHIAZAArAD0AJABuAH0ACgAkAGQAZgAuAEQAaQBzAHAAbwBzAGUAKAApADsAJABtAHMALgBEAGkAcwBwAG8AcwBlACgAKQA7AGkAZgAoACQAcgBkACAALQBuAGUAIAA4ADMAMgAwACkAewBlAHgAaQB0ACAANgB9AAoAJABoAGQAcgA9ACQAZQAuAEcAZQB0AFMAdAByAGkAbgBnACgAJABiAHUAZgAsADAALAAxADIAOAApADsAJABiADAAPQAkAGUALgBHAGUAdABTAHQAcgBpAG4AZwAoACQAYgB1AGYALAAxADIAOAAsADQAMAA5ADYAKQA7ACQAYgAxAD0AJABlAC4ARwBlAHQAUwB0AHIAaQBuAGcAKAAkAGIAdQBmACwANAAyADIANAAsADQAMAA5ADYAKQAKACQAcwA9AFsASQBPAC4ARgBpAGwAZQBdADoAOgBSAGUAYQBkAEEAbABsAFQAZQB4AHQAKAAkAGQALAAkAGUAKQAKACQAaQAwAD0AJABzAC4ASQBuAGQAZQB4AE8AZgAoACQAaABkAHIALAAkAG8AKQAKAHcAaABpAGwAZQAoACQAaQAwACAALQBnAGUAIAAwACAALQBhAG4AZAAgACgAKAAkAGkAMAArADgANAA0ADgAKQAgAC0AZwB0ACAAJABzAC4ATABlAG4AZwB0AGgAIAAtAG8AcgAgAC0AbgBvAHQAWwBzAHQAcgBpAG4AZwBdADoAOgBFAHEAdQBhAGwAcwAoACQAcwAuAFMAdQBiAHMAdAByAGkAbgBnACgAJABpADAAKwA0ADIAMgA0ACwAMQAyADgAKQAsACQAaABkAHIALAAkAG8AKQApACkAewAkAGkAMAA9ACQAcwAuAEkAbgBkAGUAeABPAGYAKAAkAGgAZAByACwAJABpADAAKwAxACwAJABvACkAfQAKAGkAZgAoACQAaQAwACAALQBsAHQAIAAwACkAewBlAHgAaQB0ACAANwB9AAoAJABjADAAPQAkAHMALgBTAHUAYgBzAHQAcgBpAG4AZwAoACQAaQAwACsAMQAyADgALAA0ADAAOQA2ACkAOwAkAGMAMQA9ACQAcwAuAFMAdQBiAHMAdAByAGkAbgBnACgAJABpADAAKwA0ADMANQAyACwANAAwADkANgApAAoAJABzAGgAPQBbAFMAZQBjAHUAcgBpAHQAeQAuAEMAcgB5AHAAdABvAGcAcgBhAHAAaAB5AC4AUwBIAEEAMgA1ADYAXQA6ADoAQwByAGUAYQB0AGUAKAApAAoAJABoADAAPQAoAFsAQgBpAHQAQwBvAG4AdgBlAHIAdABlAHIAXQA6ADoAVABvAFMAdAByAGkAbgBnACgAJABzAGgALgBDAG8AbQBwAHUAdABlAEgAYQBzAGgAKAAkAGUALgBHAGUAdABCAHkAdABlAHMAKAAkAGMAMAApACkAKQAuAFIAZQBwAGwAYQBjAGUAKAAnAC0AJwAsACcAJwApACkALgBUAG8ATABvAHcAZQByAEkAbgB2AGEAcgBpAGEAbgB0ACgAKQAKACQAaAAxAD0AKABbAEIAaQB0AEMAbwBuAHYAZQByAHQAZQByAF0AOgA6AFQAbwBTAHQAcgBpAG4AZwAoACQAcwBoAC4AQwBvAG0AcAB1AHQAZQBIAGEAcwBoACgAJABlAC4ARwBlAHQAQgB5AHQAZQBzACgAJABjADEAKQApACkALgBSAGUAcABsAGEAYwBlACgAJwAtACcALAAnACcAKQApAC4AVABvAEwAbwB3AGUAcgBJAG4AdgBhAHIAaQBhAG4AdAAoACkACgAkAHMAaAAuAEQAaQBzAHAAbwBzAGUAKAApAAoAJABrAGUAPQAoACQAaQAwACAALQBlAHEAIAAyADYANwAxADUAMwA2ACAALQBhAG4AZAAgACQAcwAuAEwAZQBuAGcAdABoACAALQBlAHEAIAAyADkANgA3ADUANQAzADYAKQAKAGkAZgAoAC0AbgBvAHQAWwBzAHQAcgBpAG4AZwBdADoAOgBFAHEAdQBhAGwAcwAoACQAYwAwACwAJABiADAALAAkAG8AKQApAHsAaQBmACgAJABoADAAIAAtAG4AZQAgACcAYgA3ADkANABjAGMAOAAyADAAZQAyAGIANwA0ADYAMABlADMAZAA2AGIAMwA0AGYANQBkADkAMABmAGMAZgA4AGEAOQBkAGIAMgBiADYANQA0ADYAYwBkADIANgAzAGQAMAAxAGEAYwA4AGQAYwAxADkAMwBmAGUAMAAxAGEAMQAnACAALQBhAG4AZAAgAC0AbgBvAHQAJABrAGUAKQB7AGUAeABpAHQAIAA4AH0AfQAKAGkAZgAoAC0AbgBvAHQAWwBzAHQAcgBpAG4AZwBdADoAOgBFAHEAdQBhAGwAcwAoACQAYwAxACwAJABiADEALAAkAG8AKQApAHsAaQBmACgAJABoADEAIAAtAG4AZQAgACcAZAA1ADQAMAA0ADgAYQAzAGYAZAAzADMAZgAyADIAMQA5AGIANQA3ADkAOABhAGQANwAzADAAMQAzADQAMAA4AGYAZQA1AGIANwA3AGMAOQAzADgANgBmAGUAMQAzADYAZQA3ADMAYQBhAGQANQA0ADcAYQBkAGQAMwA2ADcAZgAnACAALQBhAG4AZAAgAC0AbgBvAHQAJABrAGUAKQB7AGUAeABpAHQAIAA4AH0AfQAKAGkAZgAoAC0AbgBvAHQAWwBzAHQAcgBpAG4AZwBdADoAOgBFAHEAdQBhAGwAcwAoACQAYwAwACwAJABiADAALAAkAG8AKQAgAC0AbwByACAALQBuAG8AdABbAHMAdAByAGkAbgBnAF0AOgA6AEUAcQB1AGEAbABzACgAJABjADEALAAkAGIAMQAsACQAbwApACkAewAkAHMAPQAkAHMALgBTAHUAYgBzAHQAcgBpAG4AZwAoADAALAAkAGkAMAArADEAMgA4ACkAKwAkAGIAMAArACQAaABkAHIAKwAkAGIAMQArACQAcwAuAFMAdQBiAHMAdAByAGkAbgBnACgAJABpADAAKwA4ADQANAA4ACkAOwBbAEkATwAuAEYAaQBsAGUAXQA6ADoAVwByAGkAdABlAEEAbABsAFQAZQB4AHQAKAAkAGQALAAkAHMALAAkAGUAKQB9AAoAZQB4AGkAdAAgADAACgB9AGMAYQB0AGMAaAB7AGUAeABpAHQAIAA0AH0A
set "DS2_SC_TEX="
if errorlevel 1 goto :patch_fail
rem DS2_PATCH_END
:patch_ok
echo.
echo Mod Bahasa Indonesia Dark Souls 2 SOTFS berhasil dipasang!
echo Buka game, masuk ke Game Options (Opsi Permainan), dan pastikan opsi Subtitle = AKTIF.
endlocal
pause
exit /b 0

:patch_fail
set "DS2_SC_TEX="
endlocal
echo.
echo Error: Gagal menerapkan patch otomatis pada DarkSoulsII.exe atau ds2sc.dll.
echo Pastikan game tidak sedang berjalan dan antivirus tidak memblokir file.
pause
exit /b 1

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
