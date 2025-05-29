CREATE DATABASE dbhotel;
USE dbhotel;


---1---
DROP TRIGGER IF EXISTS before_insert_tamu;
DELIMITER //
CREATE TRIGGER before_insert_tamu
BEFORE INSERT ON tamu
FOR EACH ROW
BEGIN
    IF NEW.no_hp IS NULL OR NEW.no_hp = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Nomor HP harus angka dan minimal 10 digit.';
    END IF;
END//
DELIMITER ;

INSERT INTO tamu (id_tamu, nama, ktp, no_hp, alamat)
VALUES (13, 'NagitaBBB', '5555555553', '1', 'Jl. Mawar');
INSERT INTO tamu (id_tamu, nama, ktp, no_hp, alamat) 
VALUES (12, 'Budi Santoso', '998989898', '08123456789', 'Jl. Merdeka No.1');
INSERT INTO tamu (id_tamu, nama, ktp, no_hp, alamat) 
VALUES (17, 'Khaijesna', '111112345', '08123456777', 'Jl. Merdeka No.1');
SELECT * FROM tamu;


DROP TRIGGER IF EXISTS before_update_kamar;


DELIMITER //
CREATE TRIGGER before_update_kamar
BEFORE UPDATE ON kamar
FOR EACH ROW
BEGIN
    IF NEW.harga_per_malam <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Harga per malam harus lebih dari 0.';
    END IF;
END//
DELIMITER ;

INSERT INTO kamar (id_kamar, nomor_kamar, tipe_kamar, harga_per_malam)
VALUES (11, 'A10078', 'Standard', 300000);

UPDATE kamar SET harga_per_malam = -2 WHERE id_kamar = 11;
SHOW TRIGGERS FROM dbhotel;

SELECT * FROM kamar;


DROP TRIGGER IF EXISTS before_reservasi_delete;
DELIMITER //
CREATE TRIGGER before_reservasi_delete
BEFORE DELETE ON reservasi
FOR EACH ROW
BEGIN
    
    IF EXISTS (SELECT * FROM pembayaran WHERE id_reservasi = OLD.id_reservasi) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tidak bisa menghapus reservasi yang sudah memiliki pembayaran';
    END IF;
END//
DELIMITER ;


DELETE FROM reservasi WHERE id_reservasi = 3;
SELECT * FROM reservasi;
SELECT * FROM pembayaran;




---2---
DROP TRIGGER IF EXISTS after_insert_tamu;
DELIMITER //
CREATE TRIGGER after_insert_tamu
AFTER INSERT ON tamu
FOR EACH ROW
BEGIN
    INSERT INTO log_action (table_name, ACTION, record_id, tanggal, description) 
    VALUES ('tamu', 'INSERT', NEW.id_tamu, NOW(), 
           CONCAT('Tamu baru: ', NEW.nama, ' | HP: ', NEW.no_hp));
END//
DELIMITER ;

INSERT INTO tamu (id_tamu, nama, ktp, no_hp, alamat) 
VALUES (53, 'TARI ', '123456789099', '08123456788', 'Jl. Merdeka No.1');

SELECT * FROM tamu;
SELECT * FROM log_action;



DROP TRIGGER IF EXISTS after_update_reservasi;
DELIMITER //
CREATE TRIGGER after_update_reservasi
AFTER UPDATE ON reservasi
FOR EACH ROW
BEGIN
    IF OLD.status != NEW.status THEN
        INSERT INTO log_action (table_name, ACTION, record_id, tanggal, description)
        VALUES ('reservasi', 'UPDATE', NEW.id_reservasi, NOW(),
               CONCAT('Status berubah dari ', OLD.status, ' ke ', NEW.status));
    END IF;
END//
DELIMITER ;

INSERT INTO reservasi (id_reservasi, id_tamu, id_kamar, tanggal_checkin, tanggal_checkout, STATUS)
VALUES (8, 12, 11, '2023-11-01', '2023-11-03', 'Reserved'); -- atau nilai yang lebih pendek
UPDATE reservasi SET STATUS = 'Check-in' WHERE id_reservasi = 14;

SELECT * FROM reservasi WHERE id_reservasi = 14;
SELECT * FROM reservasi;
SELECT * FROM log_action;
SELECT * FROM log_action ORDER BY tanggal DESC;
DESCRIBE log_action;
ALTER TABLE log_action 
MODIFY COLUMN description VARCHAR(255) DEFAULT NULL;
SHOW TRIGGERS LIKE 'reservasi';



DROP TRIGGER IF EXISTS after_delete_pembayaran;
DELIMITER //
CREATE TRIGGER after_delete_pembayaran
AFTER DELETE ON pembayaran
FOR EACH ROW
BEGIN
    INSERT INTO log_action (table_name, ACTION, record_id, tanggal, description)
    VALUES ('pembayaran', 'DELETE', OLD.id_pembayaran, NOW(),
           CONCAT('Pembayaran dihapus: ID ', OLD.id_pembayaran, 
                  ' untuk reservasi ', OLD.id_reservasi));
END//
DELIMITER ;

INSERT INTO pembayaran (id_pembayaran, id_reservasi, metode_pembayaran, total_bayar)
VALUES (1, 1, 'Cash', 600000);
DELETE FROM pembayaran WHERE id_pembayaran = 12;
SELECT * FROM pembayaran;
SELECT * FROM log_action;


CREATE TABLE log_action (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    table_name VARCHAR(50),
    ACTION ENUM('INSERT', 'UPDATE', 'DELETE'),
    record_id INT,
    tanggal DATETIME
);
ALTER TABLE log_action 
ADD COLUMN description VARCHAR(255) DEFAULT NULL;
SELECT * FROM log_action;

SELECT * FROM log_action WHERE ACTION = 'INSERT' ORDER BY tanggal DESC;
SELECT * FROM log_action WHERE ACTION = 'UPDATE' ORDER BY tanggal DESC;
SELECT * FROM log_action WHERE ACTION = 'DELETE' ORDER BY tanggal DESC;

SELECT * FROM log_action WHERE table_name = 'reservasi' ORDER BY tanggal DESC;
SELECT * FROM log_action WHERE table_name = 'tamu' ORDER BY tanggal DESC;

SELECT * FROM log_action WHERE record_id = 8 ORDER BY tanggal DESC;
SELECT * FROM log_action WHERE tanggal BETWEEN '2023-11-01' AND '2023-11-02' ORDER BY tanggal DESC;
SELECT 
    id_log,
    CONCAT(table_name, ' (ID:', record_id, ')') AS target,
    ACTION,
    DATE_FORMAT(tanggal, '%d/%m/%Y %H:%i') AS waktu,
    description
FROM log_action
ORDER BY tanggal DESC;
SELECT * FROM log_action ORDER BY id_log DESC LIMIT 3;