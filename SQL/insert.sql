-- ==========================================================
-- SCRIPT D'INSERTION DE DONNÉES TEST
-- ==========================================================

-- 1. REMPLISSAGE DE LA TABLE COMPAGNIE
INSERT INTO COMPAGNIE (id_compagnie, nom_comp) VALUES 
(1, 'Air France'),
(2, 'Lufthansa'),
(3, 'Delta Airlines'),
(4, 'British Airways'),
(5, 'Emirates');

-- 2. REMPLISSAGE DE LA TABLE AEROPORT
INSERT INTO AEROPORT (numero_aeroport, nom_aeroport, ville, pays) VALUES 
(101, 'Charles de Gaulle', 'Paris', 'France'),
(102, 'Frankfurt Airport', 'Francfort', 'Allemagne'),
(103, 'JFK International', 'New York', 'USA'),
(104, 'Heathrow', 'Londres', 'Royaume-Uni'),
(105, 'Dubai International', 'Dubai', 'Émirats Arabes Unis'),
(106, 'Orly', 'Paris', 'France');

-- 3. REMPLISSAGE DE LA TABLE VOL
INSERT INTO VOL (numero_vol, date_debut, heure_debut, date_arrivee, heure_arrivee, id_compagnie, numero_aeroport_dep, numero_aeroport_arr) VALUES 
(100, '2026-06-01', '08:00:00', '2026-06-01', '09:30:00', 1, 101, 104), 
(100, '2026-06-02', '08:00:00', '2026-06-02', '09:30:00', 1, 101, 104),
(250, '2026-06-01', '10:15:00', '2026-06-01', '12:45:00', 2, 102, 101), 
(442, '2026-06-01', '14:00:00', '2026-06-02', '02:00:00', 5, 105, 101), 
(88,  '2026-06-01', '16:30:00', '2026-06-01', '19:00:00', 3, 103, 104), 
(88,  '2026-06-02', '16:30:00', '2026-06-02', '19:00:00', 3, 103, 104),
(312, '2026-06-03', '07:45:00', '2026-06-03', '08:50:00', 1, 106, 102),
(905, '2026-06-03', '21:00:00', '2026-06-04', '06:30:00', 4, 104, 103);

-- 4. REMPLISSAGE DE LA TABLE TERMINAL
INSERT INTO TERMINAL (numero_vol, numero_aeroport, date_debut, heure_debut, id_terminal) VALUES 
(100, 101, '2026-06-01', '08:00:00', 2),
(100, 101, '2026-06-02', '08:00:00', 2),
(250, 102, '2026-06-01', '10:15:00', 1),
(442, 105, '2026-06-01', '14:00:00', 3),
(88,  103, '2026-06-01', '16:30:00', 4),
(312, 106, '2026-06-03', '07:45:00', 1),
(905, 104, '2026-06-03', '21:00:00', 5);
-- ==========================================================
-- SCRIPT D'INSERTION DE DONNÉES TEST
-- ==========================================================

-- 1. REMPLISSAGE DE LA TABLE COMPAGNIE
INSERT INTO COMPAGNIE (id_compagnie, nom_comp) VALUES 
(1, 'Air France'),
(2, 'Lufthansa'),
(3, 'Delta Airlines'),
(4, 'British Airways'),
(5, 'Emirates');

-- 2. REMPLISSAGE DE LA TABLE AEROPORT
INSERT INTO AEROPORT (numero_aeroport, nom_aeroport, ville, pays) VALUES 
(101, 'Charles de Gaulle', 'Paris', 'France'),
(102, 'Frankfurt Airport', 'Francfort', 'Allemagne'),
(103, 'JFK International', 'New York', 'USA'),
(104, 'Heathrow', 'Londres', 'Royaume-Uni'),
(105, 'Dubai International', 'Dubai', 'Émirats Arabes Unis'),
(106, 'Orly', 'Paris', 'France');

-- 3. REMPLISSAGE DE LA TABLE VOL
INSERT INTO VOL (numero_vol, date_debut, heure_debut, date_arrivee, heure_arrivee, id_compagnie, numero_aeroport_dep, numero_aeroport_arr) VALUES 
(100, '2026-06-01', '08:00:00', '2026-06-01', '09:30:00', 1, 101, 104),--
(100, '2026-06-02', '08:00:00', '2026-06-02', '09:30:00', 1, 101, 104),--
(250, '2026-06-01', '10:15:00', '2026-06-01', '12:45:00', 2, 102, 101), 
(442, '2026-06-01', '14:00:00', '2026-06-02', '02:00:00', 5, 105, 101), 
(88,  '2026-06-01', '16:30:00', '2026-06-01', '19:00:00', 3, 103, 104), 
(88,  '2026-06-02', '16:30:00', '2026-06-02', '19:00:00', 3, 103, 104),
(312, '2026-06-03', '07:45:00', '2026-06-03', '08:50:00', 1, 106, 102),--
(905, '2026-06-03', '21:00:00', '2026-06-04', '06:30:00', 4, 104, 103);

-- 4. REMPLISSAGE DE LA TABLE TERMINAL
INSERT INTO TERMINAL (numero_vol, numero_aeroport, date_debut, heure_debut, id_terminal) VALUES 
(100, 101, '2026-06-01', '08:00:00', 2),
(100, 101, '2026-06-02', '08:00:00', 2),
(250, 102, '2026-06-01', '10:15:00', 1),
(442, 105, '2026-06-01', '14:00:00', 3),
(88,  103, '2026-06-01', '16:30:00', 4),
(312, 106, '2026-06-03', '07:45:00', 1),
(905, 104, '2026-06-03', '21:00:00', 5);