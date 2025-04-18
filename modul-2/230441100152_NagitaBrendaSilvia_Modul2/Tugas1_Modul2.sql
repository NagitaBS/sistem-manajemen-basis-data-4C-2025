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

--  data  untuk Kategori UMKM
INSERT INTO kategori_umkm (nama_kategori, deskripsi) VALUES
('Kuliner', 'Usaha yang bergerak di bidang makanan dan minuman'),
('Fesyen', 'Usaha yang bergerak di bidang pakaian, aksesoris, dan produk fashion lainnya'),
('Kerajinan', 'Usaha yang bergerak di bidang pembuatan produk kerajinan tangan'),
('Pertanian', 'Usaha yang bergerak di bidang pertanian, perkebunan, dan pengolahan hasil pertanian'),
('Peternakan', 'Usaha yang bergerak di bidang peternakan dan pengolahan hasil peternakan'),
('Perikanan', 'Usaha yang bergerak di bidang perikanan dan pengolahan hasil perikanan'),
('Jasa', 'Usaha yang bergerak di bidang pelayanan jasa'),
('Perdagangan', 'Usaha yang bergerak di bidang perdagangan barang'),
('Manufaktur', 'Usaha yang bergerak di bidang pembuatan produk'),
('Teknologi', 'Usaha yang bergerak di bidang teknologi informasi'),
('Pariwisata', 'Usaha yang bergerak di bidang pariwisata dan hospitality'),
('Ekonomi Kreatif', 'Usaha yang bergerak di bidang ekonomi kreatif seperti desain, seni, dll');

-- data  untuk Skala UMKM
INSERT INTO skala_umkm (nama_skala, batas_aset_bawah, batas_aset_atas, batas_omzet_bawah, batas_omzet_atas) VALUES
('Mikro', 0, 50000000, 0, 300000000),
('Kecil', 50000000, 500000000, 300000000, 2500000000),
('Menengah', 500000000, 10000000000, 2500000000, 50000000000);

-- data  untuk Kabupaten/Kota di Jawa Barat
INSERT INTO kabupaten_kota (nama_kabupaten_kota) VALUES
('Kota Bandung'),
('Kota Bekasi'),
('Kota Bogor'),
('Kota Cimahi'),
('Kota Cirebon'),
('Kota Depok'),
('Kota Sukabumi'),
('Kota Tasikmalaya'),
('Kota Banjar'),
('Kabupaten Bandung'),
('Kabupaten Bandung Barat'),
('Kabupaten Bekasi'),
('Kabupaten Bogor'),
('Kabupaten Ciamis'),
('Kabupaten Cianjur'),
('Kabupaten Cirebon'),
('Kabupaten Garut'),
('Kabupaten Indramayu'),
('Kabupaten Karawang'),
('Kabupaten Kuningan'),
('Kabupaten Majalengka'),
('Kabupaten Pangandaran'),
('Kabupaten Purwakarta'),
('Kabupaten Subang'),
('Kabupaten Sukabumi'),
('Kabupaten Sumedang'),
('Kabupaten Tasikmalaya');

-- Data untuk Pemilik UMKM
INSERT INTO pemilik_umkm (nik, nama_lengkap, jenis_kelamin, alamat, nomor_telepon, email) VALUES
('3273012505780001', 'Ahmad Sudrajat', 'Laki-laki', 'Jl. Pahlawan No. 123, Bandung', '081234567890', 'ahmad.sudrajat@gmail.com'),
('3217016004850002', 'Siti Rahayu', 'Perempuan', 'Jl. Merdeka No. 45, Bekasi', '085678901234', 'siti.rahayu@gmail.com'),
('3273025601900003', 'Budi Santoso', 'Laki-laki', 'Jl. Sukajadi No. 78, Bandung', '081345678901', 'budi.santoso@gmail.com'),
('3271046502870004', 'Dewi Lestari', 'Perempuan', 'Jl. Veteran No. 56, Bogor', '087890123456', 'dewi.lestari@gmail.com'),
('3275021203830005', 'Joko Widodo', 'Laki-laki', 'Jl. Cendana No. 34, Bekasi', '089012345678', 'joko.widodo@gmail.com'),
('3277054408920006', 'Rina Anggraini', 'Perempuan', 'Jl. Kemuning No. 67, Cimahi', '082345678901', 'rina.anggraini@gmail.com'),
('3210015509870007', 'Agus Hermawan', 'Laki-laki', 'Jl. Teratai No. 89, Bandung', '081456789012', 'agus.hermawan@gmail.com'),
('3215026302860008', 'Ani Yudhoyono', 'Perempuan', 'Jl. Cikutra No. 23, Garut', '083567890123', 'ani.yudhoyono@gmail.com'),
('3601014507830009', 'Hendra Wijaya', 'Laki-laki', 'Jl. Sudirman No. 56, Cianjur', '085678901234', 'hendra.wijaya@gmail.com'),
('3216028308910010', 'Maya Sari', 'Perempuan', 'Jl. Gatot Subroto No. 78, Cirebon', '087890123456', 'maya.sari@gmail.com'),
('3214013011820011', 'Rudi Hartono', 'Laki-laki', 'Jl. Setiabudi No. 90, Kuningan', '089012345678', 'rudi.hartono@gmail.com'),
('3279027105860012', 'Lina Marlina', 'Perempuan', 'Jl. Pasteur No. 45, Majalengka', '081234567890', 'lina.marlina@gmail.com'),
('3278011708840013', 'Dedi Kurniawan', 'Laki-laki', 'Jl. Ciganitri No. 67, Purwakarta', '085678901234', 'dedi.kurniawan@gmail.com'),
('3215023004900014', 'Tuti Winarti', 'Perempuan', 'Jl. Cibaduyut No. 23, Sumedang', '081345678901', 'tuti.winarti@gmail.com'),
('3211014406870015', 'Eko Susanto', 'Laki-laki', 'Jl. Anggrek No. 76, Tasikmalaya', '087890123456', 'eko.susanto@gmail.com');

-- Data untuk UMKM
INSERT INTO umkm (nama_usaha, id_pemilik, id_kategori, id_skala, id_kabupaten_kota, alamat_usaha, nib, npwp, tahun_berdiri, jumlah_karyawan, total_aset, omzet_per_tahun, deskripsi_usaha, tanggal_registrasi) VALUES
('Warung Sambel Hejo', 1, 1, 1, 1, 'Jl. Pahlawan No. 123, Bandung', '9120001234567', '09.876.543.2-123.000', 2018, 3, 35000000, 250000000, 'Warung makan spesialis sambel khas Sunda dengan aneka lauk', '2022-03-15'),
('Butik Batik Pesona', 2, 2, 2, 2, 'Jl. Merdeka No. 45, Bekasi', '9120001234568', '09.876.543.2-123.001', 2015, 7, 320000000, 1200000000, 'Butik batik dengan motif khas Jawa Barat', '2021-07-20'),
('Kerajinan Anyaman Rahayu', 3, 3, 1, 1, 'Jl. Sukajadi No. 78, Bandung', '9120001234569', '09.876.543.2-123.002', 2019, 5, 45000000, 280000000, 'Produk kerajinan anyaman bambu dan rotan', '2022-01-10'),
('Taman Buah Sejahtera', 4, 4, 2, 3, 'Jl. Veteran No. 56, Bogor', '9120001234570', '09.876.543.2-123.003', 2014, 10, 450000000, 2000000000, 'Pertanian buah-buahan lokal dan jeruk impor', '2020-11-05'),
('Ternak Ayam Makmur', 5, 5, 1, 12, 'Jl. Cendana No. 34, Bekasi', '9120001234571', '09.876.543.2-123.004', 2020, 4, 48000000, 275000000, 'Peternakan ayam dan pengolahan telur', '2022-02-28'),
('Budidaya Ikan Barokah', 6, 6, 2, 4, 'Jl. Kemuning No. 67, Cimahi', '9120001234572', '09.876.543.2-123.005', 2017, 8, 380000000, 1800000000, 'Budidaya ikan air tawar dan olahan ikan', '2021-04-12'),
('Bengkel Las Abadi', 7, 7, 1, 10, 'Jl. Teratai No. 89, Bandung', '9120001234573', '09.876.543.2-123.006', 2016, 6, 49000000, 290000000, 'Jasa pengelasan dan pembuatan pagar', '2022-05-17'),
('Toko Sembako Barokah', 8, 8, 2, 17, 'Jl. Cikutra No. 23, Garut', '9120001234574', '09.876.543.2-123.007', 2013, 5, 420000000, 2300000000, 'Perdagangan sembako dan kebutuhan rumah tangga', '2020-08-23'),
('Furniture Kayu Jati', 9, 9, 3, 15, 'Jl. Sudirman No. 56, Cianjur', '9120001234575', '09.876.543.2-123.008', 2012, 20, 2500000000, 15000000000, 'Produksi furniture kayu jati untuk ekspor', '2020-03-10'),
('Digital Solution', 10, 10, 2, 16, 'Jl. Gatot Subroto No. 78, Cirebon', '9120001234576', '09.876.543.2-123.009', 2018, 12, 480000000, 2200000000, 'Pengembangan aplikasi dan website', '2021-09-15'),
('Homestay Panorama', 11, 11, 1, 20, 'Jl. Setiabudi No. 90, Kuningan', '9120001234577', '09.876.543.2-123.010', 2019, 4, 47000000, 270000000, 'Penyedia akomodasi homestay di daerah wisata', '2022-04-21'),
('Studio Desain Kreatif', 12, 12, 2, 21, 'Jl. Pasteur No. 45, Majalengka', '9120001234578', '09.876.543.2-123.011', 2016, 8, 350000000, 1900000000, 'Jasa desain grafis dan branding', '2021-05-17'),
('Oleh-oleh Khas Sunda', 13, 1, 2, 23, 'Jl. Ciganitri No. 67, Purwakarta', '9120001234579', '09.876.543.2-123.012', 2015, 9, 370000000, 2100000000, 'Makanan oleh-oleh khas Sunda Buhun', '2020-10-30'),
('Rajutan Cantik', 14, 2, 1, 26, 'Jl. Cibaduyut No. 23, Sumedang', '9120001234580', '09.876.543.2-123.013', 2020, 3, 40000000, 260000000, 'Produk rajutan handmade berkualitas', '2022-02-14'),
('Perkebunan Kopi Gunung', 15, 4, 3, 27, 'Jl. Anggrek No. 76, Tasikmalaya', '9120001234581', '09.876.543.2-123.014', 2010, 25, 3500000000, 20000000000, 'Perkebunan dan pengolahan kopi premium', '2020-01-05');

-- Data untuk Produk UMKM
INSERT INTO produk_umkm (id_umkm, nama_produk, deskripsi_produk, harga) VALUES
(1, 'Sambel Hejo Level 1', 'Sambel hejo dengan tingkat kepedasan rendah', 15000),
(1, 'Sambel Hejo Level 3', 'Sambel hejo dengan tingkat kepedasan sedang', 17000),
(1, 'Sambel Hejo Level 5', 'Sambel hejo dengan tingkat kepedasan tinggi', 20000),
(1, 'Ayam Goreng Sambel Hejo', 'Paket nasi dengan ayam goreng dan sambel hejo', 25000),
(2, 'Batik Tulis Mega Mendung', 'Batik tulis motif mega mendung khas Cirebon', 750000),
(2, 'Batik Cap Kujang', 'Batik cap dengan motif kujang', 350000),
(2, 'Kemeja Batik Pria', 'Kemeja batik pria lengan panjang', 275000),
(2, 'Dress Batik Modern', 'Dress batik modern untuk wanita', 325000),
(3, 'Keranjang Anyaman Bambu', 'Keranjang anyaman bambu multi fungsi', 85000),
(3, 'Topi Anyaman Bambu', 'Topi anyaman bambu untuk bertani', 45000),
(3, 'Vas Bunga Rotan', 'Vas bunga dari rotan dengan desain klasik', 120000),
(4, 'Jeruk Keprok 1 kg', 'Jeruk keprok segar langsung dari kebun', 30000),
(4, 'Mangga Gedong Gincu 1 kg', 'Mangga gedong gincu khas Indramayu', 45000),
(5, 'Telur Ayam Kampung 1 kg', 'Telur ayam kampung organik', 60000),
(5, 'Ayam Potong Segar 1 ekor', 'Ayam potong segar', 75000),
(6, 'Ikan Nila Segar 1 kg', 'Ikan nila segar hasil budidaya', 40000),
(6, 'Ikan Mas Segar 1 kg', 'Ikan mas segar hasil budidaya', 45000),
(6, 'Pempek Ikan', 'Pempek ikan nila homemade', 60000),
(7, 'Jasa Las Teralis', 'Jasa pembuatan teralis per meter', 350000),
(7, 'Jasa Las Pagar', 'Jasa pembuatan pagar besi per meter', 450000),
(8, 'Paket Sembako Hemat', 'Paket sembako hemat (beras, minyak, gula)', 150000),
(8, 'Beras Premium 5 kg', 'Beras premium kualitas terbaik', 75000),
(9, 'Meja Makan Set', 'Set meja makan kayu jati dengan 6 kursi', 12500000),
(9, 'Lemari Pakaian 3 Pintu', 'Lemari pakaian 3 pintu dari kayu jati', 8500000),
(10, 'Jasa Pembuatan Website', 'Jasa pembuatan website profesional', 5000000),
(10, 'Jasa Pembuatan Aplikasi Mobile', 'Jasa pembuatan aplikasi mobile Android dan iOS', 15000000),
(11, 'Kamar Standar per Malam', 'Sewa kamar standar per malam termasuk sarapan', 350000),
(11, 'Kamar Superior per Malam', 'Sewa kamar superior per malam termasuk sarapan', 500000),
(12, 'Jasa Desain Logo', 'Jasa pembuatan desain logo perusahaan', 2500000),
(12, 'Jasa Branding Komprehensif', 'Jasa branding komprehensif (logo, kop surat, dll)', 7500000),
(13, 'Dodol Garut', 'Dodol khas Garut berbagai rasa', 25000),
(13, 'Opak Singkong', 'Opak singkong khas Purwakarta', 20000),
(14, 'Syal Rajutan', 'Syal rajutan tangan dengan benang wol premium', 150000),
(14, 'Topi Rajutan Bayi', 'Topi rajutan untuk bayi', 75000),
(15, 'Kopi Arabika Gunung Puntang 250gr', 'Kopi arabika premium dari Gunung Puntang', 125000),
(15, 'Kopi Robusta Gunung Papandayan 250gr', 'Kopi robusta premium dari Gunung Papandayan', 95000);

SELECT * FROM produk_umkm;

#No 1

CREATE VIEW view_umkm_detail AS
SELECT 
    u.nama_usaha,
    p.nama_lengkap AS nama_pemilik,
    k.nama_kategori,
    s.nama_skala AS skala_usaha,
    kk.nama_kabupaten_kota,
    u.tahun_berdiri
FROM umkm u
JOIN pemilik_umkm p ON u.id_pemilik = p.id_pemilik
JOIN kategori_umkm k ON u.id_kategori = k.id_kategori
JOIN skala_umkm s ON u.id_skala = s.id_skala
JOIN kabupaten_kota kk ON u.id_kabupaten_kota = kk.id_kabupaten_kota;

#No 2

CREATE VIEW view_pemilik_dan_usaha AS
SELECT 
    p.nik,
    p.nama_lengkap,
    p.jenis_kelamin,
    p.nomor_telepon,
    p.email,
    u.nama_usaha
FROM pemilik_umkm p
JOIN umkm u ON p.id_pemilik = u.id_pemilik;

#No 3

CREATE VIEW view_produk_umkm AS
SELECT 
    u.nama_usaha,
    p.nama_produk,
    p.deskripsi_produk,
    p.harga
FROM produk_umkm p
JOIN umkm u ON p.id_umkm = u.id_umkm;

#no 4

CREATE VIEW view_umkm_menengah AS
SELECT 
    u.nama_usaha,
    p.nama_lengkap AS nama_pemilik,
    u.total_aset,
    u.omzet_per_tahun
FROM umkm u
JOIN pemilik_umkm p ON u.id_pemilik = p.id_pemilik
JOIN skala_umkm s ON u.id_skala = s.id_skala
WHERE s.nama_skala = 'Menengah';

#No 5

CREATE VIEW view_umkm_per_kota AS
SELECT 
    kk.nama_kabupaten_kota,
    COUNT(u.id_umkm) AS jumlah_umkm
FROM kabupaten_kota kk
LEFT JOIN umkm u ON kk.id_kabupaten_kota = u.id_kabupaten_kota
GROUP BY kk.nama_kabupaten_kota;


SELECT * FROM view_umkm_detail;
SELECT * FROM view_pemilik_dan_usaha;
SELECT * FROM view_produk_umkm;
SELECT * FROM view_umkm_menengah;
SELECT * FROM view_umkm_per_kota;

