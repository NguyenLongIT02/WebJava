USE [master]
GO
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'Fruitables')
BEGIN
    ALTER DATABASE [Fruitables] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [Fruitables];
END
GO
CREATE DATABASE [Fruitables]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Fruitables', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\Fruitables.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Fruitables_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\Fruitables_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [Fruitables] SET COMPATIBILITY_LEVEL = 160
GO
USE [Fruitables]
GO

-- Tables
CREATE TABLE [dbo].[Category](
	[cate_id] [int] IDENTITY(1,1) NOT NULL,
	[cate_name] [nvarchar](255) NOT NULL,
PRIMARY KEY CLUSTERED ([cate_id] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Product](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](255) NOT NULL,
	[price] [float] NULL,
	[cate_id] [int] NOT NULL,
	[des] [nvarchar](2000) NULL,
	[image] [nvarchar](255) NULL,
    [view_count] [int] DEFAULT 0,
    [quantity] [int] DEFAULT 100,
    [import_price] [float] DEFAULT 0,
PRIMARY KEY CLUSTERED ([id] ASC),
FOREIGN KEY([cate_id]) REFERENCES [dbo].[Category] ([cate_id])
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[User](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[email] [varchar](50) NULL,
	[username] [varchar](50) NOT NULL UNIQUE,
	[password] [varchar](36) NOT NULL,
	[avatar] [nvarchar](50) NULL,
	[isAdmin] [bit] NOT NULL DEFAULT 0,
	[isActive] [bit] NOT NULL DEFAULT 1,
PRIMARY KEY CLUSTERED ([id] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Cart](
	[id] [varchar](50) NOT NULL,
	[u_id] [int] NOT NULL,
	[buyDate] [date] NULL,
    [status] [int] DEFAULT 3,
    [delivery_date] [date] NULL,
    [delivery_time] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED ([id] ASC),
FOREIGN KEY([u_id]) REFERENCES [dbo].[User] ([id])
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[CartItem](
	[id] [varchar](50) NOT NULL,
	[quantity] [int] NULL,
	[unitPrice] [float] NULL,
	[pro_id] [int] NOT NULL,
	[cat_id] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED ([id] ASC),
FOREIGN KEY([cat_id]) REFERENCES [dbo].[Cart] ([id]),
FOREIGN KEY([pro_id]) REFERENCES [dbo].[Product] ([id])
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Reviews](
    [id] [int] IDENTITY(1,1) NOT NULL,
    [u_id] [int] NOT NULL,
    [pro_id] [int] NOT NULL,
    [rating] [int] CHECK (rating >= 1 AND rating <= 5),
    [comment] [nvarchar](MAX) NULL,
    [review_date] [date] DEFAULT GETDATE(),
PRIMARY KEY CLUSTERED ([id] ASC),
FOREIGN KEY([u_id]) REFERENCES [dbo].[User] ([id]),
FOREIGN KEY([pro_id]) REFERENCES [dbo].[Product] ([id])
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

-- Insert Data
SET IDENTITY_INSERT [dbo].[Category] ON 
INSERT [dbo].[Category] ([cate_id], [cate_name]) VALUES (1, N'Rau Sạch')
INSERT [dbo].[Category] ([cate_id], [cate_name]) VALUES (2, N'Quả Tươi Sạch')
INSERT [dbo].[Category] ([cate_id], [cate_name]) VALUES (3, N'Củ Sạch')
INSERT [dbo].[Category] ([cate_id], [cate_name]) VALUES (5, N'Quả thiên nhiên')
SET IDENTITY_INSERT [dbo].[Category] OFF
GO

SET IDENTITY_INSERT [dbo].[Product] ON 
INSERT [dbo].[Product] ([id], [name], [price], [cate_id], [des], [image], [view_count], [quantity], [import_price]) VALUES (2, N'Ớt ngọt', 20, 2, N'Ớt tươi sạch được trồng và thu hoạch tự nhiên', N'vegetable-item-4.jpg', 100, 150, 14)
INSERT [dbo].[Product] ([id], [name], [price], [cate_id], [des], [image], [view_count], [quantity], [import_price]) VALUES (3, N'Khoai tây', 25, 3, N'Khoai tây tươi sạch được trồng và thu hoạch tự nhiên', N'vegetable-item-5.jpg', 50, 200, 17.5)
INSERT [dbo].[Product] ([id], [name], [price], [cate_id], [des], [image], [view_count], [quantity], [import_price]) VALUES (4, N'Cam sành', 12, 2, N'Cam sành tươi sạch được trồng và thu hoạch tự nhiên', N'fruite-item-1.jpg', 200, 180, 8.4)
INSERT [dbo].[Product] ([id], [name], [price], [cate_id], [des], [image], [view_count], [quantity], [import_price]) VALUES (5, N'Đu đủ', 15, 2, N'Đu đủ tươi sạch được trồng và thu hoạch tự nhiên', N'fruite-item-4.jpg', 80, 120, 10.5)
INSERT [dbo].[Product] ([id], [name], [price], [cate_id], [des], [image], [view_count], [quantity], [import_price]) VALUES (6, N'Táo mỹ', 35, 2, N'Táo mỹ tươi sạch được nhập sản phẩm chất lượng từ Mỹ', N'fruite-item-6.jpg', 300, 100, 24.5)
INSERT [dbo].[Product] ([id], [name], [price], [cate_id], [des], [image], [view_count], [quantity], [import_price]) VALUES (7, N'Cải xanh', 20, 1, N'Cải xanh tươi sạch được trồng và thu hoạch tự nhiên', N'caixanh.jpg', 40, 250, 14)
INSERT [dbo].[Product] ([id], [name], [price], [cate_id], [des], [image], [view_count], [quantity], [import_price]) VALUES (8, N'Ớt ngọt', 15, 2, N'Ớt tươi sạch được trồng và thu hoạch tự nhiên', N'vegetable-item-4.jpg', 60, 140, 10.5)
INSERT [dbo].[Product] ([id], [name], [price], [cate_id], [des], [image], [view_count], [quantity], [import_price]) VALUES (9, N'Khoai tây', 25, 3, N'Khoai tây tươi sạch được trồng và thu hoạch tự nhiên', N'vegetable-item-5.jpg', 90, 190, 17.5)
INSERT [dbo].[Product] ([id], [name], [price], [cate_id], [des], [image], [view_count], [quantity], [import_price]) VALUES (10, N'Cam sành', 12, 2, N'Cam sành tươi sạch được trồng và thu hoạch tự nhiên', N'fruite-item-1.jpg', 150, 170, 8.4)
INSERT [dbo].[Product] ([id], [name], [price], [cate_id], [des], [image], [view_count], [quantity], [import_price]) VALUES (11, N'Đu đủ', 15, 2, N'Đu đủ tươi sạch được trồng và thu hoạch tự nhiên', N'fruite-item-4.jpg', 70, 110, 10.5)
INSERT [dbo].[Product] ([id], [name], [price], [cate_id], [des], [image], [view_count], [quantity], [import_price]) VALUES (12, N'Táo mỹ', 35, 2, N'Táo mỹ tươi sạch được nhập sản phẩm chất lượng từ Mỹ', N'fruite-item-6.jpg', 250, 95, 24.5)
INSERT [dbo].[Product] ([id], [name], [price], [cate_id], [des], [image], [view_count], [quantity], [import_price]) VALUES (13, N'Cải xanh', 20, 1, N'Cải xanh tươi sạch được trồng và thu hoạch tự nhiên', N'caixanh.jpg', 30, 240, 14)
INSERT [dbo].[Product] ([id], [name], [price], [cate_id], [des], [image], [view_count], [quantity], [import_price]) VALUES (14, N'Ớt ngọt', 15, 2, N'Ớt tươi sạch được trồng và thu hoạch tự nhiên', N'vegetable-item-4.jpg', 110, 130, 10.5)
INSERT [dbo].[Product] ([id], [name], [price], [cate_id], [des], [image], [view_count], [quantity], [import_price]) VALUES (15, N'Khoai tây', 25, 3, N'Khoai tây tươi sạch được trồng và thu hoạch tự nhiên', N'vegetable-item-5.jpg', 55, 180, 17.5)
INSERT [dbo].[Product] ([id], [name], [price], [cate_id], [des], [image], [view_count], [quantity], [import_price]) VALUES (16, N'Cam sành', 12, 2, N'Cam sành tươi sạch được trồng và thu hoạch tự nhiên', N'fruite-item-1.jpg', 180, 160, 8.4)
INSERT [dbo].[Product] ([id], [name], [price], [cate_id], [des], [image], [view_count], [quantity], [import_price]) VALUES (17, N'Đu đủ', 15, 2, N'Đu đủ tươi sạch được trồng và thu hoạch tự nhiên', N'fruite-item-4.jpg', 85, 105, 10.5)
INSERT [dbo].[Product] ([id], [name], [price], [cate_id], [des], [image], [view_count], [quantity], [import_price]) VALUES (18, N'Táo mỹ', 35, 2, N'Táo mỹ tươi sạch được nhập sản phẩm chất lượng từ Mỹ', N'fruite-item-6.jpg', 280, 88, 24.5)
INSERT [dbo].[Product] ([id], [name], [price], [cate_id], [des], [image], [view_count], [quantity], [import_price]) VALUES (19, N'Cải xanh', 20, 1, N'Cải xanh tươi sạch được trồng và thu hoạch tự nhiên', N'caixanh.jpg', 45, 230, 14)
INSERT [dbo].[Product] ([id], [name], [price], [cate_id], [des], [image], [view_count], [quantity], [import_price]) VALUES (20, N'Ớt ngọt', 15, 2, N'Ớt tươi sạch được trồng và thu hoạch tự nhiên', N'vegetable-item-4.jpg', 120, 125, 10.5)
INSERT [dbo].[Product] ([id], [name], [price], [cate_id], [des], [image], [view_count], [quantity], [import_price]) VALUES (21, N'Khoai tây', 25, 3, N'Khoai tây tươi sạch được trồng và thu hoạch tự nhiên', N'vegetable-item-5.jpg', 60, 175, 17.5)
INSERT [dbo].[Product] ([id], [name], [price], [cate_id], [des], [image], [view_count], [quantity], [import_price]) VALUES (22, N'Cam sành', 12, 2, N'Cam sành tươi sạch được trồng và thu hoạch tự nhiên', N'fruite-item-1.jpg', 190, 155, 8.4)
INSERT [dbo].[Product] ([id], [name], [price], [cate_id], [des], [image], [view_count], [quantity], [import_price]) VALUES (23, N'Đu đủ', 15, 2, N'Đu đủ tươi sạch được trồng và thu hoạch tự nhiên', N'fruite-item-4.jpg', 90, 100, 10.5)
INSERT [dbo].[Product] ([id], [name], [price], [cate_id], [des], [image], [view_count], [quantity], [import_price]) VALUES (24, N'Táo mỹ', 35, 2, N'Táo mỹ tươi sạch được nhập sản phẩm chất lượng từ Mỹ', N'fruite-item-6.jpg', 310, 82, 24.5)
INSERT [dbo].[Product] ([id], [name], [price], [cate_id], [des], [image], [view_count], [quantity], [import_price]) VALUES (25, N'Cải xanh', 20, 1, N'Cải xanh tươi sạch được trồng và thu hoạch tự nhiên', N'caixanh.jpg', 50, 220, 14)
INSERT [dbo].[Product] ([id], [name], [price], [cate_id], [des], [image], [view_count], [quantity], [import_price]) VALUES (26, N'Ớt ngọt', 15, 2, N'Ớt tươi sạch được trồng và thu hoạch tự nhiên', N'vegetable-item-4.jpg', 130, 120, 10.5)
INSERT [dbo].[Product] ([id], [name], [price], [cate_id], [des], [image], [view_count], [quantity], [import_price]) VALUES (27, N'Khoai tây', 25, 3, N'Khoai tây tươi sạch được trồng và thu hoạch tự nhiên', N'vegetable-item-5.jpg', 65, 170, 17.5)
INSERT [dbo].[Product] ([id], [name], [price], [cate_id], [des], [image], [view_count], [quantity], [import_price]) VALUES (28, N'Cam sành', 12, 2, N'Cam sành tươi sạch được trồng và thu hoạch tự nhiên', N'fruite-item-1.jpg', 210, 150, 8.4)
INSERT [dbo].[Product] ([id], [name], [price], [cate_id], [des], [image], [view_count], [quantity], [import_price]) VALUES (29, N'Đu đủ', 15, 2, N'Đu đủ tươi sạch được trồng và thu hoạch tự nhiên', N'fruite-item-4.jpg', 95, 98, 10.5)
INSERT [dbo].[Product] ([id], [name], [price], [cate_id], [des], [image], [view_count], [quantity], [import_price]) VALUES (30, N'Táo mỹ', 35, 2, N'Táo mỹ tươi sạch được nhập sản phẩm chất lượng từ Mỹ', N'fruite-item-6.jpg', 320, 78, 24.5)
INSERT [dbo].[Product] ([id], [name], [price], [cate_id], [des], [image], [view_count], [quantity], [import_price]) VALUES (31, N'Cải xanh', 20, 1, N'Cải xanh tươi sạch được trồng và thu hoạch tự nhiên', N'featur-3.jpg', 55, 210, 14)
INSERT [dbo].[Product] ([id], [name], [price], [cate_id], [des], [image], [view_count], [quantity], [import_price]) VALUES (32, N'Ớt ngọt', 15, 2, N'Ớt tươi sạch được trồng và thu hoạch tự nhiên', N'vegetable-item-4.jpg', 140, 115, 10.5)
INSERT [dbo].[Product] ([id], [name], [price], [cate_id], [des], [image], [view_count], [quantity], [import_price]) VALUES (33, N'Khoai tây', 25, 3, N'Khoai tây tươi sạch được trồng và thu hoạch tự nhiên', N'vegetable-item-5.jpg', 70, 165, 17.5)
INSERT [dbo].[Product] ([id], [name], [price], [cate_id], [des], [image], [view_count], [quantity], [import_price]) VALUES (34, N'Cam sành', 12, 2, N'Cam sành tươi sạch được trồng và thu hoạch tự nhiên', N'fruite-item-1.jpg', 220, 145, 8.4)
INSERT [dbo].[Product] ([id], [name], [price], [cate_id], [des], [image], [view_count], [quantity], [import_price]) VALUES (35, N'Đu đủ', 15, 2, N'Đu đủ tươi sạch được trồng và thu hoạch tự nhiên', N'fruite-item-4.jpg', 100, 95, 10.5)
INSERT [dbo].[Product] ([id], [name], [price], [cate_id], [des], [image], [view_count], [quantity], [import_price]) VALUES (36, N'Táo mỹ', 35, 2, N'Táo mỹ tươi sạch được nhập sản phẩm chất lượng từ Mỹ', N'fruite-item-6.jpg', 330, 75, 24.5)
INSERT [dbo].[Product] ([id], [name], [price], [cate_id], [des], [image], [view_count], [quantity], [import_price]) VALUES (37, N'Nho xanh', 15, 5, N'Nho xanh tươi sạch được thu hoạch tự nhiên ở Việt Nam', N'fruite-item-5.jpg', 10, 80, 10.5)
SET IDENTITY_INSERT [dbo].[Product] OFF
GO

SET IDENTITY_INSERT [dbo].[User] ON 
INSERT [dbo].[User] ([id], [email], [username], [password], [avatar], [isAdmin], [isActive]) VALUES (1, N'admin@fruitables.com', N'admin', N'12345', N'Upload/avatar.jpg', 1, 1)
INSERT [dbo].[User] ([id], [email], [username], [password], [avatar], [isAdmin], [isActive]) VALUES (2, N'nguyenlong@gmail.com', N'nguyenlong', N'12345', N'Upload/avatar.jpg', 1, 1)
INSERT [dbo].[User] ([id], [email], [username], [password], [avatar], [isAdmin], [isActive]) VALUES (3, N'user1@gmail.com', N'longnguyen', N'12345', N'Upload/avatar.jpg', 0, 1)
INSERT [dbo].[User] ([id], [email], [username], [password], [avatar], [isAdmin], [isActive]) VALUES (4, N'user2@gmail.com', N'anhtran', N'123', N'Upload/testimonial-1.jpg', 0, 1)
INSERT [dbo].[User] ([id], [email], [username], [password], [avatar], [isAdmin], [isActive]) VALUES (5, N'user3@gmail.com', N'yenthan', N'12345', N'Upload/images.jfif', 0, 1)
INSERT [dbo].[User] ([id], [email], [username], [password], [avatar], [isAdmin], [isActive]) VALUES (6, N'user4@gmail.com', N'trungnguyen', N'12345', N'Upload/images.jfif', 0, 1)
SET IDENTITY_INSERT [dbo].[User] OFF
GO

-- Insert Cart with diverse dates in 2025, focusing on last 5 days (Nov 25-29)
-- Last 5 days (for weekly chart)
INSERT [dbo].[Cart] ([id], [u_id], [buyDate], [status]) VALUES (N'DH001', 3, '2025-11-29', 3)
INSERT [dbo].[Cart] ([id], [u_id], [buyDate], [status]) VALUES (N'DH002', 4, '2025-11-28', 3)
INSERT [dbo].[Cart] ([id], [u_id], [buyDate], [status]) VALUES (N'DH003', 5, '2025-11-27', 2)
INSERT [dbo].[Cart] ([id], [u_id], [buyDate], [status]) VALUES (N'DH004', 6, '2025-11-26', 3)
INSERT [dbo].[Cart] ([id], [u_id], [buyDate], [status]) VALUES (N'DH005', 3, '2025-11-25', 3)

-- Earlier in November
INSERT [dbo].[Cart] ([id], [u_id], [buyDate], [status]) VALUES (N'DH006', 4, '2025-11-20', 3)
INSERT [dbo].[Cart] ([id], [u_id], [buyDate], [status]) VALUES (N'DH007', 5, '2025-11-15', 3)
INSERT [dbo].[Cart] ([id], [u_id], [buyDate], [status]) VALUES (N'DH008', 6, '2025-11-10', 3)
INSERT [dbo].[Cart] ([id], [u_id], [buyDate], [status]) VALUES (N'DH009', 3, '2025-11-05', 3)

-- October 2025
INSERT [dbo].[Cart] ([id], [u_id], [buyDate], [status]) VALUES (N'DH010', 4, '2025-10-25', 3)
INSERT [dbo].[Cart] ([id], [u_id], [buyDate], [status]) VALUES (N'DH011', 5, '2025-10-15', 3)
INSERT [dbo].[Cart] ([id], [u_id], [buyDate], [status]) VALUES (N'DH012', 6, '2025-10-05', 3)

-- September 2025
INSERT [dbo].[Cart] ([id], [u_id], [buyDate], [status]) VALUES (N'DH013', 3, '2025-09-20', 3)
INSERT [dbo].[Cart] ([id], [u_id], [buyDate], [status]) VALUES (N'DH014', 4, '2025-09-10', 3)

-- August 2025
INSERT [dbo].[Cart] ([id], [u_id], [buyDate], [status]) VALUES (N'DH015', 5, '2025-08-25', 3)
INSERT [dbo].[Cart] ([id], [u_id], [buyDate], [status]) VALUES (N'DH016', 6, '2025-08-15', 3)

-- July 2025
INSERT [dbo].[Cart] ([id], [u_id], [buyDate], [status]) VALUES (N'DH017', 3, '2025-07-20', 3)
INSERT [dbo].[Cart] ([id], [u_id], [buyDate], [status]) VALUES (N'DH018', 4, '2025-07-10', 3)

-- June 2025
INSERT [dbo].[Cart] ([id], [u_id], [buyDate], [status]) VALUES (N'DH019', 5, '2025-06-15', 3)

-- May 2025
INSERT [dbo].[Cart] ([id], [u_id], [buyDate], [status]) VALUES (N'DH020', 6, '2025-05-20', 3)
GO

-- Insert CartItem for all orders
INSERT [dbo].[CartItem] ([id], [quantity], [unitPrice], [pro_id], [cat_id]) VALUES (N'CI001', 2, 20, 2, N'DH001')
INSERT [dbo].[CartItem] ([id], [quantity], [unitPrice], [pro_id], [cat_id]) VALUES (N'CI002', 5, 12, 4, N'DH001')
INSERT [dbo].[CartItem] ([id], [quantity], [unitPrice], [pro_id], [cat_id]) VALUES (N'CI003', 4, 35, 6, N'DH002')
INSERT [dbo].[CartItem] ([id], [quantity], [unitPrice], [pro_id], [cat_id]) VALUES (N'CI004', 2, 25, 3, N'DH003')
INSERT [dbo].[CartItem] ([id], [quantity], [unitPrice], [pro_id], [cat_id]) VALUES (N'CI005', 5, 15, 5, N'DH004')
INSERT [dbo].[CartItem] ([id], [quantity], [unitPrice], [pro_id], [cat_id]) VALUES (N'CI006', 3, 12, 10, N'DH005')
INSERT [dbo].[CartItem] ([id], [quantity], [unitPrice], [pro_id], [cat_id]) VALUES (N'CI007', 6, 20, 7, N'DH006')
INSERT [dbo].[CartItem] ([id], [quantity], [unitPrice], [pro_id], [cat_id]) VALUES (N'CI008', 2, 35, 12, N'DH007')
INSERT [dbo].[CartItem] ([id], [quantity], [unitPrice], [pro_id], [cat_id]) VALUES (N'CI009', 4, 15, 37, N'DH008')
INSERT [dbo].[CartItem] ([id], [quantity], [unitPrice], [pro_id], [cat_id]) VALUES (N'CI010', 3, 20, 2, N'DH009')
INSERT [dbo].[CartItem] ([id], [quantity], [unitPrice], [pro_id], [cat_id]) VALUES (N'CI011', 5, 35, 6, N'DH010')
INSERT [dbo].[CartItem] ([id], [quantity], [unitPrice], [pro_id], [cat_id]) VALUES (N'CI012', 2, 12, 4, N'DH011')
INSERT [dbo].[CartItem] ([id], [quantity], [unitPrice], [pro_id], [cat_id]) VALUES (N'CI013', 4, 25, 3, N'DH012')
INSERT [dbo].[CartItem] ([id], [quantity], [unitPrice], [pro_id], [cat_id]) VALUES (N'CI014', 3, 15, 5, N'DH013')
INSERT [dbo].[CartItem] ([id], [quantity], [unitPrice], [pro_id], [cat_id]) VALUES (N'CI015', 6, 20, 7, N'DH014')
INSERT [dbo].[CartItem] ([id], [quantity], [unitPrice], [pro_id], [cat_id]) VALUES (N'CI016', 2, 35, 12, N'DH015')
INSERT [dbo].[CartItem] ([id], [quantity], [unitPrice], [pro_id], [cat_id]) VALUES (N'CI017', 5, 12, 10, N'DH016')
INSERT [dbo].[CartItem] ([id], [quantity], [unitPrice], [pro_id], [cat_id]) VALUES (N'CI018', 3, 15, 37, N'DH017')
INSERT [dbo].[CartItem] ([id], [quantity], [unitPrice], [pro_id], [cat_id]) VALUES (N'CI019', 4, 20, 2, N'DH018')
INSERT [dbo].[CartItem] ([id], [quantity], [unitPrice], [pro_id], [cat_id]) VALUES (N'CI020', 2, 35, 6, N'DH019')
INSERT [dbo].[CartItem] ([id], [quantity], [unitPrice], [pro_id], [cat_id]) VALUES (N'CI021', 5, 25, 3, N'DH020')
GO

-- Insert Reviews
INSERT [dbo].[Reviews] ([u_id], [pro_id], [rating], [comment]) VALUES (3, 2, 5, N'Sản phẩm rất tươi ngon, giao hàng nhanh!')
INSERT [dbo].[Reviews] ([u_id], [pro_id], [rating], [comment]) VALUES (4, 4, 4, N'Cam ngọt, nhưng hơi nhỏ.')
INSERT [dbo].[Reviews] ([u_id], [pro_id], [rating], [comment]) VALUES (5, 6, 5, N'Táo giòn, ngọt, rất đáng tiền.')
INSERT [dbo].[Reviews] ([u_id], [pro_id], [rating], [comment]) VALUES (6, 10, 5, N'Mua lần 2 rồi, vẫn rất hài lòng.')
GO

USE [master]
GO
ALTER DATABASE [Fruitables] SET  READ_WRITE 
GO
