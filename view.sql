/*
script by Nguyen Chinh
*/

-- create view

--1. Tạo‌ ‌view‌ ‌chứa‌ ‌danh‌ ‌sách‌ ‌nhân‌ ‌viên‌ ‌với‌ ‌các‌ ‌thông‌ ‌tin:‌ ‌Mã Nhân Viên,‌ ‌Tên Nhân Viên,‌ Lương Cơ Bản, Phụ Cấp
CREATE VIEW vv_dsnhanvien AS
SELECT iMaNV AS [Mã Nhân Viên], sTenNV AS [Họ & Tên], fLuongCoBan AS [Lương Cơ Bản], fPhuCap AS [Phụ Cấp]
FROM dbo.tblNhanVien

SELECT * FROM vv_dsnhanvien

--2. Tạo view cho biết danh sách tên hàng đã bán trong tháng 6 năm 2020
CREATE VIEW vv_dshangban2020 AS
SELECT dbo.tblMatHang.sMaHang, sTenHang, dNgayDatHang, dNgayGiaoHang
FROM dbo.tblMatHang, dbo.tblDonDatHang, dbo.tblChiTietDatHang
WHERE dbo.tblMatHang.sMaHang = dbo.tblChiTietDatHang.sMaHang
AND dbo.tblDonDatHang.iSoHD = dbo.tblChiTietDatHang.iSoHD
AND YEAR(dbo.tblDonDatHang.dNgayDatHang) = 2020
AND MONTH(dbo.tblDonDatHang.dNgayDatHang) = 06

SELECT * FROM vv_dshangban2020

--3. Tạo view cho biết mặt hàng có số lượng lớn hơn 200
CREATE VIEW vv_dshangbansoluong200 AS
SELECT sMaHang, sTenHang, fSoLuong
FROM dbo.tblMatHang
WHERE fSoLuong > 200 
	
SELECT * FROM vv_dshangbansoluong200

--4. Tạo view chứa danh sách nhân viên nam
CREATE VIEW vv_dsnhanviennam AS
SELECT *
FROM dbo.tblNhanVien
WHERE sGioiTinh = N'Nam'

SELECT * FROM vv_dsnhanviennam

--5. Tạo view chứa danh sách mặt hàng với các thông tin: Mã Hàng, Tên Hàng, Số Lượng, Giá Hàng
CREATE VIEW vv_dsmathang AS
SELECT  sMaHang AS [Mã Hàng], sTenHang AS [Tên Hàng], fSoLuong AS [Số Lượng], fGiaHang AS [Giá Hàng]
FROM dbo.tblMatHang

SELECT * FROM vv_dsmathang

--6 Tạo view cho biết thông tin mặt hàng có mã hàng là MH11
CREATE VIEW vv_dsmathangmahangmh11 AS
SELECT  *
FROM dbo.tblMatHang
WHERE sMaHang = 'MH11'

SELECT * FROM vv_dsmathangmahangmh11

--7 Tạo view cho biết thông tin sản phẩm đã mua của khách hàng có số hóa đơn là 510
CREATE VIEW vv_dsthongtinsphd510 AS
SELECT dbo.tblDonDatHang.iSoHD, dbo.tblKhachHang.sTenKH, dbo.tblMatHang.sTenHang, dbo.tblChiTietDatHang.iSoLuongMua
FROM dbo.tblMatHang, dbo.tblDonDatHang, dbo.tblChiTietDatHang, dbo.tblKhachHang
WHERE dbo.tblDonDatHang.iSoHD = 510
AND dbo.tblDonDatHang.iSoHD = dbo.tblChiTietDatHang.iSoHD
AND dbo.tblDonDatHang.iMaKH = dbo.tblKhachHang.iMaKH
AND dbo.tblChiTietDatHang.sMaHang = dbo.tblMatHang.sMaHang

SELECT * FROM vv_dsthongtinsphd510

--8 Tạo view cho biết thông tin của nhân viên có tên là Đỗ Thị Bích
CREATE VIEW vv_dsnhanviendothibich AS
SELECT *
FROM dbo.tblNhanVien
WHERE sTenNV = N'Đỗ Thị Bích'

SELECT * FROM vv_dsnhanviendothibich

--9 Tạo view cho biết số mặt hàng của từng loại hàng
CREATE VIEW vv_dssomathang AS
SELECT tblLoaiHang.sMaLoaiHang, sTenLoaiHang, COUNT(dbo.tblMatHang.sMaLoaiHang) AS [Số lượng sản phẩm], SUM(fSoLuong) AS [Tổng số lượng]
FROM dbo.tblLoaiHang,dbo.tblMatHang
WHERE tblLoaiHang.sMaLoaiHang = dbo.tblMatHang.sMaLoaiHang
GROUP BY tblLoaiHang.sMaLoaiHang, sTenLoaiHang

SELECT * FROM vv_dssomathang

--10 Tạo view cho xem khách hàng mua hàng tổng tiền nhiều nhất
CREATE VIEW vv_khachhangmuanhieunhat AS
SELECT tblKhachHang.iMaKH, sTenKH
FROM dbo.tblKhachHang
WHERE iMaKH = (
	SELECT TOP 1 iMaKH
	FROM dbo.tblDonDatHang
	GROUP BY iMaKH
	ORDER BY SUM(fTongTienHD) DESC
)

SELECT * FROM vv_khachhangmuanhieunhat

--11 Tạo view cho biết tổng số tiền hàng thu được trong mỗi tháng của năm 2020
CREATE VIEW vv_tongtienhangthang2020 AS
SELECT tblDonDatHang.iSoHD, MONTH(dNgayGiaoHang) AS [Tháng], SUM(iSoLuongMua*fGiaBan - iSoLuongMua*fGiaBan*fMucGiamGia) AS [Tổng tiền]
FROM dbo.tblChiTietDatHang,dbo.tblDonDatHang
WHERE dbo.tblDonDatHang.iSoHD = tblChiTietDatHang.iSoHD
AND YEAR(dNgayGiaoHang) = 2020
GROUP BY tblDonDatHang.iSoHD, MONTH(dNgayGiaoHang)

SELECT * FROM vv_tongtienhangthang2020

/*
-- 12.Tạo view thống kê tên các sản phẩm không bán được trong năm 2019
CREATE VIEW vv_sanphamkhongbanduoc2019 AS
SELECT dbo.tblMatHang.sMaHang, dbo.tblMatHang.sTenHang
FROM dbo.tblMatHang, dbo.tblDonDatHang, dbo.tblChiTietDatHang
WHERE NOT YEAR(dNgayGiaoHang) = 2019
AND dbo.tblDonDatHang.iSoHD = dbo.tblChiTietDatHang.iSoHD
AND tblChiTietDatHang.sMaHang = tblMatHang.sMaHang
GROUP BY  dbo.tblMatHang.sMaHang, dbo.tblMatHang.sTenHang

SELECT * FROM vv_sanphamkhongbanduoc2019

*/

-- 12.Tạo view thống kê tên các sản phẩm không bán được trong năm 2019
CREATE VIEW vv_sanphamkhongbanduoc2019
AS
SELECT dbo.tblMatHang.sMaHang, dbo.tblMatHang.sTenHang
FROM dbo.tblMatHang
WHERE tblMatHang.sMaHang NOT IN ( 
	SELECT tblMatHang.sMaHang
	FROM dbo.tblMatHang, dbo.tblDonDatHang, dbo.tblChiTietDatHang
	WHERE YEAR(dNgayGiaoHang) = 2019
	AND dbo.tblDonDatHang.iSoHD = dbo.tblChiTietDatHang.iSoHD
	AND tblChiTietDatHang.sMaHang = tblMatHang.sMaHang
)
GROUP BY dbo.tblMatHang.sMaHang, dbo.tblMatHang.sTenHang

SELECT * FROM vv_sanphamkhongbanduoc2019

-- 13.Tạo view cho biết tổng số mặt hàng của từng nhà cung cấp
CREATE VIEW vv_tongmathangcuatungnhacungcap AS
SELECT  dbo.tblNhaCungCap.iMaNCC, dbo.tblNhaCungCap.sTenNhaCC, COUNT(dbo.tblMatHang.fSoLuong) AS [Tổng Số Mặt Hàng]
FROM dbo.tblMatHang, dbo.tblNhaCungCap
WHERE dbo.tblMatHang.iMaNCC = dbo.tblNhaCungCap.iMaNCC
GROUP BY dbo.tblNhaCungCap.iMaNCC, dbo.tblNhaCungCap.sTenNhaCC

SELECT * FROM vv_tongmathangcuatungnhacungcap

-- 14.Tạo view cho biết tổng tiền hàng đã nhập trong mỗi tháng của năm 2020
CREATE VIEW vv_tongtienhangdanhap2020 AS
SELECT tblDonNhapKho.iSoNK, MONTH(dNgayNhapHang) AS [Tháng], SUM(fSoLuongNhap*fGiaNhap) AS [Tổng tiền]
FROM dbo.tblChiTietNhapKho, dbo.tblDonNhapKho
WHERE dbo.tblDonNhapKho.iSoNK = dbo.tblChiTietNhapKho.iSoNK
AND YEAR(dNgayNhapHang) = 2020
GROUP BY dbo.tblDonNhapKho.iSoNK, MONTH(dNgayNhapHang)

SELECT * FROM vv_tongtienhangdanhap2020

-- 15.Tạo view cho biết tổng số lượng nhập hàng trong năm 2019
CREATE VIEW vv_tongSLnhaphang2019 AS
SELECT  dbo.tblMatHang.sTenHang, SUM(dbo.tblChiTietNhapKho.fSoLuongNhap) AS [Tổng số lượng]
FROM dbo.tblDonNhapKho, dbo.tblChiTietNhapKho, dbo.tblMatHang
WHERE dbo.tblDonNhapKho.iSoNK = dbo.tblChiTietNhapKho.iSoNK
AND dbo.tblChiTietNhapKho.sMaHang = dbo.tblMatHang.sMaHang
AND YEAR(dNgayNhapHang) = 2019
GROUP BY  dbo.tblMatHang.sTenHang

SELECT * FROM vv_tongSLnhaphang2019

-- 16.Tạo view tính lương của từng nhân viên
CREATE VIEW vv_luongtungNV AS
SELECT sTenNV, (fLuongCoBan + fPhuCap) AS [Tổng Lương]
FROM dbo.tblNhanVien

SELECT * FROM vv_luongtungNV

-- 17. Tạo view đưa ra top 5 sản phẩm doanh thu cao nhất
CREATE VIEW vv_top5sanphamcaonhat AS
SELECT *
FROM dbo.tblMatHang 
WHERE sMaHang IN (
	SELECT TOP 5 dbo.tblMatHang.sMaHang
	FROM dbo.tblDonDatHang, dbo.tblChiTietDatHang, dbo.tblMatHang
	WHERE dbo.tblDonDatHang.iSoHD = dbo.tblChiTietDatHang.iSoHD 
	AND dbo.tblChiTietDatHang.sMaHang = tblMatHang.sMaHang
	GROUP BY tblMatHang.sMaHang
	ORDER BY SUM(iSoLuongMua * fGiaBan - iSoLuongMua * fGiaBan * fMucGiamGia) DESC		
)

SELECT * FROM vv_top5sanphamcaonhat

-- 18. Hóa đơn có tổng tiền cao nhất (đơn đặt hàng)
CREATE VIEW vv_hoadonMAX AS
SELECT TOP 1 tblDonDatHang.iSoHD, SUM(iSoLuongMua * fGiaBan - iSoLuongMua * fGiaBan * fMucGiamGia) AS [Tổng tiền Max]
FROM dbo.tblDonDatHang, dbo.tblChiTietDatHang
WHERE dbo.tblDonDatHang.iSoHD = dbo.tblChiTietDatHang.iSoHD
GROUP BY tblDonDatHang.iSoHD
ORDER BY SUM(iSoLuongMua * fGiaBan - iSoLuongMua * fGiaBan * fMucGiamGia) DESC

SELECT * FROM vv_hoadonMAX

-- 19. Tạo view cho biết số lượng và tổng tiền đã bán của từng sản phẩm trong năm 2020
CREATE VIEW vv_soluongvatongtiensp2020 AS
SELECT tblMatHang.sMaHang, SUM(iSoLuongMua) AS [Tổng số lượng], SUM(iSoLuongMua * fGiaBan - iSoLuongMua * fGiaBan * fMucGiamGia) AS [Tổng tiền Max]
FROM dbo.tblDonDatHang, dbo.tblChiTietDatHang, dbo.tblMatHang
WHERE dbo.tblDonDatHang.iSoHD = dbo.tblChiTietDatHang.iSoHD
AND tblMatHang.sMaHang = tblChiTietDatHang.sMaHang
GROUP BY tblMatHang.sMaHang

SELECT * FROM vv_soluongvatongtiensp2020

-- 20. Tạo view nhân viên làm việc trên 2 năm
CREATE VIEW vv_nhanvienlamtren2nam AS
SELECT *
FROM dbo.tblNhanVien
WHERE DATEDIFF(YEAR, dNgayVaoLam, GETDATE()) >=2

SELECT * FROM vv_nhanvienlamtren2nam