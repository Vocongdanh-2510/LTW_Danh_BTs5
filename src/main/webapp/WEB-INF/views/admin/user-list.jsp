<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Người dùng - Admin Panel</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        body { min-height: 100vh; display: flex; flex-direction: column; background-color: #f4f6f9; }
        .table-card { border-radius: 0.75rem; border: none; box-shadow: 0 4px 12px rgba(0,0,0,0.05); }
        .avatar-img { width: 42px; height: 42px; object-fit: cover; border-radius: 50%; }
    </style>
</head>
<body>
    <jsp:include page="../common/navbar.jsp" />

    <div class="container my-4">
        <!-- Breadcrumb & Header -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-1">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home">Trang chủ</a></li>
                        <li class="breadcrumb-item active">Quản trị Người dùng</li>
                    </ol>
                </nav>
                <h3 class="fw-bold mb-0"><i class="bi bi-people-fill text-success me-2"></i>Quản Lý Người Dùng</h3>
            </div>
            <a href="${pageContext.request.contextPath}/admin/users/add" class="btn btn-success">
                <i class="bi bi-person-plus me-1"></i>Thêm Người Dùng
            </a>
        </div>

        <!-- Thông báo Alert -->
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>${successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>${errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Thẻ Tìm Kiếm & Lọc -->
        <div class="card table-card mb-4">
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/admin/users" method="get" class="row g-3 align-items-center">
                    <div class="col-md-6 col-lg-5">
                        <div class="input-group">
                            <span class="input-group-text bg-white"><i class="bi bi-search"></i></span>
                            <input type="text" name="keyword" class="form-control" 
                                   placeholder="Tìm theo username, họ tên, email..." value="${keyword}">
                        </div>
                    </div>
                    <div class="col-auto">
                        <button type="submit" class="btn btn-success">
                            <i class="bi bi-search me-1"></i>Tìm kiếm
                        </button>
                        <c:if test="${not empty keyword}">
                            <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-secondary ms-1">
                                <i class="bi bi-x-circle me-1"></i>Xóa lọc
                            </a>
                        </c:if>
                    </div>
                    <div class="col-auto ms-auto d-flex align-items-center">
                        <label class="form-label me-2 mb-0 small text-muted">Hiển thị:</label>
                        <select name="size" class="form-select form-select-sm" onchange="this.form.submit()">
                            <option value="5" ${pageSize == 5 ? 'selected' : ''}>5 dòng/trang</option>
                            <option value="10" ${pageSize == 10 ? 'selected' : ''}>10 dòng/trang</option>
                            <option value="20" ${pageSize == 20 ? 'selected' : ''}>20 dòng/trang</option>
                        </select>
                    </div>
                </form>
            </div>
        </div>

        <!-- Bảng Dữ Liệu Users -->
        <div class="card table-card">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th class="text-center" style="width: 60px;">ID</th>
                                <th style="width: 60px;">Avatar</th>
                                <th>Tên đăng nhập</th>
                                <th>Họ và tên</th>
                                <th>Email</th>
                                <th>Số điện thoại</th>
                                <th class="text-center" style="width: 100px;">Vai Trò</th>
                                <th class="text-center" style="width: 110px;">Trạng Thái</th>
                                <th class="text-center" style="width: 140px;">Thao Tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty users}">
                                    <c:forEach items="${users}" var="u">
                                        <tr>
                                            <td class="text-center fw-semibold">${u.id}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty u.avatar}">
                                                        <img src="${u.avatar.startsWith('http') ? u.avatar : pageContext.request.contextPath.concat(u.avatar)}" 
                                                             class="avatar-img border" alt="${u.username}">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="avatar-img bg-secondary-subtle border d-flex align-items-center justify-content-center text-muted">
                                                            <i class="bi bi-person"></i>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <span class="fw-bold text-dark">${u.username}</span>
                                            </td>
                                            <td>${u.fullname}</td>
                                            <td><span class="text-muted small">${u.email}</span></td>
                                            <td><span class="text-muted small">${u.phone}</span></td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${u.roleid == 1}">
                                                        <span class="badge bg-danger-subtle text-danger border border-danger-subtle px-2 py-1">
                                                            <i class="bi bi-shield-fill me-1"></i>Admin
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-primary-subtle text-primary border border-primary-subtle px-2 py-1">
                                                            <i class="bi bi-person me-1"></i>User
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${u.status == 1}">
                                                        <span class="badge bg-success-subtle text-success border border-success-subtle px-2 py-1">
                                                            <i class="bi bi-check-circle me-1"></i>Hoạt động
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-danger-subtle text-danger border border-danger-subtle px-2 py-1">
                                                            <i class="bi bi-lock me-1"></i>Bị khóa
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center">
                                                <div class="btn-group btn-group-sm">
                                                    <a href="${pageContext.request.contextPath}/admin/users/edit/${u.id}" 
                                                       class="btn btn-outline-primary" title="Chỉnh sửa">
                                                        <i class="bi bi-pencil-square"></i>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/admin/users/delete/${u.id}" 
                                                       class="btn btn-outline-danger" title="Xóa"
                                                       onclick="return confirm('Bạn có chắc muốn xóa tài khoản [${u.username}] không?');">
                                                        <i class="bi bi-trash"></i>
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="9" class="text-center py-5 text-muted">
                                            <i class="bi bi-people display-6 d-block mb-2"></i>
                                            Không tìm thấy người dùng nào phù hợp!
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Footer & Thanh Phân Trang (Pagination) -->
            <div class="card-footer bg-white d-flex flex-wrap justify-content-between align-items-center py-3">
                <span class="text-muted small">
                    Hiển thị <strong>${users.size()}</strong> trên tổng số <strong>${totalItems}</strong> người dùng (Trang ${currentPage} / ${totalPages})
                </span>

                <c:if test="${totalPages > 1}">
                    <nav aria-label="Pagination">
                        <ul class="pagination pagination-sm mb-0">
                            <!-- Nút Trang Đầu -->
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/admin/users?page=1&size=${pageSize}&keyword=${keyword}">
                                    <i class="bi bi-chevron-double-left"></i>
                                </a>
                            </li>
                            <!-- Nút Trang Trước -->
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/admin/users?page=${currentPage - 1}&size=${pageSize}&keyword=${keyword}">
                                    <i class="bi bi-chevron-left"></i>
                                </a>
                            </li>

                            <!-- Các Trang Số -->
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <c:if test="${i >= currentPage - 2 && i <= currentPage + 2}">
                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                        <a class="page-link" href="${pageContext.request.contextPath}/admin/users?page=${i}&size=${pageSize}&keyword=${keyword}">
                                            ${i}
                                        </a>
                                    </li>
                                </c:if>
                            </c:forEach>

                            <!-- Nút Trang Sau -->
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/admin/users?page=${currentPage + 1}&size=${pageSize}&keyword=${keyword}">
                                    <i class="bi bi-chevron-right"></i>
                                </a>
                            </li>
                            <!-- Nút Trang Cuối -->
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/admin/users?page=${totalPages}&size=${pageSize}&keyword=${keyword}">
                                    <i class="bi bi-chevron-double-right"></i>
                                </a>
                            </li>
                        </ul>
                    </nav>
                </c:if>
            </div>
        </div>
    </div>

    <jsp:include page="../common/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
