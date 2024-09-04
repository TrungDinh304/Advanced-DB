--Quản trị viên:
-- Xem danh sách nha sĩ và lịch trình làm việc tương ứng. Đối tượng người dùng cho phép: quản trị viên, nhân viên, nha sĩ. 
	-- Lịch trình làm việc theo ngày riêng lẻ, tuần, tháng. 
	-- Lịch theo tháng cho biết những ngày trong tháng có thể làm việc
	-- Proc xem lịch làm việc của nha sĩ trong tháng
	CREATE OR ALTER PROCEDURE sp_XemLichTrinhLamViecTheoThang
		@MaNS VARCHAR(10)
	AS
		-- Kiểm tra nha sĩ có tồn tại không
		IF EXISTS (SELECT * FROM NhaSi WHERE MaNS = @MaNS)
		BEGIN
			-- Lấy thông tin tháng năm hiện tại
			DECLARE @ThangHienTai INT, @NamHienTai INT
			SET @ThangHienTai = MONTH(GETDATE())
			SET @NamHienTai = YEAR(GETDATE())
			-- Lọc thông tin trong bảng LichCaNhan
			SELECT	Ngay, Ca
			FROM LichCaNhan
			WHERE (NS_khamchinh = @MaNS OR NS_khamphu = @MaNS) AND MONTH(Ngay) = @ThangHienTai AND YEAR(Ngay) = @NamHienTai
		END
		ELSE
		BEGIN
			PRINT N'NHA SĨ NÀY KHÔNG TỒN TẠI'
		END
	GO
	-- lịch theo tuần đơn vị là mỗi thứ trong tuần. 
	CREATE OR ALTER PROCEDURE sp_XemLichTrinhLamViecTheoTuan
		@MaNS VARCHAR(10)
	AS
		-- Kiểm tra nha sĩ có tồn tại không
		IF EXISTS (SELECT * FROM NhaSi WHERE MaNS = @MaNS)
		BEGIN
			-- Lấy thông tin hôm nay là thứ mấy
			DECLARE @Thu INT
			SET @Thu = DATEPART(WEEKDAY, GETDATE())
			-- Lọc thông tin từ hôm nay tới cuối tuần 
			IF (@Thu != 1)
			BEGIN
				SELECT Ngay, DATEPART(WEEKDAY, Ngay) AS Thu, Ca 
				FROM LichCaNhan
				WHERE (NS_khamchinh = @MaNS OR NS_khamphu = @MaNS) AND Ngay >= GETDATE() AND DATEDIFF(d, Ngay, GETDATE()) < (7 - @Thu + 2) --Số ngày còn lại trong tuần
				END
			ELSE
			BEGIN
				SELECT Ngay, DATEPART(WEEKDAY, Ngay) AS Thu, Ca 
				FROM LichCaNhan
				WHERE (NS_khamchinh = @MaNS OR NS_khamphu = @MaNS) AND Ngay = GETDATE()
			END
		END
		ELSE
		BEGIN
			PRINT N'NHA SĨ NÀY KHÔNG TỒN TẠI'
		END
	GO
	-- Lịch theo ngày riêng lẻ, mỗi đơn vị là các ngày cụ thể. Trong mỗi ngày có thời gian có thể khám, thời gian không thể khám. Lễ tân, nhân viên dựa vào lịch này để đặt hẹn cho bệnh nhân.
	CREATE OR ALTER PROCEDURE sp_XemLichTrinhLamViecTheoNgay
		@MaNS VARCHAR(10),
		@Ngay DATE
	AS
		-- Kiểm tra nha sĩ có tồn tại không
		IF EXISTS (SELECT * FROM NhaSi WHERE MaNS = @MaNS)
		BEGIN
			SELECT Ngay, Ca 
			FROM LichCaNhan
			WHERE Ngay = @Ngay AND (NS_khamchinh = @MaNS OR NS_khamphu = @MaNS)
		END
		ELSE
		BEGIN
			PRINT N'NHA SĨ NÀY KHÔNG TỒN TẠI'
		END
	GO
	-- Chỉ có quản trị viên mới có quyền thêm lịch làm việc cho nha sĩ
--Quản lý thuốc:
    -- Xem danh sách thuốc. Đối tượng người dùng cho phép: quản trị viên, nhân viên, nha sĩ
	CREATE OR ALTER PROCEDURE sp_XemDanhSachThuoc
	AS
		SELECT * FROM Thuoc
	GO

	--EXEC XemDanhSachThuoc
    
	-- Thêm/Cập nhật/Xóa thuốc (quản trị viên)
	-- Thêm thuốc
	CREATE or ALTER PROCEDURE sp_ThemThuoc
		@MaThuoc VARCHAR(10),
		@TenThuoc NVARCHAR(255),
		@HanSD DATE,
		@DonGia INT,
		@DonViTinh NVARCHAR(50),
		@Soluongton INT,
		@GhiChu NVARCHAR(MAX)
	AS
		IF IS_MEMBER('QuanTriVien') = 1 --Chỉ có QuanTriVien được quyền thêm thuốc
		BEGIN
		INSERT INTO Thuoc (MaThuoc, TenThuoc, HanSD, DonGia, DonViTinh, Soluongton, GhiChu)
		VALUES (@MaThuoc, @TenThuoc, @HanSD, @DonGia, @DonViTinh, @Soluongton, @GhiChu)
		END
		ELSE
		BEGIN 
			PRINT N'BẠN KHÔNG CÓ QUYỀN THỰC HIỆN THAO TÁC NÀY'
		END
	GO

	-- Cập nhật thuốc 
	CREATE or ALTER PROCEDURE sp_CapNhatThuoc
		@MaThuoc VARCHAR(10),
		@TenThuoc NVARCHAR(255),
		@HanSD DATE,
		@DonGia INT,
		@DonViTinh NVARCHAR(50),
		@Soluongton INT,
		@GhiChu NVARCHAR(MAX)
	AS
		IF IS_MEMBER('QuanTriVien') = 1 --Chỉ có QuanTriVien được quyền cập nhật thuốc
		BEGIN
			IF EXISTS (SELECT * FROM Thuoc WHERE MaThuoc = @MaThuoc)
			BEGIN
				UPDATE Thuoc
				SET TenThuoc = @TenThuoc, HanSD = @HanSD, DonGia = @DonGia, DonViTinh = @DonViTinh, Soluongton = @Soluongton
				WHERE MaThuoc = @MaThuoc
			END
			ELSE
			BEGIN
				PRINT N'THUỐC KHÔNG TỒN TẠI'
			END
		END
		ELSE
		BEGIN
			PRINT N'BẠN KHÔNG CÓ QUYỀN THỰC HIỆN THAO TÁC NÀY'
		END
	GO
	
	--Xóa thuốc
	CREATE or ALTER PROCEDURE sp_XoaThuoc
		@MaThuoc VARCHAR(10)
	AS
		IF IS_MEMBER('QuanTriVien') = 1 --Chỉ có QuanTriVien được quyền xóa thuốc
		BEGIN
			IF EXISTS (SELECT * FROM Thuoc WHERE MaThuoc = @MaThuoc)
			BEGIN
				IF EXISTS (SELECT 1 FROM ChiTietDonThuoc WHERE MaThuoc = @MaThuoc)
				BEGIN
					PRINT N'BẠN KHÔNG THỂ XÓA THUỐC NÀY, BẠN CÓ THỂ ĐIỀU CHỈNH SỐ LƯỢNG CỦA NÓ VỀ KHÔNG'
				END
				ELSE
				BEGIN
					DELETE Thuoc
					WHERE MaThuoc = @MaThuoc
				END
			END
			ELSE
			BEGIN
				PRINT N'THUỐC KHÔNG TỒN TẠI'
			END
		END
		ELSE
		BEGIN
			PRINT N'BẠN KHÔNG CÓ QUYỀN THỰC HIỆN THAO TÁC NÀY'
		END
	GO

-- Các chức năng thống kê:
    -- Báo cáo các điều trị từ ngày trong ngày, theo từng bác sĩ
    CREATE OR ALTER PROCEDURE sp_BaoCaoCacDieuTri
		@MaNS VARCHAR(10),
		@NgayBD DATE,
		@NgayKT DATE
	AS
		-- Kiểm tra nha sĩ có tồn tại không, NgayBD < NgayKT
		IF (EXISTS (SELECT * FROM NhaSi WHERE MaNS = @MaNS)) AND (@NgayBD < @NgayKT)
		BEGIN
			SELECT * 
			FROM KeHoachDieuTri
			WHERE (NS_khamchinh = @MaNS OR NS_khamphu = @MaNS) AND Ngay BETWEEN @NgayBD AND @NgayKT
		END
		ELSE
		BEGIN
			PRINT N'NHA SĨ NÀY KHÔNG TỒN TẠI'
		END
	GO
	-- Báo cáo các cuộc hẹn từ ngày đến ngày, theo từng bác sĩ
	CREATE OR ALTER PROCEDURE sp_BaoCaoCacCuocHen
		@MaNS VARCHAR(10),
		@NgayBD DATE,
		@NgayKT DATE
	AS
		-- Kiểm tra nha sĩ này có tồn tại không
		IF (EXISTS (SELECT * FROM NhaSi WHERE MaNS = @MaNS)) AND (@NgayBD < @NgayKT)
		BEGIN
			SELECT * 
			FROM CuocHenMoi
			WHERE (NS_khamchinh = @MaNS OR NS_khamphu = @MaNS) AND Ngay BETWEEN @NgayBD AND @NgayKT
		END
		ELSE
		BEGIN
			PRINT N'NHA SĨ NÀY KHÔNG TỒN TẠI'
		END
	GO
	