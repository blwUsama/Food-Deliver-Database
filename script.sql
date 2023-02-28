DROP DATABASE IF EXISTS foodpanda;
CREATE DATABASE IF NOT EXISTS foodpanda;
USE foodpanda;

-- Tabela Partener:
CREATE TABLE IF NOT EXISTS partener(
id_partener INT NOT NULL AUTO_INCREMENT,
nume VARCHAR(50) NOT NULL,
oras VARCHAR(50) NOT NULL,
adresa VARCHAR(200) NOT NULL,
telefon INT(10) zerofill NOT NULL ,
ora_deschidere TIME NOT NULL,
ora_inchidere TIME NOT NULL,
PRIMARY KEY(id_partener),
CHECK(telefon > 99999999)
);

INSERT INTO partener(nume, oras, adresa, telefon, ora_deschidere, ora_inchidere) VALUES
('KFC', 'Bucuresti', 'Strada Puiului nr.10', 0734567899, '10:00', '22:00'),
('Shaormeria Kogalniceanu', 'Bucuresti', 'Strada Mihail Kogalniceanu nr 23', 0712489670, '08:00', '08:00'), 
('La Placinte', 'Bucuresti', 'Bulevardul Doina Cornea 4E', 0756207005, '10:00', '22:00'),
('Ciorbarie', 'Bucuresti', 'Calea Dorobanti 73', 0725067447, '11:00', '21:00'),
('Pizza Hut', 'Bucuresti', 'Bulevardul Regina Elisabeta 15-19', 0740121903,'10:00', '22:00');

CREATE TABLE IF NOT EXISTS produs(
id_produs int AUTO_INCREMENT,
id_partener int,
nume VARCHAR(100) NOT NULL,
pret FLOAT NOT NULL,
gramaj int,
PRIMARY KEY(id_produs),
FOREIGN KEY(id_partener) REFERENCES partener(id_partener)
  ON DELETE CASCADE ON UPDATE CASCADE,
CHECK(pret >= 0)
);

INSERT INTO produs(id_partener, nume, pret, gramaj) VALUES
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

CREATE TABLE flota(
CNP_manager BIGINT UNSIGNED, -- folosesc BIGINT in loc de VARCHAR(13) pentru a economisi spatiu, BIGINT 
							 -- fiind pe 8 bytes iar varchar(13) pe 13, si pentru a asigura valori numerice in CNP
nume_flota VARCHAR(50) UNIQUE NOT NULL,
nume_manager VARCHAR(50) NOT NULL,
prenume_manager VARCHAR(100) NOT NULL,
telefon INT(10) zerofill NOT NULL,
data_infiintare DATE NOT NULL,
PRIMARY KEY(CNP_manager),
CHECK(CNP_manager >= 1000000000000 AND CNP_manager < 10000000000000),
CHECK(telefon >= 100000000) --
);

INSERT INTO flota VALUES
(1940420464795, 'PANDAWANS SRL', 'Popa', 'Alin', 0794856720, '2018-04-25'),
(1871203393845, 'FAST WHEELS DELIVERY SA', 'Stan', 'Mihai', 0759642873, '2019-01-12'),
(1890529276052, 'TU COMANZI NOI VARSAM SRL', 'Girip', 'Florentin Mihai', 0722454906, '2016-12-12');

CREATE TABLE IF NOT EXISTS livrator(
CNP_livrator BIGINT UNSIGNED,
CNP_manager BIGINT UNSIGNED NOT NULL,
nume VARCHAR(50) NOT NULL,
prenume VARCHAR(100) NOT NULL,
vehicul ENUM('bicicleta', 'motocicleta', 'masina') NOT NULL,
data_inscriere date NOT NULL,
data_demisie date,
PRIMARY KEY(CNP_livrator),
CHECK(CNP_livrator >= 1000000000000 AND CNP_livrator < 10000000000000),
FOREIGN KEY(CNP_manager) REFERENCES flota(CNP_manager)
  ON DELETE cascade ON UPDATE cascade
);

INSERT INTO livrator (CNP_livrator, CNP_manager, nume, prenume, vehicul, data_inscriere) VALUES
(2940625117515, 1940420464795, 'Luminita', 'Calin', 1, '2018-07-29'),
(5000221447182, 1940420464795, 'Dobre', 'Marius', 'motocicleta', '2019-10-21'),
(1960619242151, 1940420464795, 'Manolache', 'Carmen', 3, '2018-12-03'),

(1900321437226, 1871203393845, 'Tutea', 'Mihaela', 'masina', '2021-05-13'),
(1900504132009, 1871203393845, 'Dragos', 'Madalin', 'masina', '2020-03-03'),
(1940401425984, 1871203393845, 'Iancu', 'Paul', 'bicicleta', '2019-05-20'),

(5000311342697, 1890529276052, 'Bratosin', 'Tania', 'motocicleta', '2017-09-12'),
(5051003331744, 1890529276052, 'Buse', 'Dorin', 2, '2018-10-18'),
(2930324281024, 1890529276052, 'Pop', 'Dragos', 'motocicleta', '2019-02-25');

CREATE TABLE IF NOT EXISTS departament(
id_departament INT AUTO_INCREMENT,
nume VARCHAR(50),
oras VARCHAR(25),
adresa VARCHAR(100),
PRIMARY KEY(id_departament)
);

INSERT INTO departament(nume, oras, adresa) VALUES
('Logistica', 'Bucuresti', 'Str. Gheorghe Palade, nr. 22'),
('Customer Support', 'Cluj', 'Str. Fericirii, nr. 80'),
('Marketing', 'Bucuresti', 'Str. Gheorghe Palade, nr. 22'),
('Human Resources', 'Bucuresti', 'Str. Gheorghe Palade, nr. 22');

CREATE TABLE IF NOT EXISTS angajat(
CNP BIGINT UNSIGNED,
id_departament INT NOT NULL,
nume VARCHAR(50) NOT NULL,
prenume VARCHAR(100) NOT NULL,
data_angajarii DATE NOT NULL,
data_demisiei DATE,
PRIMARY KEY(CNP),
FOREIGN KEY(id_departament) REFERENCES departament(id_departament),
CHECK(CNP >= 1000000000000 AND CNP < 10000000000000)
);

INSERT INTO angajat VALUES
(2890428304955, 1, 'Toma', 'Eugen', '2016-02-10', '2020-03-09'),
(6050702414663, 1, 'Vlasceanu', 'Stefania', '2020-03-20', NULL),

(6050907289261, 2, 'Olteanu', 'Bratosin', '2019-08-12', NULL),
(2950929406237, 2, 'Vasilica', 'Carmen', '2020-12-03', '2022-05-02'),
(1930415417460, 2, 'Dabija', 'Mirel', '2019-02-24', NULL),

(5011227077202, 3, 'Marguta', 'Stefania', '2018-07-10', '2019-03-12'),
(5050107374443, 3, 'Chirila', 'Nadia', '2017-03-22', NULL);

CREATE TABLE client(
telefon INT(10) zerofill,
nume VARCHAR(50) NOT NULL,
prenume VARCHAR(100) NOT NULL,
email VARCHAR(50),
numar_card VARCHAR(16),
PRIMARY KEY(telefon),
CHECK(telefon > 99999999)
);

INSERT INTO client VALUES
(0731811481, 'Malaeru', 'Claudia', 'salomea07@iacob.com', 2318724900697226),
(0769278398, 'Tamas', 'Vlad', 'teohari57@aldea.biz', 4539226626017928),
(0751981418, 'Vasilica', 'Lina', 'casiana84@preda.com', NULL),
(0756243678, 'Dinu', 'Paul', NULL, NULL),
(0748151900, 'Mocanu', 'Alexandru', NULL, '4556172271593334'),
(0782815988, 'Chirita', 'Monica', 'sandu.amanda@yahoo.com', 4556260554608729);

CREATE TABLE ticket(
id_ticket INT AUTO_INCREMENT ,
telefon_client INT(10) zerofill NOT NULL,
CNP_angajat BIGINT UNSIGNED NOT NULL,
durata_prim_raspuns INT UNSIGNED NOT NULL, -- acesti timpi se vor masura in secunde 
durata_rezolvare BIGINT UNSIGNED NOT NULL,
satisfactie ENUM('foarte nemultumit', 'nemultumit', 'neutru', 'multumit', 'foarte multumit'),
PRIMARY KEY(id_ticket),
FOREIGN KEY(telefon_client) REFERENCES client(telefon),
FOREIGN KEY(CNP_angajat) REFERENCES angajat(CNP)
);

INSERT INTO ticket(telefon_client, CNP_angajat, durata_prim_raspuns, durata_rezolvare, satisfactie) VALUES
(0731811481, 6050907289261, 5, 300, 4),
(0756243678, 6050907289261, 4, 180, 5),
(0769278398, 2950929406237, 14, 500, 2),
(0748151900, 1930415417460, 2, 150, 5);

CREATE TABLE comanda(
id_comanda INT AUTO_INCREMENT,
telefon_client INT(10) zerofill,
adresa VARCHAR(200) NOT NULL,
timp_plasare TIME NOT NULL,
timp_estimat_livrare TIME NOT NULL,
timp_livrare TIME NOT NULL,
tip_plata ENUM('cash', 'card') NOT NULL,
status ENUM('livrata', 'anulata') NOT NULL,
PRIMARY KEY(id_comanda),
FOREIGN KEY(telefon_client) REFERENCES client(telefon)
);

INSERT INTO comanda(telefon_client, adresa, timp_plasare, timp_estimat_livrare, timp_livrare, tip_plata, status) VALUES
(0731811481, 'Str. Grivita 93', '20:13', '20:33', '20:40', 'card', 'livrata'),
(0748151900, 'Str, Hateg 10 bl.N2 sc.1 ap.10', '17:45', '18:00', '18:00', 'card', 'anulata'),
(0751981418, 'Str. Carausilor nr.4-6', '16:22', '16:40', '17:00', 'cash', 'livrata'),
(0756243678, 'Bd. Regina Elizabeta nr.40', '20:00', '20:20', '20:15', 'cash', 'anulata'),
(0731811481, 'Str. Stefan Cel Mare nr.26', '21:09', '21:30', '21:32', 2, 'livrata'),
(0748151900, 'Str, Hateg 10 bl.N2 sc.1 ap.10', '20:22', '20:45', '20:50', 'cash', 'livrata'); 

CREATE TABLE istoric_comenzi(
id_comanda INT,
CNP_livrator BIGINT UNSIGNED,
profit_livrator FLOAT NOT NULL,
PRIMARY KEY(id_comanda, CNP_livrator),
FOREIGN KEY(id_comanda) REFERENCES comanda(id_comanda),
FOREIGN KEY(CNP_livrator) REFERENCES livrator(CNP_livrator)
);

INSERT INTO istoric_comenzi VALUES
(1, 2930324281024, 4.30),
(2, 1900504132009, 4),
(3, 5000311342697, 3.80),
(4, 2930324281024, 3),
(5, 5000221447182, 4.30),
(6, 1960619242151, 4.50);

CREATE TABLE lista_produse(
id_comanda INT,
id_produs INT,
cantitate INT NOT NULL,
PRIMARY KEY(id_produs, id_comanda),
FOREIGN KEY(id_produs) REFERENCES produs(id_produs),
FOREIGN KEY(id_comanda) REFERENCES comanda(id_comanda)
);

insert into lista_produse VALUES
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