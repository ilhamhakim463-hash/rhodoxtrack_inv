# RhodoxTrack — Sistem Inventori Toko Sembako

Aplikasi manajemen stok & HPP berbasis Flask + MySQL.

## Prasyarat
- Python 3.10+
- MySQL/MariaDB di port **3307** (XAMPP default)
- pip

## Instalasi & Jalankan

```powershell
# 1. Masuk folder
cd rhodoxtrack_inv

# 2. (Opsional) buat virtual environment
python -m venv venv
.\venv\Scripts\Activate

# 3. Install dependencies
pip install -r requirements.txt

# 4. Buat database di MySQL
# Buka XAMPP Shell atau:
# & "C:\xampp\mysql\bin\mysql.exe" -P 3307 -u root -p
# CREATE DATABASE rhodoxtrack CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

# 5. Jalankan (otomatis buat tabel + seed data)
python app.py
```

Akses: **http://127.0.0.1:3307**

## Akun Default
| Role  | Username | Password  |
|-------|----------|-----------|
| Admin | admin    | admin123  |
| Kasir | kasir1   | kasir123  |

## Fitur
- Dashboard analytics (grafik 7 hari, top produk)
- Manajemen produk dengan barcode/SKU
- Scanner barcode (ketik/scan di form transaksi)
- Kalkulasi HPP Weighted Average otomatis
- Laporan HPP dengan Export Excel (berwarna) & JSON
- Low stock alert di topbar
- Kategori: tambah, edit (sinkron ke produk), hapus
- Audit trail semua aktivitas
- Manajemen user (admin/kasir)
- Responsif: HP, tablet, laptop, PC

## Konfigurasi (Environment Variables)
| Variable   | Default     |
|------------|-------------|
| DB_USER    | root        |
| DB_PASS    | (kosong)    |
| DB_HOST    | 127.0.0.1   |
| DB_PORT    | 3307        |
| DB_NAME    | rhodoxtrack |
| SECRET_KEY | (default)   |

## API Endpoints
| URL | Deskripsi |
|-----|-----------|
| GET /api/product/\<id\> | Detail produk |
| GET /api/low_stock | Produk stok rendah/habis |
| GET /api/barcode/\<code\> | Cari produk by barcode atau SKU |
