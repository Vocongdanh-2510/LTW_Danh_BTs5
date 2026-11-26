<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký tài khoản mới - Spring Boot</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        .register-card {
            border-radius: 1rem;
            border: none;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
        }
    </style>
</head>
<body>
    <jsp:include page="common/navbar.jsp" />

    <div class="container my-auto py-5">
        <div class="row justify-content-center">
            <div class="col-md-7 col-lg-5">
                <div class="card register-card p-4">
                    <div class="card-body">
                        <div class="text-center mb-4">
                            <i class="bi bi-person-plus-fill text-primary display-4"></i>
                            <h3 class="fw-bold mt-2">Tạo Tài Khoản Mới</h3>
                            <p class="text-muted small">Điền các thông tin bên dưới để đăng ký</p>
                        </div>

                        <!-- Thông báo lỗi -->
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show small" role="alert">
                                <i class="bi bi-exclamation-triangle-fill me-1"></i>${errorMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/register" method="post">
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Tên đăng nhập (Username) <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-person"></i></span>
                                    <input type="text" name="username" class="form-control" 
                                           placeholder="Ví dụ: danhvo" value="${username}" required>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Họ và tên</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-card-text"></i></span>
                                    <input type="text" name="fullname" class="form-control" 
                                           placeholder="Ví dụ: Võ Công Danh" value="${fullname}">
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Địa chỉ Email <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                                    <input type="email" name="email" class="form-control" 
                                           placeholder="Ví dụ: email@gmail.com" value="${email}" required>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Số điện thoại</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-telephone"></i></span>
                                    <input type="tel" name="phone" class="form-control" 
                                           placeholder="Ví dụ: 0912345678" value="${phone}">
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Mật khẩu <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-lock"></i></span>
                                    <input type="password" name="password" class="form-control" 
                                           placeholder="Tối thiểu 6 ký tự" required>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Xác nhận mật khẩu <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-lock-fill"></i></span>
                                    <input type="password" name="repassword" class="form-control" 
                                           placeholder="Nhập lại mật khẩu" required>
                                </div>
                            </div>

                            <div class="d-grid mb-3">
                                <button type="submit" class="btn btn-primary btn-lg fw-semibold">
                                    <i class="bi bi-person-check me-1"></i>Đăng Ký Tài Khoản
                                </button>
                            </div>

                            <div class="text-center mt-3">
                                <span class="text-muted small">Đã có tài khoản?</span>
                                <a href="${pageContext.request.contextPath}/login" class="fw-semibold text-primary ms-1 small">Đăng nhập</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="common/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
