-- =============================================
-- AirBnB Clone Database - Sample Data Seeding
-- =============================================
-- Description: Insert sample data for testing and development

-- =============================================

-- Disable foreign key checks temporarily for easier insertion
SET FOREIGN_KEY_CHECKS = 0;

-- Clear existing data (in reverse order of dependencies)
TRUNCATE TABLE Message;
TRUNCATE TABLE Review;
TRUNCATE TABLE Payment;
TRUNCATE TABLE Booking;
TRUNCATE TABLE Location;
TRUNCATE TABLE Property;
TRUNCATE TABLE User;

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- =============================================
-- INSERT USERS
-- =============================================

INSERT INTO User (user_id, first_name, last_name, email, password_hash, phone_number, role, created_at) VALUES
-- Guests
('550e8400-e29b-41d4-a716-446655440001', 'John', 'Doe', 'john.doe@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5oe2KP4.PZRm2', '+1234567890', 'guest', '2024-01-15 10:30:00'),
('550e8400-e29b-41d4-a716-446655440002', 'Jane', 'Smith', 'jane.smith@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5oe2KP4.PZRm2', '+1234567891', 'guest', '2024-02-20 14:15:00'),
('550e8400-e29b-41d4-a716-446655440003', 'Michael', 'Johnson', 'michael.j@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5oe2KP4.PZRm2', '+1234567892', 'guest', '2024-03-10 09:00:00'),

-- Hosts
('550e8400-e29b-41d4-a716-446655440004', 'Sarah', 'Williams', 'sarah.w@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5oe2KP4.PZRm2', '+1234567893', 'host', '2023-11-05 08:30:00'),
('550e8400-e29b-41d4-a716-446655440005', 'David', 'Brown', 'david.brown@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5oe2KP4.PZRm2', '+1234567894', 'host', '2023-12-12 16:45:00'),
('550e8400-e29b-41d4-a716-446655440006', 'Emily', 'Davis', 'emily.davis@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5oe2KP4.PZRm2', '+1234567895', 'host', '2024-01-08 11:20:00'),

-- Admin
('550e8400-e29b-41d4-a716-446655440007', 'Admin', 'User', 'admin@airbnb.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5oe2KP4.PZRm2', '+1234567896', 'admin', '2023-10-01 00:00:00');

-- =============================================
-- INSERT PROPERTIES
-- =============================================

INSERT INTO Property (property_id, host_id, name, description, pricepernight, created_at, updated_at) VALUES
-- Sarah's Properties
('660e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440004', 'Cozy Downtown Apartment', 'Beautiful 2-bedroom apartment in the heart of downtown. Walking distance to restaurants, shops, and entertainment. Perfect for couples or small families.', 150.00, '2023-11-10 10:00:00', '2023-11-10 10:00:00'),
('660e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440004', 'Beachfront Villa', 'Luxurious 4-bedroom villa with private beach access. Stunning ocean views, infinity pool, and modern amenities. Ideal for families and groups.', 450.00, '2023-11-15 14:30:00', '2024-06-20 09:15:00'),

-- David's Properties
('660e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440005', 'Mountain Cabin Retreat', 'Rustic 3-bedroom cabin nestled in the mountains. Fireplace, hiking trails nearby, and peaceful surroundings. Great for nature lovers.', 200.00, '2023-12-20 11:45:00', '2023-12-20 11:45:00'),
('660e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440005', 'Modern City Loft', 'Stylish 1-bedroom loft in trendy neighborhood. High ceilings, exposed brick, and rooftop access. Perfect for solo travelers or couples.', 120.00, '2024-01-05 13:20:00', '2024-01-05 13:20:00'),

-- Emily's Properties
('660e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440006', 'Suburban Family Home', 'Spacious 5-bedroom house in quiet suburban area. Large backyard, full kitchen, and close to schools and parks. Family-friendly.', 280.00, '2024-01-15 09:30:00', '2024-01-15 09:30:00'),
('660e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440006', 'Historic Townhouse', 'Charming 3-bedroom townhouse in historic district. Original architecture, modern updates, and walking distance to museums.', 175.00, '2024-02-01 15:00:00', '2024-02-01 15:00:00');

-- =============================================
-- INSERT LOCATIONS
-- =============================================

INSERT INTO Location (location_id, property_id, street_address, city, state, country, postal_code, latitude, longitude) VALUES
('770e8400-e29b-41d4-a716-446655440001', '660e8400-e29b-41d4-a716-446655440001', '123 Main Street, Apt 5B', 'New York', 'New York', 'USA', '10001', 40.7128, -74.0060),
('770e8400-e29b-41d4-a716-446655440002', '660e8400-e29b-41d4-a716-446655440002', '456 Ocean Drive', 'Miami', 'Florida', 'USA', '33139', 25.7617, -80.1918),
('770e8400-e29b-41d4-a716-446655440003', '660e8400-e29b-41d4-a716-446655440003', '789 Pine Road', 'Aspen', 'Colorado', 'USA', '81611', 39.1911, -106.8175),
('770e8400-e29b-41d4-a716-446655440004', '660e8400-e29b-41d4-a716-446655440004', '321 Urban Avenue, Unit 12', 'San Francisco', 'California', 'USA', '94102', 37.7749, -122.4194),
('770e8400-e29b-41d4-a716-446655440005', '660e8400-e29b-41d4-a716-446655440005', '654 Maple Lane', 'Portland', 'Oregon', 'USA', '97201', 45.5152, -122.6784),
('770e8400-e29b-41d4-a716-446655440006', '660e8400-e29b-41d4-a716-446655440006', '987 Heritage Street', 'Boston', 'Massachusetts', 'USA', '02108', 42.3601, -71.0589);

-- =============================================
-- INSERT BOOKINGS
-- =============================================

INSERT INTO Booking (booking_id, property_id, user_id, start_date, end_date, total_price, status, created_at) VALUES
-- Confirmed bookings
('880e8400-e29b-41d4-a716-446655440001', '660e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', '2024-12-01', '2024-12-05', 600.00, 'confirmed', '2024-11-10 14:30:00'),
('880e8400-e29b-41d4-a716-446655440002', '660e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440002', '2024-12-15', '2024-12-22', 3150.00, 'confirmed', '2024-11-15 10:15:00'),
('880e8400-e29b-41d4-a716-446655440003', '660e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440003', '2025-01-10', '2025-01-14', 800.00, 'confirmed', '2024-12-01 16:45:00'),
('880e8400-e29b-41d4-a716-446655440004', '660e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440001', '2025-02-05', '2025-02-08', 360.00, 'confirmed', '2025-01-15 09:20:00'),

-- Pending booking
('880e8400-e29b-41d4-a716-446655440005', '660e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440002', '2025-03-01', '2025-03-07', 1680.00, 'pending', '2025-02-10 11:30:00'),

-- Canceled booking
('880e8400-e29b-41d4-a716-446655440006', '660e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440003', '2024-11-20', '2024-11-23', 525.00, 'canceled', '2024-11-01 13:00:00'),

-- Past bookings
('880e8400-e29b-41d4-a716-446655440007', '660e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440002', '2024-09-10', '2024-09-13', 450.00, 'confirmed', '2024-08-25 10:00:00'),
('880e8400-e29b-41d4-a716-446655440008', '660e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440001', '2024-10-05', '2024-10-10', 1000.00, 'confirmed', '2024-09-15 14:30:00');

-- =============================================
-- INSERT PAYMENTS
-- =============================================

INSERT INTO Payment (payment_id, booking_id, amount, payment_date, payment_method) VALUES
('990e8400-e29b-41d4-a716-446655440001', '880e8400-e29b-41d4-a716-446655440001', 600.00, '2024-11-10 14:35:00', 'credit_card'),
('990e8400-e29b-41d4-a716-446655440002', '880e8400-e29b-41d4-a716-446655440002', 3150.00, '2024-11-15 10:20:00', 'stripe'),
('990e8400-e29b-41d4-a716-446655440003', '880e8400-e29b-41d4-a716-446655440003', 800.00, '2024-12-01 16:50:00', 'paypal'),
('990e8400-e29b-41d4-a716-446655440004', '880e8400-e29b-41d4-a716-446655440004', 360.00, '2025-01-15 09:25:00', 'credit_card'),
('990e8400-e29b-41d4-a716-446655440005', '880e8400-e29b-41d4-a716-446655440007', 450.00, '2024-08-25 10:05:00', 'stripe'),
('990e8400-e29b-41d4-a716-446655440006', '880e8400-e29b-41d4-a716-446655440008', 1000.00, '2024-09-15 14:35:00', 'paypal');

-- =============================================
-- INSERT REVIEWS
-- =============================================

INSERT INTO Review (review_id, property_id, user_id, rating, comment, created_at) VALUES
-- Reviews for Downtown Apartment
('aa0e8400-e29b-41d4-a716-446655440001', '660e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440002', 5, 'Amazing location! The apartment was spotless and exactly as described. Host was very responsive. Would definitely book again!', '2024-09-16 10:30:00'),
('aa0e8400-e29b-41d4-a716-446655440002', '660e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', 4, 'Great place, very comfortable. Only minor issue was some street noise at night, but overall excellent value for money.', '2024-12-06 14:20:00'),

-- Review for Beachfront Villa
('aa0e8400-e29b-41d4-a716-446655440003', '660e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440002', 5, 'Absolutely stunning property! The views are breathtaking. Perfect for our family vacation. The pool was amazing and beach access was convenient.', '2024-12-23 16:45:00'),

-- Review for Mountain Cabin
('aa0e8400-e29b-41d4-a716-446655440004', '660e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440001', 5, 'Perfect mountain getaway! Cozy cabin with everything we needed. The fireplace was wonderful. Highly recommend for a peaceful retreat.', '2024-10-12 09:15:00'),

-- Review for City Loft
('aa0e8400-e29b-41d4-a716-446655440005', '660e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440001', 4, 'Stylish loft in a great neighborhood. Lots of restaurants nearby. Rooftop was a nice bonus. Only wish it had a bit more storage space.', '2025-02-09 11:00:00'),

-- Review for Suburban Family Home
('aa0e8400-e29b-41d4-a716-446655440006', '660e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440003', 3, 'Good property for families. House was spacious and clean. Location was quiet but a bit far from downtown attractions. Overall decent stay.', '2024-08-15 13:30:00');

-- =============================================
-- INSERT MESSAGES
-- =============================================

INSERT INTO Message (message_id, sender_id, recipient_id, message_body, sent_at) VALUES
-- Guest inquiries to hosts
('bb0e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440004', 'Hi! I am interested in booking your downtown apartment for December. Is it available for the dates I selected?', '2024-11-09 15:30:00'),
('bb0e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440001', 'Hello! Yes, the apartment is available for your dates. Feel free to book and let me know if you have any questions!', '2024-11-09 16:15:00'),

('bb0e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440004', 'Does the beachfront villa allow pets? We have a small dog.', '2024-11-13 10:00:00'),
('bb0e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440002', 'Unfortunately, we do not allow pets at this property. Sorry about that!', '2024-11-13 11:30:00'),

('bb0e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440005', 'What time is check-in for the mountain cabin?', '2024-11-28 14:20:00'),
('bb0e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440003', 'Check-in is at 3:00 PM and check-out is at 11:00 AM. Looking forward to hosting you!', '2024-11-28 15:45:00'),

-- Follow-up messages
('bb0e8400-e29b-41d4-a716-446655440007', '550e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440004', 'Thanks for a great stay! The apartment was perfect for our needs.', '2024-12-06 10:00:00'),
('bb0e8400-e29b-41d4-a716-446655440008', '550e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440001', 'Thank you for staying with us! Hope to host you again soon!', '2024-12-06 12:30:00');

-- =============================================
-- VERIFICATION QUERIES
-- =============================================

-- Count records in each table
SELECT 'Users' AS TableName, COUNT(*) AS RecordCount FROM User
UNION ALL
SELECT 'Properties', COUNT(*) FROM Property
UNION ALL
SELECT 'Locations', COUNT(*) FROM Location
UNION ALL
SELECT 'Bookings', COUNT(*) FROM Booking
UNION ALL
SELECT 'Payments', COUNT(*) FROM Payment
UNION ALL
SELECT 'Reviews', COUNT(*) FROM Review
UNION ALL
SELECT 'Messages', COUNT(*) FROM Message;

-- =============================================
-- END OF SEED DATA
-- =============================================