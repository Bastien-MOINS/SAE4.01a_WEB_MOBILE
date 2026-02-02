-- ==========================================================
-- JEU DE DONNÉES DE TEST : VOLS AVEC CORRESPONDANCE DEPUIS PARIS
-- ==========================================================

-- 1. Ajout d'aéroports pour les tests
-- (IDs 200+ pour ne pas entrer en conflit avec les existants)
INSERT INTO AEROPORT (numero_aeroport, nom_aeroport, ville, pays) VALUES 
(200, 'Munich Airport', 'Munich', 'Allemagne'),       -- Escale Test
(201, 'Madrid Barajas', 'Madrid', 'Espagne'),         -- Destination Valide (1 corresp)
(202, 'Rome Fiumicino', 'Rome', 'Italie'),            -- Destination Invalide (Vol direct)
(203, 'Vienna Airport', 'Vienne', 'Autriche'),        -- Escale pour trajet "Départ non Paris"
(204, 'Lisbon Airport', 'Lisbonne', 'Portugal'),      -- Destination Invalide (Départ de Lyon)
(205, 'Lyon St Exupery', 'Lyon', 'France'),           -- Ville de départ "Lyon"
(206, 'Berlin Brand', 'Berlin', 'Allemagne');         -- Destination Invalide (Mauvaise correspondance)

-- 2. Ajout des vols (Table VOL)
-- PRIMARY KEY: (numero_vol, date_debut, heure_debut)
-- Id Comp 1 = Air France

-- ----------------------------------------------------------
-- CAS 1 : Trajet Valide avec 1 correspondance (DOIT APPARAITRE)
-- Trajet : Paris (CDG 101) -> Munich (200) -> Madrid (201)
-- ----------------------------------------------------------

-- Vol 1 : Départ Paris 08:00, Arrivée Munich 09:30
INSERT INTO VOL (numero_vol, date_debut, heure_debut, date_arrivee, heure_arrivee, id_compagnie, numero_aeroport_dep, numero_aeroport_arr) VALUES 
(1001, '2026-07-01', '08:00:00', '2026-07-01', '09:30:00', 1, 101, 200);

-- Vol 2 : Départ Munich 11:00 (1h30 d'escale), Arrivée Madrid 13:30
INSERT INTO VOL (numero_vol, date_debut, heure_debut, date_arrivee, heure_arrivee, id_compagnie, numero_aeroport_dep, numero_aeroport_arr) VALUES 
(1002, '2026-07-01', '11:00:00', '2026-07-01', '13:30:00', 1, 200, 201);

-- >>> RÉSULTAT ATTENDU : MADRID (201) doit apparaitre dans les résultats.


-- ----------------------------------------------------------
-- CAS 2 : Vol Direct depuis Paris (NE DOIT PAS APPARAITRE)
-- Trajet : Paris (CDG 101) -> Rome (202)
-- ----------------------------------------------------------
INSERT INTO VOL (numero_vol, date_debut, heure_debut, date_arrivee, heure_arrivee, id_compagnie, numero_aeroport_dep, numero_aeroport_arr) VALUES 
(1003, '2026-07-01', '09:00:00', '2026-07-01', '11:00:00', 1, 101, 202);

-- >>> RÉSULTAT ATTENDU : ROME (202) ne doit pas être vu comme "1 correspondance".


-- ----------------------------------------------------------
-- CAS 3 : Trajet avec 1 correspondance mais Départ de Lyon (NE DOIT PAS APPARAITRE)
-- Trajet : Lyon (205) -> Vienne (203) -> Lisbonne (204)
-- ----------------------------------------------------------

-- Vol départ Lyon
INSERT INTO VOL (numero_vol, date_debut, heure_debut, date_arrivee, heure_arrivee, id_compagnie, numero_aeroport_dep, numero_aeroport_arr) VALUES 
(1004, '2026-07-01', '08:00:00', '2026-07-01', '10:00:00', 1, 205, 203); 

-- Vol suite vers Lisbonne
INSERT INTO VOL (numero_vol, date_debut, heure_debut, date_arrivee, heure_arrivee, id_compagnie, numero_aeroport_dep, numero_aeroport_arr) VALUES 
(1005, '2026-07-01', '12:00:00', '2026-07-01', '15:00:00', 1, 203, 204); 

-- >>> RÉSULTAT ATTENDU : LISBONNE (204) ne doit pas apparaitre (car départ initial de Lyon).


-- ----------------------------------------------------------
-- CAS 4 : Correspondance invalide temporelle (NE DOIT PAS APPARAITRE)
-- Trajet : Paris (CDG 101) -> Munich (200) -> Berlin (206)
-- Problème : Le vol pour Berlin part AVANT l'arrivée du vol de Paris.
-- ----------------------------------------------------------

-- Note: Le vol Paris->Munich (1001) existe déjà ci-dessus (Arrivée 09:30).
-- On ajoute un vol Munich->Berlin qui part à 09:00 la même jour.
INSERT INTO VOL (numero_vol, date_debut, heure_debut, date_arrivee, heure_arrivee, id_compagnie, numero_aeroport_dep, numero_aeroport_arr) VALUES 
(1006, '2026-07-01', '09:00:00', '2026-07-01', '10:30:00', 1, 200, 206);

-- >>> RÉSULTAT ATTENDU : BERLIN (206) ne doit pas apparaitre.
