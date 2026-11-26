package vn.iotstar.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import vn.iotstar.entity.User;
import vn.iotstar.service.CategoryService;
import vn.iotstar.service.UserService;

@Controller
public class HomeController {

    @Autowired
    private CategoryService categoryService;

    @Autowired
    private UserService userService;

    @GetMapping({"/", "/home"})
    public String home(HttpSession session, Model model) {
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;
        model.addAttribute("currentUser", currentUser);
        model.addAttribute("categories", categoryService.findAll());
        model.addAttribute("totalCategories", categoryService.count());
        model.addAttribute("totalUsers", userService.count());
        return "home";
    }
}
