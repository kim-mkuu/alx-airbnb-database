# Database Normalization - AirBnB Clone

## Overview

This document provides a comprehensive analysis of the AirBnB clone database schema normalization process. The goal is to ensure the database is in **Third Normal Form (3NF)** to eliminate redundancy, prevent anomalies, and ensure data integrity.

---

## Normalization Fundamentals

### First Normal Form (1NF)

**Requirements:**

- Each column contains atomic (indivisible) values
- Each column contains values of a single type
- Each column has a unique name
- The order of rows doesn't matter
- No repeating groups or arrays

### Second Normal Form (2NF)

**Requirements:**

- Must be in 1NF
- All non-key attributes must be fully functionally dependent on the entire primary key
- No partial dependencies (relevant only for composite primary keys)

### Third Normal Form (3NF)

**Requirements:**

- Must be in 2NF
- No transitive dependencies (non-key attributes should not depend on other non-key attributes)
- All non-key attributes must depend directly on the primary key only

---

## Initial Schema Analysis

### Current Database Structure

#### 1. USER Table

```txt
user_id (PK)
first_name
last_name
email
password_hash
phone_number
role
created_at
```

#### 2. PROPERTY Table

```txt
property_id (PK)
host_id (FK → User)
name
description
location
pricepernight
created_at
updated_at
```

#### 3. BOOKING Table

```txt
booking_id (PK)
property_id (FK → Property)
user_id (FK → User)
start_date
end_date
total_price
status
created_at
```

#### 4. PAYMENT Table

```txt
payment_id (PK)
booking_id (FK → Booking)
amount
payment_date
payment_method
```

#### 5. REVIEW Table

```txt
review_id (PK)
property_id (FK → Property)
user_id (FK → User)
rating
comment
created_at
```

#### 6. MESSAGE Table

```txt
message_id (PK)
sender_id (FK → User)
recipient_id (FK → User)
message_body
sent_at
```

---

## Normalization Analysis by Entity

### 1. USER Table - ✅ Already in 3NF

**1NF Check:**

- ✅ All attributes are atomic
- ✅ No repeating groups
- ✅ Each column has a single value type

**2NF Check:**

- ✅ Single attribute primary key (user_id)
- ✅ No partial dependencies possible

**3NF Check:**

- ✅ No transitive dependencies
- ✅ All attributes directly depend on user_id

**Functional Dependencies:**

```txt
user_id → first_name
user_id → last_name
user_id → email
user_id → password_hash
user_id → phone_number
user_id → role
user_id → created_at
```

**Conclusion:** No modifications needed. The USER table is in 3NF.

---

### 2. PROPERTY Table - ⚠️ Requires Analysis

**Initial Analysis:**

**1NF Check:**

- ✅ All attributes are atomic
- ⚠️ `location` might contain composite data (address, city, state, country, zip)

**Issue Identified:** The `location` attribute is stored as a single VARCHAR field, which may contain multiple pieces of information (street, city, state, country, postal code).

**Normalization Action Required:**

**Before (Potential 1NF Violation):**

```sql
PROPERTY
  property_id (PK)
  host_id (FK)
  name
  description
  location  -- "123 Main St, New York, NY, 10001, USA"
  pricepernight
  created_at
  updated_at
```

**After (1NF Compliant):**

```sql
PROPERTY
  property_id (PK)
  host_id (FK)
  name
  description
  pricepernight
  created_at
  updated_at

LOCATION
  location_id (PK)
  property_id (FK → Property) UNIQUE
  street_address
  city
  state
  country
  postal_code
  latitude
  longitude
```

**Rationale:**

- Separating location into atomic components allows for better querying (e.g., "Find all properties in New York")
- Supports geospatial searches
- Maintains 1NF by ensuring atomic values
- Creates a 1:1 relationship between Property and Location

**2NF Check:**

- ✅ Single attribute primary key
- ✅ No partial dependencies

**3NF Check:**

- ✅ No transitive dependencies after location normalization
- ✅ All attributes depend directly on property_id

**Final Status:** ✅ Now in 3NF after location decomposition

---

### 3. BOOKING Table - ⚠️ Contains Calculated Field

**Initial Analysis:**

**1NF Check:**

- ✅ All attributes are atomic

**2NF Check:**

- ✅ Single attribute primary key
- ✅ No partial dependencies

**3NF Check:**

- ⚠️ `total_price` can be calculated from `pricepernight`, `start_date`, and `end_date`
- ⚠️ This creates a potential transitive dependency

**Issue Identified:**

```txt
booking_id → property_id → pricepernight
booking_id → start_date, end_date
total_price = pricepernight × (end_date - start_date)
```

Therefore: `total_price` is transitively dependent on `property_id` and dates.

**Normalization Options:**

**Option 1: Remove total_price (Strict 3NF):**

```sql
BOOKING
  booking_id (PK)
  property_id (FK)
  user_id (FK)
  start_date
  end_date
  -- total_price removed (calculate on-the-fly)
  status
  created_at
```

**Option 2: Keep total_price as a Denormalized Field (Practical Approach):**

```sql
BOOKING
  booking_id (PK)
  property_id (FK)
  user_id (FK)
  start_date
  end_date
  total_price  -- Stored for historical accuracy
  status
  created_at
```

**Recommended Approach: Option 2 (Controlled Denormalization):**

**Rationale:**

- **Historical Accuracy:** Property prices may change over time. Storing `total_price` at booking time preserves the actual amount charged.
- **Performance:** Avoids complex calculations on every query
- **Business Logic:** The price at booking time may include discounts, special rates, or seasonal pricing that differ from current `pricepernight`
- **Audit Trail:** Maintains financial records accurately

**Additional Enhancement:**
Add `price_per_night` to BOOKING to capture the rate at booking time:

```sql
BOOKING
  booking_id (PK)
  property_id (FK)
  user_id (FK)
  start_date
  end_date
  price_per_night  -- Rate at time of booking
  total_price      -- Total amount charged
  status
  created_at
```

This ensures complete independence from PROPERTY table for historical bookings.

**Final Status:** ✅ In 3NF with justified denormalization for business requirements

---

### 4. PAYMENT Table - ⚠️ Requires Analysis

**Initial Analysis:**

**1NF Check:**

- ✅ All attributes are atomic

**2NF Check:**

- ✅ Single attribute primary key
- ✅ No partial dependencies

**3NF Check:**

- ⚠️ `amount` might be derived from `booking.total_price`

**Issue Identified:**
```
payment_id → booking_id → total_price
payment_id → amount
```

If `amount` always equals `booking.total_price`, there's redundancy.

**Normalization Decision:**

**Keep amount field (Recommended):**

**Rationale:**

- **Partial Payments:** A booking may have multiple payments (deposit + final payment)
- **Refunds:** Negative amounts for cancellations
- **Payment Flexibility:** Amount may differ from total_price due to discounts, fees, or adjustments
- **Financial Independence:** Payment records should be independent of booking modifications

**Enhanced Schema:**

```sql
PAYMENT
  payment_id (PK)
  booking_id (FK → Booking)
  amount           -- Can be partial, full, or refund
  payment_date
  payment_method
  payment_status   -- NEW: (pending, completed, failed, refunded)
  transaction_id   -- NEW: External payment gateway reference
```

**Final Status:** ✅ In 3NF with business-justified independence

---

### 5. REVIEW Table - ✅ Already in 3NF

**1NF Check:**

- ✅ All attributes are atomic

**2NF Check:**

- ✅ Single attribute primary key
- ✅ No partial dependencies

**3NF Check:**

- ✅ No transitive dependencies
- ✅ All attributes directly depend on review_id

**Functional Dependencies:**

```txt
review_id → property_id
review_id → user_id
review_id → rating
review_id → comment
review_id → created_at
```

**Conclusion:** No modifications needed. The REVIEW table is in 3NF.

---

### 6. MESSAGE Table - ✅ Already in 3NF

**1NF Check:**

- ✅ All attributes are atomic

**2NF Check:**

- ✅ Single attribute primary key
- ✅ No partial dependencies

**3NF Check:**

- ✅ No transitive dependencies
- ✅ All attributes directly depend on message_id

**Functional Dependencies:**

```txt
message_id → sender_id
message_id → recipient_id
message_id → message_body
message_id → sent_at
```

**Conclusion:** No modifications needed. The MESSAGE table is in 3NF.

---

## Final Normalized Schema (3NF)

### Entity Summary

#### 1. USER (No Changes)

```sql
CREATE TABLE User (
    user_id UUID PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20),
    role ENUM('guest', 'host', 'admin') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_email (email)
);
```

#### 2. PROPERTY (Modified - Location Extracted)

```sql
CREATE TABLE Property (
    property_id UUID PRIMARY KEY,
    host_id UUID NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    pricepernight DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (host_id) REFERENCES User(user_id) ON DELETE CASCADE,
    INDEX idx_host (host_id)
);
```

#### 3. LOCATION (New Table - 1NF Compliance)

```sql
CREATE TABLE Location (
    location_id UUID PRIMARY KEY,
    property_id UUID UNIQUE NOT NULL,
    street_address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    FOREIGN KEY (property_id) REFERENCES Property(property_id) ON DELETE CASCADE,
    INDEX idx_city (city),
    INDEX idx_country (country)
);
```

#### 4. BOOKING (Enhanced - Historical Price Storage)

```sql
CREATE TABLE Booking (
    booking_id UUID PRIMARY KEY,
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    price_per_night DECIMAL(10, 2) NOT NULL,  -- NEW: Historical rate
    total_price DECIMAL(10, 2) NOT NULL,
    status ENUM('pending', 'confirmed', 'canceled') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (property_id) REFERENCES Property(property_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE,
    INDEX idx_property (property_id),
    INDEX idx_user (user_id),
    INDEX idx_dates (start_date, end_date)
);
```

#### 5. PAYMENT (Enhanced - Additional Tracking)

```sql
CREATE TABLE Payment (
    payment_id UUID PRIMARY KEY,
    booking_id UUID NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method ENUM('credit_card', 'paypal', 'stripe') NOT NULL,
    payment_status ENUM('pending', 'completed', 'failed', 'refunded') DEFAULT 'pending',  -- NEW
    transaction_id VARCHAR(255),  -- NEW: External reference
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id) ON DELETE CASCADE,
    INDEX idx_booking (booking_id),
    INDEX idx_transaction (transaction_id)
);
```

#### 6. REVIEW (No Changes)

```sql
CREATE TABLE Review (
    review_id UUID PRIMARY KEY,
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (property_id) REFERENCES Property(property_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE,
    INDEX idx_property (property_id),
    INDEX idx_user (user_id)
);
```

#### 7. MESSAGE (No Changes)

```sql
CREATE TABLE Message (
    message_id UUID PRIMARY KEY,
    sender_id UUID NOT NULL,
    recipient_id UUID NOT NULL,
    message_body TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sender_id) REFERENCES User(user_id) ON DELETE CASCADE,
    FOREIGN KEY (recipient_id) REFERENCES User(user_id) ON DELETE CASCADE,
    INDEX idx_sender (sender_id),
    INDEX idx_recipient (recipient_id)
);
```

---

## Normalization Summary

### Changes Made

| Entity | Original Status | Issues Found | Action Taken | Final Status |
|--------|----------------|--------------|--------------|--------------|
| USER | 3NF | None | No changes | ✅ 3NF |
| PROPERTY | ~2NF | Location not atomic | Extracted LOCATION table | ✅ 3NF |
| LOCATION | N/A | N/A | New table created | ✅ 3NF |
| BOOKING | ~3NF | Calculated field | Added historical price fields | ✅ 3NF* |
| PAYMENT | ~3NF | Potential redundancy | Enhanced with status tracking | ✅ 3NF* |
| REVIEW | 3NF | None | No changes | ✅ 3NF |
| MESSAGE | 3NF | None | No changes | ✅ 3NF |

*With justified controlled denormalization for business requirements

---

## Key Normalization Decisions

### 1. Location Decomposition (1NF Compliance)

**Decision:** Extract location data into a separate table with atomic attributes.

**Benefits:**

- Enables granular location-based queries
- Supports geospatial searches
- Allows for location data updates without modifying property records
- Maintains data atomicity

### 2. Historical Price Storage (Controlled Denormalization)

**Decision:** Keep `total_price` and add `price_per_night` in BOOKING table.

**Benefits:**

- Preserves historical pricing accuracy
- Protects against price changes in PROPERTY table
- Maintains audit trail for financial transactions
- Improves query performance

**Trade-off:** Slight redundancy for significant business value

### 3. Payment Independence

**Decision:** Keep `amount` field independent from `booking.total_price`.

**Benefits:**

- Supports partial payments and installments
- Enables refund tracking
- Allows payment adjustments
- Maintains financial record integrity

---

## Verification of 3NF Compliance

### Checklist for Each Table

#### ✅ First Normal Form (1NF)

- [x] All attributes contain atomic values
- [x] No repeating groups
- [x] Each column contains single-valued data
- [x] Each record is unique (enforced by primary key)

#### ✅ Second Normal Form (2NF)

- [x] All tables are in 1NF
- [x] All non-key attributes are fully dependent on the primary key
- [x] No partial dependencies (all tables use single-attribute primary keys)

#### ✅ Third Normal Form (3NF)

- [x] All tables are in 2NF
- [x] No transitive dependencies exist
- [x] All non-key attributes depend only on the primary key
- [x] Controlled denormalization is documented and justified

---

## Benefits of Normalized Design

### 1. Data Integrity

- Eliminates update anomalies
- Prevents insertion anomalies
- Avoids deletion anomalies
- Ensures referential integrity through foreign keys

### 2. Storage Efficiency

- Reduces data redundancy
- Minimizes storage requirements
- Optimizes disk usage

### 3. Maintainability

- Simplifies database updates
- Reduces potential for inconsistencies
- Makes schema easier to understand and modify

### 4. Query Flexibility

- Atomic location data enables complex location-based queries
- Historical pricing supports accurate reporting
- Independent payment records support financial analysis

### 5. Scalability

- Normalized structure scales better with data growth
- Indexing strategies are more effective
- Supports horizontal partitioning if needed

---

## Potential Denormalization Considerations

While the current schema is in 3NF, here are scenarios where controlled denormalization might be considered in the future:

### 1. Property Average Rating (Read-Heavy Operations)

```sql
-- Could add to PROPERTY table for performance:
ALTER TABLE Property ADD COLUMN average_rating DECIMAL(3, 2);
ALTER TABLE Property ADD COLUMN review_count INTEGER;
```

**Trade-off:** Update overhead vs. query performance

### 2. User Statistics

```sql
-- Could add to USER table:
ALTER TABLE User ADD COLUMN total_bookings INTEGER;
ALTER TABLE User ADD COLUMN properties_hosted INTEGER;
```

**Trade-off:** Calculated fields vs. aggregation query cost

### 3. Booking Guest Information Snapshot

```sql
-- For GDPR compliance and user deletion:
ALTER TABLE Booking ADD COLUMN guest_name_snapshot VARCHAR(255);
ALTER TABLE Booking ADD COLUMN guest_email_snapshot VARCHAR(255);
```

**Trade-off:** Data duplication vs. historical record preservation

---

## Conclusion

The AirBnB clone database has been successfully normalized to **Third Normal Form (3NF)** with the following key improvements:

1. **Location Data Decomposition:** Extracted location into a separate table ensuring atomic values and 1NF compliance
2. **Historical Price Preservation:** Added `price_per_night` to BOOKING for accurate historical records
3. **Payment Enhancement:** Enhanced PAYMENT table with status and transaction tracking
4. **Controlled Denormalization:** Justified retention of calculated fields for business requirements

The normalized schema eliminates redundancy, prevents anomalies, ensures data integrity, and provides a solid foundation for a scalable, maintainable database system.
