-- =============================================
-- AirBnB Clone Database Schema
-- =============================================
-- Description: Complete database schema with all tables, constraints, and indexes

-- =============================================

-- Drop existing tables (in reverse order of dependencies)
DROP TABLE IF EXISTS Message;
DROP TABLE IF EXISTS Review;
DROP TABLE IF EXISTS Payment;
DROP TABLE IF EXISTS Booking;
DROP TABLE IF EXISTS Location;
DROP TABLE IF EXISTS Property;
DROP TABLE IF EXISTS User;

-- =============================================
-- USER TABLE
-- =============================================
CREATE TABLE User (
    user_id CHAR(36) PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20) NULL,
    role ENUM('guest', 'host', 'admin') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Indexes
    INDEX idx_user_email (email),
    INDEX idx_user_role (role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- PROPERTY TABLE
-- =============================================
CREATE TABLE Property (
    property_id CHAR(36) PRIMARY KEY,
    host_id CHAR(36) NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    pricepernight DECIMAL(10, 2) NOT NULL CHECK (pricepernight > 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Foreign Keys
    FOREIGN KEY (host_id) REFERENCES User(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    
    -- Indexes
    INDEX idx_property_host (host_id),
    INDEX idx_property_price (pricepernight)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- LOCATION TABLE
-- =============================================
CREATE TABLE Location (
    location_id CHAR(36) PRIMARY KEY,
    property_id CHAR(36) UNIQUE NOT NULL,
    street_address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20) NULL,
    latitude DECIMAL(10, 8) NULL,
    longitude DECIMAL(11, 8) NULL,
    
    -- Foreign Keys
    FOREIGN KEY (property_id) REFERENCES Property(property_id) ON DELETE CASCADE ON UPDATE CASCADE,
    
    -- Indexes
    INDEX idx_location_property (property_id),
    INDEX idx_location_city (city),
    INDEX idx_location_country (country),
    INDEX idx_location_coordinates (latitude, longitude)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- BOOKING TABLE
-- =============================================
CREATE TABLE Booking (
    booking_id CHAR(36) PRIMARY KEY,
    property_id CHAR(36) NOT NULL,
    user_id CHAR(36) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL CHECK (total_price > 0),
    status ENUM('pending', 'confirmed', 'canceled') NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign Keys
    FOREIGN KEY (property_id) REFERENCES Property(property_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    
    -- Check Constraints
    CONSTRAINT chk_booking_dates CHECK (end_date > start_date),
    
    -- Indexes
    INDEX idx_booking_property (property_id),
    INDEX idx_booking_user (user_id),
    INDEX idx_booking_dates (start_date, end_date),
    INDEX idx_booking_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- PAYMENT TABLE
-- =============================================
CREATE TABLE Payment (
    payment_id CHAR(36) PRIMARY KEY,
    booking_id CHAR(36) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL CHECK (amount > 0),
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method ENUM('credit_card', 'paypal', 'stripe') NOT NULL,
    
    -- Foreign Keys
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id) ON DELETE CASCADE ON UPDATE CASCADE,
    
    -- Indexes
    INDEX idx_payment_booking (booking_id),
    INDEX idx_payment_date (payment_date),
    INDEX idx_payment_method (payment_method)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- REVIEW TABLE
-- =============================================
CREATE TABLE Review (
    review_id CHAR(36) PRIMARY KEY,
    property_id CHAR(36) NOT NULL,
    user_id CHAR(36) NOT NULL,
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign Keys
    FOREIGN KEY (property_id) REFERENCES Property(property_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    
    -- Indexes
    INDEX idx_review_property (property_id),
    INDEX idx_review_user (user_id),
    INDEX idx_review_rating (rating),
    INDEX idx_review_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- MESSAGE TABLE
-- =============================================
CREATE TABLE Message (
    message_id CHAR(36) PRIMARY KEY,
    sender_id CHAR(36) NOT NULL,
    recipient_id CHAR(36) NOT NULL,
    message_body TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign Keys
    FOREIGN KEY (sender_id) REFERENCES User(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (recipient_id) REFERENCES User(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    
    -- Check Constraints
    CONSTRAINT chk_message_different_users CHECK (sender_id != recipient_id),
    
    -- Indexes
    INDEX idx_message_sender (sender_id),
    INDEX idx_message_recipient (recipient_id),
    INDEX idx_message_sent_at (sent_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- VIEWS FOR COMMON QUERIES
-- =============================================

-- View: Property with Location Details
CREATE VIEW vw_property_details AS
SELECT 
    p.property_id,
    p.name,
    p.description,
    p.pricepernight,
    p.host_id,
    CONCAT(u.first_name, ' ', u.last_name) AS host_name,
    l.street_address,
    l.city,
    l.state,
    l.country,
    l.postal_code,
    p.created_at,
    p.updated_at
FROM Property p
JOIN User u ON p.host_id = u.user_id
LEFT JOIN Location l ON p.property_id = l.property_id;

-- View: Booking Details with User and Property Info
CREATE VIEW vw_booking_details AS
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    b.created_at,
    CONCAT(u.first_name, ' ', u.last_name) AS guest_name,
    u.email AS guest_email,
    p.name AS property_name,
    l.city AS property_city,
    CONCAT(h.first_name, ' ', h.last_name) AS host_name
FROM Booking b
JOIN User u ON b.user_id = u.user_id
JOIN Property p ON b.property_id = p.property_id
JOIN User h ON p.host_id = h.user_id
LEFT JOIN Location l ON p.property_id = l.property_id;

-- =============================================
-- STORED PROCEDURES
-- =============================================

DELIMITER //

-- Procedure: Get Available Properties by Date Range
CREATE PROCEDURE sp_get_available_properties(
    IN p_start_date DATE,
    IN p_end_date DATE,
    IN p_city VARCHAR(100)
)
BEGIN
    SELECT 
        p.property_id,
        p.name,
        p.description,
        p.pricepernight,
        l.city,
        l.state,
        l.country
    FROM Property p
    JOIN Location l ON p.property_id = l.property_id
    WHERE (p_city IS NULL OR l.city = p_city)
    AND p.property_id NOT IN (
        SELECT property_id
        FROM Booking
        WHERE status IN ('confirmed', 'pending')
        AND NOT (end_date <= p_start_date OR start_date >= p_end_date)
    )
    ORDER BY p.pricepernight ASC;
END //

DELIMITER ;

-- =============================================
-- PERFORMANCE OPTIMIZATION NOTES
-- =============================================
-- 1. All foreign keys are indexed automatically
-- 2. Email field in User table is indexed for authentication queries
-- 3. Composite index on Booking dates for availability searches
-- 4. Property price indexed for sorting and filtering
-- 5. Review rating indexed for aggregation queries
-- 6. Message sent_at indexed for chronological retrieval
-- 7. Location coordinates indexed for geospatial queries

-- =============================================
-- END OF SCHEMA
-- =============================================