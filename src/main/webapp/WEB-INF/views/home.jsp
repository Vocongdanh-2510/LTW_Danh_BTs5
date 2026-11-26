<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang Chủ - Hệ Thống Spring Boot Web</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        body { min-height: 100vh; display: flex; flex-direction: column; background-color: #f8f9fa; }
        .hero-banner {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            color: white;
            padding: 3rem 0;
            border-radius: 0 0 2rem 2rem;
            margin-bottom: 2rem;
        }
        .feature-card {
            border: none;
            border-radius: 1rem;
            box-shadow: 0 4px 15px rgba(0,0,0,0.06);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .feature-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.12);
        }
    </style>
</head>
<body>
    <jsp:include page="common/navbar.jsp" />

    <!-- Hero Banner -->
    <div class="hero-banner">
        <div class="container text-center py-4">
            <h1 class="display-5 fw-bold mb-3">HỆ THỐNG SPRING BOOT & JSP/JSTL</h1>
            <p class="lead mb-4">Bài tập 05: Đăng ký, Đăng nhập, Quản lý CRUD Category & User với Tìm kiếm & Phân trang</p>
            <c:choose>
                <c:when test="${sessionScope.user != null}">
                    <div class="d-inline-flex align-items-center bg-white text-dark px-4 py-2 rounded-pill shadow-sm">
                        <i class="bi bi-person-check-fill text-success fs-4 me-2"></i>
                        <span>Xin chào, <strong>${sessionScope.user.fullname != null ? sessionScope.user.fullname : sessionScope.user.username}</strong>! (${sessionScope.user.roleid == 1 ? 'Quản trị viên' : 'Thành viên'})</span>
                    </div>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-warning btn-lg fw-semibold px-4 me-2">
                        <i class="bi bi-box-arrow-in-right me-1"></i>Đăng Nhập Ngay
                    </a>
                    <a href="${pageContext.request.contextPath}/register" class="btn btn-outline-light btn-lg fw-semibold px-4">
                        <i class="bi bi-person-plus me-1"></i>Đăng Ký
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Main Content -->
    <div class="container my-4">
        <!-- Thống kê -->
        <div class="row g-4 mb-5">
            <div class="col-md-4">
                <div class="card feature-card p-3 bg-white">
                    <div class="card-body d-flex align-items-center">
                        <div class="bg-primary text-white p-3 rounded-circle me-3">
                            <i class="bi bi-tags-fill fs-3"></i>
                        </div>
                        <div>
                            <h6 class="text-muted mb-1">Tổng Số Danh Mục</h6>
                            <h3 class="fw-bold mb-0 text-primary">${totalCategories}</h3>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card feature-card p-3 bg-white">
                    <div class="card-body d-flex align-items-center">
                        <div class="bg-success text-white p-3 rounded-circle me-3">
                            <i class="bi bi-people-fill fs-3"></i>
                        </div>
                        <div>
                            <h6 class="text-muted mb-1">Tổng Số Người Dùng</h6>
                            <h3 class="fw-bold mb-0 text-success">${totalUsers}</h3>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card feature-card p-3 bg-white">
                    <div class="card-body d-flex align-items-center">
                        <div class="bg-info text-white p-3 rounded-circle me-3">
                            <i class="bi bi-shield-check fs-3"></i>
                        </div>
                        <div>
                            <h6 class="text-muted mb-1">Công Nghệ Sử Dụng</h6>
                            <h5 class="fw-bold mb-0 text-info">Spring Boot + JSP/JSTL</h5>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Chức năng chính -->
        <h4 class="fw-bold mb-3"><i class="bi bi-grid-fill text-primary me-2"></i>Tính năng hệ thống</h4>
        <div class="row g-4">
            <c:if test="${sessionScope.user != null && sessionScope.user.roleid == 1}">
                <div class="col-md-6">
                    <div class="card feature-card h-100">
                        <div class="card-body p-4">
                            <div class="d-flex align-items-center mb-3">
                                <i class="bi bi-tags text-primary fs-2 me-3"></i>
                                <h5 class="card-title fw-bold mb-0">Quản lý Danh mục (Admin)</h5>
                            </div>
                            <p class="card-text text-muted">
                                Xem danh sách, tìm kiếm theo tên danh mục, phân trang theo kích thước trang tùy chọn, thêm mới, sửa và xóa danh mục với ảnh upload.
                            </p>
                            <a href="${pageContext.request.contextPath}/admin/categories" class="btn btn-primary">
                                <i class="bi bi-arrow-right-circle me-1"></i>Truy cập Quản lý Danh mục
                            </a>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="card feature-card h-100">
                        <div class="card-body p-4">
                            <div class="d-flex align-items-center mb-3">
                                <i class="bi bi-people text-success fs-2 me-3"></i>
                                <h5 class="card-title fw-bold mb-0">Quản lý Người dùng (Admin)</h5>
                            </div>
                            <p class="card-text text-muted">
                                Quản lý danh sách thành viên, tìm kiếm theo tên hoặc email, phân trang, thêm mới tài khoản, phân quyền Admin/User và khóa/mở tài khoản.
                            </p>
                            <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-success">
                                <i class="bi bi-arrow-right-circle me-1"></i>Truy cập Quản lý Người dùng
                            </a>
                        </div>
                    </div>
                </div>
            </c:if>

            <!-- Danh sách Category hiển thị cho người xem -->
            <div class="col-12 mt-4">
                <div class="card feature-card">
                    <div class="card-header bg-white py-3">
                        <h5 class="fw-bold mb-0"><i class="bi bi-card-list text-primary me-2"></i>Danh mục nổi bật</h5>
                    </div>
                    <div class="card-body">
                        <div class="row g-3">
                            <c:forEach items="${categories}" var="cat">
                                <div class="col-md-3 col-sm-6">
                                    <div class="card h-100 border text-center p-3">
                                        <c:choose>
                                            <c:when test="${not empty cat.images}">
                                                <img src="${cat.images.startsWith('http') ? cat.images : pageContext.request.contextPath.concat(cat.images)}" 
                                                     class="card-img-top mx-auto rounded" style="height: 120px; object-fit: cover;" alt="${cat.categoryname}">
                                            </c:when>
                                            <c:otherwise>
                                                <div class="bg-light rounded d-flex align-items-center justify-content-center" style="height: 120px;">
                                                    <i class="bi bi-image text-muted display-6"></i>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                        <div class="card-body p-2">
                                            <h6 class="card-title fw-bold mb-1">${cat.categoryname}</h6>
                                            <span class="badge ${cat.status == 1 ? 'bg-success' : 'bg-secondary'}">
                                                ${cat.status == 1 ? 'Hoạt động' : 'Tạm khóa'}
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="common/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
