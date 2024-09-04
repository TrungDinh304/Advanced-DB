USE QL_PhongKhamNhaKhoa
GO

ALTER DATABASE QL_PhongKhamNhaKhoa ADD FILEGROUP CHTK_1
GO
ALTER DATABASE QL_PhongKhamNhaKhoa ADD FILEGROUP CHTK_2
GO
ALTER DATABASE QL_PhongKhamNhaKhoa ADD FILEGROUP CHTK_3
GO
ALTER DATABASE QL_PhongKhamNhaKhoa ADD FILEGROUP CHTK_4
GO

ALTER DATABASE QL_PhongKhamNhaKhoa
ADD FILE
(
	NAME = 'CHTK_1',
	FILENAME = 'D:\QL_PhongKhamNhaKhoa\CHTK_1\CHTK_1.ndf',
	SIZE = 5,
	MAXSIZE = 500,
	FILEGROWTH = 5
) TO FILEGROUP CHTK_1
GO 

ALTER DATABASE QL_PhongKhamNhaKhoa
ADD FILE
(
	NAME = 'CHTK_2',
	FILENAME = 'D:\QL_PhongKhamNhaKhoa\CHTK_2\CHTK_2.ndf',
	SIZE = 5,
	MAXSIZE = 500,
	FILEGROWTH = 5
) TO FILEGROUP CHTK_2
GO

ALTER DATABASE QL_PhongKhamNhaKhoa
ADD FILE
(
	NAME = 'CHTK_3',
	FILENAME = 'D:\QL_PhongKhamNhaKhoa\CHTK_3\CHTK_3.ndf',
	SIZE = 5,
	MAXSIZE = 500,
	FILEGROWTH = 5
) TO FILEGROUP CHTK_3
GO

ALTER DATABASE QL_PhongKhamNhaKhoa
ADD FILE
(
	NAME = 'CHTK_4',
	FILENAME = 'D:\QL_PhongKhamNhaKhoa\CHTK_4\CHTK_4.ndf',
	SIZE = 5,
	MAXSIZE = 500,
	FILEGROWTH = 5
) TO FILEGROUP CHTK_4
GO

CREATE PARTITION FUNCTION PartitionCHTKByRoom (INT)
AS
	RANGE LEFT
	FOR VALUES (5,10,15)
GO

CREATE PARTITION SCHEME PartitionCHTK_Scheme
AS
	PARTITION PartitionCHTKByRoom
	TO (CHTK_1,CHTK_2,CHTK_3,CHTK_4)
GO

ALTER TABLE CuocHenTaiKham
DROP CONSTRAINT PK__CuocHenT__049EC579F00FF962 -- Name of primary key
GO

-- Tạo lại PK với Mã phòng

ALTER TABLE CuocHenTaiKham
ALTER COLUMN Phong INT NOT NULL;
GO

ALTER TABLE CuocHenTaiKham
ADD CONSTRAINT PK_CuocHenTaiKham
PRIMARY KEY NONCLUSTERED(MaCuocHen,Phong ASC) ON [PRIMARY]
GO

CREATE CLUSTERED INDEX IX_PHONG_INT
ON CuocHenTaiKham
(
	Phong
) ON PartitionCHTK_Scheme(Phong)
GO

SELECT p.partition_number AS partition_number,
f.name AS file_group,
p.rows AS row_count
FROM sys.partitions p JOIN sys.destination_data_spaces dds ON
p.partition_number = dds.destination_id
JOIN sys.filegroups f ON dds.data_space_id = f.data_space_id
WHERE OBJECT_NAME(OBJECT_ID) = 'CuocHenTaiKham'
order by partition_number;