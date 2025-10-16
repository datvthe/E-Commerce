# WEBGMS Project Structure Diagram
## Digital Goods Marketplace Architecture

```mermaid
graph TB
    subgraph "Frontend Layer"
        A[Homepage - home.jsp]
        B[Product List - products.jsp]
        C[Product Detail - product-detail.jsp]
        D[Login - login.jsp]
        E[Register - register.jsp]
        F[Forgot Password - forgot-password.jsp]
    end
    
    subgraph "Controller Layer"
        G[CommonHomeController]
        H[ProductDetailController]
        I[CommonLoginController]
        J[AdminDashboardController]
        K[RBACInitController]
    end
    
    subgraph "Service Layer"
        L[EmailService]
        M[RoleBasedAccessControl]
    end
    
    subgraph "DAO Layer"
        N[ProductDAO]
        O[UserDAO]
        P[RoleDAO]
        Q[OrderDAO]
    end
    
    subgraph "Model Layer"
        R[Products]
        S[Users]
        T[Categories]
        U[Orders]
        V[DigitalCodes]
    end
    
    subgraph "Database Layer"
        W[(MySQL Database)]
        X[users table]
        Y[products table]
        Z[product_categories table]
        AA[digital_goods_codes table]
        BB[orders table]
        CC[order_items table]
    end
    
    subgraph "External Services"
        DD[SMTP Email Service]
        EE[Payment Gateway]
        FF[File Storage]
    end
    
    %% Frontend to Controller
    A --> G
    B --> G
    C --> H
    D --> I
    E --> I
    F --> I
    
    %% Controller to Service
    G --> L
    H --> N
    I --> L
    J --> M
    K --> M
    
    %% Service to DAO
    L --> O
    M --> P
    N --> R
    O --> S
    P --> T
    Q --> U
    
    %% DAO to Model
    N --> R
    O --> S
    P --> T
    Q --> U
    
    %% Model to Database
    R --> Y
    S --> X
    T --> Z
    U --> BB
    V --> AA
    
    %% Database connections
    X --> W
    Y --> W
    Z --> W
    AA --> W
    BB --> W
    CC --> W
    
    %% External service connections
    L --> DD
    H --> EE
    H --> FF
    
    %% Styling
    classDef frontend fill:#e1f5fe
    classDef controller fill:#f3e5f5
    classDef service fill:#e8f5e8
    classDef dao fill:#fff3e0
    classDef model fill:#fce4ec
    classDef database fill:#f1f8e9
    classDef external fill:#e0f2f1
    
    class A,B,C,D,E,F frontend
    class G,H,I,J,K controller
    class L,M service
    class N,O,P,Q dao
    class R,S,T,U,V model
    class W,X,Y,Z,AA,BB,CC database
    class DD,EE,FF external
```

## Project Structure:

### 📁 **WEBGMS/**
```
WEBGMS/
├── src/java/
│   ├── controller/          # Controllers
│   │   ├── admin/          # Admin controllers
│   │   ├── common/         # Common controllers
│   │   └── user/           # User controllers
│   ├── dao/                # Data Access Objects
│   ├── model/              # Data Models
│   ├── service/            # Business Logic
│   └── filter/             # Security Filters
├── web/
│   ├── views/              # JSP Pages
│   │   ├── admin/          # Admin pages
│   │   ├── common/         # Common pages
│   │   ├── user/           # User pages
│   │   └── component/      # Reusable components
│   ├── assets/             # Static assets
│   └── WEB-INF/
│       ├── lib/            # JAR libraries
│       └── web.xml         # Web configuration
└── missing_tables.sql      # Database schema
```

### 🎨 **Frontend Components:**
- **Electro Bootstrap Template**: Modern UI framework
- **Responsive Design**: Mobile-friendly interface
- **Vietnamese Localization**: Full Vietnamese support
- **Digital Goods Focus**: Optimized for digital products

### 🔧 **Backend Architecture:**
- **MVC Pattern**: Model-View-Controller separation
- **DAO Pattern**: Data Access Object abstraction
- **Service Layer**: Business logic encapsulation
- **Filter Security**: Role-based access control

### 🗄️ **Database Design:**
- **Digital Goods Optimized**: Built for digital products
- **Multi-vendor Support**: Seller management
- **Order Management**: Complete transaction tracking
- **Code Management**: Digital code delivery system

### 🔐 **Security Features:**
- **Role-based Access**: Admin/Seller/User roles
- **Password Security**: Encrypted passwords
- **Token-based Reset**: Secure password recovery
- **Session Management**: User authentication

### 📧 **Email System:**
- **SMTP Integration**: Gmail SMTP service
- **Password Reset**: Token-based recovery
- **Order Notifications**: Transaction emails
- **User Communication**: System notifications

## Key Features:

### 🛒 **Digital Marketplace**
- **Product Categories**: Thẻ cào, Tài khoản, Phần mềm
- **Digital Delivery**: Instant code/file delivery
- **Multi-vendor**: Multiple sellers support
- **Inventory Management**: Stock tracking

### 💳 **Payment & Orders**
- **Order Processing**: Complete order lifecycle
- **Digital Delivery**: Automatic code delivery
- **Payment Integration**: Multiple payment methods
- **Order Tracking**: Status monitoring

### 👥 **User Management**
- **User Registration**: Account creation
- **Authentication**: Secure login system
- **Profile Management**: User information
- **Role Assignment**: Admin/Seller/User roles

### 🏪 **Seller Features**
- **Product Management**: Add/edit products
- **Inventory Control**: Stock management
- **Sales Tracking**: Revenue monitoring
- **Order Fulfillment**: Digital delivery

### 🔧 **Admin Features**
- **User Management**: Approve/disable users
- **Product Approval**: Review new products
- **System Monitoring**: Performance tracking
- **Reports**: Analytics and insights

