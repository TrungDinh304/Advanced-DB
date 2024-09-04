USE QL_PhongKhamNhaKhoa
GO

-- Cuoc Hen Moi
ALTER DATABASE QL_PhongKhamNhaKhoa ADD FILEGROUP CHM_1
ALTER DATABASE QL_PhongKhamNhaKhoa ADD FILEGROUP CHM_2
ALTER DATABASE QL_PhongKhamNhaKhoa ADD FILEGROUP CHM_3
ALTER DATABASE QL_PhongKhamNhaKhoa ADD FILEGROUP CHM_4

ALTER DATABASE QL_PhongKhamNhaKhoa
ADD FILE
(
	NAME = 'CHM_2019',
	FILENAME = 'D:\CSDLNC\CHM_1\CHM_1.ndf',
	SIZE = 5,
	MAXSIZE = 1000,
	FILEGROWTH = 5
) TO FILEGROUP CHM_1
GO
ALTER DATABASE QL_PhongKhamNhaKhoa
ADD FILE
(
	NAME = 'CHM_2020',
	FILENAME = 'D:\CSDLNC\CHM_2\CHM_2.ndf',
	SIZE = 5,
	MAXSIZE = 1000,
	FILEGROWTH = 5
) TO FILEGROUP CHM_2
GO
ALTER DATABASE QL_PhongKhamNhaKhoa
ADD FILE
(
	NAME = 'CHM_2021',
	FILENAME = 'D:\CSDLNC\CHM_3\CHM_3.ndf',
	SIZE = 5,
	MAXSIZE = 1000,
	FILEGROWTH = 5
) TO FILEGROUP CHM_3
GO
ALTER DATABASE QL_PhongKhamNhaKhoa
ADD FILE
(
	NAME = 'CHM_Beyond',
	FILENAME = 'D:\CSDLNC\CHM_4\CHM_4.ndf',
	SIZE = 5,
	MAXSIZE = 1000,
	FILEGROWTH = 5
) TO FILEGROUP CHM_4
GO

CREATE PARTITION FUNCTION Partition_CuocHenMoi (DATE)
AS
	RANGE LEFT
	FOR VALUES ('2019/12/31','2020/12/31','2021/12/31')
GO

CREATE PARTITION SCHEME Partition_CuocHenMoi_Scheme
AS
	PARTITION Partition_CuocHenMoi
	TO (CHM_1,CHM_2,CHM_3,CHM_4)
GO



ALTER TABLE CuocHenMoi
DROP CONSTRAINT PK_CHM --Name of primary key (is non-static)

ALTER TABLE CuocHenMoi
ADD CONSTRAINT PK_CHM
PRIMARY KEY NONCLUSTERED(MaCuocHen ASC) ON [PRIMARY]
GO

CREATE CLUSTERED INDEX IX_CuocHenMoi_Ngay	
ON CuocHenMoi
(
	Ngay
) ON Partition_CuocHenMoi_Scheme(Ngay)

SELECT p.partition_number AS partition_number,
f.name AS file_group,
p.rows AS row_count
FROM sys.partitions p JOIN sys.destination_data_spaces dds ON
p.partition_number = dds.destination_id
JOIN sys.filegroups f ON dds.data_space_id = f.data_space_id
WHERE OBJECT_NAME(OBJECT_ID) = 'CuocHenMoi'
order by partition_number;


SELECT t.name AS TableName, ps.name AS PartitionSchemeName
FROM sys.tables t
JOIN sys.indexes i ON t.object_id = i.object_id
JOIN sys.data_spaces ds ON i.data_space_id = ds.data_space_id
JOIN sys.partition_schemes ps ON ds.data_space_id = ps.data_space_id
WHERE ps.name = 'Partition_CuocHenMoi_Scheme';
-- Xem các dòng dữ liệu của một phân vùng cụ thể
SELECT *
FROM CuocHenMoi
WHERE $PARTITION.Partition_CuocHenMoi(Ngay) = 2;