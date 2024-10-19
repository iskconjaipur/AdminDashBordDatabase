-- Create the database
CREATE DATABASE IF NOT EXISTS donation_system;

-- Use the newly created database
USE donation_system;

-- Create the roles table
CREATE TABLE roles (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(50) UNIQUE NOT NULL
);

-- Create the referrals table
CREATE TABLE referrals (
    referral_id VARCHAR(100) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    contact VARCHAR(15) NOT NULL,
	isDeleted BOOLEAN DEFAULT FALSE,
    referral_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Create the users table with isDeleted column
CREATE TABLE users (
    user_id VARCHAR(100) PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    contact VARCHAR(15) UNIQUE NOT NULL,
    address TEXT NOT NULL,
    pan_card VARCHAR(10),
    is_verified BOOLEAN DEFAULT FALSE,
    isDeleted BOOLEAN DEFAULT FALSE,
    role_id INT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES roles(role_id)
);

-- Add indexes to the users table
CREATE INDEX idx_users_contact ON users(contact);
CREATE INDEX idx_users_isDeleted ON users(isDeleted);
CREATE INDEX idx_users_created_at ON users(created_at);

-- Create the user authentication table
CREATE TABLE user_auth (
    user_id VARCHAR(100) PRIMARY KEY,
    password_hash VARCHAR(255) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Create the user tokens table
CREATE TABLE user_tokens (
    user_id VARCHAR(100),
    token VARCHAR(255) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Add an index to the user tokens table
CREATE INDEX idx_user_tokens_user_id ON user_tokens(user_id);

-- Create the donation purposes table
CREATE TABLE donation_purposes (
    purpose_id INT AUTO_INCREMENT PRIMARY KEY,
    purpose_name VARCHAR(255) UNIQUE NOT NULL
);

-- Create the slots table
CREATE TABLE slots (
    slot_id INT AUTO_INCREMENT PRIMARY KEY,
    purpose_id INT,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    FOREIGN KEY (purpose_id) REFERENCES donation_purposes(purpose_id)
);

-- Add indexes to the slots table
CREATE INDEX idx_slots_purpose_id ON slots(purpose_id);

-- Create the donations table
CREATE TABLE donations (
    donation_id VARCHAR(100) PRIMARY KEY,
    user_id VARCHAR(100),
    transaction_id VARCHAR(100),
    amount DECIMAL(10, 2) NOT NULL,
    donation_time DATETIME NOT NULL,
    purpose_id INT,
    referral_id VARCHAR(100),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (purpose_id) REFERENCES donation_purposes(purpose_id),
    FOREIGN KEY (referral_id) REFERENCES referrals(referral_id)
);

-- Add indexes to the donations table
CREATE INDEX idx_donations_user_id ON donations(user_id);
CREATE INDEX idx_donations_purpose_id ON donations(purpose_id);
CREATE INDEX idx_donations_referral_id ON donations(referral_id);
CREATE INDEX idx_donations_donation_time ON donations(donation_time);

-- Create the bookings table with additional columns
CREATE TABLE bookings (
    booking_id VARCHAR(100) PRIMARY KEY,
    donation_id VARCHAR(100),
    user_id VARCHAR(100),
    slot_id INT,
    booking_time DATETIME NOT NULL,
    is_completed BOOLEAN DEFAULT FALSE,
    completion_time DATETIME,
    delivery_address VARCHAR(100),  
    pray_for VARCHAR(255),    
    youtube_link VARCHAR(255),
	is_prasadam_delivered BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (donation_id) REFERENCES donations(donation_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (slot_id) REFERENCES slots(slot_id)
);

-- Add indexes to the bookings table
CREATE INDEX idx_bookings_donation_id ON bookings(donation_id);
CREATE INDEX idx_bookings_user_id ON bookings(user_id);
CREATE INDEX idx_bookings_slot_id ON bookings(slot_id);
CREATE INDEX idx_bookings_booking_time ON bookings(booking_time);

-- Create the feedback table
CREATE TABLE feedback (
    feedback_id VARCHAR(100) PRIMARY KEY,
    booking_id VARCHAR(100),
    rating INT NOT NULL,
    comments TEXT,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
);

-- Add an index to the feedback table
CREATE INDEX idx_feedback_booking_id ON feedback(booking_id);

-- Create the queries table
CREATE TABLE queries (
    query_id VARCHAR(100) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    contact VARCHAR(15) NOT NULL,
    query_text TEXT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Add an index to the queries table
CREATE INDEX idx_queries_contact ON queries(contact);
CREATE INDEX idx_queries_created_at ON queries(created_at);

-- Create the yajna_sanskar table
CREATE TABLE yajna_sanskar (
    yajna_id VARCHAR(100) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    contact VARCHAR(15) NOT NULL,
    yajna_details TEXT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Add an index to the yajna_sanskar table
CREATE INDEX idx_yajna_sanskar_contact ON yajna_sanskar(contact);
CREATE INDEX idx_yajna_sanskar_created_at ON yajna_sanskar(created_at);

-- Insert initial roles
INSERT INTO roles (role_name) VALUES 
('admin'),
('user');

-- Insert initial admin user
INSERT INTO users (user_id, first_name, last_name, email, contact, address, pan_card, is_verified, role_id, created_at)
VALUES 
('DBD564B5B226', 'ISKCON', 'Jaipur', 'iskconjaipur@example.com', '9090909090', 'ISKCON Jaipur', 'ABCDE1234F', TRUE, 1, '2024-08-18 10:43:45');

-- Insert user authentication for admin
INSERT INTO user_auth (user_id, password_hash)
VALUES 
('DBD564B5B226', '$2b$10$xkDeBsXbKo0xRbd6239Jvedo7CJ9cNIcupFN9rVg1Nq5K5fP2K.RO');

-- Insert donation purposes
INSERT INTO donation_purposes (purpose_name) VALUES 
('All Aarti Of The Day'),
('All Bhog Offering'),
('Nitya Seva - Sandhya Aarti'),
('Nitya Seva - Shayan Aarti'),
('Special Pooja - 108 Naam Seva'),
('Special Pooja - Giriraj Panchamrita Abhisheka'),
('Special Pooja - Balarama Kavach Pooja'),
('Special Pooja - Priti Bhog'),
('Special Pooja - Gau Pooja'),
('Festival - Balarama Poornima'),
('Festival - Janmasthami'),
('Festival - Radhasthami'),
('Festival - Gaur Poornima'),
('Festival - Rath Yatra');

-- Insert slots for each donation purpose with the same time range (4:30 AM to 9:00 PM)
INSERT INTO slots (purpose_id, start_time, end_time) VALUES
(1, '04:30:00', '21:00:00'),  -- All Aarti Of The Day
(2, '04:30:00', '21:00:00'),  -- All Bhog Offering
(3, '04:30:00', '21:00:00'),  -- Nitya Seva - Sandhya Aarti
(4, '04:30:00', '21:00:00'),  -- Nitya Seva - Shayan Aarti
(5, '04:30:00', '21:00:00'),  -- Special Pooja - 108 Naam Seva
(6, '04:30:00', '21:00:00'),  -- Special Pooja - Giriraj Panchamrita Abhisheka
(7, '04:30:00', '21:00:00'),  -- Special Pooja - Balarama Kavach Pooja
(8, '04:30:00', '21:00:00'),  -- Special Pooja - Priti Bhog
(9, '04:30:00', '21:00:00'),  -- Special Pooja - Gau Pooja
(10, '04:30:00', '21:00:00'), -- Festival - Balarama Poornima
(11, '04:30:00', '21:00:00'), -- Festival - Janmasthami
(12, '04:30:00', '21:00:00'), -- Festival - Radhasthami
(13, '04:30:00', '21:00:00'), -- Festival - Gaur Poornima
(14, '04:30:00', '21:00:00'); -- Festival - Rath Yatra

-- Stored Procedure to Get Donations and Bookings Report
DELIMITER //

CREATE PROCEDURE GetDonationsAndBookingsReport(IN startDate DATETIME, IN endDate DATETIME)
BEGIN
    -- Declare variables to hold results
    DECLARE userCount INT;
    DECLARE bookingCount INT;
    DECLARE totalDonation DECIMAL(10, 2);
    DECLARE yajnaCount INT;

    -- Get the number of users who registered within the date range
    SELECT COUNT(*) INTO userCount
    FROM users
    WHERE created_at BETWEEN startDate AND endDate
      AND isDeleted = FALSE;

    -- Get the number of bookings within the date range
    SELECT COUNT(*) INTO bookingCount
    FROM bookings
    WHERE booking_time BETWEEN startDate AND endDate;

    -- Get the total donation amount within the date range
    SELECT SUM(amount) INTO totalDonation
    FROM donations
    WHERE donation_time BETWEEN startDate AND endDate;

    -- Get the total number of yajna sanskar entries within the date range
    SELECT COUNT(*) INTO yajnaCount
    FROM yajna_sanskar
    WHERE created_at BETWEEN startDate AND endDate;

    -- Output the results
    SELECT 
        userCount AS 'Number of Users Registered',
        bookingCount AS 'Number of Bookings',
        totalDonation AS 'Total Donation Amount',
        yajnaCount AS 'Number of Yajna Sanskar Entries';

    -- Get the referral statistics
    SELECT 
        r.referral_id,
        r.name AS 'User Name',
        COUNT(d.referral_id) AS 'Number of Referrals',
        IFNULL(SUM(d.amount), 0) AS 'Total Referral Donations'
    FROM referrals r
    LEFT JOIN donations d ON r.referral_id = d.referral_id
    WHERE d.donation_time BETWEEN startDate AND endDate
      AND r.isDeleted = FALSE
    GROUP BY r.referral_id
    ORDER BY 'Total Referral Donations' DESC;

END //

DELIMITER ;
