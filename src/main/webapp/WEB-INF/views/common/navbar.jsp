<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow-sm sticky-top">
    <div class="container">
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/">
            <i class="bi bi-box-seam me-2"></i>HCMUTE - Web App
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/home">
                        <i class="bi bi-house-door me-1"></i>Trang chủ
                    </a>
                </li>
                <c:if test="${sessionScope.user != null && sessionScope.user.roleid == 1}">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/categories">
                            <i class="bi bi-tags me-1"></i>Quản lý Danh mục
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/users">
                            <i class="bi bi-people me-1"></i>Quản lý Người dùng
                        </a>
                    </li>
                </c:if>
            </ul>
            <ul class="navbar-nav ms-auto align-items-center">
                <c:choose>
                    <c:when test="${sessionScope.user != null}">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle text-white fw-semibold" href="#" id="userMenu" role="button" data-bs-toggle="dropdown">
                                <i class="bi bi-person-circle me-1"></i>${sessionScope.user.fullname != null && !sessionScope.user.fullname.isEmpty() ? sessionScope.user.fullname : sessionScope.user.username}
                                <span class="badge ${sessionScope.user.roleid == 1 ? 'bg-danger' : 'bg-info'} ms-1">
                                    ${sessionScope.user.roleid == 1 ? 'Admin' : 'User'}
                                </span>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end shadow">
                                <li>
                                    <span class="dropdown-item-text text-muted small">
                                        <i class="bi bi-envelope me-1"></i>${sessionScope.user.email}
                                    </span>
                                </li>
                                <li><hr class="dropdown-divider"></li>
                                <c:if test="${sessionScope.user.roleid == 1}">
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/categories"><i class="bi bi-tags me-2"></i>Quản lý Categories</a></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/users"><i class="bi bi-people me-2"></i>Quản lý Users</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                </c:if>
                                <li>
                                    <a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout">
                                        <i class="bi bi-box-arrow-right me-2"></i>Đăng xuất
                                    </a>
                                </li>
                            </ul>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/login">
                                <i class="bi bi-box-arrow-in-right me-1"></i>Đăng nhập
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="btn btn-outline-light btn-sm ms-2" href="${pageContext.request.contextPath}/register">
                                <i class="bi bi-person-plus me-1"></i>Đăng ký
                            </a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>
