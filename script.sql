DROP DATABASE IF EXISTS foodpanda;
CREATE DATABASE IF NOT EXISTS foodpanda;
USE foodpanda;

-- Tabela Partener:
CREATE TABLE IF NOT EXISTS partner(
partner_id INT NOT NULL AUTO_INCREMENT,
name VARCHAR(50) NOT NULL,
city VARCHAR(50) NOT NULL,
address VARCHAR(200) NOT NULL,
phone INT(10) zerofill NOT NULL ,
opening_time TIME NOT NULL,
closing_time TIME NOT NULL,
PRIMARY KEY(partner_id),
CHECK(phone > 99999999)
);

INSERT INTO partner(name, city, address, phone, opening_time, closing_time) VALUES
('KFC', 'Bucuresti', 'Strada Puiului nr.10', 0734567899, '10:00', '22:00'),
('Shaormeria Kogalniceanu', 'Bucuresti', 'Strada Mihail Kogalniceanu nr 23', 0712489670, '08:00', '08:00'), 
('La Placinte', 'Bucuresti', 'Bulevardul Doina Cornea 4E', 0756207005, '10:00', '22:00'),
('Ciorbarie', 'Bucuresti', 'Calea Dorobanti 73', 0725067447, '11:00', '21:00'),
('Pizza Hut', 'Bucuresti', 'Bulevardul Regina Elisabeta 15-19', 0740121903,'10:00', '22:00');

CREATE TABLE IF NOT EXISTS product(
product_id int AUTO_INCREMENT,
partner_id int,
name VARCHAR(100) NOT NULL,
price FLOAT NOT NULL,
weight int,
PRIMARY KEY(product_id),
FOREIGN KEY(partner_id) REFERENCES partner(partner_id)
  ON DELETE CASCADE ON UPDATE CASCADE,
CHECK(price >= 0)
);

INSERT INTO product(partner_id, name, price, weight) VALUES
(1, 'hot booster', 5.5, 125),
(1, 'crispy sandwich', 6, 130),
(1, 'snack box', 13, NULL),
(2, 'shaorma mica', 8, 100),
(2, 'shaorma medie', 10, 150),
(2, 'shaorma mare', 13, 200),
(3, 'carne de curcan cu varza calita', 49, NULL),
(3, 'fasole cu afumaturi', 35, NULL),
(3, 'tocana de porc cu mamaliga', 55, NULL),
(4, 'ciorba de burta', 20, NULL),
(4, 'ciorba de vaca', 21, NULL),
(4, 'ciorba de curcan a la grec', 20, NULL),
(5, 'pizza margherita mica', 18, 200),
(5, 'pizza europeana medie', 35.5, 300),
(5, 'pizza california mare', 45, 450);

CREATE TABLE fleet(
manager_CNP BIGINT UNSIGNED, -- i use BIGINT instead of VARCHAR(13) to save space (8 bytes instead of 13 per CNP)
							               -- this also ensures we only have numerical values in this field
fleet_name VARCHAR(50) UNIQUE NOT NULL,
manager_name VARCHAR(50) NOT NULL,
manager_surname VARCHAR(100) NOT NULL,
phone INT(10) zerofill NOT NULL,
creation_date DATE NOT NULL,
PRIMARY KEY(manager_CNP),
CHECK(manager_CNP >= 1000000000000 AND manager_CNP < 10000000000000),
CHECK(phone >= 100000000) --
);

INSERT INTO fleet VALUES
(1940420464795, 'PANDAWANS SRL', 'Popa', 'Alin', 0794856720, '2018-04-25'),
(1871203393845, 'FAST WHEELS DELIVERY SA', 'Stan', 'Mihai', 0759642873, '2019-01-12'),
(1890529276052, 'TU COMANZI NOI VARSAM SRL', 'Girip', 'Florentin Mihai', 0722454906, '2016-12-12');

CREATE TABLE IF NOT EXISTS courier(
courier_CNP BIGINT UNSIGNED,
manager_CNP BIGINT UNSIGNED NOT NULL,
name VARCHAR(50) NOT NULL,
surname VARCHAR(100) NOT NULL,
vehicle ENUM('bicicleta', 'motocicleta', 'masina') NOT NULL,
registration_date date NOT NULL,
resignation_date date,
PRIMARY KEY(courier_CNP),
CHECK(courier_CNP >= 1000000000000 AND courier_CNP < 10000000000000),
FOREIGN KEY(manager_CNP) REFERENCES fleet(manager_CNP)
  ON DELETE cascade ON UPDATE cascade
);

INSERT INTO courier (courier_CNP, manager_CNP, name, surname, vehicle, registration_date) VALUES
(2940625117515, 1940420464795, 'Luminita', 'Calin', 1, '2018-07-29'),
(5000221447182, 1940420464795, 'Dobre', 'Marius', 'motocicleta', '2019-10-21'),
(1960619242151, 1940420464795, 'Manolache', 'Carmen', 3, '2018-12-03'),

(1900321437226, 1871203393845, 'Tutea', 'Mihaela', 'masina', '2021-05-13'),
(1900504132009, 1871203393845, 'Dragos', 'Madalin', 'masina', '2020-03-03'),
(1940401425984, 1871203393845, 'Iancu', 'Paul', 'bicicleta', '2019-05-20'),

(5000311342697, 1890529276052, 'Bratosin', 'Tania', 'motocicleta', '2017-09-12'),
(5051003331744, 1890529276052, 'Buse', 'Dorin', 2, '2018-10-18'),
(2930324281024, 1890529276052, 'Pop', 'Dragos', 'motocicleta', '2019-02-25');

CREATE TABLE IF NOT EXISTS department(
department_id INT AUTO_INCREMENT,
name VARCHAR(50),
city VARCHAR(25),
address VARCHAR(100),
PRIMARY KEY(department_id)
);

INSERT INTO department(name, city, address) VALUES
('Logistica', 'Bucuresti', 'Str. Gheorghe Palade, nr. 22'),
('Customer Support', 'Cluj', 'Str. Fericirii, nr. 80'),
('Marketing', 'Bucuresti', 'Str. Gheorghe Palade, nr. 22'),
('Human Resources', 'Bucuresti', 'Str. Gheorghe Palade, nr. 22');

CREATE TABLE IF NOT EXISTS employee(
CNP BIGINT UNSIGNED,
department_id INT NOT NULL,
name VARCHAR(50) NOT NULL,
surname VARCHAR(100) NOT NULL,
registration_date DATE NOT NULL,
resignation_date DATE,
PRIMARY KEY(CNP),
FOREIGN KEY(department_id) REFERENCES department(department_id)
  ON DELETE CASCADE ON UPDATE CASCADE,
CHECK(CNP >= 1000000000000 AND CNP < 10000000000000)
);

INSERT INTO employee VALUES
(2890428304955, 1, 'Toma', 'Eugen', '2016-02-10', '2020-03-09'),
(6050702414663, 1, 'Vlasceanu', 'Stefania', '2020-03-20', NULL),

(6050907289261, 2, 'Olteanu', 'Bratosin', '2019-08-12', NULL),
(2950929406237, 2, 'Vasilica', 'Carmen', '2020-12-03', '2022-05-02'),
(1930415417460, 2, 'Dabija', 'Mirel', '2019-02-24', NULL),

(5011227077202, 3, 'Marguta', 'Stefania', '2018-07-10', '2019-03-12'),
(5050107374443, 3, 'Chirila', 'Nadia', '2017-03-22', NULL);

CREATE TABLE client(
phone INT(10) zerofill,
name VARCHAR(50) NOT NULL,
surname VARCHAR(100) NOT NULL,
email VARCHAR(50),
card_number VARCHAR(16),
PRIMARY KEY(phone),
CHECK(phone > 99999999)
);

INSERT INTO client VALUES
(0731811481, 'Malaeru', 'Claudia', 'salomea07@iacob.com', 2318724900697226),
(0769278398, 'Tamas', 'Vlad', 'teohari57@aldea.biz', 4539226626017928),
(0751981418, 'Vasilica', 'Lina', 'casiana84@preda.com', NULL),
(0756243678, 'Dinu', 'Paul', NULL, NULL),
(0748151900, 'Mocanu', 'Alexandru', NULL, '4556172271593334'),
(0782815988, 'Chirita', 'Monica', 'sandu.amanda@yahoo.com', 4556260554608729);

CREATE TABLE ticket(
ticket_id INT AUTO_INCREMENT ,
client_phone INT(10) zerofill NOT NULL,
employee_CNP BIGINT UNSIGNED NOT NULL,
first_answer_time INT UNSIGNED NOT NULL, -- these times will be measured in seconds
solve_time BIGINT UNSIGNED NOT NULL,
satisfaction ENUM('foarte nemultumit', 'nemultumit', 'neutru', 'multumit', 'foarte multumit'),
PRIMARY KEY(ticket_id),
FOREIGN KEY(client_phone) REFERENCES client(phone)
  ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(employee_CNP) REFERENCES employee(CNP)
ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO ticket(client_phone, employee_CNP, first_answer_time, solve_time, satisfaction) VALUES
(0731811481, 6050907289261, 5, 300, 4),
(0756243678, 6050907289261, 4, 180, 5),
(0769278398, 2950929406237, 14, 500, 2),
(0748151900, 1930415417460, 2, 150, 5);

CREATE TABLE orders(
order_id INT AUTO_INCREMENT,
client_phone INT(10) zerofill,
address VARCHAR(200) NOT NULL,
order_time TIME NOT NULL,
estimated_delivery_time TIME NOT NULL,
delivery_time TIME NOT NULL,
payment_type ENUM('cash', 'card') NOT NULL,
status ENUM('livrata', 'anulata') NOT NULL,
PRIMARY KEY(order_id),
FOREIGN KEY(client_phone) REFERENCES client(phone)
  ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO orders(client_phone, address, order_time, estimated_delivery_time, delivery_time, payment_type, status) VALUES
(0731811481, 'Str. Grivita 93', '20:13', '20:33', '20:40', 'card', 'livrata'),
(0748151900, 'Str, Hateg 10 bl.N2 sc.1 ap.10', '17:45', '18:00', '18:00', 'card', 'anulata'),
(0751981418, 'Str. Carausilor nr.4-6', '16:22', '16:40', '17:00', 'cash', 'livrata'),
(0756243678, 'Bd. Regina Elizabeta nr.40', '20:00', '20:20', '20:15', 'cash', 'anulata'),
(0731811481, 'Str. Stefan Cel Mare nr.26', '21:09', '21:30', '21:32', 2, 'livrata'),
(0748151900, 'Str, Hateg 10 bl.N2 sc.1 ap.10', '20:22', '20:45', '20:50', 'cash', 'livrata'); 

CREATE TABLE order_history(
order_id INT,
courier_CNP BIGINT UNSIGNED,
courier_profit FLOAT NOT NULL,
PRIMARY KEY(order_id, courier_CNP),
FOREIGN KEY(order_id) REFERENCES orders(order_id)
  ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(courier_CNP) REFERENCES courier(courier_CNP)
  ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO order_history VALUES
(1, 2930324281024, 4.30),
(2, 1900504132009, 4),
(3, 5000311342697, 3.80),
(4, 2930324281024, 3),
(5, 5000221447182, 4.30),
(6, 1960619242151, 4.50);

CREATE TABLE product_list(
order_id INT,
product_id INT,
quantity INT NOT NULL,
PRIMARY KEY(product_id, order_id),
FOREIGN KEY(product_id) REFERENCES product(product_id) 
  ON DELETE CASCADE,
FOREIGN KEY(order_id) REFERENCES orders(order_id) 
  ON DELETE CASCADE
);

insert into product_list VALUES
(1, 1, 2),
(1, 2, 2),
(1, 3, 1),
(2, 3, 5),
(3, 13, 1),
(3, 15, 1),
(4, 10, 2),
(4, 11, 1),
(4, 12, 3),
(5, 1, 8),
(6, 7, 1),
(6, 8, 2); 