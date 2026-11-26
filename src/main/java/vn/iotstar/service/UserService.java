package vn.iotstar.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import vn.iotstar.entity.User;

import java.util.List;
import java.util.Optional;

public interface UserService {

    List<User> findAll();

    Page<User> findAll(Pageable pageable);

    Page<User> searchPaginated(String keyword, Pageable pageable);

    Optional<User> findById(int id);

    User save(User user);

    void deleteById(int id);

    Optional<User> findByUsername(String username);

    Optional<User> findByEmail(String email);

    boolean existsByUsername(String username);

    boolean existsByEmail(String email);

    User login(String usernameOrEmail, String password);

    User register(User user);

    long count();
}
