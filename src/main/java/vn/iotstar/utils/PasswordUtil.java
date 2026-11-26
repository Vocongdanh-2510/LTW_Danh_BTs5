package vn.iotstar.utils;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * Tiện ích băm mật khẩu SHA-256 và kiểm tra mật khẩu.
 * Hỗ trợ băm mật khẩu bảo mật và tương thích ngược với dữ liệu cũ.
 */
public class PasswordUtil {

    public static String hashPassword(String password) {
        if (password == null) {
            return null;
        }
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashBytes = md.digest(password.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : hashBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Lỗi: Không tìm thấy thuật toán SHA-256", e);
        }
    }

    public static boolean checkPassword(String plainPassword, String storedPassword) {
        if (plainPassword == null || storedPassword == null) {
            return false;
        }
        // Kiểm tra khớp mã băm SHA-256
        String hashedInput = hashPassword(plainPassword);
        if (hashedInput.equalsIgnoreCase(storedPassword)) {
            return true;
        }
        // Tương thích ngược với mật khẩu dạng plain-text
        return plainPassword.equals(storedPassword);
    }
}
