use QL_PhongKhamNhaKhoa
go


--BenhAn 

ALTER DATABASE QL_PhongKhamNhaKhoa
ADD FILEGROUP BA1
go
ALTER DATABASE QL_PhongKhamNhaKhoa
ADD FILEGROUP BA2
go
ALTER DATABASE QL_PhongKhamNhaKhoa
ADD FILEGROUP BA3
go



ALTER DATABASE QL_PhongKhamNhaKhoa
ADD FILE (NAME = BA1,
FILENAME = N'D:\QL_PhongKhamNhaKhoa\BenhAn_1\DBPartition_BA1.ndf',
Size = 4MB,
MAXSIZE = UNLIMITED,
FILEGROWTH = 1
) TO FILEGROUP BA1


ALTER DATABASE QL_PhongKhamNhaKhoa
ADD FILE (NAME = BA2,
FILENAME = N'D:\QL_PhongKhamNhaKhoa\BenhAn_2\DBPartition_BA2.ndf',
Size = 4MB,
MAXSIZE = UNLIMITED,
FILEGROWTH = 1
) TO FILEGROUP BA2


ALTER DATABASE QL_PhongKhamNhaKhoa
ADD FILE (NAME = BA3,
FILENAME = N'D:\QL_PhongKhamNhaKhoa\BenhAn_3\DBPartition_BA3.ndf',
Size = 4MB,
MAXSIZE = UNLIMITED,
FILEGROWTH = 1
) TO FILEGROUP BA3
go

--drop PARTITION FUNCTION BenhAn_Partitions
CREATE PARTITION FUNCTION BenhAn_Partitions(varchar(10))
AS RANGE Left
FOR VALUES('BA033333','BA066666','BA100000')
go


--drop PARTITION SCHEME BenhAn_PartitionsScheme

CREATE PARTITION SCHEME BenhAn_PartitionsScheme
AS PARTITION BenhAn_Partitions
TO (BA1,BA2,BA3,[PRIMARY])
go


alter table keHoachDieuTri
--add  CONSTRAINT FK_KHDT_BA FOREIGN KEY (MaBA) REFERENCES BenhAn(MaBA)
drop constraint FK_KHDT_BA

alter table CuocHenMoi
--add CONSTRAINT FK_CHKM_BA FOREIGN KEY (MaBA) REFERENCES BenhAn(MaBA)
drop constraint FK_CHKM_BA

alter table TinhTrangDiUng
--add CONSTRAINT FK_TTDU_BA FOREIGN KEY (MaBA) REFERENCES BenhAn(MaBA)
drop constraint FK_TTDU_BA

alter table ChongChiDinh
--add CONSTRAINT FK_CCD_BA FOREIGN KEY (MaBA) REFERENCES BenhAn(MaBA)
drop constraint FK_CCD_BA
go

alter table BenhAn
drop constraint PK_BA
go


ALTER TABLE BenhAn
ADD CONSTRAINT PK_BA
PRIMARY KEY NONCLUSTERED(MaBA ASC) ON [PRIMARY]
GO


--drop INDEX BenhAn_MaBA
--on dbo.BenhAn



CREATE CLUSTERED INDEX BenhAn_MaBA	
ON BenhAn
(
	MaBA
) ON BenhAn_PartitionsScheme(MaBA)

alter table keHoachDieuTri
add  CONSTRAINT FK_KHDT_BA FOREIGN KEY (MaBA) REFERENCES BenhAn(MaBA)

alter table CuocHenMoi
add CONSTRAINT FK_CHKM_BA FOREIGN KEY (MaBA) REFERENCES BenhAn(MaBA)

alter table TinhTrangDiUng
add CONSTRAINT FK_TTDU_BA FOREIGN KEY (MaBA) REFERENCES BenhAn(MaBA)

alter table ChongChiDinh
add CONSTRAINT FK_CCD_BA FOREIGN KEY (MaBA) REFERENCES BenhAn(MaBA)





SELECT t.name AS TableName, ps.name AS PartitionSchemeName
FROM sys.tables t
JOIN sys.indexes i ON t.object_id = i.object_id
JOIN sys.data_spaces ds ON i.data_space_id = ds.data_space_id
JOIN sys.partition_schemes ps ON ds.data_space_id = ps.data_space_id
WHERE ps.name = 'BenhAn_PartitionsScheme';



SELECT p.partition_number AS partition_number,
f.name AS file_group,
p.rows AS row_count
FROM sys.partitions p JOIN sys.destination_data_spaces dds ON
p.partition_number = dds.destination_id
JOIN sys.filegroups f ON dds.data_space_id = f.data_space_id
WHERE OBJECT_NAME(OBJECT_ID) = 'BenhAn'
order by partition_number;



-- Xem các dòng dữ liệu của một phân vùng cụ thể
SELECT *
FROM BenhAn
WHERE $PARTITION.BenhAn_Partitions(MaBA) = 1;


--SELECT 
--    s.session_id,
--    c.client_net_address,
--    s.login_name,
--    s.host_name,
--    s.program_name
--FROM 
--    sys.dm_exec_sessions s
--JOIN 
--    sys.dm_exec_connections c ON s.session_id = c.session_id
--WHERE 
--    s.database_id = DB_ID('QL_PhongKhamNhaKhoa');

