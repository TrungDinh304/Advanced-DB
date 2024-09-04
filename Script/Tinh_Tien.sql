use QL_PhongKhamNhaKhoa
go



ALTER TABLE KeHoachDieuTri
add Tong_Phi decimal(18,0)
go

create or alter function fn_Phi_DieuTri (@MaDT nvarchar(10))
returns decimal(18,0)
as
begin
	declare @TongPhi decimal(18,0)
	set @TongPhi = (select (select gia from DichVu where MaDV = dt.MaDV ) from KeHoachDieuTri dt where dt.MaDT = @MaDT)

	set @TongPhi = @TongPhi + (select sum(t.DonGia*ctdt.Soluong) from ChiTietDonThuoc ctdt join Thuoc t on ctdt.MaThuoc = t.MaThuoc where ctdt.MaDT = @MaDT)

	return (@TongPhi)
end
go

Update KeHoachDieuTri
set Tong_Phi = dbo.fn_Phi_DieuTri(MaDT)
go

create or alter function fn_TongTien_ThanhToan (@MaTT nvarchar(10))
returns decimal(18,0)
as
begin
	declare @TongTien decimal(18,0)
	set @TongTien = (select sum(Tong_Phi) from KeHoachDieuTri where MaTT = @MaTT)
	return @TongTien
end
go


Update ThanhToan
set TongTien = dbo.fn_TongTien_ThanhToan(MaTT)
go

create or alter function fn_TongTien_DieuTri (@MaBA nvarchar(10))
returns decimal(18,0)
as
begin
	declare @TongTien decimal(18,0)
	
	set @TongTien = (select sum(Tong_Phi) from KeHoachDieuTri where MaBA = @MaBA)
	return @TongTien
end
go

Update BenhAn 
set TongTienDieuTri = dbo.fn_TongTien_DieuTri(MaBA)
go

create or alter function fn_TongTien_DieuTri_DaTra (@MaBA nvarchar(10))
returns decimal(18,0)
as
begin 
	declare @TongTra decimal(18,0)
	set @TongTra = (select sum(temp.tientra) 
					from (select distinct(khdt.MaTT), greatest(tt.Tien_Nhan, tt.TongTien) as tientra	
						from ThanhToan tt join KeHoachDieuTri khdt on tt.MaTT = khdt.MaTT 
						where khdt.MaBA = @MaBA) as temp)
	return @TongTra
end
go

Update BenhAn
set TongTienDieuTri_datra = dbo.fn_TongTien_DieuTri_DaTra(MaBA)


