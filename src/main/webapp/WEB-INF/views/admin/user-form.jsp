<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${isEdit ? 'Chỉnh sửa' : 'Thêm mới'} Người Dùng - Admin Panel</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        body { min-height: 100vh; display: flex; flex-direction: column; background-color: #f4f6f9; }
        .form-card { border-radius: 0.75rem; border: none; box-shadow: 0 4px 15px rgba(0,0,0,0.06); }
        .avatar-preview { width: 80px; height: 80px; border-radius: 50%; object-fit: cover; }
    </style>
</head>
<body>
    <jsp:include page="../common/navbar.jsp" />

    <div class="container my-4">
        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-3">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home">Trang chủ</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/users">Người dùng</a></li>
                <li class="breadcrumb-item active">${isEdit ? 'Chỉnh sửa' : 'Thêm mới'}</li>
            </ol>
        </nav>

        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card form-card">
                    <div class="card-header bg-white py-3 border-bottom">
                        <h4 class="fw-bold mb-0">
                            <i class="bi ${isEdit ? 'bi-pencil-square text-warning' : 'bi-person-plus text-success'} me-2"></i>
                            ${isEdit ? 'Chỉnh Sửa Thông Tin Người Dùng' : 'Thêm Người Dùng Mới'}
                        </h4>
                    </div>
                    <div class="card-body p-4">
                        <form action="${pageContext.request.contextPath}/admin/users/save" method="post" enctype="multipart/form-data">
                            <!-- ID ẩn nếu là Edit -->
                            <input type="hidden" name="id" value="${user.id}" />

                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Tên đăng nhập (Username) <span class="text-danger">*</span></label>
                                    <input type="text" name="username" class="form-control" 
                                           value="${user.username}" ${isEdit ? 'readonly' : 'required'} 
                                           placeholder="Ví dụ: danhvo">
                                    <c:if test="${isEdit}">
                                        <small class="text-muted">Không thể thay đổi tên đăng nhập.</small>
                                    </c:if>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">
                                        Mật khẩu ${isEdit ? '<span class="text-muted small fw-normal">(để trống nếu không đổi)</span>' : '<span class="text-danger">*</span>'}
                                    </label>
                                    <input type="password" name="rawPassword" class="form-control" 
                                           placeholder="${isEdit ? 'Nhập mật khẩu mới...' : 'Tối thiểu 6 ký tự'}" 
                                           ${isEdit ? '' : 'required'}>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Họ và tên</label>
                                    <input type="text" name="fullname" class="form-control" 
                                           value="${user.fullname}" placeholder="Ví dụ: Võ Công Danh">
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Địa chỉ Email</label>
                                    <input type="email" name="email" class="form-control" 
                                           value="${user.email}" placeholder="email@gmail.com">
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Số điện thoại</label>
                                    <input type="tel" name="phone" class="form-control" 
                                           value="${user.phone}" placeholder="0912345678">
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Ảnh đại diện (Avatar)</label>
                                    <input type="file" name="avatarFile" class="form-control" accept="image/*">
                                    <c:if test="${not empty user.avatar}">
                                        <div class="mt-2 d-flex align-items-center">
                                            <img src="${user.avatar.startsWith('http') ? user.avatar : pageContext.request.contextPath.concat(user.avatar)}" 
                                                 class="avatar-preview border me-2" alt="Avatar">
                                            <span class="small text-muted">Avatar hiện tại</span>
                                        </div>
                                    </c:if>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Vai trò (Role)</label>
                                    <select name="roleid" class="form-select">
                                        <option value="5" ${user.roleid != 1 ? 'selected' : ''}>Người dùng thông thường (User)</option>
                                        <option value="1" ${user.roleid == 1 ? 'selected' : ''}>Quản trị viên (Admin)</option>
                                    </select>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Trạng thái tài khoản</label>
                                    <select name="status" class="form-select">
                                        <option value="1" ${user.status == 1 ? 'selected' : ''}>Hoạt động / Đã kích hoạt</option>
                                        <option value="0" ${user.status == 0 ? 'selected' : ''}>Tạm khóa / Chưa kích hoạt</option>
                                    </select>
                                </div>
                            </div>

                            <div class="d-flex justify-content-between pt-4 mt-4 border-top">
                                <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-secondary">
                                    <i class="bi bi-arrow-left me-1"></i>Quay lại danh sách
                                </a>
                                <button type="submit" class="btn btn-success px-4 fw-semibold">
                                    <i class="bi bi-save me-1"></i>${isEdit ? 'Lưu Thay Đổi' : 'Thêm Người Dùng'}
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
