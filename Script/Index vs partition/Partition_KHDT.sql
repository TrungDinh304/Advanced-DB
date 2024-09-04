use QL_PhongKhamNhaKhoa
go



--BenhAn 

ALTER DATABASE QL_PhongKhamNhaKhoa
ADD FILEGROUP KHDT1

ALTER DATABASE QL_PhongKhamNhaKhoa
ADD FILEGROUP KHDT2

ALTER DATABASE QL_PhongKhamNhaKhoa
ADD FILEGROUP KHDT3



ALTER DATABASE QL_PhongKhamNhaKhoa
ADD FILE (NAME = KHDT1,
FILENAME = N'D:\QL_PhongKhamNhaKhoa\KeHoachDieuTri_1\DBPartition_KHDT1.ndf',
Size = 4MB,
MAXSIZE = UNLIMITED,
FILEGROWTH = 1
) TO FILEGROUP KHDT1


ALTER DATABASE QL_PhongKhamNhaKhoa
ADD FILE (NAME = KHDT2,
FILENAME = N'D:\QL_PhongKhamNhaKhoa\KeHoachDieuTri_2\DBPartition_KHDT2.ndf',
Size = 4MB,
MAXSIZE = UNLIMITED,
FILEGROWTH = 1
) TO FILEGROUP KHDT2


ALTER DATABASE QL_PhongKhamNhaKhoa
ADD FILE (NAME = KHDT3,
FILENAME = N'D:\QL_PhongKhamNhaKhoa\KeHoachDieuTri_3\DBPartition_KHDT3.ndf',
Size = 4MB,
MAXSIZE = UNLIMITED,
FILEGROWTH = 1
) TO FILEGROUP KHDT3




CREATE PARTITION FUNCTION KeHoachDieuTri_Partitions(varchar(10))
AS RANGE Left
FOR VALUES('BA033333','BA066666','BA100000')
--
CREATE PARTITION SCHEME KeHoachDieuTri_PartitionsScheme
AS PARTITION KeHoachDieuTri_Partitions
TO (KHDT1,KHDT2,KHDT3,[PRIMARY])

alter table ChiTietRang
drop constraint FK_CTR_DT

ALTER TABLE chitietdonthuoc
drop constraint FK_CTDT_KHDT

ALTER TABLE CuocHenTaiKham
drop constraint FK_CHTK_DT

ALTER TABLE KeHoachDieuTri
drop constraint PK_KHDT
go

alter table KeHoachDieuTri
alter COLUMN MaBA varchar(10) not null;

ALTER TABLE KeHoachDieuTri
ADD CONSTRAINT PK_KHDT
PRIMARY KEY NONCLUSTERED(MaDT ASC) ON [PRIMARY]
GO

--drop INDEX BenhAn_MaBA
--on dbo.BenhAn

CREATE CLUSTERED INDEX KeHoachDieuTri_MaBA
ON KeHoachDieuTri
(
	MaBA
) ON KeHoachDieuTri_PartitionsScheme(MaBA)

alter table ChiTietRang
add CONSTRAINT FK_CTR_DT FOREIGN KEY (MaDT) REFERENCES KeHoachDieuTri(MaDT)

ALTER TABLE chitietdonthuoc
add constraint FK_CTDT_KHDT FOREIGN KEY (MaDT) REFERENCES keHoachDieuTri(MaDT)

ALTER TABLE CuocHenTaiKham
add constraint FK_CHTK_DT FOREIGN KEY (MaDT) REFERENCES keHoachDieuTri(MaDT)














SELECT p.partition_number AS partition_number,
f.name AS file_group,
p.rows AS row_count
FROM sys.partitions p JOIN sys.destination_data_spaces dds ON
p.partition_number = dds.destination_id
JOIN sys.filegroups f ON dds.data_space_id = f.data_space_id
WHERE OBJECT_NAME(OBJECT_ID) = 'KeHoachDieuTri'
order by partition_number;



