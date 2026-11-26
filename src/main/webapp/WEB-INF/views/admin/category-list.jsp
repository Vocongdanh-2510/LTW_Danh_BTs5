<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Danh mục - Admin Panel</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        body { min-height: 100vh; display: flex; flex-direction: column; background-color: #f4f6f9; }
        .table-card { border-radius: 0.75rem; border: none; box-shadow: 0 4px 12px rgba(0,0,0,0.05); }
        .table-thumbnail { width: 50px; height: 50px; object-fit: cover; border-radius: 0.35rem; }
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
                        <li class="breadcrumb-item active">Quản trị Category</li>
                    </ol>
                </nav>
                <h3 class="fw-bold mb-0"><i class="bi bi-tags-fill text-primary me-2"></i>Quản Lý Danh Mục</h3>
            </div>
            <a href="${pageContext.request.contextPath}/admin/categories/add" class="btn btn-primary">
                <i class="bi bi-plus-circle me-1"></i>Thêm Danh Mục Mới
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
                <form action="${pageContext.request.contextPath}/admin/categories" method="get" class="row g-3 align-items-center">
                    <div class="col-md-6 col-lg-5">
                        <div class="input-group">
                            <span class="input-group-text bg-white"><i class="bi bi-search"></i></span>
                            <input type="text" name="keyword" class="form-control" 
                                   placeholder="Nhập tên danh mục cần tìm..." value="${keyword}">
                        </div>
                    </div>
                    <div class="col-auto">
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-search me-1"></i>Tìm kiếm
                        </button>
                        <c:if test="${not empty keyword}">
                            <a href="${pageContext.request.contextPath}/admin/categories" class="btn btn-outline-secondary ms-1">
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

        <!-- Bảng Dữ Liệu -->
        <div class="card table-card">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th class="text-center" style="width: 70px;">ID</th>
                                <th style="width: 90px;">Hình ảnh</th>
                                <th>Tên Danh Mục</th>
                                <th class="text-center" style="width: 140px;">Trạng Thái</th>
                                <th class="text-center" style="width: 160px;">Thao Tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty categories}">
                                    <c:forEach items="${categories}" var="cat">
                                        <tr>
                                            <td class="text-center fw-semibold">${cat.categoryId}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty cat.images}">
                                                        <img src="${cat.images.startsWith('http') ? cat.images : pageContext.request.contextPath.concat(cat.images)}" 
                                                             class="table-thumbnail border" alt="${cat.categoryname}">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="table-thumbnail bg-light border d-flex align-items-center justify-content-center text-muted">
                                                            <i class="bi bi-image"></i>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <span class="fw-bold text-dark">${cat.categoryname}</span>
                                            </td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${cat.status == 1}">
                                                        <span class="badge bg-success-subtle text-success border border-success-subtle px-3 py-2">
                                                            <i class="bi bi-check-circle me-1"></i>Hoạt động
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle px-3 py-2">
                                                            <i class="bi bi-lock me-1"></i>Tạm khóa
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center">
                                                <div class="btn-group btn-group-sm">
                                                    <a href="${pageContext.request.contextPath}/admin/categories/edit/${cat.categoryId}" 
                                                       class="btn btn-outline-primary" title="Chỉnh sửa">
                                                        <i class="bi bi-pencil-square"></i> Sửa
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/admin/categories/delete/${cat.categoryId}" 
                                                       class="btn btn-outline-danger" title="Xóa"
                                                       onclick="return confirm('Bạn có chắc chắn muốn xóa danh mục [${cat.categoryname}] không?');">
                                                        <i class="bi bi-trash"></i> Xóa
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="5" class="text-center py-5 text-muted">
                                            <i class="bi bi-inbox display-6 d-block mb-2"></i>
                                            Không tìm thấy danh mục nào phù hợp!
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
                    Hiển thị <strong>${categories.size()}</strong> trên tổng số <strong>${totalItems}</strong> danh mục (Trang ${currentPage} / ${totalPages})
                </span>

                <c:if test="${totalPages > 1}">
                    <nav aria-label="Pagination">
                        <ul class="pagination pagination-sm mb-0">
                            <!-- Nút Trang Đầu -->
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/admin/categories?page=1&size=${pageSize}&keyword=${keyword}">
                                    <i class="bi bi-chevron-double-left"></i>
                                </a>
                            </li>
                            <!-- Nút Trang Trước -->
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/admin/categories?page=${currentPage - 1}&size=${pageSize}&keyword=${keyword}">
                                    <i class="bi bi-chevron-left"></i>
                                </a>
                            </li>

                            <!-- Các Trang Số -->
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <c:if test="${i >= currentPage - 2 && i <= currentPage + 2}">
                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                        <a class="page-link" href="${pageContext.request.contextPath}/admin/categories?page=${i}&size=${pageSize}&keyword=${keyword}">
                                            ${i}
                                        </a>
                                    </li>
                                </c:if>
                            </c:forEach>

                            <!-- Nút Trang Sau -->
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/admin/categories?page=${currentPage + 1}&size=${pageSize}&keyword=${keyword}">
                                    <i class="bi bi-chevron-right"></i>
                                </a>
                            </li>
                            <!-- Nút Trang Cuối -->
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/admin/categories?page=${totalPages}&size=${pageSize}&keyword=${keyword}">
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
