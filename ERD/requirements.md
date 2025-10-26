# AirBnB Clone - Entity-Relationship Diagram

## Overview

This document provides a comprehensive Entity-Relationship (ER) diagram for the AirBnB clone database system. The diagram illustrates the structure of all entities, their attributes, and the relationships between them.

## ER Diagram Entities and Attributes

### 1. USER

**Description:** Represents all users in the system (guests, hosts, and admins).

| Attribute       | Type      | Constraints                          | Description                          |
|----------------|-----------|--------------------------------------|--------------------------------------|
| user_id        | UUID      | PRIMARY KEY, Indexed                 | Unique identifier for each user      |
| first_name     | VARCHAR   | NOT NULL                             | User's first name                    |
| last_name      | VARCHAR   | NOT NULL                             | User's last name                     |
| email          | VARCHAR   | UNIQUE, NOT NULL, Indexed            | User's email address                 |
| password_hash  | VARCHAR   | NOT NULL                             | Encrypted password                   |
| phone_number   | VARCHAR   | NULL                                 | User's contact number                |
| role           | ENUM      | NOT NULL (guest, host, admin)        | User's role in the system            |
| created_at     | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP            | Account creation timestamp           |

---

### 2. PROPERTY

**Description:** Represents properties listed by hosts for rental.

| Attribute      | Type      | Constraints                          | Description                          |
|---------------|-----------|--------------------------------------|--------------------------------------|
| property_id   | UUID      | PRIMARY KEY, Indexed                 | Unique identifier for each property  |
| host_id       | UUID      | FOREIGN KEY → User(user_id)          | Reference to the host (property owner)|
| name          | VARCHAR   | NOT NULL                             | Property name/title                  |
| description   | TEXT      | NOT NULL                             | Detailed property description        |
| location      | VARCHAR   | NOT NULL                             | Property location/address            |
| pricepernight | DECIMAL   | NOT NULL                             | Nightly rental rate                  |
| created_at    | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP            | Property listing creation timestamp  |
| updated_at    | TIMESTAMP | ON UPDATE CURRENT_TIMESTAMP          | Last update timestamp                |

---

### 3. BOOKING
**Description:** Represents reservations made by guests for properties.

| Attribute    | Type      | Constraints                          | Description                          |
|-------------|-----------|--------------------------------------|--------------------------------------|
| booking_id  | UUID      | PRIMARY KEY, Indexed                 | Unique identifier for each booking   |
| property_id | UUID      | FOREIGN KEY → Property(property_id)  | Reference to the booked property     |
| user_id     | UUID      | FOREIGN KEY → User(user_id)          | Reference to the guest making booking|
| start_date  | DATE      | NOT NULL                             | Check-in date                        |
| end_date    | DATE      | NOT NULL                             | Check-out date                       |
| total_price | DECIMAL   | NOT NULL                             | Total booking cost                   |
| status      | ENUM      | NOT NULL (pending, confirmed, canceled)| Booking status                    |
| created_at  | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP            | Booking creation timestamp           |

---

### 4. PAYMENT
**Description:** Represents payment transactions for bookings.

| Attribute      | Type      | Constraints                          | Description                          |
|---------------|-----------|--------------------------------------|--------------------------------------|
| payment_id    | UUID      | PRIMARY KEY, Indexed                 | Unique identifier for each payment   |
| booking_id    | UUID      | FOREIGN KEY → Booking(booking_id)    | Reference to the associated booking  |
| amount        | DECIMAL   | NOT NULL                             | Payment amount                       |
| payment_date  | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP            | Payment transaction timestamp        |
| payment_method| ENUM      | NOT NULL (credit_card, paypal, stripe)| Payment method used                 |

---

### 5. REVIEW

**Description:** Represents reviews and ratings left by guests for properties.

| Attribute    | Type      | Constraints                          | Description                          |
|-------------|-----------|--------------------------------------|--------------------------------------|
| review_id   | UUID      | PRIMARY KEY, Indexed                 | Unique identifier for each review    |
| property_id | UUID      | FOREIGN KEY → Property(property_id)  | Reference to the reviewed property   |
| user_id     | UUID      | FOREIGN KEY → User(user_id)          | Reference to the user who wrote review|
| rating      | INTEGER   | NOT NULL, CHECK (rating >= 1 AND rating <= 5)| Numeric rating (1-5)       |
| comment     | TEXT      | NOT NULL                             | Review text/comment                  |
| created_at  | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP            | Review creation timestamp            |

---

### 6. MESSAGE

**Description:** Represents messages exchanged between users.

| Attribute     | Type      | Constraints                          | Description                          |
|--------------|-----------|--------------------------------------|--------------------------------------|
| message_id   | UUID      | PRIMARY KEY, Indexed                 | Unique identifier for each message   |
| sender_id    | UUID      | FOREIGN KEY → User(user_id)          | Reference to the message sender      |
| recipient_id | UUID      | FOREIGN KEY → User(user_id)          | Reference to the message recipient   |
| message_body | TEXT      | NOT NULL                             | Message content                      |
| sent_at      | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP            | Message sent timestamp               |

---

## Relationships

### 1. User → Property (One-to-Many)

- **Relationship:** A user (host) can list multiple properties.
- **Cardinality:** 1 User : * Properties
- **Foreign Key:** Property.host_id → User.user_id
- **Description:** Each property must be owned by exactly one host, but a host can own multiple properties.

---

### 2. User → Booking (One-to-Many)

- **Relationship:** A user (guest) can make multiple bookings.
- **Cardinality:** 1 User : * Bookings
- **Foreign Key:** Booking.user_id → User.user_id
- **Description:** Each booking is made by exactly one guest, but a guest can have multiple bookings.

---

### 3. Property → Booking (One-to-Many)

- **Relationship:** A property can have multiple bookings.
- **Cardinality:** 1 Property : * Bookings
- **Foreign Key:** Booking.property_id → Property.property_id
- **Description:** Each booking is for exactly one property, but a property can be booked multiple times.

---

### 4. Booking → Payment (One-to-One)

- **Relationship:** Each booking has exactly one payment.
- **Cardinality:** 1 Booking : 1 Payment
- **Foreign Key:** Payment.booking_id → Booking.booking_id
- **Description:** Each payment is associated with exactly one booking, and each booking has one payment record.

---

### 5. Property → Review (One-to-Many)

- **Relationship:** A property can have multiple reviews.
- **Cardinality:** 1 Property : * Reviews
- **Foreign Key:** Review.property_id → Property.property_id
- **Description:** Each review is for exactly one property, but a property can have multiple reviews from different guests.

---

### 6. User → Review (One-to-Many)

- **Relationship:** A user can write multiple reviews.
- **Cardinality:** 1 User : * Reviews
- **Foreign Key:** Review.user_id → User.user_id
- **Description:** Each review is written by exactly one user, but a user can write multiple reviews for different properties.

---

### 7. User → Message (One-to-Many) [Sender]

- **Relationship:** A user can send multiple messages.
- **Cardinality:** 1 User : * Messages
- **Foreign Key:** Message.sender_id → User.user_id
- **Description:** Each message has exactly one sender, but a user can send multiple messages.

---

### 8. User → Message (One-to-Many) [Recipient]

- **Relationship:** A user can receive multiple messages.
- **Cardinality:** 1 User : * Messages
- **Foreign Key:** Message.recipient_id → User.user_id
- **Description:** Each message has exactly one recipient, but a user can receive multiple messages.

---

## Indexing Strategy

The following indexes are implemented for optimal query performance:

1. **Primary Keys:** All primary keys (user_id, property_id, booking_id, payment_id, review_id, message_id) are automatically indexed.

2. **User Table:**
   - Index on `email` for fast user lookup during authentication.

3. **Property Table:**
   - Index on `property_id` for efficient property queries.

4. **Booking Table:**
   - Index on `property_id` for property-specific booking queries.
   - Index on `booking_id` for payment linkage.

5. **Payment Table:**
   - Index on `booking_id` for payment-booking relationship queries.

---

## Constraints Summary

### User Table

- `email` must be UNIQUE
- `first_name`, `last_name`, `email`, `password_hash`, and `role` are NOT NULL

### Property Table

- `host_id` FOREIGN KEY constraint references User(user_id)
- `name`, `description`, `location`, and `pricepernight` are NOT NULL

### Booking Table

- `property_id` FOREIGN KEY references Property(property_id)
- `user_id` FOREIGN KEY references User(user_id)
- `status` must be one of: pending, confirmed, canceled
- All date and price fields are NOT NULL

### Payment Table

- `booking_id` FOREIGN KEY references Booking(booking_id)
- `payment_method` must be one of: credit_card, paypal, stripe
- All fields are NOT NULL

### Review Table

- `property_id` FOREIGN KEY references Property(property_id)
- `user_id` FOREIGN KEY references User(user_id)
- `rating` must be between 1 and 5 (CHECK constraint)
- All fields are NOT NULL

### Message Table

- `sender_id` FOREIGN KEY references User(user_id)
- `recipient_id` FOREIGN KEY references User(user_id)
- `message_body` is NOT NULL

---

## Design Principles Applied

### 1. Entity Identification

All major business objects (User, Property, Booking, Payment, Review, Message) have been identified and modeled as separate entities.

### 2. Attribute Definition

Each entity has well-defined attributes with appropriate data types, constraints, and default values.

### 3. Relationship Establishment

ed using foreign keys:
- One-to-Many: User-Property, User-Booking, Property-Booking, Property-Review, User-Review, User-Message
- One-to-One: Booking-Payment

### 4. Data Integrity

- Primary keys ensure unique identification
- Foreign keys maintain referential integrity
- CHECK constraints validate data ranges (e.g., rating 1-5)
- NOT NULL constraints prevent missing critical data
- UNIQUE constraints prevent duplicates (e.g., email)

### 5. Normalization

The database design follows Third Normal Form (3NF):

- **1NF:** All attributes contain atomic values
- **2NF:** No partial dependencies on composite keys
- **3NF:** No transitive dependencies; all non-key attributes depend only on primary keys

---

## Notes for Implementation

1. **UUID Usage:** All primary keys use UUID for global uniqueness and better distribution across distributed systems.

2. **ENUM Types:** Used for fixed-value fields (role, status, payment_method) to ensure data consistency.

3. **Timestamps:** Automatic timestamp tracking for audit trails and record history.

4. **Indexing:** Strategic indexes on foreign keys and frequently queried fields improve performance.

5. **Scalability:** The design supports horizontal scaling and can be extended with additional entities as needed.

---

## Visual Diagram Tool

This ER diagram can be recreated in **Draw.io** or similar tools using the following steps:

1. Create rectangles for each entity (User, Property, Booking, Payment, Review, Message)
2. List attributes inside each rectangle with PK/FK designations
3. Draw lines connecting related entities
4. Label relationships with cardinality (1:1, 1:*, *:*)
5. Add crow's foot notation for many relationships
6. Use different colors to distinguish entity types

