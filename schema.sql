CREATE DATABASE IF NOT EXISTS smart_tour
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE smart_tour;

CREATE TABLE IF NOT EXISTS customers (
  id INT AUTO_INCREMENT PRIMARY KEY,
  full_name VARCHAR(120) NOT NULL,
  email VARCHAR(190) NOT NULL UNIQUE,
  phone VARCHAR(30),
  username VARCHAR(80) NOT NULL UNIQUE,
  password_hash VARCHAR(64) NOT NULL,
  role ENUM('customer','admin') NOT NULL DEFAULT 'customer',
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS destinations (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(120) NOT NULL UNIQUE,
  description TEXT
);

CREATE TABLE IF NOT EXISTS tours (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(180) NOT NULL,
  destination_id INT NOT NULL,
  duration_days INT NOT NULL,
  price_per_person DECIMAL(14,2) NOT NULL,
  description TEXT,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (destination_id) REFERENCES destinations(id)
);

CREATE TABLE IF NOT EXISTS departure_schedules (
  id INT AUTO_INCREMENT PRIMARY KEY,
  tour_id INT NOT NULL,
  departure_date DATE NOT NULL,
  seats_total INT NOT NULL DEFAULT 20,
  seats_available INT NOT NULL DEFAULT 20,
  FOREIGN KEY (tour_id) REFERENCES tours(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS hotels (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(180) NOT NULL,
  address VARCHAR(255),
  star_rating TINYINT NOT NULL DEFAULT 3,
  is_active BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS rooms (
  id INT AUTO_INCREMENT PRIMARY KEY,
  hotel_id INT NOT NULL,
  room_type VARCHAR(100) NOT NULL,
  price_per_night DECIMAL(14,2) NOT NULL,
  max_guests INT NOT NULL DEFAULT 2,
  total_rooms INT NOT NULL DEFAULT 1,
  FOREIGN KEY (hotel_id) REFERENCES hotels(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS hotel_tours (
  hotel_id INT NOT NULL,
  tour_id INT NOT NULL,
  PRIMARY KEY (hotel_id, tour_id),
  FOREIGN KEY (hotel_id) REFERENCES hotels(id) ON DELETE CASCADE,
  FOREIGN KEY (tour_id) REFERENCES tours(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS bookings (
  id INT AUTO_INCREMENT PRIMARY KEY,
  customer_id INT NOT NULL,
  tour_id INT NOT NULL,
  room_id INT,
  check_in DATE NOT NULL,
  check_out DATE NOT NULL,
  guests INT NOT NULL,
  room_count INT NOT NULL DEFAULT 1,
  tour_amount DECIMAL(14,2) NOT NULL,
  room_amount DECIMAL(14,2) NOT NULL DEFAULT 0,
  total_amount DECIMAL(14,2) NOT NULL,
  status ENUM('pending','confirmed','cancelled','completed') NOT NULL DEFAULT 'pending',
  payment_status ENUM('unpaid','paid_simulated','refunded') NOT NULL DEFAULT 'unpaid',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (customer_id) REFERENCES customers(id),
  FOREIGN KEY (tour_id) REFERENCES tours(id),
  FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE SET NULL
);

INSERT IGNORE INTO destinations(name,description) VALUES
('Vũng Tàu','Biển, hải sản và tham quan Bạch Dinh.'),
('Đà Lạt','Khí hậu mát mẻ, thiên nhiên và nghỉ dưỡng.'),
('Đà Nẵng','Biển, thành phố và các điểm tham quan miền Trung.'),
('Nha Trang','Biển và nghỉ dưỡng.'),
('Phú Quốc','Biển đảo và nghỉ dưỡng.');

INSERT INTO tours(name,destination_id,duration_days,price_per_person,description)
SELECT 'Vũng Tàu 3N2Đ tiết kiệm', id, 3, 1200000,
       'Biển, ăn uống, Bạch Dinh và tham quan thành phố.'
FROM destinations WHERE name='Vũng Tàu'
AND NOT EXISTS (SELECT 1 FROM tours WHERE name='Vũng Tàu 3N2Đ tiết kiệm');

INSERT INTO tours(name,destination_id,duration_days,price_per_person,description)
SELECT 'Đà Lạt 3N2Đ', id, 3, 1800000,
       'Thiên nhiên, cà phê, văn hóa và nghỉ dưỡng.'
FROM destinations WHERE name='Đà Lạt'
AND NOT EXISTS (SELECT 1 FROM tours WHERE name='Đà Lạt 3N2Đ');

-- Sau khi tạo schema, tạo admin bằng cách đăng ký một tài khoản bình thường
-- rồi chạy:
-- UPDATE customers SET role='admin' WHERE username='TEN_DANG_NHAP_ADMIN';
