/*
	script by Nguyen Chinh
*/

-- TRIGGER

-- 1. Giá bán phải lớn hơn hoặc bằng giá hàng
CREATE TRIGGER tg_kiemTraGiaBan
ON dbo.tblChiTietDatHang
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @giaBan FLOAT, @giaHang FLOAT, @maHang VARCHAR(20)

		SELECT @giaBan = fGiaBan, @maHang = sMaHang FROM Inserted
		SELECT @giaHang = fGiaHang FROM dbo.tblMatHang WHERE @maHang = sMaHang

		IF(@giaBan < @giaHang)
		BEGIN
		    PRINT N'Giá bán phải lớn hơn hoặc bằng giá hàng'
				ROLLBACK TRAN
		END
END

SELECT * FROM dbo.tblChiTietDatHang

INSERT INTO dbo.tblChiTietDatHang
VALUES
(   550,   -- iSoHD - int
    'MH10',  -- sMaHang - varchar(20)
    6000000, -- fGiaBan - float
    1,   -- iSoLuongMua - int
    0.0  -- fMucGiamGia - float
    )

-- 2. Kiểm tra giới tính xem đúng không
CREATE TRIGGER tg_kiemtragioitinh
ON dbo.tblNhanVien
AFTER INSERT, UPDATE 
AS 
BEGIN 
	DECLARE @gioiTinh NVARCHAR(5)
	SELECT @gioiTinh = sGioiTinh FROM Inserted

	IF(@gioiTinh != N'Nam' AND @gioiTinh != N'Nữ')
		BEGIN
			RAISERROR('Giới Tính Không Hợp Lệ!', 16, 10)
			ROLLBACK TRAN
		END
END

-- 3. Kiểm tra ngày nhập hàng xem đúng không
CREATE TRIGGER tg_kiemTraNgayNhapHang
ON tblDonNhapKho
AFTER INSERT, UPDATE 
AS 
BEGIN
    DECLARE @ngayNhapHang DATETIME
		SELECT @ngayNhapHang = dNgayNhapHang FROM Inserted

		IF(@ngayNhapHang > GETDATE())
		BEGIN
		    PRINT N'Ngày nhập hàng không đc lớn hơn ngày hiện tại'
				ROLLBACK TRAN
		END
END

INSERT INTO dbo.tblDonNhapKho
VALUES
(   515,         -- iSoNK - int
    1010,         -- iMaNV - int
    '2022-02-02', -- dNgayNhapHang - datetime
    2        -- fTongSoLuong - float
    )

-- 4. Kiểm tra ngày vào làm xem hợp lý không
CREATE TRIGGER tg_kiemTraNgayVaoLam
ON tblNhanVien
AFTER INSERT, UPDATE 
AS 
BEGIN
    DECLARE @ngayVaoLam DATETIME
		SELECT @ngayVaoLam = dNgayVaoLam FROM Inserted

		IF(@ngayVaoLam > GETDATE())
		BEGIN
		    PRINT N'Ngày vào làm không đc lớn hơn ngày hiện tại'
				ROLLBACK TRAN
		END
END

INSERT INTO dbo.tblNhanVien
VALUES
(   1014,         -- iMaNV - int
    N'Nguyễn Văn A',       -- sTenNV - nvarchar(30)
    N'Tây Hồ, Hà Nội',       -- sDiaChi - nvarchar(50)
    '0938688882',        -- sDienThoai - char(10)
    '2001-10-16', -- dNgaySinh - datetime
    N'Nam',       -- sGioiTinh - nvarchar(5)
    '2022-11-12', -- dNgayVaoLam - datetime
    6500000,       -- fLuongCoBan - float
    450000        -- fPhuCap - float
    )

-- 5. Đảm bảo số lượng hàng bán không vượt số hiện có và nếu bán thì số lượng hàng trong kho sẽ giảm
CREATE TRIGGER tg_kiemtrahangban
ON dbo.tblChiTietDatHang
INSTEAD OF INSERT,UPDATE 
AS 
BEGIN 
	DECLARE @soluongmua FLOAT 
	DECLARE @smahang VARCHAR(20)
	DECLARE @soluongkho FLOAT
	SELECT @soluongmua = iSoLuongMua,@smahang = sMaHang FROM Inserted
	SELECT @soluongkho = (
		SELECT fSoLuong
		FROM dbo.tblMatHang
		WHERE @smahang = sMaHang
	)
	IF(@soluongmua > @soluongkho)
	BEGIN
		PRINT('So Luong Mua Vuot Qua So Luong Trong Kho')
		ROLLBACK TRAN
	END
	ELSE
	BEGIN
		UPDATE dbo.tblMatHang
		SET fSoLuong = fSoLuong - @soluongmua
		WHERE sMaHang = @smahang
	END
END


-- 6. Cập nhật lại số lượng hàng tồn kho khi khách hàng hủy đặt một mặt hàng
CREATE TRIGGER tg_xoachitietdathang
ON dbo.tblChiTietDatHang
AFTER DELETE
AS 
BEGIN 
	DECLARE @soluongmua FLOAT, @smahang VARCHAR(20), @soluongkho FLOAT

	SELECT @soluongmua = iSoLuongMua,@smahang = sMaHang FROM Deleted
	SELECT @soluongkho = (
		SELECT fSoLuong
		FROM dbo.tblMatHang
		WHERE @smahang = sMaHang
	)
	BEGIN
		UPDATE dbo.tblMatHang
		SET fSoLuong = fSoLuong+@soluongmua
		WHERE sMaHang = @smahang
	END
END 

-- 7. Cập nhật số lượng hàng tồn kho khi nhập thêm mặt hàng
CREATE TRIGGER tg_themChiTietDatHang
ON dbo.tblChiTietDatHang
AFTER INSERT 
AS 
BEGIN 
	DECLARE @soLuongMua FLOAT, @maHang VARCHAR(20), @soLuongKho FLOAT

	SELECT @soLuongMua = iSoLuongMua, @maHang = sMaHang FROM Inserted
	SELECT @soLuongKho = fSoLuong FROM dbo.tblMatHang WHERE @maHang = sMaHang
							
	BEGIN
		UPDATE dbo.tblMatHang
		SET fSoLuong = fSoLuong - @soLuongMua
		WHERE sMaHang = @maHang
	END
END 

SELECT * FROM dbo.tblMatHang 

SELECT * FROM dbo.tblChiTietDatHang

INSERT INTO dbo.tblChiTietDatHang
VALUES
(   550,   -- iSoHD - int
    'MH13',  -- sMaHang - varchar(20)
    2490000, -- fGiaBan - float
    2,   -- iSoLuongMua - int
    0  -- fMucGiamGia - float
    )

-- 8. Cập nhật tổng tiền của hóa đơn khi đặt thêm hàng
CREATE TRIGGER tg_tongTienHoaDon_insert
ON tblChiTietDatHang
AFTER INSERT 
AS 
BEGIN
    DECLARE @soHD INT, @giaMuaHang FLOAT
		SELECT 
			@giaMuaHang = (fGiaBan * iSoLuongMua * (1 - fMucGiamGia)), 
			@soHD = iSoHD FROM Inserted

		BEGIN
		    UPDATE dbo.tblDonDatHang
				SET fTongTienHD = fTongTienHD + @giaMuaHang
				WHERE @soHD = iSoHD
		END
END

SELECT * FROM dbo.tblChiTietDatHang
SELECT * FROM dbo.tblDonDatHang

INSERT INTO dbo.tblChiTietDatHang
VALUES
(   550,   -- iSoHD - int
    'MH12',  -- sMaHang - varchar(20)
    3990000, -- fGiaBan - float
    1,   -- iSoLuongMua - int
    0 -- fMucGiamGia - float
    )

-- 9. Cập nhật tổng tiền của hoá đơn khi khách hàng huỷ đặt mặt hàng
CREATE TRIGGER tg_tongtienhoadon_delete
ON dbo.tblChiTietDatHang
AFTER DELETE
AS
BEGIN
	DECLARE @iSohd INT
	DECLARE @giahangmua FLOAT
	SELECT @giahangmua = (fGiaBan * iSoLuongMua - fGiaBan * iSoLuongMua * fMucGiamGia), @iSohd = iSoHD FROM Deleted
	BEGIN
		UPDATE dbo.tblDonDatHang
		SET fTongTienHD = fTongTienHD - @giahangmua
		WHERE iSoHD = @iSohd
	END 
END

-- 10. Cập nhật số lượng hàng nhập của một hoá đơn nhập kho kho nhập mới
CREATE TRIGGER tg_capnhatdonnhapkho_soluong
ON dbo.tblChiTietNhapKho
INSTEAD OF INSERT
AS
BEGIN
	DECLARE @slnhap FLOAT, @sonk INT 
	SELECT @slnhap = fSoLuongNhap, @sonk = iSoNK FROM Inserted
	BEGIN
		UPDATE dbo.tblDonNhapKho
		SET fTongSoLuong = fTongSoLuong + @slnhap
		WHERE @sonk = iSoNK
	END
END