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

-- 1. nampilin berdsarkan rentan waktu
DROP PROCEDURE IF EXISTS sp_reservasi_berdasarkan_lama;
DELIMITER //
CREATE PROCEDURE sp_reservasi_berdasarkan_lama(IN periode VARCHAR(20))
BEGIN
    DECLARE tanggal_awal DATE;
    
    CASE periode
        WHEN 'SEMINGGU' THEN SET tanggal_awal = DATE_SUB(CURDATE(), INTERVAL 1 WEEK);
        WHEN '1 BULAN' THEN SET tanggal_awal = DATE_SUB(CURDATE(), INTERVAL 1 MONTH);
        WHEN '3 BULAN' THEN SET tanggal_awal = DATE_SUB(CURDATE(), INTERVAL 3 MONTH);
        ELSE SET tanggal_awal = CURDATE(); -- biar gak NULL
    END CASE;
    
    SELECT 
        r.id_reservasi,
        t.nama AS nama_tamu,
        k.nomor_kamar,
        r.tanggal_checkin,
        r.tanggal_checkout,
        r.status
    FROM 
        reservasi r
        JOIN tamu t ON r.id_tamu = t.id_tamu
        JOIN kamar k ON r.id_kamar = k.id_kamar
    WHERE 
        r.tanggal_checkin >= tanggal_awal
    ORDER BY 
        r.tanggal_checkin DESC;
END //
DELIMITER ;


CALL sp_reservasi_berdasarkan_lama('1 Bulan');

SELECT * FROM reservasi;


-- 2
DELIMITER //
CREATE PROCEDURE sp_hapus_transaksi_lama_v2()
BEGIN

    DELETE r FROM reservasi r
    JOIN pembayaran p ON r.id_reservasi = p.id_reservasi
    WHERE 
        r.tanggal_checkout < DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
        AND p.status_pembayaran = 'Lunas';
    
    SELECT CONCAT(ROW_COUNT(), ' transaksi lama berhasil dihapus') AS hasil;
END //
DELIMITER ;

CALL sp_hapus_transaksi_lama();
SELECT * FROM pembayaran;



-- 3
DELIMITER //
CREATE PROCEDURE sp_update_status_reservasi(IN status_baru VARCHAR(20))
BEGIN
    
    UPDATE reservasi r
    JOIN (
        SELECT id_reservasi 
        FROM reservasi 
        WHERE STATUS != status_baru
        LIMIT 7
    ) AS temp ON r.id_reservasi = temp.id_reservasi
    SET r.STATUS = status_baru;
    
    SELECT CONCAT(ROW_COUNT(), ' status reservasi diubah') AS hasil;
END //
DELIMITER ;

CALL sp_update_status_reservasi('Check-In');
SELECT * FROM reservasi;

-- 4
DROP PROCEDURE IF EXISTS sp_edit_user;
DELIMITER //
CREATE PROCEDURE sp_edit_user(
    IN p_id_tamu INT,
    IN p_nama_baru VARCHAR(100),
    IN p_ktp_baru VARCHAR(100),
    IN p_no_hp_baru VARCHAR(15),
    IN p_alamat_baru TEXT
)
BEGIN
    UPDATE tamu t
    LEFT JOIN (
        SELECT DISTINCT id_tamu 
        FROM reservasi 
        WHERE id_tamu = p_id_tamu
    ) r ON t.id_tamu = r.id_tamu
    SET 
        t.nama = p_nama_baru,
        t.ktp = p_ktp_baru,
        t.no_hp = p_no_hp_baru,
        t.alamat = p_alamat_baru
    WHERE 
        t.id_tamu = p_id_tamu AND
        r.id_tamu IS NULL;


    SELECT 
        CASE
            WHEN EXISTS (SELECT 1 FROM tamu WHERE id_tamu = p_id_tamu) = 0 THEN 
                CONCAT('Gagal: Tamu ID ', p_id_tamu, ' tidak ditemukan')
            WHEN EXISTS (SELECT 1 FROM reservasi WHERE id_tamu = p_id_tamu) THEN 
                CONCAT('Gagal: Tamu ID ', p_id_tamu, ' memiliki transaksi')
            WHEN ROW_COUNT() = 0 THEN 
                CONCAT('Gagal: Tidak ada perubahan pada Tamu ID ', p_id_tamu)
            ELSE 
                CONCAT('Sukses: Data tamu ID ', p_id_tamu, ' berhasil diperbarui')
        END AS hasil;
END //
DELIMITER ;

-- CALL editResepsionis (1, 'Jl. BaruKota No. 1');

-- CALL editResepsionis (5, 'Arianti Adilah', '08123456789', 'Jl. Baru No. 1');
-- CALL sp_edit_tamu (6, 'NagitaB', '08123456789', 'Jl. Baru No.1');
CALL sp_edit_user(
    6,
    'ALfathan222',
    '3509012345670001',
    '082112345678',
    'Jl. Pahlawan No. 123, Surabaya'
);
SELECT * FROM tamu; 


-- WHERE id_tamu = 3;
-- select * from reservasi;
DROP PROCEDURE sp_edit_tamu;
-- CALL sp_edit_tamu_no_branching(6, 'Nagita Updated', '08123456789', 'Jl. Baru No. 1');

-- 5
DELIMITER //
CREATE PROCEDURE sp_update_status_by_transaksi()
BEGIN
    DECLARE id_min INT;
    DECLARE id_mid INT;
    DECLARE id_max INT;
    
    -- sedikit
    SELECT id_tamu INTO id_min
    FROM (
        SELECT id_tamu, COUNT(*) AS jumlah
        FROM reservasi
        WHERE tanggal_checkin >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
        GROUP BY id_tamu
        ORDER BY jumlah ASC
        LIMIT 1
    ) AS temp;
    
    -- Menengah
    SELECT id_tamu INTO id_mid
    FROM (
        SELECT id_tamu, COUNT(*) AS jumlah
        FROM reservasi
        WHERE tanggal_checkin >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
        GROUP BY id_tamu
        ORDER BY jumlah ASC
        LIMIT 1 OFFSET 1
    ) AS temp;
    
    --  terbanyak
    SELECT id_tamu INTO id_max
    FROM (
        SELECT id_tamu, COUNT(*) AS jumlah
        FROM reservasi
        WHERE tanggal_checkin >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
        GROUP BY id_tamu
        ORDER BY jumlah DESC
        LIMIT 1
    ) AS temp;
    
    -- Update status
    UPDATE tamu
    SET 
        alamat = CASE
            WHEN id_tamu = id_min THEN CONCAT(alamat, ' [Non-Aktif]')
            WHEN id_tamu = id_mid THEN CONCAT(alamat, ' [Pasif]')
            WHEN id_tamu = id_max THEN CONCAT(alamat, ' [Aktif]')
            ELSE alamat
        END
    WHERE id_tamu IN (id_min, id_mid, id_max);
    
    SELECT 'Status tamu berhasil diupdate' AS hasil;
END //
DELIMITER ;

CALL sp_update_status_by_transaksi();
 -- select * from reservasi;
SELECT * FROM tamu;


-- 6
DELIMITER //
CREATE PROCEDURE sp_count_transaksi_berhasil()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE trans_id INT;
    DECLARE cur CURSOR FOR 
        SELECT id_reservasi 
        FROM reservasi
        WHERE STATUS = 'Check-out' 
          AND tanggal_checkout >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH);
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    SET @count := 0;
    
    OPEN cur;
    
    read_loop: LOOP
        FETCH cur INTO trans_id;
        IF done THEN
            LEAVE read_loop;
        END IF;
        SET @count := @count + 1;
    END LOOP;
    
    CLOSE cur;
    
    SELECT @count AS jumlah_transaksi_berhasil;
END //
DELIMITER ;

SELECT 
    id_reservasi,
    tanggal_checkout,
    STATUS
FROM 
    reservasi
WHERE 
    STATUS = 'Check-out'
    AND tanggal_checkout >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH);
    
CALL sp_count_transaksi_berhasil();