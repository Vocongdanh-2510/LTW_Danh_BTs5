package vn.iotstar.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import vn.iotstar.entity.Category;

import java.util.List;
import java.util.Optional;

@Repository
public interface CategoryRepository extends JpaRepository<Category, Integer> {

    // Tìm kiếm theo tên có phân trang
    Page<Category> findByCategorynameContainingIgnoreCase(String categoryname, Pageable pageable);

    // Tìm kiếm theo tên trả về danh sách
    List<Category> findByCategorynameContainingIgnoreCase(String categoryname);

    Optional<Category> findByCategoryname(String categoryname);
}
