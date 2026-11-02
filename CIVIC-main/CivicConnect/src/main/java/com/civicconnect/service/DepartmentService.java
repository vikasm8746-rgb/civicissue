package com.civicconnect.service;

import com.civicconnect.dao.CategoryDAO;
import com.civicconnect.dao.DepartmentDAO;
import com.civicconnect.model.Category;
import com.civicconnect.model.Department;

import java.util.List;

/**
 * Service managing municipal departments and complaint categories.
 */
public class DepartmentService {

    private final DepartmentDAO departmentDAO;
    private final CategoryDAO categoryDAO;

    public DepartmentService() {
        this.departmentDAO = new DepartmentDAO();
        this.categoryDAO = new CategoryDAO();
    }

    public List<Department> getAllDepartments() {
        return departmentDAO.getAllDepartments();
    }

    public List<Department> getActiveDepartments() {
        return departmentDAO.getActiveDepartments();
    }

    public Department getDepartmentById(int id) {
        return departmentDAO.getDepartmentById(id);
    }

    public boolean addDepartment(Department dept) {
        return departmentDAO.addDepartment(dept);
    }

    public boolean updateDepartment(Department dept) {
        return departmentDAO.updateDepartment(dept);
    }

    public boolean deleteDepartment(int id) {
        return departmentDAO.deleteDepartment(id);
    }

    public List<Category> getAllCategories() {
        return categoryDAO.getAllCategories();
    }

    public List<Category> getActiveCategories() {
        return categoryDAO.getActiveCategories();
    }

    public List<Category> getCategoriesByDepartment(int departmentId) {
        return categoryDAO.getCategoriesByDepartment(departmentId);
    }

    public Category getCategoryById(int id) {
        return categoryDAO.getCategoryById(id);
    }

    public boolean addCategory(Category category) {
        return categoryDAO.addCategory(category);
    }

    public boolean updateCategory(Category category) {
        return categoryDAO.updateCategory(category);
    }

    public boolean deleteCategory(int id) {
        return categoryDAO.deleteCategory(id);
    }
}
