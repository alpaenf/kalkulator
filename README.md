# 🧮 Kalkulator Konsol Dart

Aplikasi **kalkulator konsol sederhana** berbasis **Dart**, dengan dukungan evaluasi ekspresi lengkap — termasuk *operator precedence*, tanda kurung, dan *unary minus*.

---

## 👤 Identitas

**Nama:** Mukhammad Alfaen Fadillah
**NIM:** H1D023032
**Shift:** B → E

---

## 🚀 Fitur Utama

* 🔢 Evaluator ekspresi dengan dukungan prioritas operator dan tanda kurung.
* ⚙️ Operator yang didukung: `+`, `-`, `*`, `/`, `%`, `^` *(pangkat)*.
* ➖ Mendukung *unary minus* (contoh: `-5 + 3`).
* 💬 Mode interaktif — ketik `q` atau `quit` untuk keluar.
* 🧠 Menggunakan algoritma **Shunting Yard** untuk parsing ke RPN (Reverse Polish Notation).

---

## 🧩 Cara Menjalankan

1. Pastikan **Dart SDK** sudah terinstal.

2. Jalankan melalui terminal (contoh di PowerShell):

   ```powershell
   dart run d:\Praktikum_Flutter\kalkulator.dart
   ```

3. Untuk mode non-interaktif (piped):

   ```powershell
   echo "3+4" | dart run d:\Praktikum_Flutter\kalkulator.dart
   echo "2+3*4" | dart run d:\Praktikum_Flutter\kalkulator.dart
   echo "(2+3)*4" | dart run d:\Praktikum_Flutter\kalkulator.dart
   ```

### 💡 Contoh Output

```
= 7
```

---

## 🛠️ Catatan Teknis

* Menggunakan transformasi **RPN (Reverse Polish Notation)** agar menghormati prioritas operator.
* Operasi pembagian atau modulus dengan nol akan menghasilkan pesan error.
* Parser sederhana — hanya mendukung angka (integer/desimal), operator, dan tanda kurung.
* Tidak mendukung variabel atau fungsi seperti `sin()`, `cos()`, atau `log()`.

---
