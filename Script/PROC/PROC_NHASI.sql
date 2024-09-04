USE QL_PhongKhamNhaKhoa
GO


-- Xem danh sách nha sĩ. Đối tượng người dùng cho phép: quản trị viên, nhân viên, nha sĩ
CREATE OR ALTER PROC sp_XemNhaSi
AS
	-- Xuất 1 bảng
	SELECT *
	FROM NhaSi
GO

-- Thêm/Cập nhật thông tin nha sĩ. Đối tượng người dùng cho phép: quản trị viên.
CREATE OR ALTER PROC sp_ThemNhaSi
	@MaNS VARCHAR(10),
	@TenNS NVARCHAR(50),
	@NgaySinh DATE,
	@GioiTinh NVARCHAR(10),
	@SoDienThoai VARCHAR(15),
	@Email NVARCHAR(255),
	@DiaChi NVARCHAR(300)
AS
	IF (EXISTS(	SELECT * FROM NhaSi 
				WHERE @MaNS = MaNS))
	BEGIN
		PRINT N'Mã nha sĩ' + @MaNS + ' đã được dùng'
		ROLLBACK TRAN
		RETURN 1
	END

	INSERT INTO NhaSi VALUES
	(@MaNS,@TenNS,@NgaySinh,@GioiTinh,@SoDienThoai,@Email,@DiaChi)
GO

CREATE OR ALTER PROC sp_CapNhatNhaSi
	@MaNS VARCHAR(10),
	@TenNS NVARCHAR(50),
	@NgaySinh DATE,
	@GioiTinh NVARCHAR(10),
	@SoDienThoai VARCHAR(15),
	@Email NVARCHAR(255),
	@DiaChi NVARCHAR(300)
AS
	--Kiểm tra nha sĩ có tồn tại không
	IF (NOT EXISTS(	SELECT * FROM NhaSi
					WHERE @MaNS = MaNS))
	BEGIN
		PRINT N'Không thể tìm thấy nha sĩ với mã: ' + @MaNS
		ROLLBACK TRAN
		RETURN 1
	END

	--Cập nhật nha sĩ tương ứng
	UPDATE NhaSi
	SET TenNS=@TenNS, Ngaysinh=@NgaySinh, gioitinh=@GioiTinh,sodienthoai=@SoDienThoai,
		Email=@Email, Diachi=@DiaChi
	WHERE MaNS = @MaNS

	PRINT N'Giao tác thành công!'
	RETURN 0
GO


-- Xem danh sách nhân viên. Đối tượng người dùng cho phép: quản trị viên, nhân viên, nha sĩ
CREATE OR ALTER PROC sp_XemNhanVien
AS
	SELECT * FROM NhanVien
GO

-- Thêm/Cập nhật thông tin nhân viên. Đối tượng người dùng cho phép: quản trị viên
CREATE OR ALTER PROC sp_ThemNhanVien
	@MaNV VARCHAR(10),
	@TenNV NVARCHAR(50),
	@NgaySinh DATE,
	@GioiTinh NVARCHAR(10),
	@SoDienThoai VARCHAR(15),
	@Email NVARCHAR(255),
	@DiaChi NVARCHAR(300)
AS
	--Kiểm tra nhân viên có tồn tại kh
	IF (EXISTS(	SELECT * FROM NhanVien 
				WHERE @MaNV= MaNV))
	BEGIN
		PRINT N'Mã nhân viên' + @MaNV + ' đã được dùng'
		ROLLBACK TRAN
		RETURN 1
	END

	--Thêm nhân viên
	INSERT INTO NhanVien VALUES
	(@MaNV,@TenNV,@NgaySinh,@GioiTinh,@SoDienThoai,@Email,@DiaChi)

	PRINT N'Giao tác thành công!'
	RETURN 0
GO

CREATE OR ALTER PROC sp_CapNhatNhanVien
	@MaNV VARCHAR(10),
	@TenNV NVARCHAR(50),
	@NgaySinh DATE,
	@GioiTinh NVARCHAR(10),
	@SoDienThoai VARCHAR(15),
	@Email NVARCHAR(255),
	@DiaChi NVARCHAR(300)
AS
	--Kiểm tra nhân viên có tồn tại kh
	IF (NOT EXISTS(	SELECT * FROM NhanVien 
				WHERE @MaNV= MaNV))
	BEGIN
		PRINT N'Không thể tìm thấy nhân viên với mã: ' + @MaNV
		ROLLBACK TRAN
		RETURN 1
	END

	--Sửa nhân viên
	UPDATE NhanVien
	SET TenNV=@TenNV, Ngaysinh=@NgaySinh, gioitinh=@GioiTinh,
		sodienthoai=@SoDienThoai,Email=@Email,Diachi=@DiaChi
	WHERE MaNV=@MaNV

	PRINT N'Giao tác thành công!'
	RETURN 0
GO
-- Thêm kế hoạch điều trị của bệnh nhân
CREATE OR ALTER PROC sp_ThemKeHoachDieuTri
	@MaDT VARCHAR(10),
	@MoTa NVARCHAR(300),
	@GhiChu NVARCHAR(300),
	@TrangThai NVARCHAR(50),
	@MaBA VARCHAR(10),
	@MaDV VARCHAR(10),
	@Ngay DATE,
	@Ca INT,
	@Chinh VARCHAR(10),
	@Phu VARCHAR(10)
AS
	IF (EXISTS(SELECT * FROM KeHoachDieuTri WHERE MaDT=@MaDT))
	BEGIN
		PRINT N'Mã điều trị ' + @MaDT + N' đã tồn tại'
		ROLLBACK TRAN
		RETURN 1
	END

	IF (NOT EXISTS(SELECT * FROM BenhAn WHERE MaBA=@MaBA))
	BEGIN
		PRINT N'Không tìm thấy bệnh nhân với mã: ' + @MaBA
		ROLLBACK TRAN
		RETURN 1
	END

	IF (NOT EXISTS(SELECT * FROM DichVu WHERE MaDV=@MaDV))
	BEGIN
		PRINT N'Không tìm thấy dịch vụ'
		ROLLBACK TRAN
		RETURN 1
	END

	-- Nha sĩ chính và phụ không thể tham gia điều trị ở 2 kế hoạch cùng lúc
	--IF (EXISTS(SELECT * FROM KeHoachDieuTri WHERE
	--	Ngay=@Ngay AND Ca=@Ca AND NS_khamchinh=@Chinh AND NS_khamphu=@Phu))
	--BEGIN
	--	PRINT N'Lịch của 2 nha sĩ này đã được định ở kế hoạch điều trị khác.'
	--	ROLLBACK TRAN
	--	RETURN 1
	--END

	IF (NOT EXISTS(SELECT * FROM LichCaNhan WHERE 
		Ngay=@Ngay AND Ca=@Ca AND NS_khamchinh=@Chinh AND NS_khamphu=@Phu))
	BEGIN
		PRINT N'Không thể lập kế hoạch cho lịch: '
		PRINT N'Nha sĩ chính: ' + @Chinh 
		PRINT N'Nha sĩ phụ: ' + @Phu
		PRINT N'Ngày ' + @Ngay + ' Ca ' + @Ca
		ROLLBACK TRAN
		RETURN 1
	END

	INSERT INTO KeHoachDieuTri(MaDT,MoTa,GhiChu,TrangThai,MaBA,MaDV,Ngay,Ca,NS_khamchinh,NS_khamphu) VALUES
	(@MaDT,@MoTa,@GhiChu,@TrangThai,@MaBA,@MaDV,@MaBA,@Ngay,@Ca,@Chinh,@Phu)
	PRINT N'Giao tác thành công!'
	RETURN 0
GO
	-- thêm / xóa / sửa chi tiết răng: các bảng liên quan KeHoachDieuTri, ChiTietRang,Rang,BeMat
CREATE OR ALTER PROC sp_ThemCTRang
	@MaDT VARCHAR(10),
	@MaRang VARCHAR(10),
	@MaBeMat VARCHAR(10)
AS
	-- kiểm tra madt
	IF (NOT EXISTS(SELECT * FROM KeHoachDieuTri WHERE MaDT = @MaDT))
	BEGIN
		PRINT N'Mã điều trị: ' + @MaDT + N' không tồn tại'
		ROLLBACK TRAN
		RETURN 1
	END

	-- kiểm tra mã răng
	IF (NOT EXISTS(SELECT * FROM Rang WHERE maRang =@MaRang))
	BEGIN
		PRINT N'Mã răng không tồn tại'
		ROLLBACK TRAN
		RETURN 1
	END

	-- kiểm tra mabemat
	IF (NOT EXISTS(SELECT * FROM BeMatRang WHERE maBeMat = @MaBeMat))
	BEGIN
		PRINT N'Bề mặt răng không tồn tại'
		ROLLBACK TRAN
		RETURN 1
	END

	-- kiểm tra chi tiết có tồn tại
	IF (EXISTS (SELECT * FROM ChiTietRang WHERE MaBeMat=@MaBeMat AND MaRang = @MaRang
				AND MaDT = @MaDT))
	BEGIN
		PRINT N'Đã có chi tiết răng này!'
		ROLLBACK TRAN
		RETURN 1
	END

	INSERT INTO ChiTietRang VALUES
	(@MaDT,@MaRang,@MaBeMat)
GO

CREATE OR ALTER PROC sp_XoaCTRang
	@MaDT VARCHAR(10),
	@MaRang VARCHAR(10),
	@MaBeMat VARCHAR(10)
AS
	-- kiểm tra chi tiết có tồn tại
	IF (NOT EXISTS (SELECT * FROM ChiTietRang WHERE MaBeMat=@MaBeMat AND MaRang = @MaRang
					AND MaDT = @MaDT))
	BEGIN
		PRINT N'Chi tiết răng không tồn tại.'
		ROLLBACK TRAN
		RETURN 1
	END

	-- xóa chi tiết tương ứng
	DELETE FROM ChiTietRang
	WHERE MaDT = @MaDT AND MaRang=@MaRang AND MaBeMat=@MaBeMat

	PRINT N'Giao tác thành công!'
	RETURN 0
GO

CREATE OR ALTER PROC sp_SuaCTRang
	@MaDT VARCHAR(10),
	@MaRang VARCHAR(10),
	@MaBeMat VARCHAR(10),
	@RangMoi VARCHAR(10),
	@BeMatMoi VARCHAR(10)
AS
	-- kiểm tra chi tiết cần sửa có tồn tại
	IF (NOT EXISTS (SELECT * FROM ChiTietRang WHERE MaBeMat=@MaBeMat AND MaRang = @MaRang
				AND MaDT = @MaDT))
	BEGIN
		PRINT N'Chi tiết răng không tồn tại.'
		ROLLBACK TRAN
		RETURN 1
	END

	-- kiểm tra răng có tồn tại
	IF (NOT EXISTS(SELECT * FROM Rang WHERE maRang =@RangMoi))
	BEGIN
		PRINT N'Mã răng không tồn tại'
		ROLLBACK TRAN
		RETURN 1
	END

	-- kiểm tra bề mặt có tồn tại
	IF (NOT EXISTS(SELECT * FROM BeMatRang WHERE maBeMat = @BeMatMoi))
	BEGIN
		PRINT N'Bề mặt răng không tồn tại'
		ROLLBACK TRAN
		RETURN 1
	END

	UPDATE ChiTietRang
	SET	MaRang=@RangMoi, MaBeMat=@BeMatMoi, Soluong=@SoLg
	WHERE MaDT=@MaDT AND MaRang=@MaRang AND MaBeMat=@MaBeMat

	PRINT N'Giao tác thành công!'
	RETURN 0
GO
	-- thêm /xóa/ sửa chi tiết đơn thuốc: các bảng liên quan KHDT, Thuoc, CTDonThuoc
CREATE OR ALTER PROC sp_ThemDonThuoc
	@MaThuoc VARCHAR(10),
	@MaDT VARCHAR(10),
	@SL INT,
	@Lieu NVARCHAR(255)
AS
	-- Kiểm tra thuốc có tồn tại
	IF (NOT EXISTS(SELECT * FROM Thuoc WHERE MaThuoc=@MaThuoc))
	BEGIN
		PRINT N'Mã thuốc không tồn tại'
		ROLLBACK TRAN
		RETURN 1
	END

	-- kiểm tra kế hoạch điều trị tồn tại
	IF (NOT EXISTS(SELECT * FROM KeHoachDieuTri WHERE MaDT = @MaDT))
	BEGIN
		PRINT N'Mã điều trị: ' + @MaDT + N' không tồn tại'
		ROLLBACK TRAN
		RETURN 1
	END

	-- kiểm tra số lượng hợp lý
	IF (@SL <= 0)
	BEGIN
		PRINT N'Số lượng phải lớn hơn 0!'
		ROLLBACK TRAN
		RETURN 1
	END

	IF (@SL > (SELECT Soluongton
				FROM Thuoc
				WHERE MaThuoc = @MaThuoc))
	BEGIN
		PRINT N'Thuốc với mã: ' + @MaThuoc + N' đã hết'
		ROLLBACK TRAN
		RETURN 1
	END

	-- kiểm tra đơn thuốc có tồn tại chưa
	IF (EXISTS (SELECT * FROM ChiTietDonThuoc WHERE MaThuoc=@MaThuoc
				AND MaDT = @MaDT))
	BEGIN
		PRINT N'Thuốc đã được kê cho kế hoạch này!'
		ROLLBACK TRAN
		RETURN 1
	END

	-- Kê đơn thuốc
	INSERT INTO ChiTietDonThuoc VALUES
	(@MaThuoc,@MaDT,@SL,@Lieu)

	UPDATE Thuoc
	SET Soluongton = Soluongton - @SL
	WHERE MaThuoc=@MaThuoc

	PRINT N'Giao tác thành công!'
	RETURN 0
GO

CREATE OR ALTER PROC sp_XoaDonThuoc
	@MaThuoc VARCHAR(10),
	@MaDT VARCHAR(10)
AS
	--kiểm tra đơn thuốc
	IF (NOT EXISTS (SELECT * FROM ChiTietDonThuoc WHERE MaThuoc=@MaThuoc
				AND MaDT = @MaDT))
	BEGIN
		PRINT N'Không tìm thấy đơn thuốc!'
		ROLLBACK TRAN
		RETURN 1
	END

	--cập nhật đơn thuốc
	DECLARE @SL INT
	SET @SL = (SELECT Soluong
				FROM ChiTietDonThuoc
				WHERE MaDT=@MaDT AND MaThuoc=@MaThuoc)

	UPDATE Thuoc
	SET Soluongton = Soluongton + @SL
	WHERE MaThuoc=@MaThuoc

	DELETE FROM ChiTietDonThuoc WHERE MaThuoc=@MaThuoc AND MaDT = @MaDT
	PRINT N'Giao tác thành công!'

	RETURN 0
GO

CREATE OR ALTER PROC sp_SuaDonThuoc
	@MaThuoc VARCHAR(10),
	@MaDT VARCHAR(10),
	@ThuocMoi VARCHAR(10),
	@SL INT,
	@Lieu NVARCHAR(255)
AS
	
	IF (NOT EXISTS (SELECT * FROM ChiTietDonThuoc WHERE MaThuoc=@MaThuoc
				AND MaDT = @MaDT))
	BEGIN
		PRINT N'Không tìm thấy đơn thuốc!'
		ROLLBACK TRAN
		RETURN 1
	END

	IF (NOT EXISTS (SELECT * FROM Thuoc WHERE MaThuoc=@ThuocMoi))
	BEGIN
		PRINT N'Không tìm thấy thuốc!'
		ROLLBACK TRAN
		RETURN 1
	END

	IF (@SL <= 0)
	BEGIN
		PRINT N'Số lượng phải lớn hơn 0!'
		ROLLBACK TRAN
		RETURN 1
	END

	DECLARE @SLCu INT
	SET @SLCu = (SELECT Soluong
				FROM ChiTietDonThuoc
				WHERE MaThuoc=@MaThuoc AND MaDT = @MaDT)

	IF (@SL-@SLCu > (SELECT Soluongton
					FROM Thuoc
					WHERE MaThuoc = @MaThuoc))
	BEGIN
		PRINT N'Không đủ thuốc!'
		ROLLBACK TRAN
		RETURN 1
	END

	UPDATE Thuoc
	SET Soluongton=Soluongton-(@SL-@SLCu)
	WHERE MaThuoc = @MaThuoc

	UPDATE ChiTietDonThuoc
	SET MaThuoc = @ThuocMoi, Soluong=@SL, Lieudung=@Lieu
	WHERE MaThuoc = @MaThuoc AND MaDT = @MaDT

	PRINT N'Giao tác thành công!'

	RETURN 0
GO

-- Xem các cuộc hẹn (tái khám, lẫn mới)
CREATE OR ALTER PROC sp_XemCuocHen
AS
	-- in chung một bản 
	-- hiển thị loại cuộc hẹn
	SELECT MaCuocHen,Phong, N'Cuộc hẹn mới' AS TrangThai
	FROM CuocHenMoi
	UNION
	SELECT MaCuocHen,Phong, N'Cuộc hẹn tái khám' AS TrangThai
	FROM CuocHenTaiKham
GO
	
-- Lịch cá nhân: Nha sĩ không thể vừa khám chính vừa khám phụ
	-- Trong cùng 1 ngày và ca nha sĩ không thể vừa khám chính cho record này vừa khám phụ cho record kia