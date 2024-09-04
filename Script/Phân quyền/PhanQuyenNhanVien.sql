use QL_PhongKhamNhaKhoa
go

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


--EXEC sp_addlogin 'user','1000','QL_PhongKhamNhaKhoa'
--EXEC sp_grantdbaccess 'user', 'user'
--EXEC sp_addrolemember 'NhanVien', 'user'

--EXEC sp_droprolemember 'NhanVien', 'user'
--EXEC sp_droprole 'NhanVien'
--EXEC sp_revokedbaccess 'user'
--EXEC sp_droplogin 'user'