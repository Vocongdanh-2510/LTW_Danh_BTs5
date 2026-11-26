package vn.iotstar.entity;

import java.io.Serializable;
import java.sql.Date;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;

@Entity
@Table(name = "users")
public class User implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private int id;

    @Column(name = "email", columnDefinition = "NVARCHAR(100) NULL")
    private String email;

    @NotBlank(message = "Tên đăng nhập không được để trống")
    @Column(name = "username", columnDefinition = "NVARCHAR(50) NOT NULL", unique = true)
    private String username;

    @Column(name = "fullname", columnDefinition = "NVARCHAR(100) NULL")
    private String fullname;

    @Column(name = "password", columnDefinition = "NVARCHAR(255) NOT NULL")
    private String password;

    @Column(name = "avatar", columnDefinition = "NVARCHAR(255) NULL")
    private String avatar;

    @Column(name = "roleid")
    private int roleid = 5; // 1: Admin, 2: Manager, 5: User thường

    @Column(name = "phone", columnDefinition = "NVARCHAR(20) NULL")
    private String phone;

    @Column(name = "createdDate")
    private Date createdDate;

    @Column(name = "status")
    private int status = 1; // 1: Đã kích hoạt/Hoạt động, 0: Bị khóa/Chưa kích hoạt

    @Column(name = "code", columnDefinition = "NVARCHAR(50) NULL")
    private String code;

    public User() {
    }

    public User(String email, String username, String fullname, String password,
                String avatar, int roleid, String phone, Date createdDate) {
        this.email = email;
        this.username = username;
        this.fullname = fullname;
        this.password = password;
        this.avatar = avatar;
        this.roleid = roleid;
        this.phone = phone;
        this.createdDate = createdDate;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getFullname() {
        return fullname;
    }

    public void setFullname(String fullname) {
        this.fullname = fullname;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public int getRoleid() {
        return roleid;
    }

    public void setRoleid(int roleid) {
        this.roleid = roleid;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public boolean isAdmin() {
        return this.roleid == 1;
    }
}
