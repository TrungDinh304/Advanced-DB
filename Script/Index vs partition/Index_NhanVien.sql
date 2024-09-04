USE QL_PhongKhamNhaKhoa
GO

BEGIN TRANSACTION

-- Tạo index cho việc tìm kiếm bệnh nhân bằng số điện thoại 
CREATE NONCLUSTERED INDEX Idx_BenhAn_sodienthoai ON dbo.BenhAn(sodienthoai)
GO

-- Tạo index cho việc tìm kiếm kế hoạch điều trị bằng mã bệnh án 
CREATE NONCLUSTERED INDEX Idx_KeHoachDieuTri_MaBA ON dbo.KeHoachDieuTri(MaBA)
GO

-- Tạo index cho việc tìm kiếm cuộc hẹn mới bằng mã bệnh án  
CREATE NONCLUSTERED INDEX Idx_CuocHenMoi_MaBA ON dbo.CuocHenMoi(MaBA)
GO

-- Tạo index cho việc tìm kiếm lịch cá nhân bằng mã nha sĩ khám chính
CREATE NONCLUSTERED INDEX Idx_LichCaNhan_NSkhamchinh ON dbo.LichCaNhan(NS_khamchinh)
GO

-- Tạo index cho việc tìm kiếm lịch cá nhân bằng mã nha sĩ khám phụ
CREATE NONCLUSTERED INDEX Idx_LichCaNhan_NSkhamphu ON dbo.LichCaNhan(NS_khamphu)
GO

COMMIT TRANSACTION