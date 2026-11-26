package vn.iotstar.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import vn.iotstar.entity.User;
import vn.iotstar.service.UserService;
import vn.iotstar.utils.PasswordUtil;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.Date;
import java.util.Optional;

@Controller
@RequestMapping("/admin/users")
public class AdminUserController {

    @Autowired
    private UserService userService;

    @Value("${app.upload.dir:src/main/webapp/uploads/}")
    private String uploadDir;

    // =========================================================================
    // 1. DANH SÁCH + TÌM KIẾM + PHÂN TRANG (PAGINATION & SEARCH)
    // =========================================================================

    @GetMapping({"", "/", "/searchpaginated"})
    public String listUsers(
            @RequestParam(name = "keyword", required = false, defaultValue = "") String keyword,
            @RequestParam(name = "page", required = false, defaultValue = "1") int page,
            @RequestParam(name = "size", required = false, defaultValue = "5") int size,
            @RequestParam(name = "sort", required = false, defaultValue = "id,desc") String sort,
            Model model) {

        String[] sortParams = sort.split(",");
        String sortField = sortParams[0];
        Sort.Direction direction = (sortParams.length > 1 && sortParams[1].equalsIgnoreCase("asc"))
                ? Sort.Direction.ASC : Sort.Direction.DESC;

        int pageIndex = Math.max(0, page - 1);
        Pageable pageable = PageRequest.of(pageIndex, size, Sort.by(direction, sortField));

        Page<User> userPage = userService.searchPaginated(keyword, pageable);

        model.addAttribute("userPage", userPage);
        model.addAttribute("users", userPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", Math.max(1, userPage.getTotalPages()));
        model.addAttribute("totalItems", userPage.getTotalElements());
        model.addAttribute("keyword", keyword);
        model.addAttribute("pageSize", size);
        model.addAttribute("sort", sort);

        return "admin/user-list";
    }

    // =========================================================================
    // 2. THÊM MỚI NGƯỜI DÙNG (CREATE)
    // =========================================================================

    @GetMapping("/add")
    public String showAddForm(Model model) {
        User user = new User();
        user.setRoleid(5); // Default user thường
        user.setStatus(1); // Default hoạt động
        model.addAttribute("user", user);
        model.addAttribute("isEdit", false);
        return "admin/user-form";
    }

    // =========================================================================
    // 3. CHỈNH SỬA NGƯỜI DÙNG (EDIT)
    // =========================================================================

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable("id") int id, Model model, RedirectAttributes ra) {
        Optional<User> opt = userService.findById(id);
        if (opt.isEmpty()) {
            ra.addFlashAttribute("errorMessage", "Không tìm thấy người dùng ID: " + id);
            return "redirect:/admin/users";
        }
        model.addAttribute("user", opt.get());
        model.addAttribute("isEdit", true);
        return "admin/user-form";
    }

    // =========================================================================
    // 4. LƯU (THÊM MỚI HOẶC CẬP NHẬT)
    // =========================================================================

    @PostMapping("/save")
    public String saveUser(
            @ModelAttribute("user") User user,
            @RequestParam(value = "avatarFile", required = false) MultipartFile avatarFile,
            @RequestParam(value = "rawPassword", required = false) String rawPassword,
            RedirectAttributes ra) {

        try {
            boolean isNew = (user.getId() == 0);

            // Kiểm tra trùng username / email khi thêm mới
            if (isNew) {
                if (userService.existsByUsername(user.getUsername())) {
                    ra.addFlashAttribute("errorMessage", "Tên đăng nhập '" + user.getUsername() + "' đã tồn tại!");
                    return "redirect:/admin/users/add";
                }
                if (user.getEmail() != null && !user.getEmail().isEmpty() && userService.existsByEmail(user.getEmail())) {
                    ra.addFlashAttribute("errorMessage", "Email '" + user.getEmail() + "' đã được sử dụng!");
                    return "redirect:/admin/users/add";
                }
                // Mã hóa password
                if (rawPassword != null && !rawPassword.trim().isEmpty()) {
                    user.setPassword(PasswordUtil.hashPassword(rawPassword.trim()));
                } else {
                    user.setPassword(PasswordUtil.hashPassword("123456")); // Mật khẩu mặc định
                }
                user.setCreatedDate(new Date(System.currentTimeMillis()));
            } else {
                // Cập nhật người dùng cũ
                Optional<User> existingOpt = userService.findById(user.getId());
                if (existingOpt.isPresent()) {
                    User existing = existingOpt.get();
                    // Giữ lại mật khẩu cũ nếu không nhập mật khẩu mới
                    if (rawPassword != null && !rawPassword.trim().isEmpty()) {
                        user.setPassword(PasswordUtil.hashPassword(rawPassword.trim()));
                    } else {
                        user.setPassword(existing.getPassword());
                    }
                    if (user.getCreatedDate() == null) {
                        user.setCreatedDate(existing.getCreatedDate());
                    }
                    if (user.getAvatar() == null || user.getAvatar().isEmpty()) {
                        user.setAvatar(existing.getAvatar());
                    }
                }
            }

            // Xử lý upload avatar
            if (avatarFile != null && !avatarFile.isEmpty()) {
                String originalFilename = avatarFile.getOriginalFilename();
                String ext = (originalFilename != null && originalFilename.contains("."))
                        ? originalFilename.substring(originalFilename.lastIndexOf(".")) : ".jpg";
                String filename = "user_" + System.currentTimeMillis() + ext;

                File dir = new File(uploadDir + "users/");
                if (!dir.exists()) {
                    dir.mkdirs();
                }

                Path filePath = Paths.get(dir.getAbsolutePath(), filename);
                Files.copy(avatarFile.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);
                user.setAvatar("/uploads/users/" + filename);
            }

            userService.save(user);

            ra.addFlashAttribute("successMessage",
                    isNew ? "Thêm mới tài khoản thành công!" : "Cập nhật tài khoản thành công!");
        } catch (IOException e) {
            ra.addFlashAttribute("errorMessage", "Lỗi tải ảnh đại diện: " + e.getMessage());
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Lỗi lưu tài khoản: " + e.getMessage());
        }

        return "redirect:/admin/users";
    }

    // =========================================================================
    // 5. XÓA NGƯỜI DÙNG (DELETE)
    // =========================================================================

    @GetMapping("/delete/{id}")
    public String deleteUser(@PathVariable("id") int id, HttpSession session, RedirectAttributes ra) {
        try {
            User currentUser = (session != null) ? (User) session.getAttribute("user") : null;
            if (currentUser != null && currentUser.getId() == id) {
                ra.addFlashAttribute("errorMessage", "Không thể xóa chính tài khoản Admin bạn đang đăng nhập!");
                return "redirect:/admin/users";
            }

            Optional<User> opt = userService.findById(id);
            if (opt.isPresent()) {
                userService.deleteById(id);
                ra.addFlashAttribute("successMessage", "Đã xóa thành công tài khoản ID: " + id);
            } else {
                ra.addFlashAttribute("errorMessage", "Không tìm thấy tài khoản người dùng!");
            }
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Không thể xóa người dùng: " + e.getMessage());
        }
        return "redirect:/admin/users";
    }
}
