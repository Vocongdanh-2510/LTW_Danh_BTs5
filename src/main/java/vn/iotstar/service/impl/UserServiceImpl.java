package vn.iotstar.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import vn.iotstar.entity.User;
import vn.iotstar.repository.UserRepository;
import vn.iotstar.service.UserService;
import vn.iotstar.utils.PasswordUtil;

import java.sql.Date;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class UserServiceImpl implements UserService {

    @Autowired
    private UserRepository userRepository;

    @Override
    public List<User> findAll() {
        return userRepository.findAll();
    }

    @Override
    public Page<User> findAll(Pageable pageable) {
        return userRepository.findAll(pageable);
    }

    @Override
    public Page<User> searchPaginated(String keyword, Pageable pageable) {
        if (keyword != null && !keyword.trim().isEmpty()) {
            String kw = keyword.trim();
            return userRepository.findByUsernameContainingIgnoreCaseOrFullnameContainingIgnoreCaseOrEmailContainingIgnoreCase(
                    kw, kw, kw, pageable);
        }
        return userRepository.findAll(pageable);
    }

    @Override
    public Optional<User> findById(int id) {
        return userRepository.findById(id);
    }

    @Override
    public User save(User user) {
        return userRepository.save(user);
    }

    @Override
    public void deleteById(int id) {
        userRepository.deleteById(id);
    }

    @Override
    public Optional<User> findByUsername(String username) {
        return userRepository.findByUsername(username);
    }

    @Override
    public Optional<User> findByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    @Override
    public boolean existsByUsername(String username) {
        return userRepository.existsByUsername(username);
    }

    @Override
    public boolean existsByEmail(String email) {
        return userRepository.existsByEmail(email);
    }

    @Override
    public User login(String usernameOrEmail, String password) {
        if (usernameOrEmail == null || password == null) {
            return null;
        }
        String account = usernameOrEmail.trim();
        Optional<User> userOpt = userRepository.findByUsername(account);
        if (userOpt.isEmpty()) {
            userOpt = userRepository.findByEmail(account);
        }

        if (userOpt.isPresent()) {
            User user = userOpt.get();
            if (PasswordUtil.checkPassword(password, user.getPassword())) {
                return user;
            }
        }
        return null;
    }

    @Override
    public User register(User user) {
        if (user.getPassword() != null && !user.getPassword().isEmpty()) {
            user.setPassword(PasswordUtil.hashPassword(user.getPassword()));
        }
        if (user.getRoleid() <= 0) {
            user.setRoleid(5); // Default user role
        }
        if (user.getCreatedDate() == null) {
            user.setCreatedDate(new Date(System.currentTimeMillis()));
        }
        user.setStatus(1); // Mặc định kích hoạt
        return userRepository.save(user);
    }

    @Override
    public long count() {
        return userRepository.count();
    }
}
