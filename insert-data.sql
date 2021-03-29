/* 
script by Nguyen Chinh
*/


-- THEM DU LIEU
-- tblLoaiHang
INSERT INTO dbo.tblLoaiHang VALUES
	('LH01', N'LapTop'),
	('LH02', N'PC'),
	('LH03', N'Phụ Kiện')

--tblNhaCungCap
INSERT INTO dbo.tblNhaCungCap VALUES
	(101, N'ASUS', N'Nhập Hàng Asus', N'Hà Nội', '0334455667'), 
	(102, N'DELL', N'Nhập Hàng Dell', N'Đà Nẵng', '0334455668'),
	(103, N'APPLE', N'Nhập Hàng Apple', N'Hải Phòng', '0334455669'),
	(104, N'LENOVO', N'Nhập Hàng Lenovo', N'TP. Hồ Chí Minh', '0334455670')

--tblKhachHang
INSERT INTO dbo.tblKhachHang VALUES
	(111, N'Trần Anh Vũ', N'Giáp Nhị, Hà Nội', '0112233445'),
	(112, N'Trần Thanh Tâm', N'Hoàng Mai, Hà Nội', '0112233446'),
	(113, N'Nguyễn Minh Tú', N'Minh Khai, Hà Nội', '0112233447'),
	(114, N'Đỗ Thu Phương', N'Giáp Bát, Hà Nội', '0112233448'),
	(115, N'Lê Văn Tráng', N'Định Công, Hà Nội', '0112233449')
	
-- tblNhanVien
INSERT INTO dbo.tblNhanVien VALUES
	(1010,	N'Đỗ Thị Bích',	N'Giáp Bát, Hà Nội',	'0123456781',	'1997/01/01',	N'Nữ',	'2019/02/26',	7050000, 1000000),
	(1011,	N'Nguyễn Công Chính',	N'Pháp Vân, Hà Nội',	 '0123456782', '1989/12/21',	N'Nam',	'2016/11/22',	12100000,	2000000),
	(1012,	N'Vương Quang Huy',	N'Giải Phóng, Hà Nội', 	'0123456783',	'1999/03/12',	N'Nam',	'2020/04/02',	5500000, 450000),
	(1013,	N'Phạm Tiến Đạt',	N'Cầu Giấy, Hà Nội', 	'0123456784',	'2000/07/15',	N'Nam',	'2020/07/03',	5000000, 250000)

--tblMatHang
INSERT INTO dbo.tblMatHang VALUES
	('MH01', N'ASUS VivoBook 15 A512DA', 101, 'LH01', 400, 12290000),
	('MH02', N'ASUS Laptop 15 X509UA', 101, 'LH01', 350, 10700000),
	('MH03', N'Laptop Dell XPS 13', 102, 'LH01', 100, 40400000),
	('MH04', N'Laptop Dell Gaming G3', 102, 'LH01', 200, 21000000),
	('MH05', N'Laptop Lenovo Thinkpad X13', 104, 'LH01', 150, 34500000),
	('MH06', N'Apple MacBook Pro', 103, 'LH01', 250, 35500000),
	('MH07', N'PC Dell Vostro', 102, 'LH02', 300, 7050000),
	('MH08', N'PC Lenovo V50t', 104, 'LH02', 200, 9190000),
	('MH09', N'PC Lenovo Ideacentre AIO', 104, 'LH02', 500, 12000000),
	('MH10', N'PC Asus Pro D340MC', 101, 'LH02', 650, 7000000),
	('MH11', N'PC Apple iMac 2019', 103, 'LH02', 250, 47800000),
	('MH12', N'Tai nghe AirPods 2', 103, 'LH03', 200, 3990000),
	('MH13', N'Apple Magic Mouse 2', 103, 'LH03', 200, 2490000),
	('MH14', N'CPU AMD Ryzen 9', 101, 'LH03', 150, 19299000),
	('MH15', N'Card đồ họa RTX3060TI', 101, 'LH03', 200, 13149000)

--tblDonNhapKho
INSERT INTO dbo.tblDonNhapKho VALUES
	(511, 1010, '2019/01/23', 2110),
	(512, 1011, '2017/11/12', 1800),
	(513, 1012, '2020/04/25', 1660),
	(514, 1013, '2020/07/07', 800)

--tblChiTietNhapKho
INSERT INTO dbo.tblChiTietNhapKho VALUES
	(511, 'MH01', 10790000, 450),
	(511, 'MH12', 2490000, 400),
	(511, 'MH03', 38900000, 250),
	(511, 'MH11', 46300000, 560),
	(511, 'MH05', 33000000, 450),
	(512, 'MH06', 34000000, 350),
	(512, 'MH07', 5550000, 600),
	(512, 'MH15', 11649000, 500),
	(512, 'MH09', 10500000, 350),
	(513, 'MH10', 5500000, 450),
	(513, 'MH04', 19500000, 400),
	(513, 'MH02', 9200000, 250),
	(513, 'MH13', 990000, 560),
	(514, 'MH14', 17799000, 450),
	(514, 'MH08', 7690000, 350)

--tblDonDatHang
INSERT INTO dbo.tblDonDatHang VALUES
	(510, 1010, 111, '2020/01/14', '2020/01/17', 59690000),
	(520, 1011, 112, '2020/03/15', '2020/03/18', 109400000 ),
	(530, 1012, 113, '2019/05/16', '2019/05/19',  47800000 ),
	(540, 1013, 114, '2020/06/17', '2020/06/20',  148204000 ),
	(550, 1011, 115, '2017/11/18', '2017/11/21',  71000000 )

--tblChiTietDatHang
INSERT INTO dbo.tblChiTietDatHang VALUES
	(510, 'MH01', 12290000, 1, 0),
	(510, 'MH03', 40400000, 1, 0),
	(510, 'MH10', 7000000, 1, 0),
	(520, 'MH05', 34500000, 2, 0),
	(520, 'MH03', 40400000, 1, 0),
	(530, 'MH11', 47800000, 1, 0),
	(540, 'MH15', 13149000, 3, 0),
	(540, 'MH07', 7050000, 2, 0),
	(540, 'MH08', 9190000, 4, 0),
	(540, 'MH14', 19299000, 3, 0),
	(550, 'MH06', 35500000, 2, 0)

-- in bảng
SELECT * FROM dbo.tblLoaiHang
SELECT * FROM dbo.tblMatHang
SELECT * FROM dbo.tblKhachHang
SELECT * FROM dbo.tblNhanVien
SELECT * FROM dbo.tblDonDatHang
SELECT * FROM dbo.tblChiTietDatHang
SELECT * FROM dbo.tblDonNhapKho
SELECT * FROM dbo.tblChiTietNhapKho
