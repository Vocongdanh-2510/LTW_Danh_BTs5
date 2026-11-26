package vn.iotstar.interceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import vn.iotstar.entity.User;

@Component
public class AdminInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            // Chưa đăng nhập -> chuyển về trang login
            response.sendRedirect(request.getContextPath() + "/login?error=notlogin");
            return false;
        }

        if (user.getRoleid() != 1) {
            // Không phải Admin (roleid = 1) -> từ chối truy cập
            response.sendRedirect(request.getContextPath() + "/login?error=unauthorized");
            return false;
        }

        return true;
    }
}
