USE QL_PhongKhamNhaKhoa
GO

-- Thanh Toan
ALTER DATABASE QL_PhongKhamNhaKhoa ADD FILEGROUP TT_1
ALTER DATABASE QL_PhongKhamNhaKhoa ADD FILEGROUP TT_2
ALTER DATABASE QL_PhongKhamNhaKhoa ADD FILEGROUP TT_3
ALTER DATABASE QL_PhongKhamNhaKhoa ADD FILEGROUP TT_4
ALTER DATABASE QL_PhongKhamNhaKhoa ADD FILEGROUP TT_5

ALTER DATABASE QL_PhongKhamNhaKhoa
ADD FILE
(
	NAME = 'TT_2019',
	FILENAME = 'D:\CSDLNC\TT_1\TT_1.ndf',
	SIZE = 5,
	MAXSIZE = 1000,
	FILEGROWTH = 5
) TO FILEGROUP TT_1
GO
ALTER DATABASE QL_PhongKhamNhaKhoa
ADD FILE
(
	NAME = 'TT_2020',
	FILENAME = 'D:\CSDLNC\TT_2\TT_2.ndf',
	SIZE = 5,
	MAXSIZE = 1000,
	FILEGROWTH = 5
) TO FILEGROUP TT_2
GO
ALTER DATABASE QL_PhongKhamNhaKhoa
ADD FILE
(
	NAME = 'TT_2021',
	FILENAME = 'D:\CSDLNC\TT_3\TT_3.ndf',
	SIZE = 5,
	MAXSIZE = 1000,
	FILEGROWTH = 5
) TO FILEGROUP TT_3
GO
ALTER DATABASE QL_PhongKhamNhaKhoa
ADD FILE
(
	NAME = 'TT_2022',
	FILENAME = 'D:\CSDLNC\TT_4\TT_4.ndf',
	SIZE = 5,
	MAXSIZE = 1000,
	FILEGROWTH = 5
) TO FILEGROUP TT_4
GO
ALTER DATABASE QL_PhongKhamNhaKhoa
ADD FILE
(
	NAME = 'TT_Beyond',
	FILENAME = 'D:\CSDLNC\TT_5\TT_5.ndf',
	SIZE = 5,
	MAXSIZE = 1000,
	FILEGROWTH = 5
) TO FILEGROUP TT_5
GO

CREATE PARTITION FUNCTION Partition_ThanhToan (DATE)
AS
	RANGE LEFT
	FOR VALUES ('2019/12/31','2020/12/31','2021/12/31','2022/12/31')
GO

CREATE PARTITION SCHEME Partition_ThanhToan_Scheme
AS
	PARTITION Partition_ThanhToan
	TO (TT_1,TT_2,TT_3,TT_4,TT_5)
GO

alter table keHoachDieuTri
--add  CONSTRAINT FK_KHDT_TT FOREIGN KEY (MaTT) REFERENCES ThanhToan(maTT),
drop constraint FK_KHDT_TT

ALTER TABLE ThanhToan
DROP CONSTRAINT PK__ThanhToa__2725007908630F82 -- Name of primary key
GO

ALTER TABLE ThanhToan
ADD CONSTRAINT PK_TT
PRIMARY KEY NONCLUSTERED(MaTT ASC) ON [PRIMARY]
GO

CREATE CLUSTERED INDEX IX_ThanhToan_NgayGD	
ON ThanhToan
(
	NgayGD
) ON Partition_ThanhToan_Scheme(NgayGD)

alter table keHoachDieuTri
add  CONSTRAINT FK_KHDT_TT FOREIGN KEY (MaTT) REFERENCES ThanhToan(maTT)

SELECT p.partition_number AS partition_number,
f.name AS file_group,
p.rows AS row_count
FROM sys.partitions p JOIN sys.destination_data_spaces dds ON
p.partition_number = dds.destination_id
JOIN sys.filegroups f ON dds.data_space_id = f.data_space_id
WHERE OBJECT_NAME(OBJECT_ID) = 'ThanhToan'
order by partition_number;

SELECT t.name AS TableName, ps.name AS PartitionSchemeName
FROM sys.tables t
JOIN sys.indexes i ON t.object_id = i.object_id
JOIN sys.data_spaces ds ON i.data_space_id = ds.data_space_id
JOIN sys.partition_schemes ps ON ds.data_space_id = ps.data_space_id
WHERE ps.name = 'Partition_ThanhToan_Scheme';
-- Xem các dòng dữ liệu của một phân vùng cụ thể
SELECT *
FROM ThanhToan
WHERE $PARTITION.Partition_ThanhToan(NgayGD) = 2;