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


#N01
DELIMITER //

CREATE PROCEDURE UpdateDataMaster(
    IN id INT,
    IN nilai_baru VARCHAR(100),
    OUT STATUS VARCHAR(50)
)
BEGIN
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        SET STATUS = 'Gagal memperbarui data';
    END;

    -- Misalnya kita akan memperbarui nama tamu
    UPDATE tamu SET nama = nilai_baru WHERE id_tamu = id;
    SET STATUS = 'Data berhasil diperbarui';
END //

DELIMITER ;

CALL UpdateDataMaster(1, 'Jusup hadi', @status);
SELECT @status AS status_operasi;

SELECT nama FROM tamu;

#NO2
DELIMITER //

CREATE PROCEDURE CountTransaksi(
    OUT total_transaksi INT
)
BEGIN
    SELECT COUNT(*) INTO total_transaksi FROM reservasi;
END //

DELIMITER ;

CALL CountTransaksi(@total_transaksi);
SELECT @total_transaksi AS total_transaksi;

#NO3
DELIMITER //

CREATE PROCEDURE GetDataMasterByID(
    IN id INT,
    OUT nama VARCHAR(100),
    OUT ktp VARCHAR(100),
    OUT no_hp VARCHAR(15),
    OUT alamat TEXT
)
BEGIN
    SELECT nama, ktp, no_hp, alamat INTO nama, ktp, no_hp, alamat FROM tamu WHERE id_tamu = id;
END //

DELIMITER ;

CALL GetDataMasterByID(2, @nama, @ktp, @no_hp, @alamat);
SELECT @nama AS nama, @ktp AS ktp, @no_hp AS no_hp, @alamat AS alamat;

SELECT * FROM tamu ;


#N04
DELIMITER //

CREATE PROCEDURE UpdateFieldTransaksi(
    IN id INT,
    INOUT field1 VARCHAR(100),
    INOUT field2 DATE
)
BEGIN
    DECLARE current_field1 VARCHAR(100);
    DECLARE current_field2 DATE;

    -- Ambil nilai saat ini
    SELECT nama, tanggal_checkin INTO current_field1, current_field2 FROM reservasi WHERE id_reservasi = id;

    -- Perbarui nilai jika field1 atau field2 tidak kosong
    IF field1 IS NULL OR field1 = '' THEN
        SET field1 = current_field1;
    END IF;

    IF field2 IS NULL THEN
        SET field2 = current_field2;
    END IF;

    UPDATE reservasi SET nama = field1, tanggal_checkin = field2 WHERE id_reservasi = id;
END //

DELIMITER ;

SET @field1 = 'Jane Doe'; 
SET @field2 = NULL; 
CALL UpdateFieldTransaksi(1, @field1, @field2);

SELECT * FROM reservasi ;

#N0 5
DELIMITER //

CREATE PROCEDURE DeleteEntriesByIDMaster(
    IN id INT
)
BEGIN
    DELETE FROM tamu WHERE id_tamu = id;
END //

DELIMITER ;

CALL DeleteEntriesByIDMaster(1);


DROP PROCEDURE IF EXISTS UpdateDataMaster;