USE QL_PhongKhamNhaKhoa
GO

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
--Xem, xóa các yêu cầu hẹn từ bệnh nhân
Grant select, delete on PhieuYCHen to QuanTriVien
go
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

--EXEC sp_addlogin 'user','1000','QL_PhongKhamNhaKhoa'
--EXEC sp_grantdbaccess 'user', 'user'
--EXEC sp_addrolemember 'QuanTriVien', 'user'

--EXEC sp_droprolemember 'QuanTriVien', 'user'
--EXEC sp_droprole 'QuanTriVien'
--EXEC sp_revokedbaccess 'user'
--EXEC sp_droplogin 'user'

