/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.product;

import java.sql.Timestamp;

public class ProductCategories {

    private long category_id;
    private ProductCategories parent_id; // Danh mục cha (nếu null thì là danh mục gốc) 
    private String name;
    private String slug;
    private String description;
    private String status; // active / inactive
    private Timestamp created_at;
    private Timestamp updated_at;

    public ProductCategories() {
    }

    public ProductCategories(long category_id, ProductCategories parent_id, String name, String slug, String description, String status, Timestamp created_at, Timestamp updated_at) {
        this.category_id = category_id;
        this.parent_id = parent_id;
        this.name = name;
        this.slug = slug;
        this.description = description;
        this.status = status;
        this.created_at = created_at;
        this.updated_at = updated_at;
    }

    public long getCategory_id() {
        return category_id;
    }

    public void setCategory_id(long category_id) {
        this.category_id = category_id;
    }

    public ProductCategories getParent_id() {
        return parent_id;
    }

    public void setParent_id(ProductCategories parent_id) {
        this.parent_id = parent_id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSlug() {
        return slug;
    }

    public void setSlug(String slug) {
        this.slug = slug;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreated_at() {
        return created_at;
    }

    public void setCreated_at(Timestamp created_at) {
        this.created_at = created_at;
    }

    public Timestamp getUpdated_at() {
        return updated_at;
    }

    public void setUpdated_at(Timestamp updated_at) {
        this.updated_at = updated_at;
    }

    @Override
    public String toString() {
        return "ProductCategories{" + "category_id=" + category_id + ", parent_id=" + parent_id + ", name=" + name + ", slug=" + slug + ", description=" + description + ", status=" + status + ", created_at=" + created_at + ", updated_at=" + updated_at + '}';
    }

}
