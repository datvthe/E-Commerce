package model.product;

import java.sql.Timestamp;

public class ProductCategories {
    private long category_id;
    private String name;
    private String description;
    private String slug;
    private String status;
    private Timestamp created_at;
    private Timestamp updated_at;

    public ProductCategories() {}

    public long getCategory_id() {
        return category_id;
    }

    public void setCategory_id(long category_id) {
        this.category_id = category_id;
    }

    // Backward-compatible setter accepting int
    public void setCategory_id(int category_id) {
        this.category_id = category_id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getSlug() {
        return slug;
    }

    public void setSlug(String slug) {
        this.slug = slug;
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
        return "ProductCategories{" +
                "category_id=" + category_id +
                ", name='" + name + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}
