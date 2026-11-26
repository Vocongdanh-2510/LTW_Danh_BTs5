package vn.iotstar;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

@SpringBootApplication
public class Application extends SpringBootServletInitializer {

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder builder) {
        return builder.sources(Application.class);
    }

    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
        System.out.println("==================================================================");
        System.out.println(">>> ỨNG DỤNG SPRING BOOT BÀI TẬP 05 ĐÃ KHỞI CHẠY THÀNH CÔNG! <<<");
        System.out.println("👉 Trang chủ:               http://localhost:8080/");
        System.out.println("👉 Đăng nhập:               http://localhost:8080/login");
        System.out.println("👉 Đăng ký:                 http://localhost:8080/register");
        System.out.println("👉 Quản lý Category (Admin): http://localhost:8080/admin/categories");
        System.out.println("👉 Quản lý User (Admin):     http://localhost:8080/admin/users");
        System.out.println("==================================================================");
    }
}
