package vn.iotstar.controller;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import vn.iotstar.entity.User;
import vn.iotstar.service.UserService;

@Controller
public class AuthController {

    @Autowired
    private UserService userService;

    // =========================================================================
    // 1. CHỨC NĂNG ĐĂNG NHẬP (LOGIN)
    // =========================================================================

    @GetMapping("/login")
    public String showLoginForm(@RequestParam(value = "error", required = false) String error,
                                @RequestParam(value = "registered", required = false) String registered,
                                @RequestParam(value = "logout", required = false) String logout,
                                HttpSession session,
                                Model model,
                                HttpServletRequest request) {
        // Nếu đã đăng nhập, tự động chuyển trang tương ứng với Role
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;
        if (currentUser != null) {
            return currentUser.getRoleid() == 1 ? "redirect:/admin/categories" : "redirect:/home";
        }

        if ("notlogin".equals(error)) {
            model.addAttribute("errorMessage", "Vui lòng đăng nhập để truy cập trang quản trị!");
        } else if ("unauthorized".equals(error)) {
            model.addAttribute("errorMessage", "Bạn không có quyền quản trị để truy cập trang này!");
        } else if (registered != null) {
            model.addAttribute("successMessage", "Đăng ký tài khoản thành công! Vui lòng đăng nhập.");
        } else if (logout != null) {
            model.addAttribute("successMessage", "Đã đăng xuất tài khoản thành công!");
        }

        // Đọc cookie nhớ tài khoản nếu có
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                if ("rememberUser".equals(c.getName())) {
                    model.addAttribute("savedUsername", c.getValue());
                    model.addAttribute("isRemembered", true);
                }
            }
        }

        return "login";
    }

    @PostMapping("/login")
    public String processLogin(@RequestParam("username") String username,
                               @RequestParam("password") String password,
                               @RequestParam(value = "remember", required = false) String remember,
                               HttpSession session,
                               HttpServletResponse response,
                               Model model) {
        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            model.addAttribute("errorMessage", "Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu!");
            model.addAttribute("username", username);
            return "login";
        }

        User user = userService.login(username.trim(), password);
        if (user == null) {
            model.addAttribute("errorMessage", "Tên đăng nhập hoặc mật khẩu không chính xác!");
            model.addAttribute("username", username);
            return "login";
        }

        if (user.getStatus() != 1) {
            model.addAttribute("errorMessage", "Tài khoản của bạn đã bị khóa hoặc chưa kích hoạt. Vui lòng liên hệ Admin!");
            model.addAttribute("username", username);
            return "login";
        }

        // Lưu thông tin người dùng vào Session
        session.setAttribute("user", user);
        session.setAttribute("username", user.getUsername());
        session.setAttribute("fullname", user.getFullname());
        session.setAttribute("roleid", user.getRoleid());

        // Xử lý Ghi nhớ đăng nhập (Remember me) qua Cookie
        if (remember != null) {
            Cookie cookie = new Cookie("rememberUser", user.getUsername());
            cookie.setMaxAge(7 * 24 * 60 * 60); // 7 ngày
            cookie.setPath("/");
            response.addCookie(cookie);
        } else {
            Cookie cookie = new Cookie("rememberUser", "");
            cookie.setMaxAge(0);
            cookie.setPath("/");
            response.addCookie(cookie);
        }

        // Phân quyền điều hướng
        if (user.getRoleid() == 1) {
            return "redirect:/admin/categories";
        } else {
            return "redirect:/home";
        }
    }

    // =========================================================================
    // 2. CHỨC NĂNG ĐĂNG KÝ TÀI KHOẢN (REGISTER)
    // =========================================================================

    @GetMapping("/register")
    public String showRegisterForm(HttpSession session, Model model) {
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;
        if (currentUser != null) {
            return currentUser.getRoleid() == 1 ? "redirect:/admin/categories" : "redirect:/home";
        }
        return "register";
    }

    @PostMapping("/register")
    public String processRegister(@RequestParam("username") String username,
                                  @RequestParam("fullname") String fullname,
                                  @RequestParam("email") String email,
                                  @RequestParam(value = "phone", required = false) String phone,
                                  @RequestParam("password") String password,
                                  @RequestParam("repassword") String repassword,
                                  Model model) {
        // Giữ lại dữ liệu nhập form
        model.addAttribute("username", username);
        model.addAttribute("fullname", fullname);
        model.addAttribute("email", email);
        model.addAttribute("phone", phone);

        // Kiểm tra dữ liệu bắt buộc
        if (username == null || username.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            model.addAttribute("errorMessage", "Vui lòng điền đầy đủ các thông tin bắt buộc!");
            return "register";
        }

        if (password.length() < 6) {
            model.addAttribute("errorMessage", "Mật khẩu phải có độ dài tối thiểu 6 ký tự!");
            return "register";
        }

        if (!password.equals(repassword)) {
            model.addAttribute("errorMessage", "Xác nhận mật khẩu không khớp. Vui lòng nhập lại!");
            return "register";
        }

        if (userService.existsByUsername(username.trim())) {
            model.addAttribute("errorMessage", "Tên đăng nhập '" + username.trim() + "' đã được sử dụng!");
            return "register";
        }

        if (userService.existsByEmail(email.trim())) {
            model.addAttribute("errorMessage", "Email '" + email.trim() + "' đã được đăng ký tài khoản khác!");
            return "register";
        }

        // Tạo User mới và lưu vào CSDL
        User newUser = new User();
        newUser.setUsername(username.trim());
        newUser.setFullname(fullname != null ? fullname.trim() : "");
        newUser.setEmail(email.trim());
        newUser.setPhone(phone != null ? phone.trim() : "");
        newUser.setPassword(password); // userService.register sẽ tự hash SHA-256
        newUser.setRoleid(5);          // User thường
        newUser.setStatus(1);          // Kích hoạt luôn
        newUser.setCreatedDate(new java.sql.Date(System.currentTimeMillis()));

        userService.register(newUser);

        return "redirect:/login?registered=true";
    }

    // =========================================================================
    // 3. CHỨC NĂNG ĐĂNG XUẤT (LOGOUT)
    // =========================================================================

    @GetMapping("/logout")
    public String processLogout(HttpSession session, HttpServletResponse response) {
        if (session != null) {
            session.removeAttribute("user");
            session.removeAttribute("username");
            session.removeAttribute("fullname");
            session.removeAttribute("roleid");
            session.invalidate();
        }

        return "redirect:/login?logout=true";
    }
}
