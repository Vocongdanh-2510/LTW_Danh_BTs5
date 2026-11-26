# BÀI TẬP 05: SPRING BOOT VỚI JSP/JSTL, PHÂN TRANG & TÌM KIẾM, AUTH & CRUD ADMIN

- **Sinh viên thực hiện**: Võ Công Danh
- **MSSV**: 24110010
- **Lớp**: Lập trình Web
- **Trường**: Đại học Sư phạm Kỹ thuật TP.HCM (HCMUTE)
- **Hệ thống nộp bài**: [HCMUTE UTEX LMS](https://utexlms.hcmute.edu.vn)

---

## 1. Tóm tắt kết quả hoàn thành các yêu cầu trong bài tập

| STT | Yêu cầu bài tập | Trạng thái | Chi tiết triển khai |
|:---:|:---|:---:|:---|
| **1** | **Cấu hình JSP vào Spring Boot** | **ĐÃ HOÀN THÀNH 100%** | Tích hợp `tomcat-embed-jasper`, `jakarta.servlet.jsp.jstl`, cấu hình View Resolver (`prefix=/WEB-INF/views/`, `suffix=.jsp`), kết nối SQL Server CSDL `webst2`. |
| **2** | **Phân trang và Tìm kiếm** | **ĐÃ HOÀN THÀNH 100%** | Sử dụng Spring Data JPA `Pageable`, `PageRequest.of(...)`, `Page<T>`, tìm kiếm đa tiêu chí, giữ lại từ khóa và số dòng trên trang khi chuyển trang. |
| **3** | **Đăng ký, Đăng nhập, Đăng xuất** | **ĐÃ HOÀN THÀNH 100%** | `/register`: Đăng ký tài khoản mới, kiểm tra trùng lặp, mã hóa mật khẩu SHA-256;<br>`/login`: Đăng nhập, cookie ghi nhớ, phân quyền chuyển hướng Admin/User;<br>`/logout`: Hủy Session, xóa Cookie. |
| **4** | **CRUD Role Admin cho bảng Category và User** | **ĐÃ HOÀN THÀNH 100%** | `/admin/categories`: Thêm mới, Sửa, Xóa danh mục, hỗ trợ upload ảnh hoặc URL, phân trang & tìm kiếm.<br>`/admin/users`: Thêm, Sửa, Xóa người dùng, đổi quyền Admin/User, khóa/kích hoạt, phân trang & tìm kiếm.<br>Bảo vệ bằng `AdminInterceptor` cho mọi URL `/admin/**`. |
| **5** | **Tạo Git Repository & Commit lên GitHub** | **ĐÃ HOÀN THÀNH 100%** | Khởi tạo Git repo, cấu hình `.gitignore`, commit đầy đủ source code sạch sẽ. |
| **6** | **Nộp link GitHub lên Utex LMS** | **SẴN SÀNG NỘP** | Link Repo: `https://github.com/Vocongdanh-2510/LTW_Danh_BTs5` |

---

## 2. Kiến trúc & Cấu trúc thư mục dự án

```text
24110010_LTW_springtool/
├── .mvn/wrapper/                      # Maven Wrapper 3.9.9
├── mvnw, mvnw.cmd                     # Script chạy Maven Wrapper
├── pom.xml                            # Cấu hình Spring Boot 3.2.5, Jasper, JSTL, SQL Server
├── database_setup.sql                 # Script CSDL SQL Server (Database: webst2)
├── run.bat, run.ps1                   # File khởi động nhanh ứng dụng 1-click
├── README.md                          # Tài liệu báo cáo dự án
└── src/
    └── main/
        ├── java/vn/iotstar/
        │   ├── Application.java       # Main Spring Boot Application
        │   ├── config/
        │   │   └── WebMvcConfig.java  # Đăng ký Interceptor & Static Resource Uploads
        │   ├── interceptor/
        │   │   └── AdminInterceptor.java # Chặn truy cập trái phép vào /admin/**
        │   ├── entity/
        │   │   ├── Category.java      # Entity JPA bảng categories
        │   │   └── User.java          # Entity JPA bảng users
        │   ├── repository/
        │   │   ├── CategoryRepository.java # JPA Repository hỗ trợ tìm kiếm & phân trang
        │   │   └── UserRepository.java     # JPA Repository hỗ trợ tìm kiếm & phân trang
        │   ├── service/
        │   │   ├── CategoryService.java, impl/CategoryServiceImpl.java
        │   │   └── UserService.java, impl/UserServiceImpl.java
        │   ├── controller/
        │   │   ├── AuthController.java     # Login, Register, Logout
        │   │   ├── HomeController.java     # Trang chủ người dùng
        │   │   ├── AdminCategoryController.java # CRUD Category (Search & Paginated)
        │   │   └── AdminUserController.java     # CRUD User (Search & Paginated)
        │   └── utils/
        │       └── PasswordUtil.java  # Mã hóa băm mật khẩu SHA-256
        ├── resources/
        │   └── application.properties # Cấu hình cổng, JSP prefix/suffix, SQL Server
        └── webapp/
            ├── uploads/               # Thư mục lưu ảnh upload
            └── WEB-INF/views/
                ├── common/
                │   ├── navbar.jsp     # Thanh điều hướng dùng chung
                │   └── footer.jsp     # Chân trang thông tin sinh viên
                ├── login.jsp          # Giao diện Đăng nhập Bootstrap 5
                ├── register.jsp       # Giao diện Đăng ký Bootstrap 5
                ├── home.jsp           # Giao diện Trang chủ & thống kê
                └── admin/
                    ├── category-list.jsp # Danh sách Category (Phân trang & Tìm kiếm)
                    ├── category-form.jsp # Form thêm/sửa Category (Upload ảnh)
                    ├── user-list.jsp     # Danh sách User (Phân trang & Tìm kiếm)
                    └── user-form.jsp     # Form thêm/sửa User (Phân quyền & Khóa/Mở)
```

---

## 3. Cấu hình CSDL SQL Server

File cấu hình tại `src/main/resources/application.properties`:
```properties
# JSP View Resolver
spring.mvc.view.prefix=/WEB-INF/views/
spring.mvc.view.suffix=.jsp

# Database SQL Server
spring.datasource.url=jdbc:sqlserver://localhost:1433;databaseName=webst2;encrypt=true;trustServerCertificate=true;
spring.datasource.username=sa
spring.datasource.password=1234567@a$
spring.datasource.driver-class-name=com.microsoft.sqlserver.jdbc.SQLServerDriver
spring.jpa.hibernate.ddl-auto=update
```

### Tài khoản thử nghiệm có sẵn:
- **Tài khoản Admin (Toàn quyền quản trị)**:
  - Tên đăng nhập: `admin`
  - Mật khẩu: `123456` (hoặc `1234`)
  - Quyền hạn: Truy cập `/admin/categories`, `/admin/users`, Thêm/Sửa/Xóa.
- **Tài khoản User (Người dùng thông thường)**:
  - Tên đăng nhập: `user`
  - Mật khẩu: `123456` (hoặc `1234`)
  - Quyền hạn: Xem trang chủ `/home`, bị chặn khi vào `/admin/**`.

---

## 4. Hướng dẫn chạy chương trình

### Cách 1: Chạy trực tiếp 1-click bằng file Script
- Click đúp vào file `run.bat` (hoặc chuột phải chọn Run with PowerShell đối với `run.ps1`).
- Trình duyệt sẽ tự động mở trang `http://localhost:8080/`.

### Cách 2: Chạy trong Spring Tool Suite (STS) / Eclipse
1. Mở Spring Tool Suite (hoặc Eclipse).
2. Chọn menu **File -> Import... -> Maven -> Existing Maven Projects**.
3. Chọn thư mục `C:\Users\Vo Cong Danh\Documents\LTWeb\24110010_LTW_springtool`.
4. Nhấn **Finish**.
5. Chuột phải vào file `Application.java` -> chọn **Run As -> Spring Boot App**.

### Cách 3: Chạy bằng dòng lệnh Maven
```bash
./mvnw clean spring-boot:run
```
hoặc chạy file WAR đã đóng gói:
```bash
java -jar target/24110010_LTW_springtool-1.0.0.war
```

---

## 5. Danh sách các URL kiểm thử chức năng

| Chức năng | Đường dẫn (URL) | Mô tả |
|:---|:---|:---|
| **Trang chủ** | `http://localhost:8080/` hoặc `/home` | Hiển thị dashboard, thống kê tổng số danh mục và người dùng |
| **Đăng nhập** | `http://localhost:8080/login` | Form đăng nhập, ghi nhớ mật khẩu, tự động điều hướng theo Role |
| **Đăng ký** | `http://localhost:8080/register` | Đăng ký tài khoản mới, mã hóa mật khẩu SHA-256 |
| **Đăng xuất** | `http://localhost:8080/logout` | Đăng xuất an toàn, xóa Session và Cookie |
| **Quản lý Category** | `http://localhost:8080/admin/categories` | Danh sách danh mục, có ô tìm kiếm và thanh phân trang |
| **Thêm Category** | `http://localhost:8080/admin/categories/add` | Thêm danh mục mới, hỗ trợ tải ảnh lên |
| **Sửa Category** | `http://localhost:8080/admin/categories/edit/{id}` | Cập nhật tên, ảnh, trạng thái hoạt động |
| **Xóa Category** | `http://localhost:8080/admin/categories/delete/{id}` | Xóa danh mục an toàn |
| **Quản lý User** | `http://localhost:8080/admin/users` | Danh sách người dùng, tìm kiếm theo tên/email, phân trang |
| **Thêm User** | `http://localhost:8080/admin/users/add` | Thêm tài khoản mới, chọn quyền Admin/User |
| **Sửa User** | `http://localhost:8080/admin/users/edit/{id}` | Cập nhật thông tin, đổi quyền, khóa/mở tài khoản |
| **Xóa User** | `http://localhost:8080/admin/users/delete/{id}` | Xóa tài khoản (không thể tự xóa chính mình) |
