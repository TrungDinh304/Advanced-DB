USE QL_PhongKhamNhaKhoa
GO

-- PHÂN QUYỀN NHA SĨ

EXEC sp_addrole 'role_NhaSi'
GO

-- Nha sĩ là người dùng với quyền hạn thấp nhất

-- Chỉnh sửa thông tin bệnh án, sơ đồ nha chu, tình trạng răng hàm, hồ sơ điều trị của bệnh nhân

-- 0. Chức năng đăng nhập

-- 1. Xem/Thêm/Sửa thông tin bệnh nhân

GRANT SELECT ON BenhAn TO role_NhaSi
GO

GRANT UPDATE ON BenhAn(TongQuan) to role_NhaSi
GO

GRANT SELECT,UPDATE,INSERT ON ChongChiDinh TO role_NhaSi
GO

GRANT SELECT,UPDATE,INSERT ON TinhTrangDiUng TO role_NhaSi
GO

GRANT SELECT,UPDATE,INSERT ON KeHoachDieuTri TO role_NhaSi
GO

GRANT SELECT,UPDATE,INSERT ON ChiTietRang TO role_NhaSi
GO

GRANT SELECT ON BeMatRang TO role_NhaSi
GO

GRANT SELECT ON Rang TO role_NhaSi

-- 2. Xem thanh toán của bệnh nhân
GRANT SELECT ON ThanhToan TO role_NhaSi
GO
-- 3. Thêm/Cập nhật/Xóa đơn thuốc của bệnh nhân
GRANT SELECT,INSERT,UPDATE,DELETE ON ChiTietDonThuoc TO role_NhaSi
GO

GRANT SELECT ON Thuoc TO role_NhaSi
GO

-- 4. Xem danh sách nha sĩ
GRANT SELECT ON NhaSi TO role_NhaSi
GO
-- 5. Xem danh sách nhân viên
GRANT SELECT ON NhanVien TO role_NhaSi
GO
-- 6. Xem lịch trình làm việc của nha sĩ
GRANT SELECT, INSERT, UPDATE, DELETE ON LichCaNhan TO role_NhaSi

-- 7. Quản lí cuộc hẹn
GRANT SELECT ON CuocHenMoi TO role_NhaSi
GRANT SELECT ON CuocTaiKham TO role_NhaSi


--EXEC sp_addlogin 'user','1000','QL_PhongKhamNhaKhoa'
--EXEC sp_grantdbaccess 'user', 'user'
--EXEC sp_addrolemember 'NhaSi', 'user'

--EXEC sp_droprolemember 'NhaSi', 'user'
--EXEC sp_droprole 'NhaSi'
--EXEC sp_revokedbaccess 'user'
--EXEC sp_droplogin 'user'