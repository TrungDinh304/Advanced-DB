USE MASTER
GO

USE QL_PhongKhamNhaKhoa
GO

-- TẠO INDEX TRÊN DỮ LIỆU.

-- Tìm kiếm bệnh nhân trong bệnh án trên số điện thoại
CREATE NONCLUSTERED INDEX Idx_BenhAn_sodienthoai ON dbo.BenhAn(sodienthoai)
GO
-- Tìm kiếm các cuộc hẹn trong từng ngày
CREATE NONCLUSTERED INDEX Idx_CuocHenMoi_MaBA ON dbo.CuocHenMoi(MaBA)
GO

CREATE NONCLUSTERED INDEX Idx_CuocHenMoi_Phong ON dbo.CuocHenMoi(Phong)
GO

-- Index phục vụ cho việc lọc theo nha sĩ
CREATE NONCLUSTERED INDEX Idx_CuocHenMoi_NS_khamchinh ON dbo.CuocHenMoi(NS_khamchinh)
GO

CREATE NONCLUSTERED INDEX Idx_CuocHenMoi_NS_khamphu ON dbo.CuocHenMoi(NS_khamphu)
GO


-- Index cho kế hoạch điều trị
CREATE NONCLUSTERED INDEX Idx_KeHoachDieuTri_MaBA ON dbo.KeHoachDieuTri(MaBA)
GO

-- Index cho việc tìm kiếm đơn thuốc dựa vào mã điều trị.
CREATE NONCLUSTERED INDEX Idx_ChiTietDonThuoc_MaDT ON dbo.ChiTietDonThuoc(MaDT)
GO


-- TẠO PARTITION TRÊN DỮ LIỆU.