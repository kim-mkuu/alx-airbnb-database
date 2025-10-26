# Database Schema - AirBnB Clone

## Overview
This directory contains the SQL scripts for creating the complete database schema for the AirBnB clone application.

## Files
- `schema.sql` - Complete database schema with all tables, constraints, indexes, views, and stored procedures

## Database Structure

### Tables Created

1. **User** - Stores user account information
2. **Property** - Stores property listings
3. **Location** - Stores detailed location information for properties
4. **Booking** - Stores booking reservations
5. **Payment** - Stores payment transactions
6. **Review** - Stores property reviews and ratings
7. **Message** - Stores messages between users

### Entity Relationships

```
User (1) ----< (N) Property
User (1) ----< (N) Booking
User (1) ----< (N) Review
User (1) ----< (N) Message (as sender)
User (1) ----< (N) Message (as recipient)
Property (1) ----< (N) Booking
Property (1) ---- (1) Location
Property (1) ----< (N) Review
Booking (1) ---- (1) Payment
```

## How to Execute

### Prerequisites
- MySQL 8.0 or higher
- Database user with CREATE, DROP, and INDEX privileges

### Execution Steps

1. **Create Database**
```bash
mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS airbnb_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
```

2. **Execute Schema**
```bash
mysql -u root -p airbnb_db < schema.sql
```

3. **Verify Tables**
```bash
mysql -u root -p airbnb_db -e "SHOW TABLES;"
```

4. **Check Table Structure**
```bash
mysql -u root -p airbnb_db -e "DESCRIBE User;"
```

## Key Features

### 1. Data Types
- **CHAR(36)** - Used for UUID primary keys
- **VARCHAR** - Variable-length strings with appropriate limits
- **TEXT** - Long-form content (descriptions, comments, messages)
- **DECIMAL(10,2)** - Monetary values with precision
- **ENUM** - Predefined value sets (roles, status, payment methods)
- **TIMESTAMP** - Automatic timestamp tracking

### 2. Constraints

#### Primary Keys
- All tables use UUID-based primary keys (CHAR(36))
- Indexed automatically for fast lookups

#### Foreign Keys
- **ON DELETE CASCADE** - Child records deleted when parent is deleted
- **ON UPDATE CASCADE** - Child records updated when parent key changes
- Maintains referential integrity

#### Check Constraints
- `pricepernight > 0` - Ensures positive pricing
- `total_price > 0` - Ensures positive payment amounts
- `rating >= 1 AND rating <= 5` - Enforces rating range
- `end_date > start_date` - Validates booking date logic
- `sender_id != recipient_id` - Prevents self-messaging

#### Unique Constraints
- `User.email` - One email per account
- `Location.property_id` - One location per property

#### NOT NULL Constraints
- Applied to all essential fields
- Ensures data completeness

### 3. Indexes

#### User Table
- `idx_user_email` - Fast authentication and lookup
- `idx_user_role` - Role-based queries

#### Property Table
- `idx_property_host` - Host's property listings
- `idx_property_price` - Price filtering and sorting

#### Location Table
- `idx_location_property` - Property-location joins
- `idx_location_city` - City-based searches
- `idx_location_country` - Country filtering
- `idx_location_coordinates` - Geospatial queries

#### Booking Table
- `idx_booking_property` - Property bookings
- `idx_booking_user` - User booking history
- `idx_booking_dates` - Availability searches
- `idx_booking_status` - Status filtering

#### Payment Table
- `idx_payment_booking` - Payment-booking relationship
- `idx_payment_date` - Date-based queries
- `idx_payment_method` - Payment method analysis

#### Review Table
- `idx_review_property` - Property reviews
- `idx_review_user` - User review history
- `idx_review_rating` - Rating aggregations
- `idx_review_created` - Chronological ordering

#### Message Table
- `idx_message_sender` - Sent messages
- `idx_message_recipient` - Received messages
- `idx_message_sent_at` - Chronological retrieval

### 4. Views

#### vw_property_details
Combines property, location, and host information for easy querying.

**Usage:**
```sql
SELECT * FROM vw_property_details WHERE city = 'New York';
```

#### vw_booking_details
Provides complete booking information with guest, property, and host details.

**Usage:**
```sql
SELECT * FROM vw_booking_details WHERE status = 'confirmed';
```

### 5. Stored Procedures

#### sp_get_available_properties
Finds available properties for a given date range and optional city.

**Parameters:**
- `p_start_date` - Check-in date
- `p_end_date` - Check-out date
- `p_city` - City filter (optional, pass NULL for all cities)

**Usage:**
```sql
CALL sp_get_available_properties('2025-12-01', '2025-12-05', 'New York');
```

## Database Configuration

### Character Set
- **Character Set:** utf8mb4
- **Collation:** utf8mb4_unicode_ci
- **Supports:** Full Unicode including emojis and special characters

### Storage Engine
- **Engine:** InnoDB
- **Benefits:**
  - ACID compliance
  - Foreign key support
  - Row-level locking
  - Crash recovery

## Performance Considerations

### Index Strategy
1. **Primary Keys** - Automatic B-tree indexes
2. **Foreign Keys** - Indexed for join performance
3. **Search Columns** - Indexed (email, city, dates)
4. **Filtering Columns** - Indexed (status, rating, price)
5. **Composite Indexes** - For multi-column queries (dates, coordinates)

### Query Optimization Tips
1. Use views for complex joins
2. Leverage stored procedures for common operations
3. Use EXPLAIN to analyze query execution
4. Monitor slow query log
5. Regularly analyze and optimize tables

### Maintenance Commands

```sql
-- Analyze tables for optimization
ANALYZE TABLE User, Property, Booking, Payment, Review, Message;

-- Optimize tables
OPTIMIZE TABLE User, Property, Booking, Payment, Review, Message;

-- Check table integrity
CHECK TABLE User, Property, Booking, Payment, Review, Message;

-- Repair tables if needed
REPAIR TABLE User, Property, Booking, Payment, Review, Message;
```

## Data Integrity Rules

1. **User Deletion** - Cascades to all related records (properties, bookings, reviews, messages)
2. **Property Deletion** - Cascades to bookings, reviews, and location
3. **Booking Deletion** - Cascades to payments
4. **Date Validation** - End date must be after start date
5. **Price Validation** - All prices must be positive
6. **Rating Validation** - Ratings must be between 1 and 5
7. **Email Uniqueness** - One account per email address

## Testing the Schema

### 1. Verify Table Creation
```sql
SELECT 
    TABLE_NAME,
    TABLE_ROWS,
    ENGINE,
    TABLE_COLLATION
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'airbnb_db'
ORDER BY TABLE_NAME;
```

### 2. Check Indexes
```sql
SELECT 
    TABLE_NAME,
    INDEX_NAME,
    COLUMN_NAME,
    SEQ_IN_INDEX
FROM information_schema.STATISTICS
WHERE TABLE_SCHEMA = 'airbnb_db'
ORDER BY TABLE_NAME, INDEX_NAME, SEQ_IN_INDEX;
```

### 3. Verify Foreign Keys
```sql
SELECT 
    CONSTRAINT_NAME,
    TABLE_NAME,
    COLUMN_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'airbnb_db'
AND REFERENCED_TABLE_NAME IS NOT NULL;
```

### 4. Test Constraints
```sql
-- Test positive price constraint
INSERT INTO Property VALUES (UUID(), UUID(), 'Test', 'Test', -100, NOW(), NOW());
-- Should fail: Check constraint 'pricepernight > 0'

-- Test rating range
INSERT INTO Review VALUES (UUID(), UUID(), UUID(), 10, 'Test', NOW());
-- Should fail: Check constraint 'rating >= 1 AND rating <= 5'

-- Test date logic
INSERT INTO Booking VALUES (UUID(), UUID(), UUID(), '2025-12-05', '2025-12-01', 100, 'pending', NOW());
-- Should fail: Check constraint 'end_date > start_date'
```

## Troubleshooting

### Common Issues

**Issue 1: Foreign Key Constraint Fails**
```
ERROR 1452: Cannot add or update a child row: a foreign key constraint fails
```
**Solution:** Ensure parent record exists before inserting child record.

**Issue 2: Duplicate Entry**
```
ERROR 1062: Duplicate entry for key 'PRIMARY' or 'email'
```
**Solution:** Use unique UUIDs and ensure email uniqueness.

**Issue 3: Data Too Long**
```
ERROR 1406: Data too long for column
```
**Solution:** Check VARCHAR/TEXT length limits and adjust as needed.

## Migration Notes

### Upgrading from Previous Versions
If migrating from an older schema:
1. Backup existing data
2. Export data to CSV/JSON
3. Drop old tables
4. Execute new schema.sql
5. Import data with transformations

### Rollback Strategy
```sql
-- Backup before applying schema
mysqldump -u root -p airbnb_db > backup_$(date +%Y%m%d).sql

-- Rollback if needed
mysql -u root -p airbnb_db < backup_YYYYMMDD.sql
```

## Security Considerations

1. **Password Hashing** - Store only hashed passwords (bcrypt/Argon2)
2. **SQL Injection** - Use prepared statements in application code
3. **Access Control** - Grant minimum required privileges
4. **Data Encryption** - Consider encrypting sensitive fields
5. **Audit Logging** - Enable binary logging for change tracking

## Contributing

When modifying the schema:
1. Document changes in migration scripts
2. Update this README
3. Test with sample data
4. Verify performance impact
5. Update application code accordingly

## Support

For issues or questions:
- Check MySQL error log: `/var/log/mysql/error.log`
- Review slow query log for performance issues
- Use `EXPLAIN` for query optimization
- Consult MySQL documentation: https://dev.mysql.com/doc/

---
