CREATE DATABASE umkm_jawa_barat;
USE umkm_jawa_barat;

-- Tabel kabupaten_kota
CREATE TABLE kabupaten_kota (
    id_kabupaten_kota INT AUTO_INCREMENT PRIMARY KEY,
    nama_kabupaten_kota VARCHAR(100)
);

-- Tabel skala_umkm
CREATE TABLE skala_umkm (
    id_skala INT AUTO_INCREMENT PRIMARY KEY,
    nama_skala VARCHAR(50),
    batas_aset_bawah DECIMAL(15,2),
    batas_aset_atas DECIMAL(15,2),
    batas_omzet_bawah DECIMAL(15,2),
    batas_omzet_atas DECIMAL(15,2)
);

-- Tabel kategori_umkm
CREATE TABLE kategori_umkm (
    id_kategori INT AUTO_INCREMENT PRIMARY KEY,
    nama_kategori VARCHAR(100),
    deskripsi TEXT
);

-- Tabel pemilik_umkm
CREATE TABLE pemilik_umkm (
    id_pemilik INT AUTO_INCREMENT PRIMARY KEY,
    nik VARCHAR(60) UNIQUE,
    nama_lengkap VARCHAR(100),
    jenis_kelamin ENUM('Laki-Laki', 'Perempuan'),
    alamat TEXT,
    nomor_telepon VARCHAR(15),
    email VARCHAR(100)
);

-- Tabel umkm
CREATE TABLE umkm (
    id_umkm INT AUTO_INCREMENT PRIMARY KEY,
    nama_usaha VARCHAR(200),
    id_pemilik INT,
    id_kategori INT,
    id_skala INT,
    id_kabupaten_kota INT,
    alamat_usaha TEXT,
    nib VARCHAR (50),
    npwp VARCHAR (20),
    tahun_berdiri YEAR (4),
    jumlah_karyawan INT (11),
    total_aset DECIMAL(15,2),
    omzet_per_tahun DECIMAL(15,2),
    deskripsi_usaha TEXT,
    tanggal_registrasi DATE,
    FOREIGN KEY (id_pemilik) REFERENCES pemilik_umkm(id_pemilik),
    FOREIGN KEY (id_kategori) REFERENCES kategori_umkm(id_kategori),
    FOREIGN KEY (id_skala) REFERENCES skala_umkm(id_skala),
    FOREIGN KEY (id_kabupaten_kota) REFERENCES kabupaten_kota(id_kabupaten_kota)
);

-- Tabel produk_umkm
CREATE TABLE produk_umkm (
    id_produk INT AUTO_INCREMENT PRIMARY KEY,
    id_umkm INT,
    nama_produk VARCHAR(200),
    deskripsi_produk TEXT,
    harga DECIMAL(15,2),
    FOREIGN KEY (id_umkm) REFERENCES umkm(id_umkm)
);

#No1
DELIMITER //

CREATE PROCEDURE AddUMKM(IN u_umkm VARCHAR(200), IN u_karyawan INT)
BEGIN
	INSERT INTO umkm(nama_usaha, jumlah_karyawan)
	VALUES (u_umkm, u_karyawan);
END//

DELIMITER ;
CALL AddUMKM('Pecel Lele Pak Kumis', 5);
CALL AddUMKM('Kopi Senja Subang', 3);
CALL AddUMKM('Batik Cirebon Klasik', 10);
CALL AddUMKM('Keripik Pisang Lembang', 7);
CALL AddUMKM('Tas Rajut Garut', 4);

SELECT * FROM umkm;

SELECT nama_usaha, jumlah_karyawan
FROM umkm;


----2----
DELIMITER //
CREATE PROCEDURE UpdateKategoriUMKM(
    IN p_id_kategori INT,
    IN p_nama_baru VARCHAR(100)
)
BEGIN
    UPDATE kategori_umkm
    SET nama_kategori = p_nama_baru
    WHERE id_kategori = p_id_kategori;
END //
DELIMITER ;
CALL UpdateKategoriUMKM(3, 'Kerajinan Keris');

SELECT nama_kategori FROM kategori_umkm;

SELECT * FROM kategori_umkm;


----3----
DELIMITER //
CREATE PROCEDURE DeletePemilikUMKM(IN p_id_pemilik INT)
BEGIN
  -- Memperbarui data di tabel umkm jika id_pemilik yang akan dihapus ada
  UPDATE umkm SET id_pemilik = NULL WHERE id_pemilik = p_id_pemilik;
  -- Menghapus data dari tabel pemilik_umkm berdasarkan id_pemilik
  DELETE FROM pemilik_umkm WHERE id_pemilik = p_id_pemilik;
END //
DELIMITER ;

CALL DeletePemilikUMKM(14);

DROP PROCEDURE DeletePemilikUMKM;

SELECT * FROM pemilik_umkm;

-----4-----
DROP PROCEDURE IF EXISTS AddProduk;

DELIMITER //
CREATE PROCEDURE AddProduk(
  IN p_id_umkm INT, 
  IN p_nama_produk VARCHAR(200), 
  IN p_harga DECIMAL(15,0)
)
BEGIN
  INSERT INTO produk_umkm(id_umkm, nama_produk, harga)
  VALUES (p_id_umkm, p_nama_produk, p_harga);
END //
DELIMITER ;

CALL AddProduk(4, 'pastel keju', 25000);
SELECT * FROM produk_umkm WHERE nama_produk = 'pastel keju';

SELECT * FROM produk_umkm;

DROP PROCEDURE IF EXISTS AddProduk;

------5----
DELIMITER //
CREATE PROCEDURE GetUMKMByID(
  IN p_id_umkm INT,
  OUT p_nama_usaha VARCHAR(200),
  OUT p_alamat_usaha VARCHAR(255)
)
BEGIN
  SELECT nama_usaha, alamat_usaha
  INTO p_nama_usaha, p_alamat_usaha
  FROM umkm
  WHERE id_umkm = p_id_umkm;
END //
DELIMITER ;

CALL GetUMKMByID(6,@nama, @alamat);
SELECT @umkm AS nama_usaha, @alamat AS alamat_usaha;
SELECT nama_usaha, alamat_usaha FROM umkm;
