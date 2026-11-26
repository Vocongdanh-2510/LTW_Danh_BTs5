<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${isEdit ? 'Chỉnh sửa' : 'Thêm mới'} Danh Mục - Admin Panel</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        body { min-height: 100vh; display: flex; flex-direction: column; background-color: #f4f6f9; }
        .form-card { border-radius: 0.75rem; border: none; box-shadow: 0 4px 15px rgba(0,0,0,0.06); }
        .preview-img { max-height: 150px; border-radius: 0.5rem; object-fit: cover; }
    </style>
</head>
<body>
    <jsp:include page="../common/navbar.jsp" />

    <div class="container my-4">
        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-3">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home">Trang chủ</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/categories">Danh mục</a></li>
                <li class="breadcrumb-item active">${isEdit ? 'Chỉnh sửa' : 'Thêm mới'}</li>
            </ol>
        </nav>

        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card form-card">
                    <div class="card-header bg-white py-3 border-bottom">
                        <h4 class="fw-bold mb-0">
                            <i class="bi ${isEdit ? 'bi-pencil-square text-warning' : 'bi-plus-circle text-primary'} me-2"></i>
                            ${isEdit ? 'Chỉnh Sửa Danh Mục' : 'Thêm Danh Mục Mới'}
                        </h4>
                    </div>
                    <div class="card-body p-4">
                        <form action="${pageContext.request.contextPath}/admin/categories/save" method="post" enctype="multipart/form-data">
                            <!-- ID ẩn nếu là chế độ Edit -->
                            <input type="hidden" name="categoryId" value="${category.categoryId}" />

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Tên Danh Mục <span class="text-danger">*</span></label>
                                <input type="text" name="categoryname" class="form-control" 
                                       placeholder="Ví dụ: Thiết bị điện tử" value="${category.categoryname}" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Hình Ảnh Danh Mục</label>
                                <div class="row g-2 align-items-center">
                                    <div class="col-md-6">
                                        <label class="form-label small text-muted">Tải ảnh từ máy tính:</label>
                                        <input type="file" name="imageFile" class="form-control" accept="image/*">
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label small text-muted">Hoặc dán URL hình ảnh:</label>
                                        <input type="text" name="imageUrl" class="form-control" 
                                               placeholder="https://..." value="${category.images}">
                                    </div>
                                </div>
                                <c:if test="${not empty category.images}">
                                    <div class="mt-2">
                                        <span class="small text-muted d-block mb-1">Ảnh hiện tại:</span>
                                        <img src="${category.images.startsWith('http') ? category.images : pageContext.request.contextPath.concat(category.images)}" 
                                             class="preview-img border" alt="Preview">
                                    </div>
                                </c:if>
                            </div>

                            <div class="mb-4">
                                <label class="form-label fw-semibold">Trạng Thái</label>
                                <div class="form-check form-check-inline ms-3">
                                    <input class="form-check-input" type="radio" name="status" id="statusActive" value="1" 
                                           ${category.status == 1 ? 'checked' : ''}>
                                    <label class="form-check-label text-success fw-semibold" for="statusActive">
                                        <i class="bi bi-check-circle me-1"></i>Hoạt động
                                    </label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="status" id="statusLocked" value="0" 
                                           ${category.status == 0 ? 'checked' : ''}>
                                    <label class="form-check-label text-secondary fw-semibold" for="statusLocked">
                                        <i class="bi bi-lock me-1"></i>Tạm khóa
                                    </label>
                                </div>
                            </div>

                            <div class="d-flex justify-content-between pt-3 border-top">
                                <a href="${pageContext.request.contextPath}/admin/categories" class="btn btn-outline-secondary">
                                    <i class="bi bi-arrow-left me-1"></i>Quay lại danh sách
                                </a>
                                <button type="submit" class="btn btn-primary px-4 fw-semibold">
                                    <i class="bi bi-save me-1"></i>${isEdit ? 'Lưu Thay Đổi' : 'Thêm Mới'}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="../common/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
