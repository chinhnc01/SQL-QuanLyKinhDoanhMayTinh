/*
	script by Nguyen Chinh
*/

-- PROCEDURE

--1. Tìm nhân viên theo tên nhân viên
CREATE PROC sptimnhanvien_tennhanvien (@tennhanvien nvarchar(30))
AS
BEGIN 
	SELECT *
	FROM dbo.tblNhanVien
	WHERE sTenNV = @tennhanvien
END 

EXEC sptimnhanvien_tennhanvien N'Nguyễn Công Chính'

--2. Tổng tiền hàng bán ra trong một tháng trong 1 năm
CREATE PROC sptongtienhangban_thang (@thang int, @nam int)
AS
BEGIN 
	SELECT @thang AS[Thang], SUM (fGiaBan * iSoLuongMua - fGiaBan * iSoLuongMua * fMucGiamGia) AS [Tong tien]
	FROM dbo.tblDonDatHang, dbo.tblChiTietDatHang
	WHERE tblDonDatHang.iSoHD = tblDonDatHang.iSoHD
		AND MONTH(dNgayGiaoHang) = @thang
		AND YEAR(dNgayGiaoHang) = @nam
	GROUP BY MONTH(dNgayGiaoHang), YEAR(dNgayGiaoHang)
END 

EXEC sptongtienhangban_thang 3, 2020

--3. Tiền lương của nhân viên bất kì (theo mã NV)
CREATE PROC spluongnhanvien_maNV (@maNV nvarchar(20))
AS
BEGIN
	SELECT iMaNV,(fLuongCoBan + fPhuCap) as [Lương]
	FROM dbo.tblNhanVien
	WHERE imanv = @maNV
END

EXEC spluongnhanvien_maNV @maNV = N'1010'

--4. Mặt hàng không bán được trong năm
CREATE PROC dskhongduocban (@nam INT)
AS
BEGIN
	SELECT tblMatHang.sMaHang,sTenHang
	FROM dbo.tblMatHang, dbo.tblDonDatHang, dbo.tblChiTietDatHang
	WHERE tblMatHang.sMaHang NOT IN (
		SELECT tblMatHang.sMaHang
			FROM dbo.tblMatHang, dbo.tblChiTietDatHang, dbo.tblDonDatHang
			WHERE tblDonDatHang.iSoHD = tblChiTietDatHang.iSoHD 
			AND tblMatHang.sMaHang = tblChiTietDatHang.sMaHang
			AND YEAR(dNgayDatHang) = @nam
		)
	GROUP BY tblMatHang.sMaHang,sTenHang
END

EXEC dskhongduocban 2020

--5. Tạo thủ tục bổ sung thêm 1 bản ghi mới cho tblChiTietDatHang
CREATE PROC spthemHD (@mahd nvarchar(10), @mahang nvarchar(10), @giaban float, @SLmua int, @mucgiamgia float)
AS
BEGIN
	INSERT INTO tblChiTietDatHang
	VALUES (@mahd, @mahang, @giaban, @SLmua, @mucgiamgia)
END

EXEC spthemHD '550', 'MH02', '10700000', '1', '0'

SELECT * FROM tblChiTietDatHang

--6. Tăng lương cơ bản cho nhân viên (x %) có lượng bán ra lớn hơn chỉ tiêu của một năm --
CREATE PROC sptangluongcoban_nhanvien (@chitieu int, @nam INT, @phantram FLOAT)
AS 
BEGIN 
	UPDATE dbo.tblNhanVien
	SET fLuongCoBan = fLuongCoBan + fLuongCoBan * @phantram
	WHERE iMaNV IN (
		SELECT dbo.tblNhanVien.iMaNV
		FROM dbo.tblNhanVien, dbo.tblDonDatHang, dbo.tblChiTietDatHang
		WHERE tblDonDatHang.iMaNV = tblNhanVien.iMaNV
		AND tblDonDatHang.iSoHD = tblChiTietDatHang.iSoHD
		AND YEAR(dNgayDatHang) = @nam 
		GROUP BY tblNhanVien.iMaNV
		HAVING SUM (iSoLuongMua) > @chitieu
	)	
END

EXEC sptangluongcoban_nhanvien 11, 2020, 0.1

SELECT * FROM dbo.tblNhanVien

--7. Doanh số bán ra của một mặt hàng trong năm
CREATE PROC spdoanhso1mathang1nam (@mahang nvarchar(10), @nam int)
AS
BEGIN	
	SELECT tblChiTietDatHang.sMaHang as[Mã Hàng], (iSoLuongMua * fGiaBan - iSoLuongMua * fGiaBan * fMucGiamGia) as[Tổng số tiền]
	FROM tblMatHang, tblChiTietDatHang, tblDonDatHang
	WHERE tblMatHang.sMaHang = tblChiTietDatHang.sMaHang
	AND tblChiTietDatHang.iSoHD = tblDonDatHang.iSoHD
	AND tblChiTietDatHang.sMaHang = @mahang
	AND YEAR(tblDonDatHang.dNgayDatHang) = @nam
END 

EXEC spdoanhso1mathang1nam @mahang = 'MH11', @nam = '2019'

--8. Tổng số tiền hàng thu được của một năm
CREATE PROC sptienhang1nam (@nam int)
AS
BEGIN	
	SELECT @Nam as [Nam], SUM(tblChiTietDatHang.iSoLuongMua * tblChiTietDatHang.fGiaBan - tblChiTietDatHang.iSoLuongMua * tblChiTietDatHang.fGiaBan * tblChiTietDatHang.fMucGiamGia) AS [Tổng số tiền]
	FROM tblMatHang, tblChiTietDatHang, tblDonDatHang
	WHERE tblMatHang.sMaHang = tblChiTietDatHang.sMaHang
	AND tblChiTietDatHang.iSoHD = tblDonDatHang.iSoHD
	AND YEAR(tblDonDatHang.dNgayDatHang) = @nam
END 

EXEC sptienhang1nam 2019

--9. Tổng tiền hàng nhập vào của một năm
CREATE PROC sp_tongtiennhaphang1nam (@nam int)
AS
BEGIN	
	SELECT @nam as [Nam], SUM(tblChiTietNhapKho.fSoLuongNhap * tblChiTietNhapKho.fGiaNhap) AS [Tổng số tiền]
	FROM tblMatHang, tblChiTietNhapKho, tblDonNhapKho
	WHERE tblMatHang.sMaHang = tblChiTietNhapKho.sMaHang
	AND tblChiTietNhapKho.iSoNK = tblDonNhapKho.iSoNK
	AND YEAR(tblDonNhapKho.dNgayNhapHang) = @nam
END 

EXEC sp_tongtiennhaphang1nam 2019

--10.Giỏ hàng của hách hàng (sản phẩm đã mua + đã giao)
CREATE PROC spgiohang_khachhang (@makh int)
AS
BEGIN 
	SELECT tblKhachHang.iMaKH, tblDonDatHang.iSoHD, SUM(iSoLuongMua) AS [Tong so luong]
	FROM dbo.tblDonDatHang, dbo.tblChiTietDatHang, dbo.tblKhachHang
	WHERE tblDonDatHang.iSoHD = tblChiTietDatHang.iSoHD
	AND tblDonDatHang.iMaKH = tblKhachHang.iMaKH
	AND tblKhachHang.iMaKH = @makh
	GROUP BY tblKhachHang.iMaKH, tblDonDatHang.iSoHD
END 

EXEC spgiohang_khachhang 114

--11. Thống kê hàng nhập từ một nhà cung cấp trong một năm
CREATE PROC spthongkesanpham_nhacungcap (@mancc int, @year int)
AS
BEGIN
	SELECT tblNhaCungCap.iMaNCC, @year AS [Nam], sTenHang, SUM(fSoLuongNhap) AS [So luong]
	FROM dbo.tblNhaCungCap, dbo.tblChiTietNhapKho, dbo.tblDonNhapKho, dbo.tblMatHang
	WHERE dbo.tblDonNhapKho.iSoNK = tblChiTietNhapKho.iSoNK
	AND dbo.tblChiTietNhapKho.sMaHang = dbo.tblMatHang.sMaHang
	AND tblNhaCungCap.iMaNCC = tblMatHang.iMaNCC
	AND tblNhaCungCap.iMaNCC = @mancc
	AND YEAR(dbo.tblDonNhapKho.dNgayNhapHang) = @year
	GROUP BY tblNhaCungCap.iMaNCC, sTenHang
END 

EXEC spthongkesanpham_nhacungcap 101,2020

--12. Truy xuất nguồn gốc của một mặt hàng
CREATE PROC spchitiet_mathang (@mamathang nvarchar(20))
AS
BEGIN
	SELECT sMaHang,sTenHang, tblLoaiHang.sTenLoaiHang, sTenNhaCC,sDiaChi
	FROM dbo.tblNhaCungCap, dbo.tblMatHang, dbo.tblLoaiHang
	WHERE sMaHang = @mamathang
	AND tblMatHang.iMaNCC = tblNhaCungCap.iMaNCC
	AND tblMatHang.sMaLoaiHang = tblLoaiHang.sMaLoaiHang
END 

EXEC spchitiet_mathang N'MH06'

--13. Giảm giá với đơn đặt hàng đã tạo chưa áp dụng giảm giá và được đặt hàng trong ngày nào đó (mức giảm giá x%) 
CREATE PROC spmucgiamgia_dondathang (@sohd int, @ngaydat DATETIME, @mucgiamgia FLOAT)
AS
BEGIN
	UPDATE dbo.tblChiTietDatHang
	SET fMucGiamGia = fMucGiamGia + @mucgiamgia
	WHERE iSoHD IN (
		SELECT tblDonDatHang.iSoHD
		FROM dbo.tblDonDatHang, dbo.tblChiTietDatHang, dbo.tblMatHang
		WHERE tblDonDatHang.iSoHD = tblChiTietDatHang.iSoHD
		AND tblChiTietDatHang.sMaHang = dbo.tblMatHang.sMaHang
		AND tblDonDatHang.iSoHD = @sohd
		AND dNgayDatHang = @ngaydat
		AND fMucGiamGia = 0
	)
END 

EXEC spmucgiamgia_dondathang 510, '2020/01/14', 0.1

SELECT * FROM dbo.tblChiTietDatHang

--14 Số tiền mà nhân viên sử dụng để nhập kho và số hóa đơn đã xử lí
CREATE PROC spthongkenhapkho_nhanvien (@manv int )
AS
  BEGIN
	SELECT tblNhanVien.iMaNV, sTenNV, COUNT(tblDonNhapKho.iSoNK) AS [So Hoa Don NK], SUM(fSoLuongNhap * fGiaNhap) AS [Tong tien]
	FROM dbo.tblNhanVien, dbo.tblDonNhapKho, dbo.tblChiTietNhapKho
	WHERE dbo.tblNhanVien.iMaNV = dbo.tblDonNhapKho.iMaNV
	AND tblDonNhapKho.iSoNK = tblChiTietNhapKho.iSoNK
	AND tblNhanVien.iMaNV = @manv
	GROUP BY tblNhanVien.iMaNV, sTenNV
END 

EXEC spthongkenhapkho_nhanvien 1011

--15. Số tiền mà nhân viên bán được và số hóa đơn đã xử lý
CREATE PROC spthongkebanhang_nhanvien (@manv int )
AS
BEGIN
	SELECT tblNhanVien.iMaNV, sTenNV, COUNT(tblDonDatHang.iSoHD) AS [So Hoa Don],	SUM(iSoLuongMua * fGiaBan - iSoLuongMua * fGiaBan * fMucGiamGia) AS [Tong tien]
	FROM dbo.tblNhanVien, dbo.tblDonDatHang, dbo.tblChiTietDatHang
	WHERE dbo.tblNhanVien.iMaNV = dbo.tblDonDatHang.iMaNV
	AND tblDonDatHang.iSoHD = tblChiTietDatHang.iSoHD
	AND tblNhanVien.iMaNV = @manv
	GROUP BY tblNhanVien.iMaNV, tblNhanVien.sTenNV
END 

EXEC spthongkebanhang_nhanvien 1011