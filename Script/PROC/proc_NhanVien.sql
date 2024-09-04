USE QL_PhongKhamNhaKhoa
GO
-- Xem danh sách bệnh nhân
CREATE OR ALTER PROC sp_xemDanhSachBenhNhan 
AS
	SELECT * FROM BenhAn
GO

--Thêm 1 bệnh nhân
CREATE OR ALTER PROC sp_themBenhAn (
	@MaBA VARCHAR(10) ,
    @hoten NVARCHAR(MAX),
    @ngaysinh DATE,
    @gioitinh NVARCHAR(10),
    @email NVARCHAR(MAX),
    @sodienthoai NVARCHAR(15),
    @diachi NVARCHAR(MAX),
    @TongTienDieuTri DECIMAL(18,0),
    @TongTienDieuTri_datra DECIMAL(18,0),
    @TongQuan NVARCHAR(MAX)
)
AS
	IF NOT EXISTS (SELECT * FROM BenhAn WHERE MaBA=@MaBA) 
	BEGIN 
		INSERT INTO BenhAn VALUES (@MaBA,@hoten,@ngaysinh,@gioitinh,@email,@sodienthoai,@diachi,@TongTienDieuTri,@TongTienDieuTri_datra,@TongQuan)
	END 
	ELSE PRINT (N'Mã bệnh án đã tồn tại') 
GO

--Cập nhật 1 bệnh nhân
CREATE OR ALTER PROC sp_capNhatBenhAn (
	@MaBA VARCHAR(10) ,
    @hoten NVARCHAR(MAX),
    @ngaysinh DATE,
    @gioitinh NVARCHAR(10),
    @email NVARCHAR(MAX),
    @sodienthoai NVARCHAR(15),
    @diachi NVARCHAR(MAX),
    @TongTienDieuTri DECIMAL(18,0),
    @TongTienDieuTri_datra DECIMAL(18,0),
    @TongQuan NVARCHAR(MAX)
)
AS
	IF EXISTS (SELECT * FROM BenhAn WHERE MaBA=@MaBA) 
	BEGIN 
		UPDATE BenhAn SET 
		hoten=@hoten ,
		ngaysinh=@ngaysinh ,
		gioitinh=@gioitinh ,
		email=@email ,
		sodienthoai=@sodienthoai ,
		diachi=@diachi ,
		TongTienDieuTri=@TongTienDieuTri ,
		TongTienDieuTri_datra=@TongTienDieuTri_datra ,
		TongQuan=@TongQuan 
		WHERE MaBA=@MaBA
	END 
	ELSE PRINT (N'Mã bệnh án không tồn tại') 
GO

-- Thêm thông tin chống chỉ định thuốc của bệnh nhân
CREATE OR ALTER PROC sp_themThongTinChongChiDinh (
	@MaBA VARCHAR(10),
    @sttCCD INT,
    @Mota NVARCHAR(MAX)
)
AS
	IF NOT EXISTS (SELECT * FROM ChongChiDinh WHERE MaBA=@MaBA AND sttCCD=@sttCCD) 
	BEGIN 
		INSERT INTO ChongChiDinh VALUES (@MaBA,@sttCCD,@Mota)
	END 
	ELSE PRINT (N'thông tin chống chỉ định thuốc đã tồn tại')	
GO

-- Xoá thông tin chống chỉ định thuốc của bệnh nhân
CREATE OR ALTER PROC sp_xoaThongTinChongChiDinh (
	@MaBA VARCHAR(10),
    @sttCCD INT
)
AS
	IF EXISTS (SELECT * FROM ChongChiDinh WHERE MaBA=@MaBA AND sttCCD=@sttCCD) 
	BEGIN 
		DELETE ChongChiDinh WHERE MaBA=@MaBA AND sttCCD=@sttCCD
	END 
	ELSE PRINT (N'thông tin chống chỉ định thuốc khong tồn tại') 
GO

-- Cập nhật thông tin chống chỉ định thuốc của bệnh nhân
CREATE OR ALTER PROC sp_capNhatThongTinChongChiDinh (
	@MaBA VARCHAR(10),
    @sttCCD INT,
    @Mota NVARCHAR(MAX)
)
AS
	IF EXISTS (SELECT * FROM ChongChiDinh WHERE MaBA=@MaBA AND sttCCD=@sttCCD) 
	BEGIN 
		UPDATE ChongChiDinh SET Mota=@Mota WHERE MaBA=@MaBA AND sttCCD=@sttCCD
	END 
	ELSE PRINT (N'thông tin chống chỉ định thuốc khong tồn tại') 
GO
-- Cập nhật thông tin tình trạng sức khỏe răng miệng của bệnh nhân
CREATE OR ALTER PROC sp_capNhatTinhTrangSucKhoe (
	@MaBA VARCHAR(10),
    @sttDU INT,
    @Mota NVARCHAR(MAX)
)
AS
	IF EXISTS (SELECT * FROM TinhTrangDiUng WHERE MaBA=@MaBA AND sttDU=@sttDU) 
	BEGIN 
		UPDATE TinhTrangDiUng SET Mota=@Mota WHERE MaBA=@MaBA AND sttDU=@sttDU
	END 
	ELSE PRINT (N'thông tin tình trạng sức khỏe khong tồn tại') 
GO
-- Xem kế hoạch điều trị của bệnh nhân
CREATE OR ALTER PROC sp_xemKeHoachDieuTri @MaBA VARCHAR(10)
AS
	SELECT * FROM KeHoachDieuTri WHERE MaBA=@MaBA
GO

--Thêm kế hoạch điều trị bệnh nhân
CREATE OR ALTER PROC sp_themKeHoachDieuTri (
	@MaDT VARCHAR(10) ,
    @MoTa NVARCHAR(MAX),
    @GhiChu NVARCHAR(MAX),
    @TrangThai NVARCHAR(50),
    @MaBA VARCHAR(10),
    @MaTT VARCHAR(10),
    @MaDV VARCHAR(10),
    @Ngay DATE,
    @Ca INT,
    @NS_khamchinh VARCHAR(10),
    @NS_khamphu VARCHAR(10)
)
AS
	IF NOT EXISTS (SELECT * FROM KeHoachDieuTri WHERE MaDT=@MaDT ) 
	BEGIN 
		IF NOT EXISTS (SELECT * FROM LichCaNhan WHERE Ngay=@Ngay AND Ca=@Ca AND NS_khamchinh=@NS_khamchinh AND NS_khamphu=@NS_khamphu ) 
		BEGIN 
			INSERT INTO KeHoachDieuTri VALUES (@MaDT,@MoTa,@GhiChu,@TrangThai,@MaBA,@MaTT,@MaDV,@Ngay,@Ca,@NS_khamchinh,@NS_khamphu)
		END 
		ELSE PRINT (N'lịch cá nhân này đang bận')
		
	END 
	ELSE PRINT (N'kế hoạch điều trị đã tồn tại')
GO

--Cập nhật kế hoạch điều trị bệnh nhân
CREATE OR ALTER PROC sp_capNhatKeHoachDieuTri (
	@MaDT VARCHAR(10) ,
    @MoTa NVARCHAR(MAX),
    @GhiChu NVARCHAR(MAX),
    @TrangThai NVARCHAR(50),
    @MaBA VARCHAR(10),
    @MaTT VARCHAR(10),
    @MaDV VARCHAR(10),
    @Ngay DATE,
    @Ca INT,
    @NS_khamchinh VARCHAR(10),
    @NS_khamphu VARCHAR(10)
)
AS
	IF EXISTS (SELECT * FROM KeHoachDieuTri WHERE MaDT=@MaDT ) 
	BEGIN 
		IF NOT EXISTS (SELECT * FROM LichCaNhan WHERE Ngay=@Ngay AND Ca=@Ca AND NS_khamchinh=@NS_khamchinh AND NS_khamphu=@NS_khamphu ) 
		BEGIN 
		UPDATE KeHoachDieuTri SET MoTa=@MoTa,GhiChu=@GhiChu,TrangThai=@TrangThai,MaBA=@MaBA,MaTT=@MaTT,
				MaDV=@MaDV,Ngay=@Ngay,Ca=@Ca,NS_khamchinh=@NS_khamchinh,NS_khamphu=@NS_khamphu 
				WHERE MaDT=@MaDT
		END 
		ELSE PRINT (N'lịch cá nhân này đang bận')
		
	END 
	ELSE PRINT (N'kế hoạch điều trị khong tồn tại')
GO
--Lọc các cuộc hẹn trong ngày Lọc theo bệnh nhân
CREATE OR ALTER PROC sp_locCuocHenTheoBenhNhan (
    @Ngay DATE,
	@MaBA VARCHAR(10)
	
)
AS

	SELECT *,'cuoc hen moi' as TrangThai
	FROM CuocHenMoi WHERE MaBA=@MaBA AND Ngay=@Ngay 
	UNION
	SELECT CH.MaCuocHen,CH.Phong,KH.Ngay,KH.Ca,KH.NS_khamchinh,KH.NS_khamphu,KH.MaBA,'tai kham' as TrangThai
	FROM CuocHenTaiKham CH JOIN KeHoachDieuTri KH ON CH.MaDT=KH.MaDT
	WHERE KH.MaBA=@MaBA AND KH.Ngay=@Ngay
GO

--Lọc các cuộc hẹn trong ngày Lọc theo phòng khám bệnh
CREATE OR ALTER PROC sp_locCuocHenTheoPhongKham (
    @Ngay DATE,
	@Phong INT
)
AS
	SELECT CH.*,'cuoc hen moi' as TrangThai
	FROM CuocHenMoi CH
	WHERE CH.Ngay=@Ngay AND CH.Phong=@Phong
	UNION
	SELECT CH.MaCuocHen,CH.Phong,KH.Ngay,KH.Ca,KH.NS_khamchinh,KH.NS_khamphu,KH.MaBA, 'tai kham' as TrangThai
	FROM CuocHenTaiKham CH JOIN KeHoachDieuTri KH ON CH.MaDT=KH.MaDT
	WHERE KH.Ngay=@Ngay AND CH.Phong=@Phong
GO

--Lọc các cuộc hẹn trong ngày Lọc các cuộc hẹn của riêng nha sĩ
CREATE OR ALTER PROC sp_locCuocHenTheoNhaSi (
    @Ngay DATE,
	@NhaSi VARCHAR(10)
)
AS
	SELECT CH.*,'cuoc hen moi' as TrangThai
	FROM CuocHenMoi CH
	WHERE CH.Ngay=@Ngay AND (CH.NS_khamchinh=@NhaSi OR CH.NS_khamphu=@NhaSi)
	UNION
	SELECT CH.MaCuocHen,CH.Phong,KH.Ngay,KH.Ca,KH.NS_khamchinh,KH.NS_khamphu,KH.MaBA, 'tai kham' as TrangThai
	FROM CuocHenTaiKham CH JOIN KeHoachDieuTri KH ON CH.MaDT=KH.MaDT
	WHERE KH.Ngay=@Ngay AND (KH.NS_khamchinh=@NhaSi OR KH.NS_khamphu=@NhaSi)
GO

-- Xem các yêu cầu hẹn từ bệnh nhân.
CREATE OR ALTER PROC sp_xemYeuCauHen (
	@MaBA VARCHAR(10)
)
AS
	SELECT * 
	FROM KeHoachDieuTri KH JOIN CuocHenTaiKham CH ON KH.MaDT=CH.MaDT
	WHERE KH.MaBA=@MaBA
GO

-- xóa các yêu cầu hẹn từ bệnh nhân.
CREATE OR ALTER PROC sp_xoaYeuCauHen (
	@MaCuocHen VARCHAR(10)
)
AS
	DELETE CuocHenTaiKham
	WHERE MaCuocHen=@MaCuocHen
GO
-- Thêm cuộc hẹn
CREATE OR ALTER PROC sp_themCuocHen (
	@MaCuocHen VARCHAR(10),
    @Phong INT,
    @Ngay DATE,
    @Ca INT,
    @NS_khamchinh VARCHAR(10),
    @NS_khamphu VARCHAR(10),
    @MaBA VARCHAR(10),
	@TrangThai VARCHAR(50),
	@GhiChu NVARCHAR(MAX),
	@NgayGui DATE,
	@MaDT VARCHAR(10)
)
AS
	IF NOT EXISTS (SELECT MaCuocHen FROM CuocHenMoi WHERE MaCuocHen=@MaCuocHen 
					UNION
					SELECT MaCuocHen FROM CuocHenTaiKham WHERE MaCuocHen=@MaCuocHen 
					) 
	BEGIN 
		-- neu la cuoc hen tai kham
		IF (@TrangThai='cuoc hen tai kham')
		BEGIN
			--kiem tra ma dieu tri co ton tai hay khong
			IF NOT EXISTS (SELECT * FROM KeHoachDieuTri WHERE MaDT=@MaDT)
			BEGIN
				-- các cuộc hẹn cùng ngày và ca thì phải khác phòng.
				IF NOT EXISTS (SELECT * FROM CuocHenTaiKham CH JOIN KeHoachDieuTri KH ON CH.MaDT=KH.MaDT 
								WHERE KH.Ngay=@Ngay AND KH.Ca=@Ca AND CH.Phong=@Phong AND KH.MaDT=@MaDT) 
				BEGIN 
					-- một lịch cá nhân chỉ có 1 cuộc hẹn
					IF NOT EXISTS (SELECT * FROM CuocHenTaiKham CH JOIN KeHoachDieuTri KH ON CH.MaDT=KH.MaDT 
					WHERE KH.Ngay=@Ngay AND KH.Ca=@Ca AND (KH.NS_khamchinh=@NS_khamchinh OR KH.NS_khamphu=@NS_khamphu OR KH.NS_khamchinh=@NS_khamphu OR KH.NS_khamphu=@NS_khamchinh)) 
					BEGIN 
						INSERT INTO KeHoachDieuTri VALUES (@MaDT,null,null,@TrangThai,@MaBA,null,null,@Ngay,@Ca,@NS_khamchinh,@NS_khamphu)
						INSERT INTO CuocHenTaiKham VALUES (@MaCuocHen,@GhiChu,@Phong,@NgayGui,@MaDT)
					END 
					ELSE PRINT (N'lịch cá nhân này đang bận')
				END
				ELSE
				BEGIN
					PRINT (N'phòng khám trong ca này đang bận')
					-- Thực hiện chuyển phòng
					WHILE EXISTS (SELECT * FROM CuocHenMoi WHERE Ngay=@Ngay AND Ca=@Ca AND Phong=@Phong ) 
					BEGIN
						SET @Phong=@Phong+1
					END
					PRINT N'Đã thực hiện chuyển phòng sang phòng khác'
					-- một lịch cá nhân chỉ có 1 cuộc hẹn
					IF NOT EXISTS (SELECT * FROM CuocHenTaiKham CH JOIN KeHoachDieuTri KH ON CH.MaDT=KH.MaDT 
					WHERE KH.Ngay=@Ngay AND KH.Ca=@Ca AND (KH.NS_khamchinh=@NS_khamchinh OR KH.NS_khamphu=@NS_khamphu OR KH.NS_khamchinh=@NS_khamphu OR KH.NS_khamphu=@NS_khamchinh)) 
					BEGIN 
						INSERT INTO KeHoachDieuTri VALUES (@MaDT,null,null,@TrangThai,@MaBA,null,null,@Ngay,@Ca,@NS_khamchinh,@NS_khamphu)
						INSERT INTO CuocHenTaiKham VALUES (@MaCuocHen,@GhiChu,@Phong,@NgayGui,@MaDT)
					END 
					ELSE PRINT (N'lịch cá nhân này đang bận')
				END
			END
			ELSE PRINT (N'Mã điều trị đẫ tồn tại')
		END
		-- neu la cuoc hen moi
		ELSE
			BEGIN
			-- các cuộc hẹn cùng ngày và ca thì phải khác phòng.
			IF NOT EXISTS (SELECT * FROM CuocHenMoi WHERE Ngay=@Ngay AND Ca=@Ca AND Phong=@Phong ) 
			BEGIN 
			
				-- một lịch cá nhân chỉ có 1 cuộc hẹn
				IF NOT EXISTS (SELECT * FROM CuocHenMoi WHERE Ngay=@Ngay AND Ca=@Ca AND 
				(NS_khamchinh=@NS_khamchinh OR NS_khamphu=@NS_khamphu OR NS_khamchinh=@NS_khamphu OR NS_khamphu=@NS_khamchinh) ) 
				BEGIN 
					INSERT INTO CuocHenMoi VALUES (@MaCuocHen,@Phong,@Ngay,@Ca,@NS_khamchinh,@NS_khamphu,@MaBA)
				END 
				ELSE PRINT (N'lịch cá nhân này đang bận')
			END 
			ELSE 
			BEGIN
				PRINT (N'phòng khám trong ca này đang bận')
				-- Thực hiện chuyển phòng
				WHILE EXISTS (SELECT * FROM CuocHenMoi WHERE Ngay=@Ngay AND Ca=@Ca AND Phong=@Phong ) 
				BEGIN
					SET @Phong=@Phong+1
				END
				PRINT N'Đã thực hiện chuyển phòng sang phòng khác'
				-- một lịch cá nhân chỉ có 1 cuộc hẹn
				IF NOT EXISTS (SELECT * FROM CuocHenMoi WHERE Ngay=@Ngay AND Ca=@Ca AND 
				(NS_khamchinh=@NS_khamchinh OR NS_khamphu=@NS_khamphu OR NS_khamchinh=@NS_khamphu OR NS_khamphu=@NS_khamchinh) ) 
				BEGIN 
					INSERT INTO CuocHenMoi VALUES (@MaCuocHen,@Phong,@Ngay,@Ca,@NS_khamchinh,@NS_khamphu,@MaBA)
				END 
				ELSE PRINT (N'lịch cá nhân này đang bận')
			END
		END
	END 
	ELSE PRINT (N'cuộc hẹn đã tồn tại')
GO

-- xóa  cuộc hẹn
CREATE OR ALTER PROC sp_xoaCuocHen (
	@MaCuocHen VARCHAR(10)  
)
AS
	IF EXISTS (SELECT * FROM CuocHenMoi WHERE MaCuocHen=@MaCuocHen ) 
	BEGIN 
		DELETE CuocHenMoi WHERE MaCuocHen=@MaCuocHen
	END 
	ELSE 
	BEGIN
		IF EXISTS (SELECT * FROM CuocHenTaiKham WHERE MaCuocHen=@MaCuocHen ) 
		BEGIN 
			DELETE CuocHenTaiKham WHERE MaCuocHen=@MaCuocHen
			
		END 
		ELSE PRINT (N'cuộc hẹn khong tồn tại')
	END

GO
-- sửa cuộc hẹn
CREATE OR ALTER PROC sp_suaCuocHen (
	@MaCuocHen VARCHAR(10),
    @Phong INT,
    @Ngay DATE,
    @Ca INT,
    @NS_khamchinh VARCHAR(10),
    @NS_khamphu VARCHAR(10),
    @MaBA VARCHAR(10),
	@TrangThai VARCHAR(50),
	@GhiChu NVARCHAR(MAX),
	@NgayGui DATE,
	@MaDT VARCHAR(10)
)
AS
	IF EXISTS (SELECT MaCuocHen FROM CuocHenMoi WHERE MaCuocHen=@MaCuocHen
				UNION
				SELECT MaCuocHen FROM CuocHenTaiKham WHERE MaCuocHen=@MaCuocHen ) 
	BEGIN 
		-- neu la cuoc hen tai kham
		IF (@TrangThai='cuoc hen tai kham')
		BEGIN
			--kiem tra ma dieu tri co ton tai hay khong
			IF EXISTS (SELECT * FROM KeHoachDieuTri WHERE MaDT=@MaDT)
			BEGIN
				-- các cuộc hẹn cùng ngày và ca thì phải khác phòng.
				IF NOT EXISTS (SELECT * FROM CuocHenTaiKham CH JOIN KeHoachDieuTri KH ON CH.MaDT=KH.MaDT 
								WHERE KH.Ngay=@Ngay AND KH.Ca=@Ca AND CH.Phong=@Phong AND KH.MaDT=@MaDT) 
				BEGIN 
					-- một lịch cá nhân chỉ có 1 cuộc hẹn
					IF NOT EXISTS (SELECT * FROM CuocHenTaiKham CH JOIN KeHoachDieuTri KH ON CH.MaDT=KH.MaDT 
					WHERE KH.Ngay=@Ngay AND KH.Ca=@Ca AND (KH.NS_khamchinh=@NS_khamchinh OR KH.NS_khamphu=@NS_khamphu OR KH.NS_khamchinh=@NS_khamphu OR KH.NS_khamphu=@NS_khamchinh)) 
					BEGIN 
						UPDATE CuocHenTaiKham SET GhiChu=@GhiChu,Phong=@Phong,NgayGui=@NgayGui WHERE MaCuocHen=@MaCuocHen
						UPDATE KeHoachDieuTri SET MaBA=@MaBA,Ngay=@Ngay,Ca=@Ca,NS_khamchinh=@NS_khamchinh,NS_khamphu=@NS_khamphu WHERE MaDT=@MaDT
					END 
					ELSE PRINT (N'lịch cá nhân này đang bận')
				END
				ELSE
				BEGIN
					PRINT (N'phòng khám trong ca này đang bận')
					-- Thực hiện chuyển phòng
					WHILE EXISTS (SELECT * FROM CuocHenMoi WHERE Ngay=@Ngay AND Ca=@Ca AND Phong=@Phong ) 
					BEGIN
						SET @Phong=@Phong+1
					END
					PRINT N'Đã thực hiện chuyển phòng sang phòng khác'
					-- một lịch cá nhân chỉ có 1 cuộc hẹn
					IF NOT EXISTS (SELECT * FROM CuocHenTaiKham CH JOIN KeHoachDieuTri KH ON CH.MaDT=KH.MaDT 
					WHERE KH.Ngay=@Ngay AND KH.Ca=@Ca AND (KH.NS_khamchinh=@NS_khamchinh OR KH.NS_khamphu=@NS_khamphu OR KH.NS_khamchinh=@NS_khamphu OR KH.NS_khamphu=@NS_khamchinh)) 
					BEGIN 
						UPDATE CuocHenTaiKham SET GhiChu=@GhiChu,Phong=@Phong,NgayGui=@NgayGui WHERE MaCuocHen=@MaCuocHen
						UPDATE KeHoachDieuTri SET MaBA=@MaBA,Ngay=@Ngay,Ca=@Ca,NS_khamchinh=@NS_khamchinh,NS_khamphu=@NS_khamphu WHERE MaDT=@MaDT
					END 
					ELSE PRINT (N'lịch cá nhân này đang bận')
				END
			END
			ELSE PRINT (N'Mã điều trị khong tồn tại')
		END
		-- neu la cuoc hen moi
		ELSE
		BEGIN
			-- các cuộc hẹn cùng ngày và ca thì phải khác phòng.
			IF NOT EXISTS (SELECT * FROM CuocHenMoi WHERE Ngay=@Ngay AND Ca=@Ca AND Phong=@Phong) 
			BEGIN 
				-- một lịch cá nhân chỉ có 1 cuộc hẹn
				IF NOT EXISTS (SELECT * FROM CuocHenMoi WHERE Ngay=@Ngay AND Ca=@Ca AND 
				(NS_khamchinh=@NS_khamchinh OR NS_khamphu=@NS_khamphu OR NS_khamchinh=@NS_khamphu OR NS_khamphu=@NS_khamchinh) ) 
				BEGIN 
					UPDATE CuocHenMoi SET Phong=@Phong,Ngay=@Ngay,Ca=@Ca,NS_khamchinh=@NS_khamchinh,NS_khamphu=@NS_khamphu,MaBA=@MaBA
					WHERE MaCuocHen=@MaCuocHen
				END 
				ELSE PRINT (N'lịch cá nhân này đang bận')
			END 
			ELSE
			BEGIN
				PRINT (N'phòng khám trong ca này đang bận')
				-- Thực hiện chuyển phòng
				WHILE EXISTS (SELECT * FROM CuocHenMoi WHERE Ngay=@Ngay AND Ca=@Ca AND Phong=@Phong ) 
				BEGIN
					SET @Phong=@Phong+1
				END
				PRINT N'Đã thực hiện chuyển phòng sang phòng khác'
				-- một lịch cá nhân chỉ có 1 cuộc hẹn
				IF NOT EXISTS (SELECT * FROM CuocHenMoi WHERE Ngay=@Ngay AND Ca=@Ca AND 
				(NS_khamchinh=@NS_khamchinh OR NS_khamphu=@NS_khamphu OR NS_khamchinh=@NS_khamphu OR NS_khamphu=@NS_khamchinh) ) 
				BEGIN 
					UPDATE CuocHenMoi SET Phong=@Phong,Ngay=@Ngay,Ca=@Ca,NS_khamchinh=@NS_khamchinh,NS_khamphu=@NS_khamphu,MaBA=@MaBA
					WHERE MaCuocHen=@MaCuocHen
				END 
				ELSE PRINT (N'lịch cá nhân này đang bận')
			END

		END
	END 
	ELSE PRINT (N'cuộc hẹn khong tồn tại') 
GO

