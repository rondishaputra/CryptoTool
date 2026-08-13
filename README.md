# 🔐 CryptoTool

```text
========================================
                 PUTRA
          CRYPTOGRAPHY TOOL
========================================
        MAHASISWA BUKAN MAHA TAHU
========================================
```

**CryptoTool** adalah command-line cryptography tool berbasis **PowerShell** yang menyediakan beberapa algoritma kriptografi untuk pembelajaran dan eksperimen.

---

## ✨ Features

CryptoTool saat ini menyediakan:

- Caesar Cipher
- Vigenere Cipher
- XOR Cipher
- AES
- RSA

---

## 💻 Requirements

- Windows
- PowerShell
- Git

PowerShell sudah tersedia pada Windows modern.

Git digunakan untuk mengambil CryptoTool dari repository GitHub.

---

# 📥 Installation

## 1. Install Git

Jika Git belum terpasang, download Git for Windows:

https://git-scm.com/download/win

Setelah selesai, buka **CMD** atau **PowerShell** dan cek:

```cmd
git --version
```

Jika versi Git muncul, lanjut ke langkah berikutnya.

---

## 2. Clone CryptoTool

Buka CMD atau PowerShell.

Kemudian clone repository:

```cmd
git clone https://github.com/rondishaputra/CryptoTool.git
```

Masuk ke folder CryptoTool:

```cmd
cd CryptoTool
```

---

## 3. Install CryptoTool

Jalankan:

```cmd
install.cmd
```

Installer akan otomatis:

- Mendeteksi lokasi CryptoTool
- Menambahkan CryptoTool ke **User PATH**
- Membuat CryptoTool dapat dipanggil dari terminal
- Tidak memerlukan konfigurasi PATH secara manual

Jika muncul:

```text
========================================
       INSTALLATION COMPLETE
========================================

Please open a NEW CMD or PowerShell window.

Then simply type:

    CryptoTool
```

tutup terminal yang sedang digunakan.

Kemudian buka **CMD atau PowerShell baru**.

---

# ▶️ Running CryptoTool

Setelah instalasi selesai, Anda tidak perlu melakukan:

```cmd
cd C:\Tools\CryptoTool
```

lagi.

Cukup ketik:

```cmd
CryptoTool
```

CryptoTool dapat dijalankan dari folder mana pun.

Contoh:

```text
C:\Users\Admin> CryptoTool
```

atau:

```text
C:\Users\Admin\Desktop> CryptoTool
```

atau:

```text
C:\> CryptoTool
```

---

# 🖥️ Main Menu

Setelah CryptoTool dijalankan:

```text
========================================
                 PUTRA
          CRYPTOGRAPHY TOOL
========================================
        MAHASISWA BUKAN MAHA TAHU
========================================

[1] Caesar Cipher
[2] Vigenere Cipher
[3] XOR Cipher
[4] AES
[5] RSA
[6] Exit
```

Pilih algoritma menggunakan nomor yang tersedia.

---

# 🔐 Supported Algorithms

## 1. Caesar Cipher

Caesar Cipher merupakan substitution cipher yang melakukan pergeseran karakter berdasarkan nilai key.

Contoh:

```text
Plaintext : HELLO
Key       : 3
Result    : KHOOR
```

---

## 2. Vigenere Cipher

Vigenere Cipher merupakan polyalphabetic substitution cipher yang menggunakan keyword sebagai dasar pergeseran karakter.

Contoh:

```text
Plaintext : HELLO
Key       : KEY
```

Proses enkripsi menggunakan karakter dari key secara berulang.

---

## 3. XOR Cipher

XOR Cipher menggunakan operasi bitwise XOR antara plaintext dan key.

Konsep dasar:

```text
Ciphertext = Plaintext XOR Key
```

Operasi XOR yang sama dapat digunakan untuk mengembalikan ciphertext menjadi plaintext selama key yang digunakan sama.

---

## 4. AES

AES atau **Advanced Encryption Standard** merupakan symmetric encryption algorithm.

CryptoTool menyediakan:

```text
[1] Encrypt
[2] Decrypt
[3] Back
```

AES menggunakan key yang sama untuk proses enkripsi dan dekripsi.

---

## 5. RSA

RSA merupakan asymmetric cryptography yang menggunakan pasangan:

```text
Public Key
Private Key
```

Secara umum:

```text
Public Key  → Encryption
Private Key → Decryption
```

RSA menggunakan pasangan kunci yang berbeda untuk proses enkripsi dan dekripsi.

---

# 📂 Project Structure

```text
CryptoTool/
│
├── crypto.ps1
│
├── install.cmd
│
├── README.md
│
└── .gitignore
```

### `crypto.ps1`

Program utama CryptoTool.

### `install.cmd`

Installer CryptoTool.

Installer menambahkan lokasi CryptoTool ke **User PATH**, sehingga command:

```text
CryptoTool
```

dapat digunakan dari folder mana pun.

### `README.md`

Dokumentasi project.

### `.gitignore`

Menentukan file atau folder yang tidak perlu dimasukkan ke repository Git.

---

# 🔄 Updating CryptoTool

Jika terdapat pembaruan pada repository GitHub, masuk ke folder CryptoTool:

```cmd
cd C:\Tools\CryptoTool
```

Kemudian:

```cmd
git pull
```

Setelah selesai, jalankan:

```cmd
CryptoTool
```

Tidak perlu menjalankan `install.cmd` lagi selama lokasi instalasi CryptoTool tidak berubah.

---

# 🗑️ Uninstallation

Untuk menghapus CryptoTool:

1. Hapus folder:

```text
C:\Tools\CryptoTool
```

2. Hapus lokasi CryptoTool dari **User PATH** Windows.

Setelah itu command:

```text
CryptoTool
```

tidak lagi tersedia.

---

# ⚠️ Disclaimer

CryptoTool dibuat untuk:

- Pembelajaran kriptografi
- Eksperimen algoritma
- Memahami konsep encryption dan decryption
- Pengembangan command-line tools

CryptoTool **bukan pengganti library cryptography yang telah diaudit secara keamanan**.

Jangan gunakan implementasi ini untuk melindungi data sensitif atau sistem produksi tanpa memahami keamanan, implementasi, dan konfigurasi algoritma yang digunakan.

---

# 👨‍💻 Author

**PUTRA**

CryptoTool dibuat sebagai project pembelajaran dan pengembangan command-line cryptography tool berbasis PowerShell.

---

# 📄 License

This project is licensed under the MIT License.