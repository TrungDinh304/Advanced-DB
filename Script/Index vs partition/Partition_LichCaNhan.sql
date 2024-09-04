USE QL_PhongKhamNhaKhoa
GO

-- Lịch cá nhân chia partition ngang theo thuộc tính ngày
ALTER DATABASE QL_PhongKhamNhaKhoa ADD FILEGROUP LichCaNhan_1 --Name here
GO
ALTER DATABASE QL_PhongKhamNhaKhoa ADD FILEGROUP LichCaNhan_2
GO
ALTER DATABASE QL_PhongKhamNhaKhoa ADD FILEGROUP LichCaNhan_3
GO
ALTER DATABASE QL_PhongKhamNhaKhoa ADD FILEGROUP LichCaNhan_4
GO

ALTER DATABASE QL_PhongKhamNhaKhoa
ADD FILE
(
	NAME = 'LCN_2021',
	FILENAME = 'D:\QL_PhongKhamNhaKhoa\LichCaNhan_1\LCN_Q1.ndf',
	SIZE = 5,
	MAXSIZE = 1000,
	FILEGROWTH = 5
) TO FILEGROUP LichCaNhan_1
GO

ALTER DATABASE QL_PhongKhamNhaKhoa
ADD FILE
(
	NAME = 'LCN_2022',
	FILENAME = 'D:\QL_PhongKhamNhaKhoa\LichCaNhan_2\LCN_Q2.ndf',
	SIZE = 5,
	MAXSIZE = 1000,
	FILEGROWTH = 5
) TO FILEGROUP LichCaNhan_2
GO

ALTER DATABASE QL_PhongKhamNhaKhoa
ADD FILE
(
	NAME = 'LCN_2023',
	FILENAME = 'D:\QL_PhongKhamNhaKhoa\LichCaNhan_3\LCN_Q3.ndf',
	SIZE = 5,
	MAXSIZE = 1000,
	FILEGROWTH = 5
) TO FILEGROUP LichCaNhan_3
GO

ALTER DATABASE QL_PhongKhamNhaKhoa
ADD FILE
(
	NAME = 'LCN_Beyond',
	FILENAME = 'D:\QL_PhongKhamNhaKhoa\LichCaNhan_4\LCN_Q4.ndf',
	SIZE = 5,
	MAXSIZE = 1000,
	FILEGROWTH = 5
) TO FILEGROUP LichCaNhan_4
GO

CREATE PARTITION FUNCTION PartitionLCNByDate (DATE)
AS
	RANGE RIGHT
	FOR VALUES ('2021/01/01','2022/01/01','2023/01/01')
GO

CREATE PARTITION SCHEME PartitionLCN_Scheme
AS
	PARTITION PartitionLCNByDate
	TO (LichCaNhan_1,LichCaNhan_2,LichCaNhan_3,LichCaNhan_4)
GO

ALTER TABLE KeHoachDieuTri
DROP CONSTRAINT FK_KHDT_LCN

ALTER TABLE CuocHenMoi
DROP CONSTRAINT FK_CHKM_LCN

ALTER TABLE LichCaNhan
DROP CONSTRAINT PK_LCN --Name of primary key (is non-static)

ALTER TABLE LichCaNhan
ADD PRIMARY KEY
NONCLUSTERED(Ngay,Ca,NS_khamchinh,NS_khamphu ASC)
ON [PRIMARY]

CREATE CLUSTERED INDEX IX_NGAY_DATE	
ON LichCaNhan
(
	Ngay
) ON PartitionLCN_Scheme(Ngay)

ALTER TABLE KeHoachDieuTri
ADD CONSTRAINT FK_KHDT_LCN FOREIGN KEY (Ngay, CA, NS_khamchinh, NS_khamphu) REFERENCES LichCaNhan(Ngay,Ca,NS_khamchinh, NS_khamphu)

ALTER TABLE CuocHenMoi
ADD CONSTRAINT FK_CHKM_LCN FOREIGN KEY (Ngay, CA, NS_khamchinh, NS_khamphu) REFERENCES LichCaNhan(Ngay,Ca,NS_khamchinh, NS_khamphu)

SELECT p.partition_number AS partition_number,
f.name AS file_group,
p.rows AS row_count
FROM sys.partitions p JOIN sys.destination_data_spaces dds ON
p.partition_number = dds.destination_id
JOIN sys.filegroups f ON dds.data_space_id = f.data_space_id
WHERE OBJECT_NAME(OBJECT_ID) = 'LichCaNhan'
order by partition_number;
