CREATE DATABASE dbhotel;
USE dbhotel;

CREATE TABLE tamu (
    id_tamu INT (20) NOT NULL PRIMARY KEY,
    nama VARCHAR(100) NOT NULL,
    ktp VARCHAR(100) UNIQUE NOT NULL,
    no_hp VARCHAR(15) NOT NULL,
    alamat TEXT
);

CREATE TABLE kamar (
    id_kamar INT (20) NOT NULL PRIMARY KEY,
    nomor_kamar VARCHAR(10) UNIQUE NOT NULL,
    tipe_kamar ENUM('Standard', 'Deluxe', 'Suite') NOT NULL,
    harga_per_malam DECIMAL(10,2) NOT NULL,
    STATUS ENUM('Tersedia', 'Dipesan', 'Tidak Tersedia') DEFAULT 'Tersedia'
);

CREATE TABLE resepsionis (
    id_resepsionis INT (20) NOT NULL PRIMARY KEY,
    nama VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE reservasi (
    id_reservasi INT (20) NOT NULL PRIMARY KEY,
    id_tamu INT,
    id_kamar INT,
    id_resepsionis INT,
    tanggal_checkin DATE NOT NULL,
    tanggal_checkout DATE NOT NULL,
    STATUS ENUM('Dipesan', 'Check-in', 'Check-out', 'Dibatalkan') DEFAULT 'Dipesan',
    FOREIGN KEY (id_tamu) REFERENCES tamu(id_tamu),
    FOREIGN KEY (id_kamar) REFERENCES kamar(id_kamar),
    FOREIGN KEY (id_resepsionis) REFERENCES resepsionis(id_resepsionis)
);

CREATE TABLE pembayaran (
    id_pembayaran INT (20) NOT NULL PRIMARY KEY,
    id_reservasi INT,
    tanggal_pembayaran DATETIME DEFAULT CURRENT_TIMESTAMP,
    metode_pembayaran ENUM('Cash', 'Transfer') NOT NULL,
    total_bayar DECIMAL(10,2) NOT NULL,
    status_pembayaran ENUM('Lunas', 'Belum Lunas') DEFAULT 'Lunas',
    FOREIGN KEY (id_reservasi) REFERENCES reservasi(id_reservasi)
);


#No1
-- Menambahkan kolom 'keterangan' bertipe TEXT di bagian akhir tabel 'kamar'
ALTER TABLE kamar ADD COLUMN keterangan TEXT;

#No2
-- Gabungan 2 tabel yang memungkinkan dan memiliki fungsi pada penerapannya!
SELECT r.id_reservasi, t.nama, r.tanggal_checkin, r.tanggal_checkout
FROM reservasi r
JOIN tamu t ON r.id_tamu = t.id_tamu;

#No3

-- Menampilkan semua data tamu, diurutkan berdasarkan nama secara alfabet (A-Z)
SELECT * FROM tamu ORDER BY nama ASC;

-- Menampilkan semua data kamar, diurutkan berdasarkan harga tertinggi ke terendah
SELECT * FROM kamar ORDER BY harga_per_malam DESC;

-- Menampilkan semua reservasi, diurutkan dari tanggal check-in paling awal
SELECT * FROM reservasi ORDER BY tanggal_checkin ASC;

#No4

-- Mengubah panjang maksimum kolom 'no_hp' menjadi 20 karakter
ALTER TABLE tamu MODIFY no_hp VARCHAR(20);

#No5

-- Menampilkan semua reservasi dan tamu, tetap ditampilkan meskipun ada reservasi tanpa tamu (LEFT JOIN)
SELECT r.id_reservasi, t.nama
FROM reservasi r
LEFT JOIN tamu t ON r.id_tamu = t.id_tamu;

-- Menampilkan semua tamu dan reservasi, tetap ditampilkan meskipun ada tamu tanpa reservasi (RIGHT JOIN)
SELECT t.nama, r.id_reservasi
FROM tamu t
RIGHT JOIN reservasi r ON t.id_tamu = r.id_tamu;

-- Menampilkan pasangan dua tamu berbeda yang masing-masing memiliki reservasi berbeda
SELECT t1.nama AS Guest1, t2.nama AS Guest2
FROM tamu t1
JOIN reservasi r1 ON t1.id_tamu = r1.id_tamu
JOIN reservasi r2 ON r1.id_reservasi <> r2.id_reservasi
JOIN tamu t2 ON r2.id_tamu = t2.id_tamu;

#No6
-- 1. Menampilkan nama tamu yang memiliki kurang dari 3 reservasi
SELECT t.nama
FROM tamu t
JOIN reservasi r ON t.id_tamu = r.id_tamu
GROUP BY t.id_tamu
HAVING COUNT(r.id_reservasi) < 1;

-- Cek isi semua reservasi
SELECT * FROM reservasi;

-- 2. Menampilkan semua kamar yang harga per malamnya lebih dari 500
SELECT * FROM kamar WHERE harga_per_malam > 500;

-- 3. Menampilkan semua reservasi yang statusnya masih 'Dipesan'
SELECT * FROM reservasi WHERE STATUS = 'Dipesan';

-- 4. Menampilkan tamu yang namanya berakhiran huruf 'A'
-- Catatan: kalau mau awal huruf A, gunakan 'A%'
SELECT * FROM tamu WHERE nama LIKE '%A';

-- 5. Menampilkan semua pembayaran yang belum lunas
SELECT * FROM pembayaran WHERE status_pembayaran <> 'Lunas';

-- 1. Find guests with more than 1 reservation
SELECT t.nama FROM tamu t JOIN reservasi r ON t.id_tamu = r.id_tamu
GROUP BY t.id_tamu HAVING COUNT(r.id_reservasi) > 3;

SELECT * FROM reservasi;

-- 2. Find rooms that cost more than 500 per night
SELECT *
FROM kamar
WHERE harga_per_malam > 500;

-- 3. Find reservations that are still 'Dipesan'
SELECT *
FROM reservasi
WHERE STATUS = 'Dipesan';

-- 4. Find guests whose name starts with 'A'
SELECT *
FROM tamu
WHERE nama LIKE '%A';

-- 5. Find payments that are not 'Lunas'
SELECT *
FROM pembayaran
WHERE status_pembayaran <> 'Lunas';