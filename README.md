# Dark Souls II: Scholar of the First Sin - Installer & Uninstaller Mod Bahasa Indonesia

Repositori ini menyediakan skrip otomasi resmi untuk memasang dan mencopot **Mod Subtitle dan Lokalisasi Bahasa Indonesia untuk Dark Souls II: Scholar of the First Sin** karya **ShDitz**.

Berkas paket mod utama (teks dan tekstur) dapat diunduh melalui halaman resmi Nexus Mods. Skrip pada repositori ini dirancang untuk memudahkan Anda memasang mod secara otomatis dengan satu klik tanpa perlu menyalin berkas secara manual ataupun membongkar arsip game sebesar 18 GB menggunakan UXM.

## Mengapa Skrip Ini Ada di GitHub?

Sesuai ketentuan keamanan di Nexus Mods, paket arsip utama mod tidak menyertakan berkas eksekusi seperti file batch (.bat) agar terhindar dari deteksi keliru sistem keamanan berkas.

Bagi pemain yang menginginkan proses instalasi praktis dan otomatis, Anda dapat mengunduh berkas `install_mod.bat` dan `uninstall_mod.bat` dari repositori ini untuk mendampingi berkas mod dari Nexus Mods.



## Fitur Skrip Installer (`install_mod.bat`)

- **Deteksi Folder Otomatis**: Mencari letak instalasi game Dark Souls II SotFS di komputer Anda secara otomatis melalui folder lokal, Steam registry, maupun pemindaian partisi drive.
- **Pencadangan Aman**: Otomatis mencadangkan berkas asli game ke dalam folder `original` sebelum modifikasi dilakukan.
- **Pemasangan Teks Penuh**: Menyalin seluruh 70 berkas terjemahan Bahasa Indonesia (`menu/text/english/*.fmg`) mencakup dialog NPC, narasi pembuka, lore deskripsi item, antarmuka menu, dan pesan lantai.
- **Pemasangan Tekstur UI & Spanduk**: Memasang paket tekstur `english.fetexbnd.dcx` yang berisi tombol menu utama berbahasa Indonesia serta spanduk in-game seperti `KAMU MATI` dan `BONFIRE DINYALAKAN`.
- **Patch Tanpa Bongkar Game**: Mengaktifkan pembacaan teks dan tekstur eksternal pada `DarkSoulsII.exe` secara aman tanpa perlu mengekstrak arsip besar game.
- **Integrasi Seamless Co-op**: Jika Anda bermain menggunakan mod Seamless Co-op, skrip akan otomatis menerjemahkan teks co-op serta memperbarui tombol `Informasi Mod` pada `ds2sc.dll`.



## Fitur Skrip Uninstaller (`uninstall_mod.bat`)

- Mengembalikan file executable `DarkSoulsII.exe` dan seluruh berkas asli langsung dari folder cadangan `original`.
- Membersihkan berkas teks dan tekstur modifikasi sehingga game kembali murni ke versi standar berbahasa Inggris.



## Panduan Pemasangan

1. Unduh arsip mod utama (`DS2Subtitleindo.zip`) dari halaman Nexus Mods.
2. Ekstrak arsip ZIP tersebut ke dalam suatu folder di komputer Anda. Anda akan melihat folder `menu` (dan folder `SeamlessCoop` jika menggunakan co-op).
3. Unduh berkas `install_mod.bat` dan `uninstall_mod.bat` dari repositori ini, lalu letakkan di folder yang sama dengan folder `menu` hasil ekstrak tadi.
4. Pastikan game Dark Souls II sedang tidak berjalan.
5. Jalankan `install_mod.bat` dengan klik ganda. Jika game Anda berada di partisi sistem Program Files, klik kanan lalu pilih "Run as administrator".
6. Tunggu hingga proses selesai dengan notifikasi sukses di layar.
7. Jalankan game Dark Souls II, masuk ke menu Pengaturan Permainan (Game Options), lalu pastikan opsi **Subtitle** diatur ke **Aktif**.



## Cara Menghapus Mod

Jika ingin mengembalikan game ke kondisi semula:

1. Pastikan game sedang tidak berjalan.
2. Klik ganda pada `uninstall_mod.bat` di folder kerja Anda. Berkas asli dari folder `original` akan otomatis dikembalikan.
3. Sebagai alternatif via Steam, Anda dapat membuka Steam Library, klik kanan pada Dark Souls II > Properties > Installed Files > pilih "Verify integrity of game files".



## Catatan Mode Permainan & Keamanan

Mod ini berfokus pada terjemahan teks dan pembaruan visual tekstur antarmuka tanpa mengubah parameter gameplay, file save, maupun status karakter.

- **Mode Offline (Single Player)**: Sangat aman digunakan.
- **Mode Seamless Co-op**: Sangat aman karena berjalan melalui jaringan privat P2P Steam tanpa terhubung ke server FromSoftware.
- **Mode Vanilla Online**: Jika Anda ingin bermain PvP atau Co-op di server publik resmi FromSoftware tanpa modifikasi berkas game, disarankan menjalankan `uninstall_mod.bat` terlebih dahulu.



## Kredit & Pengembang

- **Penerjemah & Modder**: ShDitz
- **Game Asli**: Dark Souls II: Scholar of the First Sin oleh FromSoftware dan Bandai Namco Entertainment
