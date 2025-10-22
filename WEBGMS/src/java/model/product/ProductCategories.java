package model.product;

public class ProductCategories {
    private int category_id;
    private String name;
    private String description;
    private String slug;

    public ProductCategories() {}

    public int getCategory_id() {
        return category_id;
    }

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

    @Override
    public String toString() {
        return "ProductCategories{" +
                "category_id=" + category_id +
                ", name='" + name + '\'' +
                '}';
    }
}
