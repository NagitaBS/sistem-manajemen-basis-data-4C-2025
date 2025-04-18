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

INSERT INTO tamu (id_tamu, nama, ktp, no_hp, alamat) VALUES
(1, 'NAGITA BRENDA SILVIA', '340000999918', '081234567890', 'Jl. Sumatera No. 13');

INSERT INTO kamar (id_kamar, nomor_kamar, tipe_kamar, harga_per_malam, STATUS) VALUES
(1, '101', 'Standard', 350000.00, 'Tersedia');

INSERT INTO resepsionis (id_resepsionis, nama, email) VALUES
(1, 'Ayunda', 'ayunda12@hotel.com');

INSERT INTO reservasi (id_reservasi, id_tamu, id_kamar, id_resepsionis, tanggal_checkin, tanggal_checkout, STATUS) VALUES
(1, 1, 1, 1, '2025-04-11', '2025-04-12', 'Dipesan');

INSERT INTO pembayaran (id_pembayaran, id_reservasi, metode_pembayaran, total_bayar) VALUES
(1, 1, 'Cash', 700000.00);

SELECT 
    tamu.id_tamu,
    tamu.nama AS Nama_Tamu,
    tamu.no_hp,
    tamu.alamat,
    tamu.ktp,
    reservasi.tanggal_checkin,
    reservasi.tanggal_checkout,
    reservasi.status
FROM reservasi
JOIN tamu ON reservasi.id_tamu = tamu.id_tamu;

SELECT 
    tamu.nama AS Nama_Tamu,
    tamu.no_hp,
    tamu.alamat,
    tamu.ktp,
    reservasi.id_reservasi,
    reservasi.tanggal_checkin,
    reservasi.tanggal_checkout,
    reservasi.status,
    resepsionis.nama AS Nama_Resepsionis,
    resepsionis.id_resepsionis,
    resepsionis.email
FROM reservasi
JOIN tamu ON reservasi.id_tamu = tamu.id_tamu
JOIN resepsionis ON reservasi.id_resepsionis = resepsionis.id_resepsionis;










