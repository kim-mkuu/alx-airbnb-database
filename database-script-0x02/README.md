# Sample Data Seeding - AirBnB Clone

## Overview

This directory contains SQL scripts to populate the database with sample data for testing and development purposes.

## Files

- `seed.sql` - Complete sample data insertion script

## Sample Data Summary

### Data Volume

| Table | Records | Description |
|-------|---------|-------------|
| User | 7 | 3 guests, 3 hosts, 1 admin |
| Property | 6 | Various property types across different locations |
| Location | 6 | One location per property |
| Booking | 8 | Mix of confirmed, pending, and canceled bookings |
| Payment | 6 | Payments for confirmed bookings |
| Review | 6 | Reviews from guests |
| Message | 8 | Conversation threads between users |

### Sample Users

#### Guests

1. **John Doe** - john.doe@email.com
2. **Jane Smith** - jane.smith@email.com
3. **Michael Johnson** - michael.j@email.com

#### Hosts

1. **Sarah Williams** - sarah.w@email.com (2 properties)
2. **David Brown** - david.brown@email.com (2 properties)
3. **Emily Davis** - emily.davis@email.com (2 properties)

#### Admin

1. **Admin User** - admin@airbnb.com

### Sample Properties

1. **Cozy Downtown Apartment** (New York, NY) - $150/night
2. **Beachfront Villa** (Miami, FL) - $450/night
3. **Mountain Cabin Retreat** (Aspen, CO) - $200/night
4. **Modern City Loft** (San Francisco, CA) - $120/night
5. **Suburban Family Home** (Portland, OR) - $280/night
6. **Historic Townhouse** (Boston, MA) - $175/night

### Booking Scenarios

- **Confirmed Bookings**: 6 bookings with payments
- **Pending Booking**: 1 booking awaiting payment
- **Canceled Booking**: 1 booking canceled by guest
- **Past Bookings**: 2 completed bookings with reviews

## Execution Instructions

### Prerequisites

- MySQL 8.0 or higher
- Schema must be created first (run `schema.sql` from `database-script-0x01`)
- Database connection with INSERT privileges

### Step 1: Verify Schema Exists

```bash
mysql -u root -p airbnb_db -e "SHOW TABLES;"
```

Expected output: 7 tables (User, Property, Location, Booking, Payment, Review, Message)

### Step 2: Execute Seed Script

```bash
mysql -u root -p airbnb_db < seed.sql
```

### Step 3: Verify Data Insertion

```bash
mysql -u root -p airbnb_db -e "
SELECT 'Users' AS TableName, COUNT(*) AS RecordCount FROM User
UNION ALL SELECT 'Properties', COUNT(*) FROM Property
UNION ALL SELECT 'Locations', COUNT(*) FROM Location
UNION ALL SELECT 'Bookings', COUNT(*) FROM Booking
UNION ALL SELECT 'Payments', COUNT(*) FROM Payment
UNION ALL SELECT 'Reviews', COUNT(*) FROM Review
UNION ALL SELECT 'Messages', COUNT(*) FROM Message;
"
```

Expected output:

```
+------------+-------------+
| TableName  | RecordCount |
+------------+-------------+
| Users      |           7 |
| Properties |           6 |
| Locations  |           6 |
| Bookings   |           8 |
| Payments   |           6 |
| Reviews    |           6 |
| Messages   |           8 |
+------------+-------------+
```

## Sample Data Details

### Password Information

All user passwords are hashed using bcrypt. The plaintext password for all sample users is: `Password123!`

**Hash used:** `$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5oe2KP4.PZRm2`

### UUID Pattern

All UUIDs follow a consistent pattern for easy identification:

- Users: `550e8400-e29b-41d4-a716-44665544000X`
- Properties: `660e8400-e29b-41d4-a716-44665544000X`
- Locations: `770e8400-e29b-41d4-a716-44665544000X`
- Bookings: `880e8400-e29b-41d4-a716-44665544000X`
- Payments: `990e8400-e29b-41d4-a716-44665544000X`
- Reviews: `aa0e8400-e29b-41d4-a716-44665544000X`
- Messages: `bb0e8400-e29b-41d4-a716-44665544000X`

## Testing Scenarios

### 1. User Authentication Test

```sql
-- Verify user login
SELECT user_id, email, role 
FROM User 
WHERE email = 'john.doe@email.com';
```

### 2. Property Search Test

```sql
-- Find properties in a city
SELECT p.name, p.pricepernight, l.city, l.state
FROM Property p
JOIN Location l ON p.property_id = l.property_id
WHERE l.city = 'New York';
```

### 3. Booking History Test

```sql
-- Get user's booking history
SELECT b.booking_id, p.name, b.start_date, b.end_date, b.status
FROM Booking b
JOIN Property p ON b.property_id = p.property_id
WHERE b.user_id = '550e8400-e29b-41d4-a716-446655440001'
ORDER BY b.start_date DESC;
```

### 4. Property Reviews Test

```sql
-- Get reviews for a property
SELECT r.rating, r.comment, CONCAT(u.first_name, ' ', u.last_name) AS reviewer
FROM Review r
JOIN User u ON r.user_id = u.user_id
WHERE r.property_id = '660e8400-e29b-41d4-a716-446655440001'
ORDER BY r.created_at DESC;
```

### 5. Payment History Test

```sql
-- Get payment details for a booking
SELECT p.amount, p.payment_date, p.payment_method, b.total_price
FROM Payment p
JOIN Booking b ON p.booking_id = b.booking_id
WHERE b.booking_id = '880e8400-e29b-41d4-a716-446655440001';
```

### 6. Message Thread Test

```sql
-- Get conversation between two users
SELECT 
    CONCAT(sender.first_name, ' ', sender.last_name) AS sender,
    CONCAT(recipient.first_name, ' ', recipient.last_name) AS recipient,
    m.message_body,
    m.sent_at
FROM Message m
JOIN User sender ON m.sender_id = sender.user_id
JOIN User recipient ON m.recipient_id = recipient.user_id
WHERE (m.sender_id = '550e8400-e29b-41d4-a716-446655440001' 
       AND m.recipient_id = '550e8400-e29b-41d4-a716-446655440004')
   OR (m.sender_id = '550e8400-e29b-41d4-a716-446655440004' 
       AND m.recipient_id = '550e8400-e29b-41d4-a716-446655440001')
ORDER BY m.sent_at;
```

## Data Relationships Demonstrated

### 1. One-to-Many Relationships
- **User → Property**: Sarah Williams hosts 2 properties
- **User → Booking**: John Doe has 3 bookings
- **Property → Booking**: Downtown Apartment has 2 bookings
- **Property → Review**: Downtown Apartment has 2 reviews

### 2. One-to-One Relationships
- **Property → Location**: Each property has exactly one location
- **Booking → Payment**: Each confirmed booking has one payment

### 3. Many-to-Many (through junction)
- **User ↔ Property** (through Booking): Guests book multiple properties
- **User ↔ Property** (through Review): Guests review multiple properties

## Real-World Usage Patterns

### Booking Timeline
1. **Guest inquiry** → Message sent to host
2. **Host response** → Message reply
3. **Booking creation** → Status: pending
4. **Payment processing** → Status: confirmed
5. **Stay completion** → Guest leaves review

### Sample Timeline Example
```
Nov 9, 2024  - John inquires about downtown apartment
Nov 9, 2024  - Sarah responds confirming availability
Nov 10, 2024 - John creates booking
Nov 10, 2024 - Payment processed
Dec 1-5, 2024 - Stay period
Dec 6, 2024  - John leaves review and thank you message
```

## Data Integrity Checks

### Check Foreign Key Relationships
```sql
-- Verify all bookings have valid property and user references
SELECT 
    b.booking_id,
    CASE WHEN p.property_id IS NULL THEN 'INVALID' ELSE 'VALID' END AS property_check,
    CASE WHEN u.user_id IS NULL THEN 'INVALID' ELSE 'VALID' END AS user_check
FROM Booking b
LEFT JOIN Property p ON b.property_id = p.property_id
LEFT JOIN User u ON b.user_id = u.user_id;
```

### Check Payment-Booking Consistency
```sql
-- Verify all payments match booking amounts
SELECT 
    b.booking_id,
    b.total_price AS booking_amount,
    p.amount AS payment_amount,
    CASE 
        WHEN b.total_price = p.amount THEN 'MATCH'
        ELSE 'MISMATCH'
    END AS amount_check
FROM Booking b
JOIN Payment p ON b.booking_id = p.booking_id;
```

### Check Review Validity
```sql
-- Verify reviews are from guests who actually booked the property
SELECT 
    r.review_id,
    r.property_id,
    r.user_id,
    CASE 
        WHEN b.booking_id IS NOT NULL THEN 'VALID'
        ELSE 'INVALID - No booking found'
    END AS review_validity
FROM Review r
LEFT JOIN Booking b ON r.property_id = b.property_id 
    AND r.user_id = b.user_id 
    AND b.status = 'confirmed';
```

### Check Date Consistency
```sql
-- Verify booking dates are logical (end_date > start_date)
SELECT 
    booking_id,
    start_date,
    end_date,
    DATEDIFF(end_date, start_date) AS nights,
    CASE 
        WHEN end_date > start_date THEN 'VALID'
        ELSE 'INVALID'
    END AS date_check
FROM Booking;
```

## Advanced Query Examples

### 1. Host Revenue Report
```sql
-- Calculate total revenue per host
SELECT 
    CONCAT(u.first_name, ' ', u.last_name) AS host_name,
    COUNT(DISTINCT p.property_id) AS properties_count,
    COUNT(b.booking_id) AS total_bookings,
    SUM(pay.amount) AS total_revenue
FROM User u
JOIN Property p ON u.user_id = p.host_id
LEFT JOIN Booking b ON p.property_id = b.property_id AND b.status = 'confirmed'
LEFT JOIN Payment pay ON b.booking_id = pay.booking_id
WHERE u.role = 'host'
GROUP BY u.user_id
ORDER BY total_revenue DESC;
```

### 2. Property Performance Analysis
```sql
-- Analyze property performance with average rating and booking count
SELECT 
    p.name AS property_name,
    l.city,
    p.pricepernight,
    COUNT(DISTINCT b.booking_id) AS total_bookings,
    COUNT(DISTINCT r.review_id) AS total_reviews,
    AVG(r.rating) AS avg_rating,
    SUM(CASE WHEN b.status = 'confirmed' THEN pay.amount ELSE 0 END) AS total_revenue
FROM Property p
JOIN Location l ON p.property_id = l.property_id
LEFT JOIN Booking b ON p.property_id = b.property_id
LEFT JOIN Payment pay ON b.booking_id = pay.booking_id
LEFT JOIN Review r ON p.property_id = r.property_id
GROUP BY p.property_id
ORDER BY avg_rating DESC, total_bookings DESC;
```

### 3. Guest Activity Summary
```sql
-- Summarize guest booking activity
SELECT 
    CONCAT(u.first_name, ' ', u.last_name) AS guest_name,
    u.email,
    COUNT(b.booking_id) AS total_bookings,
    SUM(CASE WHEN b.status = 'confirmed' THEN 1 ELSE 0 END) AS confirmed_bookings,
    SUM(CASE WHEN b.status = 'canceled' THEN 1 ELSE 0 END) AS canceled_bookings,
    SUM(pay.amount) AS total_spent,
    COUNT(r.review_id) AS reviews_written
FROM User u
LEFT JOIN Booking b ON u.user_id = b.user_id
LEFT JOIN Payment pay ON b.booking_id = pay.booking_id
LEFT JOIN Review r ON u.user_id = r.user_id
WHERE u.role = 'guest'
GROUP BY u.user_id
ORDER BY total_spent DESC;
```

### 4. Popular Destinations
```sql
-- Find most popular cities by booking count
SELECT 
    l.city,
    l.state,
    l.country,
    COUNT(DISTINCT p.property_id) AS properties_available,
    COUNT(b.booking_id) AS total_bookings,
    AVG(p.pricepernight) AS avg_price_per_night,
    AVG(r.rating) AS avg_rating
FROM Location l
JOIN Property p ON l.property_id = p.property_id
LEFT JOIN Booking b ON p.property_id = b.property_id
LEFT JOIN Review r ON p.property_id = r.property_id
GROUP BY l.city, l.state, l.country
ORDER BY total_bookings DESC;
```

### 5. Booking Status Distribution
```sql
-- Analyze booking status distribution over time
SELECT 
    DATE_FORMAT(b.created_at, '%Y-%m') AS booking_month,
    b.status,
    COUNT(*) AS booking_count,
    SUM(b.total_price) AS total_value
FROM Booking b
GROUP BY DATE_FORMAT(b.created_at, '%Y-%m'), b.status
ORDER BY booking_month DESC, b.status;
```

### 6. Payment Method Analysis
```sql
-- Analyze payment method preferences
SELECT 
    pay.payment_method,
    COUNT(*) AS transaction_count,
    SUM(pay.amount) AS total_amount,
    AVG(pay.amount) AS avg_transaction_amount,
    MIN(pay.amount) AS min_amount,
    MAX(pay.amount) AS max_amount
FROM Payment pay
GROUP BY pay.payment_method
ORDER BY total_amount DESC;
```

## Troubleshooting

### Issue: Foreign Key Constraint Errors
**Solution:** Ensure parent records exist before inserting child records. The seed script disables foreign key checks temporarily during execution.

```sql
-- Check if foreign key constraints are causing issues
SET FOREIGN_KEY_CHECKS = 0;
-- Your INSERT statements here
SET FOREIGN_KEY_CHECKS = 1;
```

### Issue: Duplicate Entry Errors
**Solution:** The seed script includes TRUNCATE statements to clear existing data. If you encounter duplicate errors, run:

```sql
TRUNCATE TABLE Message;
TRUNCATE TABLE Review;
TRUNCATE TABLE Payment;
TRUNCATE TABLE Booking;
TRUNCATE TABLE Location;
TRUNCATE TABLE Property;
TRUNCATE TABLE User;
```

### Issue: Date Format Errors
**Solution:** Ensure your MySQL server accepts the date format used (YYYY-MM-DD). Check your SQL mode:

```sql
SELECT @@sql_mode;
```

### Issue: UUID Not Recognized
**Solution:** UUIDs are stored as VARCHAR. Ensure your schema defines UUID fields as VARCHAR(36).

## Maintenance and Updates

### Adding New Sample Data
To add more sample data without clearing existing records:

1. Comment out the TRUNCATE statements in seed.sql
2. Generate new UUIDs following the existing pattern
3. Ensure foreign key relationships are maintained
4. Run the modified script

### Resetting Sample Data
To completely reset and reload sample data:

```bash
mysql -u root -p airbnb_db < seed.sql
```

The script automatically truncates all tables before inserting fresh data.

## Best Practices

1. **Always backup** before running seed scripts in any non-development environment
2. **Verify schema compatibility** ensure your database schema matches the expected structure
3. **Check data volumes** monitor performance with larger datasets
4. **Validate relationships** run integrity check queries after seeding
5. **Document changes** update this README if you modify the seed data

## Performance Considerations

### Indexing Impact
The sample data includes indexed fields:
- All primary keys (automatic indexes)
- `User.email` (unique index)
- Foreign key columns in Booking and Payment tables

### Query Optimization Tips
- Use EXPLAIN to analyze query performance
- Leverage existing indexes in WHERE clauses
- Avoid SELECT * in production queries
- Use JOINs efficiently (demonstrated in example queries)

## Next Steps

After successfully seeding the database:

1. **Run test queries** to validate data integrity
2. **Test API endpoints** using the sample data
3. **Implement business logic** leveraging the realistic dataset
4. **Develop frontend features** with actual data flow
5. **Performance testing** with this baseline dataset

## Support and Contribution

For issues or improvements:
1. Create detailed bug reports with query examples
2. Suggest additional sample scenarios
3. Contribute edge case data
4. Document new testing patterns

## Version History

- **v1.0.0** (2024-10-26) - Initial seed data with 7 users, 6 properties, 8 bookings
  - Includes realistic booking scenarios
  - Covers all entity relationships
  - Demonstrates various booking statuses
  - Includes message threads and reviews
