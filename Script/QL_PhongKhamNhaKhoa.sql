use master 
go 

drop database QL_PhongKhamNhaKhoa
go

create database QL_PhongKhamNhaKhoa
go 

use QL_PhongKhamNhaKhoa
go

-- BenhNhan (Patient) table
CREATE TABLE BenhAn (
    MaBA VARCHAR(10),
    hoten NVARCHAR(MAX),
    ngaysinh DATE,
    gioitinh NVARCHAR(10) CHECK(gioitinh in (N'M',N'F')),
    email NVARCHAR(MAX),
    sodienthoai NVARCHAR(15),
    diachi NVARCHAR(MAX),
    TongTienDieuTri DECIMAL(18,0),
    TongTienDieuTri_datra DECIMAL(18,0),
    TongQuan NVARCHAR(MAX),

	CONSTRAINT PK_BA PRIMARY KEY(MaBA)
);
go

-- ChongChiDinh (Contraindications) table
CREATE TABLE ChongChiDinh (
    MaBA VARCHAR(10),
    sttCCD INT,
    Mota NVARCHAR(MAX),

    CONSTRAINT PK_CCD PRIMARY KEY (MaBA, sttCCD),
    CONSTRAINT FK_CCD_BA FOREIGN KEY (MaBA) REFERENCES BenhAn(MaBA)
);
go

-- TinhTrangDiUng (Allergic Status) table
CREATE TABLE TinhTrangDiUng (
    MaBA VARCHAR(10),
    sttDU INT,
    Mota NVARCHAR(MAX),

    CONSTRAINT PK_TTDU PRIMARY KEY (MaBA, sttDU),
    CONSTRAINT FK_TTDU_BA FOREIGN KEY (MaBA) REFERENCES BenhAn(MaBA)
);
go


-- ThanhToan (Payment) table
CREATE TABLE ThanhToan (
    MaTT VARCHAR(10) PRIMARY KEY,
    TongTien DECIMAL(18,2),
    Tien_Nhan DECIMAL(18,2),
    LoaiTT NVARCHAR(50),
    NgayGD DATE,
    TenNguoiTT NVARCHAR(MAX)
);
go

-- CaTruc table
CREATE TABLE CaTruc (
    Ca INT PRIMARY KEY,
    Giobd TIME,
    giokt TIME
);
go

-- NhaSi (Doctor) table
CREATE TABLE NhaSi (
    MaNS VARCHAR(10) PRIMARY KEY,
    TenNS NVARCHAR(MAX),
    Ngaysinh DATE,
    gioitinh NVARCHAR(10),
    sodienthoai NVARCHAR(15),
    Email NVARCHAR(255),
    Diachi NVARCHAR(MAX)
);
go

-- LichCaNhan (Personal Schedule) table
CREATE TABLE LichCaNhan (
    Ngay DATE,
    Ca INT,
    NS_khamchinh VARCHAR(10),
    NS_khamphu VARCHAR(10),

    CONSTRAINT PK_LCN PRIMARY KEY (Ngay, Ca, NS_khamchinh, NS_khamphu),

	CONSTRAINT FK_LCN_CT FOREIGN KEY (CA) REFERENCES CATRUC(CA),
    CONSTRAINT FK_LCN_NS1 FOREIGN KEY (NS_khamchinh) REFERENCES NhaSi(MaNS),
    CONSTRAINT FK_LCN_NS2 FOREIGN KEY (NS_khamphu) REFERENCES NhaSi(MaNS),
);
go


-- CuocHenKhachHangMoi (Appointment for New Customers) table
--DROP TABLE CuocHenMoi
CREATE TABLE CuocHenMoi (
    MaCuocHen VARCHAR(10),
    Phong INT,
    Ngay DATE,
    Ca INT,
    NS_khamchinh VARCHAR(10),
    NS_khamphu VARCHAR(10),
    MaBA VARCHAR(10),

	CONSTRAINT PK_CHM PRIMARY KEY(MaCuocHen),

    CONSTRAINT FK_CHKM_LCN FOREIGN KEY (Ngay, CA, NS_khamchinh, NS_khamphu) REFERENCES LichCaNhan(Ngay,Ca,NS_khamchinh, NS_khamphu),
    CONSTRAINT FK_CHKM_BA FOREIGN KEY (MaBA) REFERENCES BenhAn(MaBA)
);
go



-- DichVu (Service) table
CREATE TABLE DichVu (
    MaDV VARCHAR(10) PRIMARY KEY,
    TenDV NVARCHAR(255),
    Gia INT
);
go


-- KeHoachDieuTri (Treatment Plan) table
CREATE TABLE KeHoachDieuTri (
    MaDT VARCHAR(10),

    MoTa NVARCHAR(MAX),
    GhiChu NVARCHAR(MAX),
    TrangThai NVARCHAR(50),

    MaBA VARCHAR(10),
    MaTT VARCHAR(10),
    MaDV VARCHAR(10),

    Ngay DATE,
    Ca INT,
    NS_khamchinh VARCHAR(10),
    NS_khamphu VARCHAR(10),

	CONSTRAINT PK_KHDT PRIMARY KEY (MaDT),
	CONSTRAINT FK_KHDT_LCN FOREIGN KEY (Ngay, CA, NS_khamchinh, NS_khamphu) REFERENCES LichCaNhan(Ngay,Ca,NS_khamchinh, NS_khamphu),
    CONSTRAINT FK_KHDT_BA FOREIGN KEY (MaBA) REFERENCES BenhAn(MaBA),
    CONSTRAINT FK_KHDT_TT FOREIGN KEY (MaTT) REFERENCES ThanhToan(maTT),
    CONSTRAINT FK_KHDT_DV FOREIGN KEY (MaDV) REFERENCES DichVu(MaDV),
    
);
go

-- CuocHenTaiKham (Follow-up Appointment) table
CREATE TABLE CuocHenTaiKham (
    MaCuocHen VARCHAR(10) PRIMARY KEY, -- vừa là mã phiếu yêu cầu vừa là mã cuộc hẹn, nếu phiếu yc chưa đc xác nhận thì ghi chú và phòng là null.
    GhiChu NVARCHAR(MAX),
    Phong INT,

    --MaPYCH VARCHAR(10),
    NgayGui DATE,
	MaDT VARCHAR(10),

    --FOREIGN KEY (MaPYCH) REFERENCES PhieuYCHen(MaPYCH),
	CONSTRAINT FK_CHTK_DT FOREIGN KEY (MaDT) REFERENCES KeHoachDieuTri(MaDT)
);
go

-- Rang (Tooth) table
CREATE TABLE Rang (
    maRang VARCHAR(10) PRIMARY KEY,
    LoaiRang NVARCHAR(50)
);
go

-- BeMatRang (Tooth Surface) table
CREATE TABLE BeMatRang (
    maBeMat VARCHAR(10) PRIMARY KEY,
    MoTa NVARCHAR(MAX)
);
go

-- ChiTietRang (Tooth Details) table
CREATE TABLE ChiTietRang (
    MaDT VARCHAR(10),
	MaRang VARCHAR(10),
    MaBeMat VARCHAR(10),

    PRIMARY KEY (MaDT, MaRang, MaBeMat),

	CONSTRAINT FK_CTR_DT FOREIGN KEY (MaDT) REFERENCES KeHoachDieuTri(MaDT),
    CONSTRAINT FK_CTR_R FOREIGN KEY (MaRang) REFERENCES Rang(MaRang),
    CONSTRAINT FK_CTR_BMR FOREIGN KEY (MaBeMat) REFERENCES BeMatRang(maBeMat)
);
go

-- Thuoc (Medicine) table
CREATE TABLE Thuoc (
    MaThuoc VARCHAR(10) PRIMARY KEY,
    TenThuoc NVARCHAR(255),
    HanSD DATE,
    DonGia INT,
    DonViTinh NVARCHAR(50),
    Soluongton INT,
    GhiChu NVARCHAR(MAX)
);
go

-- ChiTietDonThuoc (Prescription Details) table
CREATE TABLE ChiTietDonThuoc (
    MaThuoc VARCHAR(10),
    MaDT VARCHAR(10),
    Soluong INT,
    Lieudung NVARCHAR(MAX),
    PRIMARY KEY (MaThuoc, MaDT),
    CONSTRAINT FK_CTDT_T FOREIGN KEY (MaThuoc) REFERENCES Thuoc(MaThuoc),
    CONSTRAINT FK_CTDT_KHDT FOREIGN KEY (MaDT) REFERENCES KeHoachDieuTri(MaDT)
);
go


-- NhanVien (Doctor) table
CREATE TABLE NhanVien (
    MaNV VARCHAR(10) PRIMARY KEY,
    TenNV NVARCHAR(MAX),
    Ngaysinh DATE,
    gioitinh NVARCHAR(10),
    sodienthoai NVARCHAR(15),
    Email NVARCHAR(255),
    Diachi NVARCHAR(MAX)
);
go

-- *****************************************  PHÂN QUYỀN QUẢN TRỊ VIÊN  ********************************************
EXEC sp_addrole 'QuanTriVien'
GO

--1. Quản lý hồ sơ bệnh nhân
--Xem, thêm, cập nhật bệnh nhân
Grant select, insert, update on BenhAn to QuanTriVien
go
Grant select, insert, update on ChongChiDinh to QuanTriVien
go
Grant select, insert, update on TinhTrangDiUng to QuanTriVien
go
--Xem, thêm, cập nhật kế hoạch điều trị bệnh nhân
Grant select, insert, update on KeHoachDieuTri to QuanTriVien	
go
Grant select, insert, update on ChiTietRang to QuanTriVien
go
--Thêm, cập nhật, xóa đơn thuốc của bệnh nhân
Grant select, insert, update, delete on ChiTietDonThuoc to QuanTriVien
go
--2. Quản lý cuộc hẹn
--Xem, thêm, xóa, sửa cuộc hẹn
Grant select, insert, delete, update on CuocHenMoi to QuanTriVien
go
Grant select, insert, delete, update on CuocHenTaiKham to QuanTriVien
go
----Xem, xóa các yêu cầu hẹn từ bệnh nhân
--Grant select, delete on PhieuYCHen to QuanTriVien
--go
--3. Quản lý thuốc
--Xem, thêm, cập nhật, xóa thuốc
Grant select, insert, update, delete on Thuoc to QuanTriVien
go
--4. Quản lý dữ liệu nha sĩ, nhân viên
--Xem danh sách nha sĩ, thêm / cập nhật thông tin nha sĩ
Grant select, insert, update on NhaSi to QuanTriVien
go
--Xem, thêm lịch làm việc của các nha sĩ
Grant select, insert on LichCaNhan to QuanTriVien
go
--Xem danh sách nhân viên, thêm / cập nhật thông tin nhân viên
Grant select, insert, update on NhanVien to QuanTriVien
go

-- *****************************************  PHÂN QUYỀN NHA SĨ  ********************************************
EXEC sp_addrole 'NhaSi'
GO

-- Nha sĩ là người dùng với quyền hạn thấp nhất

-- Chỉnh sửa thông tin bệnh án, sơ đồ nha chu, tình trạng răng hàm, hồ sơ điều trị của bệnh nhân

-- 0. Chức năng đăng nhập

-- 1. Xem/Thêm/Sửa thông tin bệnh nhân

GRANT SELECT ON BenhAn TO NhaSi
GO

GRANT UPDATE ON BenhAn(TongQuan) to NhaSi
GO

GRANT SELECT,UPDATE,INSERT ON ChongChiDinh TO NhaSi
GO

GRANT SELECT,UPDATE,INSERT ON TinhTrangDiUng TO NhaSi
GO

GRANT SELECT,UPDATE,INSERT ON KeHoachDieuTri TO NhaSi
GO

GRANT SELECT,UPDATE,INSERT ON ChiTietRang TO NhaSi
GO

GRANT SELECT ON BeMatRang TO NhaSi
GO

GRANT SELECT ON Rang TO NhaSi

-- 2. Xem thanh toán của bệnh nhân
GRANT SELECT ON ThanhToan TO NhaSi
GO
-- 3. Thêm/Cập nhật/Xóa đơn thuốc của bệnh nhân
GRANT SELECT,INSERT,UPDATE,DELETE ON ChiTietDonThuoc TO NhaSi
GO

GRANT SELECT ON Thuoc TO NhaSi
GO

-- 4. Xem danh sách nha sĩ
GRANT SELECT ON NhaSi TO NhaSi
GO
-- 5. Xem danh sách nhân viên
GRANT SELECT ON NhanVien TO NhaSi
GO
-- 6. Xem lịch trình làm việc của nha sĩ
GRANT SELECT, INSERT, UPDATE, DELETE ON LichCaNhan TO NhaSi

-- 7. Quản lí cuộc hẹn
GRANT SELECT ON CuocHenMoi TO NhaSi
GRANT SELECT ON CuocHenTaiKham TO NhaSi
-- *****************************************  PHÂN QUYỀN NHÂN VIÊN  ********************************************
Exec sp_addrole 'NhanVien'
go

--1. Quản lý hồ sơ bệnh nhân
-- Xem, Thêm, cập nhật bệnh nhân
Grant select, update, insert on BenhAn to NhanVien
go
Grant select, update, insert on ChongChiDinh to NhanVien
go
Grant select, update, insert on TinhTrangDiUng to NhanVien
go
-- Xem, thêm, cập nhật kế hoạch điều trị
Grant select, update, insert on KeHoachDieuTri to NhanVien
go
Grant select, update, insert on ChiTietRang to NhanVien
go
-- Thêm, cập nhật, xóa đơn thuốc của bệnh nhân
Grant select, update, insert, delete on ChiTietDonThuoc to NhanVien
go

--2. Quản lý cuộc hẹn
-- Xem, thêm, điều chỉnh, xóa cuộc hẹn
Grant select, update, insert, delete on CuocHenMoi to NhanVien
Go
Grant select, update, insert, delete on CuocHenTaiKham to NhanVien
Go

-- Xem, xóa các yêu cầu hẹn từ bệnh nhân
--Grant select, delete on PhieuYCHen to NhanVien
--Go

--3. Quản lý dữ liệu hệ thống
-- Xem danh sách nha sĩ
Grant select on NhaSi to NhanVien
Go
-- Xem danh sách nhân viên
Grant select on NhanVien to NhanVien
Go
-- Xem danh sách nha sĩ và lịch trình làm việc tương ứng
Grant select on LichCaNhan to NhanVien
Go

--4. Quản lý thuốc
-- Xem danh sách thuốc
Grant select on Thuoc to NhanVien
Go
-- *****************************************  THÊM CÁC LOGIN  ********************************************
--[KHÁCH HÀNG]

--[NHA SĨ]
Exec sp_addlogin 'NS1','1','QL_PhongKhamNhaKhoa'
Exec sp_grantdbaccess 'NS1', 'NS1'
EXEC sp_addrolemember 'NhaSi', 'NS1';
--[NHÂN VIÊN]
Exec sp_addlogin 'NV1','1','QL_PhongKhamNhaKhoa'
Exec sp_grantdbaccess 'NV1', 'NV1'
EXEC sp_addrolemember 'NhanVien', 'NV1';

--[QUẢN TRỊ VIÊN]
EXEC sp_addlogin 'QTV','1000','QL_PhongKhamNhaKhoa'
EXEC sp_grantdbaccess 'QTV', 'QTV'
EXEC sp_addrolemember 'QuanTriVien', 'QTV'
--***************************  CHẠY PROC  **************************
--[NHÂN VIÊN]
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
		IF EXISTS (SELECT * FROM LichCaNhan WHERE Ngay=@Ngay AND Ca=@Ca AND NS_khamchinh=@NS_khamchinh AND NS_khamphu=@NS_khamphu)
		BEGIN
			INSERT INTO KeHoachDieuTri VALUES (@MaDT,@MoTa,@GhiChu,@TrangThai,@MaBA,@MaTT,@MaDV,@Ngay,@Ca,@NS_khamchinh,@NS_khamphu)
		END
		ELSE PRINT (N'lịch cá nhân này không tồn tại')
		 
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
		IF EXISTS (SELECT * FROM LichCaNhan WHERE Ngay=@Ngay AND Ca=@Ca AND NS_khamchinh=@NS_khamchinh AND NS_khamphu=@NS_khamphu ) 
		BEGIN 
		UPDATE KeHoachDieuTri SET MoTa=@MoTa,GhiChu=@GhiChu,TrangThai=@TrangThai,MaBA=@MaBA,MaTT=@MaTT,
				MaDV=@MaDV,Ngay=@Ngay,Ca=@Ca,NS_khamchinh=@NS_khamchinh,NS_khamphu=@NS_khamphu 
				WHERE MaDT=@MaDT
		END 
		ELSE PRINT (N'lịch cá nhân này không tồn tại')
		
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

--[NHA SĨ]
USE QL_PhongKhamNhaKhoa
GO


-- Xem danh sách nha sĩ. Đối tượng người dùng cho phép: quản trị viên, nhân viên, nha sĩ
CREATE OR ALTER PROC sp_XemNhaSi
	@MaNS VARCHAR(10)
AS
	IF (NOT EXISTS(	SELECT * FROM NhaSi
					WHERE @MaNS = MaNS))
	BEGIN
		PRINT N'Không thể tìm thấy nha sĩ với mã: ' + @MaNS
		RETURN 1
	END
	SELECT *
	FROM NhaSi
	WHERE MaNS = @MaNS
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
	@MaNV VARCHAR(10)
AS
	IF (NOT EXISTS(	SELECT * FROM NhanVien
					WHERE @MaNV = MaNV))
	BEGIN
		PRINT N'Không thể tìm thấy nhân viên với mã: ' + @MaNV
		RETURN 1
	END

	SELECT *
	FROM NhanVien
	WHERE MaNV = @MaNV
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
		RETURN 1
	END

	IF (NOT EXISTS(SELECT * FROM BenhAn WHERE MaBA=@MaBA))
	BEGIN
		PRINT N'Không tìm thấy bệnh nhân với mã: ' + @MaBA
		RETURN 1
	END

	IF (NOT EXISTS(SELECT * FROM DichVu WHERE MaDV=@MaDV))
	BEGIN
		PRINT N'Không tìm thấy dịch vụ'
		RETURN 1
	END

	-- Nha sĩ chính và phụ không thể tham gia điều trị ở 2 kế hoạch cùng lúc
	--IF (EXISTS(SELECT * FROM KeHoachDieuTri WHERE
	--	Ngay=@Ngay AND Ca=@Ca AND NS_khamchinh=@Chinh AND NS_khamphu=@Phu))
	--BEGIN
	--	PRINT N'Lịch của 2 nha sĩ này đã được định ở kế hoạch điều trị khác.'
	--	RETURN 1
	--END

	IF (NOT EXISTS(SELECT * FROM LichCaNhan WHERE 
		Ngay=@Ngay AND Ca=@Ca AND NS_khamchinh=@Chinh AND NS_khamphu=@Phu))
	BEGIN
		PRINT N'Không thể lập kế hoạch cho lịch: '
		PRINT N'Nha sĩ chính: ' + @Chinh 
		PRINT N'Nha sĩ phụ: ' + @Phu
		PRINT N'Ngày ' + CAST(@Ngay AS VARCHAR) + ' Ca ' + CAST(@Ca AS VARCHAR)
		RETURN 1
	END

	INSERT INTO KeHoachDieuTri(MaDT,MoTa,GhiChu,TrangThai,MaBA,MaDV,Ngay,Ca,NS_khamchinh,NS_khamphu) VALUES
	(@MaDT,@MoTa,@GhiChu,@TrangThai,@MaBA,@MaDV,@Ngay,@Ca,@Chinh,@Phu)
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
		RETURN 1
	END

	-- kiểm tra mã răng
	IF (NOT EXISTS(SELECT * FROM Rang WHERE maRang =@MaRang))
	BEGIN
		PRINT N'Mã răng không tồn tại'
		RETURN 1
	END

	-- kiểm tra mabemat
	IF (NOT EXISTS(SELECT * FROM BeMatRang WHERE maBeMat = @MaBeMat))
	BEGIN
		PRINT N'Bề mặt răng không tồn tại'
		RETURN 1
	END

	-- kiểm tra chi tiết có tồn tại
	IF (EXISTS (SELECT * FROM ChiTietRang WHERE MaBeMat=@MaBeMat AND MaRang = @MaRang
				AND MaDT = @MaDT))
	BEGIN
		PRINT N'Đã có chi tiết răng này!'
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
		RETURN 1
	END

	-- kiểm tra răng có tồn tại
	IF (NOT EXISTS(SELECT * FROM Rang WHERE maRang =@RangMoi))
	BEGIN
		PRINT N'Mã răng không tồn tại'
		RETURN 1
	END

	-- kiểm tra bề mặt có tồn tại
	IF (NOT EXISTS(SELECT * FROM BeMatRang WHERE maBeMat = @BeMatMoi))
	BEGIN
		PRINT N'Bề mặt răng không tồn tại'
		RETURN 1
	END

	UPDATE ChiTietRang
	SET	MaRang=@RangMoi, MaBeMat=@BeMatMoi
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
		RETURN 1
	END

	-- kiểm tra kế hoạch điều trị tồn tại
	IF (NOT EXISTS(SELECT * FROM KeHoachDieuTri WHERE MaDT = @MaDT))
	BEGIN
		PRINT N'Mã điều trị: ' + @MaDT + N' không tồn tại'
		RETURN 1
	END

	-- kiểm tra số lượng hợp lý
	IF (@SL <= 0)
	BEGIN
		PRINT N'Số lượng phải lớn hơn 0!'
		RETURN 1
	END

	IF (@SL > (SELECT Soluongton
				FROM Thuoc
				WHERE MaThuoc = @MaThuoc))
	BEGIN
		PRINT N'Thuốc với mã: ' + @MaThuoc + N' đã hết'
		RETURN 1
	END

	-- kiểm tra đơn thuốc có tồn tại chưa
	IF (EXISTS (SELECT * FROM ChiTietDonThuoc WHERE MaThuoc=@MaThuoc
				AND MaDT = @MaDT))
	BEGIN
		PRINT N'Thuốc đã được kê cho kế hoạch này!'
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
		RETURN 1
	END

	UPDATE Thuoc
	SET Soluongton=Soluongton-(@SL-@SLCu)
	WHERE MaThuoc = @MaThuoc

	UPDATE ChiTietDonThuoc
	SET Soluong=@SL, Lieudung=@Lieu
	WHERE MaThuoc = @MaThuoc AND MaDT = @MaDT

	PRINT N'Giao tác thành công!'

	RETURN 0
GO

-- Xem các cuộc hẹn (tái khám, lẫn mới)
CREATE OR ALTER PROC sp_XemCuocHen_BenhNhan
	@Ngay DATE,
	@MaBA VARCHAR(10)
AS
	-- in chung một bản 
	-- hiển thị loại cuộc hẹn
	SELECT *, N'Cuộc hẹn mới' AS TrangThai
	FROM CuocHenMoi
	WHERE Ngay = @Ngay AND MaBA = @MaBA
	UNION
	SELECT CHTK.MaCuocHen, CHTK.Phong, KH.Ngay, KH.Ca, KH.NS_khamchinh,KH.NS_khamphu,KH.MaBA, N'Cuộc hẹn tái khám' AS TrangThai
	FROM CuocHenTaiKham CHTK JOIN KeHoachDieuTri KH ON CHTK.MaDT = KH.MaDT
	WHERE NgayGui = @Ngay AND KH.MaBA = @MaBA
GO

CREATE OR ALTER PROC sp_XemCuocHen_Phong
	@Ngay DATE,
	@Phong INT
AS
	-- in chung một bản 
	-- hiển thị loại cuộc hẹn
	SELECT *, N'Cuộc hẹn mới' AS TrangThai
	FROM CuocHenMoi
	WHERE Ngay = @Ngay AND Phong = @Phong
	UNION
	SELECT CHTK.MaCuocHen, CHTK.Phong, KH.Ngay, KH.Ca, KH.NS_khamchinh,KH.NS_khamphu,KH.MaBA, N'Cuộc hẹn tái khám' AS TrangThai
	FROM CuocHenTaiKham CHTK JOIN KeHoachDieuTri KH ON CHTK.MaDT = KH.MaDT
	WHERE NgayGui = @Ngay AND CHTK.Phong = @Phong
GO

CREATE OR ALTER PROC sp_XemCuocHen_NhaSi
	@Ngay DATE,
	@NhaSi VARCHAR(10)
AS
	SELECT CH.*,N'Cuộc hẹn mới' as TrangThai
	FROM CuocHenMoi CH
	WHERE CH.Ngay=@Ngay AND (CH.NS_khamchinh=@NhaSi OR CH.NS_khamphu=@NhaSi)
	UNION
	SELECT CH.MaCuocHen,CH.Phong,KH.Ngay,KH.Ca,KH.NS_khamchinh,KH.NS_khamphu,KH.MaBA, N'Cuộc hẹn tái khám' as TrangThai
	FROM CuocHenTaiKham CH JOIN KeHoachDieuTri KH ON CH.MaDT=KH.MaDT
	WHERE KH.Ngay=@Ngay AND (KH.NS_khamchinh=@NhaSi OR KH.NS_khamphu=@NhaSi)
GO
	
-- Lịch cá nhân: Nha sĩ không thể vừa khám chính vừa khám phụ
	-- Trong cùng 1 ngày và ca nha sĩ không thể vừa khám chính cho record này vừa khám phụ cho record kia
CREATE OR ALTER PROC sp_XemLCN_Ngay
	@Ngay DATE
AS
	SELECT * FROM LichCaNhan
	WHERE Ngay = @Ngay

	RETURN 0
GO

-- XEM THEO TUẦN
CREATE OR ALTER PROC sp_XemLCN_Tuan
AS
	SELECT * FROM LichCaNhan
	WHERE Ngay >= DATEADD(DAY, 1-DATEPART(DW,GETDATE()),CONVERT(DATE,GETDATE()))
	AND	Ngay < DATEADD(DAY, 8-DATEPART(DW,GETDATE()),CONVERT(DATE,GETDATE()))
-- XEM THEO THÁNG
GO


CREATE OR ALTER PROC sp_XemLCN_Thang
	@Thang INT
AS
	IF (@Thang < 1 OR @Thang > 12)
		RETURN 1

	SELECT * FROM LichCaNhan
	WHERE MONTH(Ngay) = @Thang
GO

--[QUẢN TRỊ VIÊN]
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
-- Xem lịch làm việc theo ngày
CREATE OR ALTER PROC  sp_XemLichCaNhan_TheoNgay
	@Ngay date
as
begin
	Select * from LichCaNhan where Ngay = @Ngay
end
go
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


CREATE OR ALTER PROCEDURE sp_XemThuoc_MaThuoc
	@MaThuoc varchar(10)
AS
	SELECT * FROM Thuoc where MaThuoc = @MaThuoc
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
		if exists(select * from Thuoc where MaThuoc = @MaThuoc ) 
		begin 
			Print N'Thuốc đã tồn tại.'
			return 1
		end
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
-------------------------   NHÂN VIÊN   -------------------------
GRANT EXEC ON dbo.sp_themCuocHen TO NhanVien
GO
GRANT EXEC ON dbo.sp_themKeHoachDieuTri TO NhanVien
GO
GRANT EXEC ON dbo.sp_themBenhAn TO NhanVien
GO
GRANT EXEC ON dbo.sp_themThongTinChongChiDinh TO NhanVien
GO
GRANT EXEC ON dbo.sp_xemKeHoachDieuTri TO NhanVien
GO
GRANT EXEC ON dbo.sp_locCuocHenTheoPhongKham TO NhanVien
GO
GRANT EXEC ON dbo.sp_locCuocHenTheoBenhNhan TO NhanVien
GO
GRANT EXEC ON dbo.sp_locCuocHenTheoNhaSi TO NhanVien
GO
-------------------------   NHA SĨ   --------------------------
GRANT EXEC ON dbo.sp_XemNhaSi TO NhaSi
GO
GRANT EXEC ON dbo.sp_ThemKeHoachDieuTri TO NhaSi
GO
GRANT EXEC ON dbo.sp_ThemCTRang TO NhaSi
GO
GRANT EXEC ON dbo.sp_XoaCTRang TO NhaSi
GO
GRANT EXEC ON dbo.sp_SuaCTRang TO NhaSi
GO
GRANT EXEC ON dbo.sp_ThemDonThuoc TO NhaSi
GO
GRANT EXEC ON dbo.sp_XoaDonThuoc TO NhaSi
GO
GRANT EXEC ON dbo.sp_SuaDonThuoc TO NhaSi
GO
GRANT EXEC ON dbo.sp_locCuocHenTheoPhongKham TO NhaSi
GO
GRANT EXEC ON dbo.sp_locCuocHenTheoBenhNhan TO NhaSi
GO
GRANT EXEC ON dbo.sp_locCuocHenTheoNhaSi TO NhaSi
GO
GRANT EXEC ON dbo.sp_XemLCN_Ngay TO NhaSi
GO
GRANT EXEC ON dbo.sp_XemLCN_Tuan TO NhaSi
GO
GRANT EXEC ON dbo.sp_XemLCN_Thang TO NhaSi
GO

-------------------------   QUẢN TRỊ VIÊN   -------------------------
GRANT EXEC ON dbo.sp_ThemThuoc TO QuanTriVien
GO
GRANT EXEC ON dbo.sp_CapNhatThuoc TO QuanTriVien
GO
GRANT EXEC ON dbo.sp_XoaThuoc TO QuanTriVien
GO
GRANT EXEC ON dbo.sp_XemLichCaNhan_TheoNgay TO QuanTriVien
GO
GRANT EXEC ON dbo.sp_locCuocHenTheoPhongKham TO QuanTriVien
GO
GRANT EXEC ON dbo.sp_locCuocHenTheoBenhNhan TO QuanTriVien
GO
GRANT EXEC ON dbo.sp_locCuocHenTheoNhaSi TO QuanTriVien
GO
GRANT EXEC ON dbo.sp_XemDanhSachThuoc TO QuanTriVien
GO
GRANT EXEC ON dbo.sp_ThemKeHoachDieuTri TO QuanTriVien
GO
GRANT EXEC ON dbo.sp_xemKeHoachDieuTri TO QuanTriVien
GO
GRANT EXEC ON dbo.sp_ThemDonThuoc TO QuanTriVien
GO
GRANT EXEC ON dbo.sp_XemThuoc_MaThuoc TO QuanTriVien
GO




