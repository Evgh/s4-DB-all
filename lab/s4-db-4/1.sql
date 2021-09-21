CREATE database E_Univer on primary 
(name=N'E_UNIVER_mdf', filename=N'D:\DB\lab\s4-db-4\files\E_UNIVER.mdf', size = 5Mb, maxsize = 10Mb, filegrowth=1Mb),
(name=N'E_UNIVER_ndf', filename=N'D:\DB\lab\s4-db-4\files\E_UNIVER.ndf', size = 5Mb, maxsize = 10Mb, filegrowth=10%),

filegroup G1
(name=N'E_UNIVER11_ndf', filename=N'D:\DB\lab\s4-db-4\files\E_UNIVER11.ndf', size = 10Mb, maxsize = 15Mb, filegrowth=1Mb),
(name=N'E_UNIVER12_ndf', filename=N'D:\DB\lab\s4-db-4\files\E_UNIVER12.ndf', size = 2Mb, maxsize = 5Mb, filegrowth=1Mb),

filegroup G2
(name=N'E_UNIVER21_ndf', filename=N'D:\DB\lab\s4-db-4\files\E_UNIVER21.ndf', size = 10Mb, maxsize = 15Mb, filegrowth=1Mb),
(name=N'E_UNIVER22_ndf', filename=N'D:\DB\lab\s4-db-4\files\E_UNIVER22.ndf', size = 2Mb, maxsize = 5Mb, filegrowth=1Mb)

log on 
(name=N'E_UNIVER12_log', filename=N'D:\DB\lab\s4-db-4\files\E_UNIVER12.ldf', size = 5Mb, maxsize = UNLIMITED, filegrowth=1Mb)
