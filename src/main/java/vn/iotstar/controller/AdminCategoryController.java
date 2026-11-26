package vn.iotstar.controller;

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
import vn.iotstar.entity.Category;
import vn.iotstar.service.CategoryService;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Optional;

@Controller
@RequestMapping("/admin/categories")
public class AdminCategoryController {

    @Autowired
    private CategoryService categoryService;

    @Value("${app.upload.dir:src/main/webapp/uploads/}")
    private String uploadDir;

    // =========================================================================
    // 1. DANH SÁCH + TÌM KIẾM + PHÂN TRANG (PAGINATION & SEARCH)
    // =========================================================================

    @GetMapping({"", "/", "/searchpaginated"})
    public String listCategories(
            @RequestParam(name = "keyword", required = false, defaultValue = "") String keyword,
            @RequestParam(name = "page", required = false, defaultValue = "1") int page,
            @RequestParam(name = "size", required = false, defaultValue = "5") int size,
            @RequestParam(name = "sort", required = false, defaultValue = "categoryId,desc") String sort,
            Model model) {

        // Xử lý Sort
        String[] sortParams = sort.split(",");
        String sortField = sortParams[0];
        Sort.Direction direction = (sortParams.length > 1 && sortParams[1].equalsIgnoreCase("asc"))
                ? Sort.Direction.ASC : Sort.Direction.DESC;

        // Spring Data JPA page index tính từ 0
        int pageIndex = Math.max(0, page - 1);
        Pageable pageable = PageRequest.of(pageIndex, size, Sort.by(direction, sortField));

        Page<Category> categoryPage = categoryService.searchPaginated(keyword, pageable);

        model.addAttribute("categoryPage", categoryPage);
        model.addAttribute("categories", categoryPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", Math.max(1, categoryPage.getTotalPages()));
        model.addAttribute("totalItems", categoryPage.getTotalElements());
        model.addAttribute("keyword", keyword);
        model.addAttribute("pageSize", size);
        model.addAttribute("sort", sort);

        return "admin/category-list";
    }

    // =========================================================================
    // 2. THÊM MỚI DANH MỤC (CREATE)
    // =========================================================================

    @GetMapping("/add")
    public String showAddForm(Model model) {
        Category category = new Category();
        category.setStatus(1); // Mặc định hoạt động
        model.addAttribute("category", category);
        model.addAttribute("isEdit", false);
        return "admin/category-form";
    }

    // =========================================================================
    // 3. CHỈNH SỬA DANH MỤC (EDIT)
    // =========================================================================

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable("id") int id, Model model, RedirectAttributes ra) {
        Optional<Category> opt = categoryService.findById(id);
        if (opt.isEmpty()) {
            ra.addFlashAttribute("errorMessage", "Không tìm thấy danh mục ID: " + id);
            return "redirect:/admin/categories";
        }
        model.addAttribute("category", opt.get());
        model.addAttribute("isEdit", true);
        return "admin/category-form";
    }

    // =========================================================================
    // 4. LƯU (THÊM MỚI HOẶC CẬP NHẬT)
    // =========================================================================

    @PostMapping("/save")
    public String saveCategory(
            @ModelAttribute("category") Category category,
            @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
            @RequestParam(value = "imageUrl", required = false) String imageUrl,
            RedirectAttributes ra) {

        try {
            // Xử lý file ảnh upload nếu người dùng tải file lên
            if (imageFile != null && !imageFile.isEmpty()) {
                String originalFilename = imageFile.getOriginalFilename();
                String ext = (originalFilename != null && originalFilename.contains("."))
                        ? originalFilename.substring(originalFilename.lastIndexOf(".")) : ".jpg";
                String filename = "cate_" + System.currentTimeMillis() + ext;

                // Thư mục lưu ảnh
                File dir = new File(uploadDir + "categories/");
                if (!dir.exists()) {
                    dir.mkdirs();
                }

                Path filePath = Paths.get(dir.getAbsolutePath(), filename);
                Files.copy(imageFile.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

                // Đường dẫn URL tương đối để hiển thị trên web
                category.setImages("/uploads/categories/" + filename);
            } else if (imageUrl != null && !imageUrl.trim().isEmpty()) {
                // Người dùng nhập link ảnh trực tiếp
                category.setImages(imageUrl.trim());
            }

            boolean isNew = (category.getCategoryId() == 0);
            categoryService.save(category);

            ra.addFlashAttribute("successMessage",
                    isNew ? "Thêm mới danh mục thành công!" : "Cập nhật danh mục thành công!");
        } catch (IOException e) {
            ra.addFlashAttribute("errorMessage", "Lỗi lưu file ảnh: " + e.getMessage());
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Lỗi xử lý danh mục: " + e.getMessage());
        }

        return "redirect:/admin/categories";
    }

    // =========================================================================
    // 5. XÓA DANH MỤC (DELETE)
    // =========================================================================

    @GetMapping("/delete/{id}")
    public String deleteCategory(@PathVariable("id") int id, RedirectAttributes ra) {
        try {
            Optional<Category> opt = categoryService.findById(id);
            if (opt.isPresent()) {
                categoryService.deleteById(id);
                ra.addFlashAttribute("successMessage", "Đã xóa thành công danh mục ID: " + id);
            } else {
                ra.addFlashAttribute("errorMessage", "Không tìm thấy danh mục để xóa!");
            }
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage",
                    "Không thể xóa danh mục này vì đang có dữ liệu liên kết (Video/Sản phẩm): " + e.getMessage());
        }
        return "redirect:/admin/categories";
    }
}
