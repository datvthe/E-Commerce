# WEBGMS Database Diagram
## Digital Goods Marketplace Database Schema

```mermaid
erDiagram
    users {
        bigint user_id PK
        varchar username
        varchar email
        varchar password
        varchar full_name
        varchar phone
        varchar address
        enum role
        boolean is_active
        timestamp created_at
        timestamp updated_at
    }

    product_categories {
        int category_id PK
        varchar name
        varchar slug
        text description
        int parent_id FK
        boolean is_active
        boolean is_digital
        varchar icon
        timestamp created_at
        timestamp updated_at
    }

    products {
        bigint product_id PK
        bigint seller_id FK
        varchar name
        varchar slug
        text description
        decimal price
        varchar currency
        int category_id FK
        boolean is_digital
        enum delivery_type
        varchar delivery_time
        int warranty_days
        enum status
        decimal average_rating
        int total_reviews
        timestamp created_at
        timestamp updated_at
    }

    product_images {
        int image_id PK
        bigint product_id FK
        varchar url
        varchar alt_text
        boolean is_primary
        timestamp created_at
    }

    digital_goods_codes {
        int code_id PK
        bigint product_id FK
        text code_value
        enum code_type
        boolean is_used
        bigint used_by FK
        timestamp used_at
        timestamp expires_at
        timestamp created_at
        timestamp updated_at
    }

    digital_goods_files {
        int file_id PK
        bigint product_id FK
        varchar file_name
        varchar file_path
        bigint file_size
        varchar file_type
        int download_count
        int max_downloads
        timestamp created_at
    }

    inventory {
        int inventory_id PK
        bigint product_id FK
        bigint seller_id FK
        int quantity
        int reserved_quantity
        int min_threshold
        timestamp updated_at
    }

    orders {
        int order_id PK
        bigint user_id FK
        varchar order_number
        decimal total_amount
        varchar currency
        enum status
        varchar payment_method
        varchar payment_reference
        enum delivery_status
        varchar delivery_method
        text notes
        timestamp created_at
        timestamp updated_at
    }

    order_items {
        int item_id PK
        int order_id FK
        bigint product_id FK
        int quantity
        decimal unit_price
        decimal total_price
        int digital_code_id FK
        enum delivery_status
        timestamp delivered_at
        timestamp created_at
    }

    wishlist {
        int wishlist_id PK
        bigint user_id FK
        bigint product_id FK
        timestamp added_at
    }

    reviews {
        int review_id PK
        bigint user_id FK
        bigint product_id FK
        int rating
        text comment
        enum status
        timestamp created_at
        timestamp updated_at
    }

    password_reset_tokens {
        int token_id PK
        bigint user_id FK
        varchar token
        timestamp expires_at
        boolean is_used
        timestamp created_at
    }

    %% Relationships
    users ||--o{ products : "sells"
    users ||--o{ orders : "places"
    users ||--o{ wishlist : "has"
    users ||--o{ reviews : "writes"
    users ||--o{ password_reset_tokens : "has"

    product_categories ||--o{ products : "categorizes"
    product_categories ||--o{ product_categories : "parent_of"

    products ||--o{ product_images : "has"
    products ||--o{ digital_goods_codes : "contains"
    products ||--o{ digital_goods_files : "has"
    products ||--o{ inventory : "tracked_in"
    products ||--o{ order_items : "ordered_as"
    products ||--o{ wishlist : "added_to"
    products ||--o{ reviews : "reviewed_in"

    orders ||--o{ order_items : "contains"

    digital_goods_codes ||--o{ order_items : "delivered_as"
    digital_goods_codes }o--|| users : "used_by"

    %% Digital Goods Flow
    products ||--o{ digital_goods_codes : "digital_codes"
    products ||--o{ digital_goods_files : "downloadable_files"
    order_items ||--o{ digital_goods_codes : "delivers_code"
```

## Key Features:

### 🛒 **Digital Goods Marketplace**
- **Multi-vendor support**: Users can be sellers
- **Digital product categories**: Thẻ cào, Tài khoản Game, Phần mềm, etc.
- **Digital delivery**: Instant delivery of codes/files
- **Inventory management**: Track digital stock

### 💳 **Order Management**
- **Order tracking**: From pending to delivered
- **Digital delivery**: Automatic code/file delivery
- **Payment integration**: Multiple payment methods
- **Order history**: Complete transaction records

### 🔐 **Digital Codes System**
- **Code types**: Serial, Account, License, Gift Card, File URL
- **Usage tracking**: Track which codes are used
- **Expiration**: Set expiry dates for codes
- **Security**: Prevent code reuse

### 📁 **File Management**
- **Downloadable files**: Store and serve digital files
- **Download limits**: Control download counts
- **File types**: Support various file formats
- **Size tracking**: Monitor file sizes

### ⭐ **User Experience**
- **Wishlist**: Save favorite products
- **Reviews**: Rate and review products
- **Search**: Find products easily
- **Categories**: Organized product browsing

### 🔒 **Security & Access**
- **Role-based access**: Admin, Seller, User roles
- **Password reset**: Secure token-based reset
- **User management**: Complete user lifecycle
- **Data integrity**: Foreign key constraints

## Database Statistics:
- **Tables**: 12 main tables
- **Relationships**: 20+ foreign key relationships
- **Indexes**: Optimized for performance
- **Digital Focus**: Built for digital goods marketplace
- **Scalable**: Supports multi-vendor operations

