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



#NO 1

CREATE VIEW view_reservasi_tamu AS
SELECT 
    r.id_reservasi,
    r.tanggal_checkin,
    r.tanggal_checkout,
    r.status AS status_reservasi,
    t.id_tamu,
    t.nama AS nama_tamu,
    t.no_hp,
    t.ktp
FROM reservasi r
JOIN tamu t ON r.id_tamu = t.id_tamu;


SELECT * FROM view_reservasi_tamu;

#NO 2

CREATE VIEW view_pembayaran_detail AS
SELECT 
    p.id_pembayaran,
    t.nama AS nama_tamu,
    t.no_hp,
    r.tanggal_checkin,
    r.tanggal_checkout,
    p.tanggal_pembayaran,
    p.metode_pembayaran,
    p.total_bayar,
    p.status_pembayaran
FROM pembayaran p
JOIN reservasi r ON p.id_reservasi = r.id_reservasi
JOIN tamu t ON r.id_tamu = t.id_tamu;

SELECT * FROM view_pembayaran_detail WHERE status_pembayaran = 'Lunas';


#NO 3

CREATE VIEW view_checkin_kamar_tersedia AS
SELECT 
    r.id_reservasi,
    r.tanggal_checkin,
    r.tanggal_checkout,
    r.status AS status_reservasi,
    k.nomor_kamar,
    k.tipe_kamar,
    k.harga_per_malam,
    k.status AS status_kamar
FROM reservasi r
JOIN kamar k ON r.id_kamar = k.id_kamar
WHERE r.status = 'Check-in' AND k.status = 'Tersedia';

SELECT * FROM view_checkin_kamar_tersedia;

#N0 4 

CREATE VIEW view_laporan_resepsionis AS
SELECT 
    rs.id_resepsionis,
    rs.nama AS nama_resepsionis,
    COUNT(r.id_reservasi) AS jumlah_reservasi,
    SUM(p.total_bayar) AS total_pendapatan,
    AVG(p.total_bayar) AS rata_rata_pembayaran
FROM resepsionis rs
JOIN reservasi r ON rs.id_resepsionis = r.id_resepsionis
JOIN pembayaran p ON r.id_reservasi = p.id_reservasi
GROUP BY rs.id_resepsionis, rs.nama;

SELECT * FROM view_laporan_resepsionis;


#NO5

CREATE VIEW view_reservasi_mendatang AS
SELECT 
    r.id_reservasi,
    t.nama AS nama_tamu,
    t.no_hp,
    k.nomor_kamar,
    k.tipe_kamar,
    r.tanggal_checkin,
    r.tanggal_checkout,
    r.status AS status_reservasi
FROM reservasi r
JOIN tamu t ON r.id_tamu = t.id_tamu
JOIN kamar k ON r.id_kamar = k.id_kamar
WHERE r.tanggal_checkin BETWEEN CURRENT_DATE AND DATE_ADD(CURRENT_DATE, INTERVAL 3 DAY)
AND r.status = 'Dipesan';

SELECT * FROM view_reservasi_mendatang ORDER BY tanggal_checkin;















