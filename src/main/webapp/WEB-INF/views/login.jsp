<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập hệ thống - Spring Boot</title>
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
        .login-card {
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
            <div class="col-md-5 col-lg-4">
                <div class="card login-card p-4">
                    <div class="card-body">
                        <div class="text-center mb-4">
                            <i class="bi bi-shield-lock-fill text-primary display-4"></i>
                            <h3 class="fw-bold mt-2">Đăng Nhập</h3>
                            <p class="text-muted small">Nhập tài khoản để tiếp tục</p>
                        </div>

                        <!-- Thông báo lỗi -->
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show small" role="alert">
                                <i class="bi bi-exclamation-triangle-fill me-1"></i>${errorMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <!-- Thông báo thành công -->
                        <c:if test="${not empty successMessage}">
                            <div class="alert alert-success alert-dismissible fade show small" role="alert">
                                <i class="bi bi-check-circle-fill me-1"></i>${successMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/login" method="post">
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Tên đăng nhập hoặc Email</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-person"></i></span>
                                    <input type="text" name="username" class="form-control" 
                                           placeholder="Nhập username hoặc email" 
                                           value="${savedUsername != null ? savedUsername : (username != null ? username : '')}" required autofocus>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Mật khẩu</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-key"></i></span>
                                    <input type="password" name="password" class="form-control" 
                                           placeholder="Nhập mật khẩu" required>
                                </div>
                            </div>

                            <div class="mb-3 form-check d-flex justify-content-between align-items-center">
                                <div>
                                    <input type="checkbox" class="form-check-input" id="remember" name="remember" 
                                           ${isRemembered ? 'checked' : ''}>
                                    <label class="form-check-label small" for="remember">Ghi nhớ đăng nhập</label>
                                </div>
                            </div>

                            <div class="d-grid mb-3">
                                <button type="submit" class="btn btn-primary btn-lg fw-semibold">
                                    <i class="bi bi-box-arrow-in-right me-1"></i>Đăng Nhập
                                </button>
                            </div>

                            <div class="text-center mt-3">
                                <span class="text-muted small">Chưa có tài khoản?</span>
                                <a href="${pageContext.request.contextPath}/register" class="fw-semibold text-primary ms-1 small">Đăng ký ngay</a>
                            </div>

                            <div class="alert alert-light border mt-4 p-2 small text-muted">
                                <strong>Tài khoản mẫu:</strong><br>
                                • Admin: <code>admin</code> / <code>123456</code> hoặc <code>1234</code><br>
                                • User: <code>user</code> / <code>123456</code> hoặc <code>1234</code>
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
