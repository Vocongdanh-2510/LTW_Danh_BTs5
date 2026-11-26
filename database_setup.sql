-- ===================================================================
-- DATABASE SETUP SCRIPT CHO BÀI TẬP 05: SPRING BOOT VỚI JSP/JSTL
-- Sinh viên: Võ Công Danh - MSSV: 24110010
-- CSDL: SQL Server (Database: webst2)
-- ===================================================================

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'webst2')
BEGIN
    CREATE DATABASE webst2;
END
GO

USE webst2;
GO

-- 1. BẢNG USERS (Hỗ trợ SHA-256 Hash Password, Role Admin=1, User=5)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'users')
BEGIN
    CREATE TABLE users (
        id          INT PRIMARY KEY IDENTITY(1,1),
        email       NVARCHAR(100) NULL,
        username    NVARCHAR(50)  NOT NULL UNIQUE,
        fullname    NVARCHAR(100) NULL,
        password    NVARCHAR(255) NOT NULL, -- Mật khẩu băm SHA-256 hoặc plain text
        avatar      NVARCHAR(255) NULL,
        roleid      INT NOT NULL DEFAULT 5,  -- 1=Admin, 5=User
        phone       NVARCHAR(20) NULL,
        createdDate DATE NULL,
        status      INT NOT NULL DEFAULT 1,  -- 1=Hoạt động, 0=Khóa
        code        NVARCHAR(50) NULL
    );
END
GO

-- 2. BẢNG CATEGORIES (Quản lý danh mục với hình ảnh và trạng thái)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'categories')
BEGIN
    CREATE TABLE categories (
        categoryId   INT PRIMARY KEY IDENTITY(1,1),
        categoryname NVARCHAR(255) NOT NULL,
        images       NVARCHAR(500) NULL,
        status       INT NOT NULL DEFAULT 1  -- 1=Hoạt động, 0=Tạm khóa
    );
END
GO

-- 3. DỮ LIỆU MẪU BAN ĐẦU (SEED DATA)
-- Tài khoản Admin: admin / 123456 (hash SHA-256: 8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92)
IF NOT EXISTS (SELECT * FROM users WHERE username = 'admin')
BEGIN
    INSERT INTO users (username, fullname, email, password, roleid, status, createdDate)
    VALUES ('admin', N'Võ Công Danh Admin', 'admin@ute.edu.vn', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 1, 1, GETDATE());
END

-- Tài khoản User: user / 123456
IF NOT EXISTS (SELECT * FROM users WHERE username = 'user')
BEGIN
    INSERT INTO users (username, fullname, email, password, roleid, status, createdDate)
    VALUES ('user', N'Nguyễn Văn User', 'user@gmail.com', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 5, 1, GETDATE());
END

-- Dữ liệu mẫu Categories
IF NOT EXISTS (SELECT * FROM categories WHERE categoryname = N'Công Nghệ & Lập Trình')
BEGIN
    INSERT INTO categories (categoryname, images, status) VALUES 
    (N'Công Nghệ & Lập Trình', 'https://images.unsplash.com/photo-1518770660439-4636190af475?w=500', 1),
    (N'Âm Nhạc & Giải Trí', 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=500', 1),
    (N'Giáo Dục & Bài Giảng', 'https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?w=500', 1),
    (N'Đời Sống & Du Lịch', 'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=500', 1),
    (N'Ẩm Thực & Nấu Ăn', 'https://images.unsplash.com/photo-1498837167922-ddd27525d352?w=500', 1),
    (N'Thể Thao & Thể Hình', 'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?w=500', 1),
    (N'Tin Tức & Thời Sự', 'https://images.unsplash.com/photo-1504711434969-e33886168f5c?w=500', 1);
END
GO
