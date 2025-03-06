-- Create a "users" table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(70) NOT NULL,
    last_name VARCHAR(70) NOT NULL,
    email VARCHAR(70) NOT NULL,
    password VARCHAR(70) NOT NULL,
    age INT NOT NULL
);

-- Create a "connections" table
CREATE TABLE connections (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    friend_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (user_id, friend_id)
);

-- Create a "establishments" table
CREATE TABLE establishments (
    id SERIAL PRIMARY KEY,
    name VARCHAR(70) NOT NULL,
    address VARCHAR(70) NOT NULL,
    phone VARCHAR(70) NOT NULL,
    email VARCHAR(70) NOT NULL,
    website VARCHAR(70) NOT NULL
);

-- Create a "locations" table
CREATE TABLE locations (
    id SERIAL PRIMARY KEY,
    latitude FLOAT,
    longitude FLOAT,
    timestamp TIMESTAMP,
    user_id INT NOT NULL,
    weight FLOAT
);

-- Insert example data
INSERT INTO users (first_name, last_name, email, password, age) VALUES 
('Alice', 'Smith', 'alice.smith@example.com', 'password123', 30),
('Bob', 'Johnson', 'bob.johnson@example.com', 'password456', 25),
('Charlie', 'Brown', 'charlie.brown@example.com', 'password789', 28),
('David', 'Lee', 'david.lee@example.com', 'securepass', 35),
('Emma', 'Watson', 'emma.watson@example.com', 'magicword', 29);

INSERT INTO connections (user_id, friend_id, created_at) VALUES 
(1, 2, '2025-01-01 10:00:00'),
(1, 3, '2025-01-02 14:30:00'),
(2, 3, '2025-01-03 16:45:00'),
(3, 4, '2025-01-04 18:20:00'),
(4, 5, '2025-01-05 12:00:00'),
(5, 1, '2025-01-06 09:15:00'),
(2, 5, '2025-01-07 11:30:00');

-- Insert bidirectional connections
INSERT INTO connections (user_id, friend_id, created_at) VALUES 
(2, 1, '2025-01-01 10:00:00'),
(3, 1, '2025-01-02 14:30:00'),
(3, 2, '2025-01-03 16:45:00'),
(4, 3, '2025-01-04 18:20:00'),
(5, 4, '2025-01-05 12:00:00'),
(1, 5, '2025-01-06 09:15:00'),
(5, 2, '2025-01-07 11:30:00');

INSERT INTO establishments (name, address, phone, email, website) VALUES 
('The Cozy Café', '123 Main St', '555-1234', 'contact@cozycafe.com', 'www.cozycafe.com'),
('Central Library', '456 Elm St', '555-5678', 'info@centrallibrary.com', 'www.centrallibrary.com'),
('Green Park', '789 Oak St', '555-9101', 'contact@greenpark.com', 'www.greenpark.com'),
('Fitness Center', '321 Maple Ave', '555-2233', 'info@fitnesscenter.com', 'www.fitnesscenter.com'),
('Movie Theater', '654 Pine St', '555-4455', 'support@movietheater.com', 'www.movietheater.com');

INSERT INTO locations (latitude, longitude, timestamp, user_id, weight) VALUES 
(37.7749, -122.4194, '2025-01-01 10:30:00', 1, 1.0), -- Alice
(40.7128, -74.0060, '2025-01-01 12:00:00', 2, 1.5), -- Bob
(34.0522, -118.2437, '2025-01-01 14:15:00', 3, 1.0), -- Charlie
(51.5074, -0.1278, '2025-01-01 16:45:00', 4, 0.8), -- David
(48.8566, 2.3522, '2025-01-01 18:30:00', 5, 1.2); -- Emma
