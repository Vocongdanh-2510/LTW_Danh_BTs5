package vn.iotstar.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import vn.iotstar.entity.Category;

import java.util.List;
import java.util.Optional;

public interface CategoryService {

    List<Category> findAll();

    Page<Category> findAll(Pageable pageable);

    Page<Category> searchPaginated(String keyword, Pageable pageable);

    Optional<Category> findById(int id);

    Category save(Category category);

    void deleteById(int id);

    long count();
}
