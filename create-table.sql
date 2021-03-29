/* 
script by Nguyen Chinh
*/

CREATE DATABASE BTLN09QuanLyKinhDoanhMayTinh
ON (
	NAME = BTLN09QuanLyKinhDoanhMayTinh,
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\assigment\BTLN09QuanLyKinhDoanhMayTinh.mdf'
)

USE BTLN09QuanLyKinhDoanhMayTinh

-- Tạo Các Bảng

-- tblLoaiHang
CREATE TABLE tblLoaiHang
(
	sMaLoaiHang VARCHAR(20) PRIMARY KEY,
	sTenLoaiHang NVARCHAR(30)
)

--tblNhaCungCap
CREATE TABLE tblNhaCungCap
(
	iMaNCC INT PRIMARY KEY,
	sTenNhaCC NVARCHAR(30),
	sTenGiaoDich NVARCHAR(50),
	sDiaChi NVARCHAR(50),
	sDienThoai CHAR(10)
)

--tblMatHang
CREATE TABLE tblMatHang
(
	sMaHang VARCHAR(20) PRIMARY KEY,
	sTenHang NVARCHAR(30),
	iMaNCC INT REFERENCES dbo.tblNhaCungCap(iMaNCC),
	sMaLoaiHang VARCHAR(20) REFERENCES dbo.tblLoaiHang(sMaLoaiHang),
	fSoLuong FLOAT,
	fGiaHang FLOAT
)

--tblKhachHang
CREATE TABLE tblKhachHang
(
	iMaKH INT PRIMARY KEY,
	sTenKH NVARCHAR(30),
	sDiaChi NVARCHAR(50),
	sDienThoai CHAR(10)
)

--tblNhanVien
CREATE TABLE tblNhanVien
(
	iMaNV INT PRIMARY KEY,
	sTenNV NVARCHAR(30),
	sDiaChi NVARCHAR(50),
	sDienThoai CHAR(10),
	dNgaySinh DATETIME CHECK(DATEDIFF(YEAR,dNgaySinh,GETDATE()) >=18),
	sGioiTinh NVARCHAR(5) CHECK(sGioiTinh = N'Nam' OR sGioiTinh = N'Nữ'),
	dNgayVaoLam DATETIME,
	fLuongCoBan FLOAT,
	fPhuCap FLOAT
)

--tblDonDatHang
CREATE TABLE tblDonDatHang
(
	iSoHD INT PRIMARY KEY,
	iMaNV INT REFERENCES dbo.tblNhanVien(iMaNV),
	iMaKH INT REFERENCES dbo.tblKhachHang(iMaKH),
	dNgayDatHang DATETIME,
	dNgayGiaoHang DATETIME,
	fTongTienHD FLOAT CHECK (fTongTienHD > 0),
	CONSTRAINT ck_ngaydathang CHECK(DATEDIFF(DAY,dNgayDatHang,dNgayGiaoHang) >= 0)
)

--tblChiTietDatHang
CREATE TABLE tblChiTietDatHang
(
	iSoHD INT REFERENCES dbo.tblDonDatHang(iSoHD),
	sMaHang VARCHAR(20) REFERENCES dbo.tblMatHang(sMaHang),
	fGiaBan FLOAT,
	iSoLuongMua INT,
	fMucGiamGia FLOAT,
	CONSTRAINT pk_chitietdathang PRIMARY KEY (iSoHD, sMaHang)
)

--tblDonNhapKho
CREATE TABLE tblDonNhapKho
(
	iSoNK INT PRIMARY KEY,
	iMaNV INT REFERENCES dbo.tblNhanVien(iMaNV),
	dNgayNhapHang DATETIME,
	fTongSoLuong FLOAT CHECK(fTongSoLuong > 0)
)

-- tblChiTietNhapKho
CREATE TABLE tblChiTietNhapKho
(
	iSoNK INT REFERENCES dbo.tblDonNhapKho(iSoNK),
	sMaHang VARCHAR(20) REFERENCES dbo.tblMatHang(sMaHang),
	fGiaNhap FLOAT,
	fSoLuongNhap FLOAT CHECK (fSoLuongNhap > 0),
	CONSTRAINT pk_chitietnhapkho PRIMARY KEY (iSoNK, sMaHang)
)