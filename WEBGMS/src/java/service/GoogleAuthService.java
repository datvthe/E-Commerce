package service;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import dao.DBConnection;
import dao.UsersDAO;
import model.user.Users;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

public class GoogleAuthService {
    
    // Google OAuth Configuration
    private static final String GOOGLE_CLIENT_ID = "737340987951-tm80i0fppt6a1ad4bh5jfla3dfsm5jrs.apps.googleusercontent.com";
    private static final String GOOGLE_CLIENT_SECRET = "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";
    private static final String GOOGLE_REDIRECT_URI = "http://localhost:9999/WEBGMS/auth/google/callback";
    private static final String GOOGLE_AUTH_URL = "https://accounts.google.com/o/oauth2/v2/auth";
    private static final String GOOGLE_TOKEN_URL = "https://oauth2.googleapis.com/token";
    private static final String GOOGLE_USER_INFO_URL = "https://www.googleapis.com/oauth2/v2/userinfo";
    
    private Gson gson = new Gson();
    private UsersDAO usersDAO = new UsersDAO();
    
    /**
     * Generate Google OAuth URL for authentication
     */
    public String getGoogleAuthUrl() {
        try {
            // Debug: Print redirect URI
            System.out.println("Google OAuth Redirect URI: " + GOOGLE_REDIRECT_URI);
            System.out.println("Google OAuth Client ID: " + GOOGLE_CLIENT_ID);
            
            Map<String, String> params = new HashMap<>();
            params.put("client_id", GOOGLE_CLIENT_ID);
            params.put("redirect_uri", GOOGLE_REDIRECT_URI);
            params.put("response_type", "code");
            params.put("scope", "openid email profile");
            params.put("access_type", "offline");
            params.put("prompt", "consent");
            
            StringBuilder urlBuilder = new StringBuilder(GOOGLE_AUTH_URL);
            urlBuilder.append("?");
            
            for (Map.Entry<String, String> entry : params.entrySet()) {
                urlBuilder.append(URLEncoder.encode(entry.getKey(), StandardCharsets.UTF_8));
                urlBuilder.append("=");
                urlBuilder.append(URLEncoder.encode(entry.getValue(), StandardCharsets.UTF_8));
                urlBuilder.append("&");
            }
            
            // Remove last &
            String url = urlBuilder.toString();
            return url.substring(0, url.length() - 1);
            
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * Exchange authorization code for access token
     */
    public String getAccessToken(String code) {
        try {
            URL url = new URL(GOOGLE_TOKEN_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setDoOutput(true);
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
            
            Map<String, String> params = new HashMap<>();
            params.put("client_id", GOOGLE_CLIENT_ID);
            params.put("client_secret", GOOGLE_CLIENT_SECRET);
            params.put("code", code);
            params.put("grant_type", "authorization_code");
            params.put("redirect_uri", GOOGLE_REDIRECT_URI);
            
            StringBuilder postData = new StringBuilder();
            for (Map.Entry<String, String> entry : params.entrySet()) {
                if (postData.length() != 0) {
                    postData.append('&');
                }
                postData.append(URLEncoder.encode(entry.getKey(), StandardCharsets.UTF_8));
                postData.append('=');
                postData.append(URLEncoder.encode(entry.getValue(), StandardCharsets.UTF_8));
            }
            
            try (OutputStreamWriter writer = new OutputStreamWriter(conn.getOutputStream())) {
                writer.write(postData.toString());
            }
            
            int responseCode = conn.getResponseCode();
            if (responseCode == 200) {
                try (BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()))) {
                    StringBuilder response = new StringBuilder();
                    String line;
                    while ((line = reader.readLine()) != null) {
                        response.append(line);
                    }
                    
                    JsonObject jsonResponse = gson.fromJson(response.toString(), JsonObject.class);
                    return jsonResponse.get("access_token").getAsString();
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Get user information from Google
     */
    public GoogleUserInfo getUserInfo(String accessToken) {
        try {
            URL url = new URL(GOOGLE_USER_INFO_URL + "?access_token=" + accessToken);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            
            int responseCode = conn.getResponseCode();
            if (responseCode == 200) {
                try (BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()))) {
                    StringBuilder response = new StringBuilder();
                    String line;
                    while ((line = reader.readLine()) != null) {
                        response.append(line);
                    }
                    
                    JsonObject jsonResponse = gson.fromJson(response.toString(), JsonObject.class);
                    
                    GoogleUserInfo userInfo = new GoogleUserInfo();
                    userInfo.setId(jsonResponse.get("id").getAsString());
                    userInfo.setEmail(jsonResponse.get("email").getAsString());
                    userInfo.setName(jsonResponse.get("name").getAsString());
                    userInfo.setPicture(jsonResponse.has("picture") ? jsonResponse.get("picture").getAsString() : null);
                    
                    return userInfo;
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Process Google OAuth login
     */
    public Users processGoogleLogin(String code) {
        try {
            System.out.println("Processing Google OAuth login with code: " + code.substring(0, Math.min(10, code.length())) + "...");
            
            // Get access token
            String accessToken = getAccessToken(code);
            if (accessToken == null) {
                System.out.println("Failed to get access token");
                return null;
            }
            System.out.println("Access token obtained successfully");
            
            // Get user info from Google
            GoogleUserInfo googleUser = getUserInfo(accessToken);
            if (googleUser == null) {
                System.out.println("Failed to get user info from Google");
                return null;
            }
            System.out.println("User info obtained: " + googleUser.getEmail());
            
            // Check if user exists by Google ID
            Users existingUser = getUserByGoogleId(googleUser.getId());
            if (existingUser != null) {
                System.out.println("User found by Google ID: " + existingUser.getEmail());
                // Update Google auth info
                updateGoogleAuthInfo(existingUser.getUser_id(), googleUser, accessToken);
                return existingUser;
            }
            
            // Check if user exists by email
            existingUser = usersDAO.getUserByEmail(googleUser.getEmail());
            if (existingUser != null) {
                System.out.println("User found by email, linking Google account: " + existingUser.getEmail());
                // Link Google account to existing user
                linkGoogleAccount(existingUser.getUser_id(), googleUser, accessToken);
                return existingUser;
            }
            
            // Create new user
            System.out.println("Creating new user for: " + googleUser.getEmail());
            Users newUser = createUserFromGoogle(googleUser);
            if (newUser != null) {
                System.out.println("New user created successfully: " + newUser.getEmail());
                // Save Google auth info
                saveGoogleAuthInfo(newUser.getUser_id(), googleUser, accessToken);
                return newUser;
            } else {
                System.out.println("Failed to create new user");
            }
            
        } catch (Exception e) {
            System.out.println("Error in processGoogleLogin: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Get user by Google ID
     */
    private Users getUserByGoogleId(String googleId) {
        String sql = "SELECT u.* FROM users u WHERE u.google_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, googleId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Users user = new Users();
                user.setUser_id(rs.getInt("user_id"));
                user.setFull_name(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password_hash")); // Use password_hash
                user.setPhone_number(rs.getString("phone_number"));
                user.setGender(rs.getString("gender"));
                user.setDate_of_birth(rs.getDate("date_of_birth"));
                user.setAddress(rs.getString("address"));
                user.setAvatar_url(rs.getString("avatar_url"));
                user.setDefault_role(rs.getString("default_role"));
                user.setStatus(rs.getString("status"));
                user.setEmail_verified(rs.getBoolean("email_verified"));
                user.setGoogle_id(rs.getString("google_id"));
                user.setAuth_provider(rs.getString("auth_provider"));
                user.setLast_login_at(rs.getDate("last_login_at"));
                user.setCreated_at(rs.getDate("created_at"));
                user.setUpdated_at(rs.getDate("updated_at"));
                user.setDeleted_at(rs.getDate("deleted_at"));
                
                return user;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Create new user from Google info
     */
    private Users createUserFromGoogle(GoogleUserInfo googleUser) {
        String sql = "INSERT INTO users (full_name, email, password_hash, google_id, auth_provider, status, email_verified, default_role, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            
            ps.setString(1, googleUser.getName());
            ps.setString(2, googleUser.getEmail());
            ps.setString(3, "GOOGLE_AUTH_USER"); // Placeholder password
            ps.setString(4, googleUser.getId());
            ps.setString(5, "google");
            ps.setString(6, "active");
            ps.setBoolean(7, true);
            ps.setString(8, "customer");
            
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int userId = generatedKeys.getInt(1);
                        return getUserByGoogleId(googleUser.getId());
                    }
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Link Google account to existing user
     */
    private void linkGoogleAccount(int userId, GoogleUserInfo googleUser, String accessToken) {
        String sql = "UPDATE users SET google_id = ?, auth_provider = ? WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, googleUser.getId());
            ps.setString(2, "google");
            ps.setInt(3, userId);
            ps.executeUpdate();
            
            // Save Google auth info
            saveGoogleAuthInfo(userId, googleUser, accessToken);
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    /**
     * Save Google auth information
     */
    private void saveGoogleAuthInfo(int userId, GoogleUserInfo googleUser, String accessToken) {
        String sql = "INSERT INTO google_auth (user_id, google_id, email, name, picture_url, access_token, created_at) " +
                    "VALUES (?, ?, ?, ?, ?, ?, NOW()) " +
                    "ON DUPLICATE KEY UPDATE " +
                    "name = VALUES(name), picture_url = VALUES(picture_url), access_token = VALUES(access_token), updated_at = NOW()";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setString(2, googleUser.getId());
            ps.setString(3, googleUser.getEmail());
            ps.setString(4, googleUser.getName());
            ps.setString(5, googleUser.getPicture());
            ps.setString(6, accessToken);
            ps.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    /**
     * Update Google auth information
     */
    private void updateGoogleAuthInfo(int userId, GoogleUserInfo googleUser, String accessToken) {
        String sql = "UPDATE google_auth SET name = ?, picture_url = ?, access_token = ?, updated_at = NOW() WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, googleUser.getName());
            ps.setString(2, googleUser.getPicture());
            ps.setString(3, accessToken);
            ps.setInt(4, userId);
            ps.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    /**
     * Google User Info class
     */
    public static class GoogleUserInfo {
        private String id;
        private String email;
        private String name;
        private String picture;
        
        // Getters and Setters
        public String getId() { return id; }
        public void setId(String id) { this.id = id; }
        
        public String getEmail() { return email; }
        public void setEmail(String email) { this.email = email; }
        
        public String getName() { return name; }
        public void setName(String name) { this.name = name; }
        
        public String getPicture() { return picture; }
        public void setPicture(String picture) { this.picture = picture; }
    }
}
