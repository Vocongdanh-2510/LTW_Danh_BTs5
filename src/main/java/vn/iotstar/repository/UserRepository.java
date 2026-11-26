package vn.iotstar.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import vn.iotstar.entity.User;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Integer> {

    Optional<User> findByUsername(String username);

    Optional<User> findByEmail(String email);

    boolean existsByUsername(String username);

    boolean existsByEmail(String email);

    // Tìm kiếm theo username hoặc fullname có phân trang
    Page<User> findByUsernameContainingIgnoreCaseOrFullnameContainingIgnoreCase(String username, String fullname, Pageable pageable);

    // Tìm kiếm tổng quát theo keyword (username, fullname, email)
    Page<User> findByUsernameContainingIgnoreCaseOrFullnameContainingIgnoreCaseOrEmailContainingIgnoreCase(
            String username, String fullname, String email, Pageable pageable);
}
