# Add Gson Dependency

## Critical Fix Required

The project uses Gson library for JSON processing but the dependency is missing. This will cause `ClassNotFoundException` errors.

## Solution

### Option 1: Download JAR file (Recommended)
1. Download `gson-2.10.1.jar` from: https://mvnrepository.com/artifact/com.google.code.gson/gson/2.10.1
2. Place the JAR file in: `web/WEB-INF/lib/gson-2.10.1.jar`
3. The project will automatically include it in the classpath

### Option 2: Using Maven (if converting to Maven project)
Add this to your `pom.xml`:
```xml
<dependency>
    <groupId>com.google.code.gson</groupId>
    <artifactId>gson</artifactId>
    <version>2.10.1</version>
</dependency>
```

### Option 3: Using Gradle (if converting to Gradle project)
Add this to your `build.gradle`:
```gradle
implementation 'com.google.code.gson:gson:2.10.1'
```

## Files That Use Gson
- `CartController.java` - JSON responses for cart operations
- `WishlistController.java` - JSON responses for wishlist operations  
- `ReviewController.java` - JSON responses for review operations

## Verification
After adding the dependency, the following should work:
- Add to cart functionality
- Wishlist toggle functionality
- Review submission
- All AJAX responses will return proper JSON

## Error Without Gson
```
java.lang.ClassNotFoundException: com.google.gson.Gson
    at java.base/jdk.internal.loader.BuiltinClassLoader.loadClass(BuiltinClassLoader.java:641)
    at java.base/jdk.internal.loader.ClassLoaders$AppClassLoader.loadClass(ClassLoaders.java:188)
    at java.base/jdk.internal.loader.ClassLoaders$PlatformClassLoader.loadClass(ClassLoaders.java:519)
```
