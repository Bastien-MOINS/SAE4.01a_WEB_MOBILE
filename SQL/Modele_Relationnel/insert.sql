-- 1. REMPLISSAGE DE LA TABLE COMPAGNIE
INSERT INTO COMPAGNIE (id_compagnie, nom_comp) VALUES (1, 'Air France');
INSERT INTO COMPAGNIE (id_compagnie, nom_comp) VALUES (2, 'Lufthansa');
INSERT INTO COMPAGNIE (id_compagnie, nom_comp) VALUES (3, 'Delta Airlines');
INSERT INTO COMPAGNIE (id_compagnie, nom_comp) VALUES (4, 'British Airways');
INSERT INTO COMPAGNIE (id_compagnie, nom_comp) VALUES (5, 'Emirates');

-- 2. REMPLISSAGE DE LA TABLE AEROPORT
INSERT INTO AEROPORT (numero_aeroport, nom_aeroport, ville, pays) VALUES (101, 'Charles de Gaulle', 'Paris', 'France');
INSERT INTO AEROPORT (numero_aeroport, nom_aeroport, ville, pays) VALUES (102, 'Frankfurt Airport', 'Francfort', 'Allemagne');
INSERT INTO AEROPORT (numero_aeroport, nom_aeroport, ville, pays) VALUES (103, 'JFK International', 'New York', 'USA');
INSERT INTO AEROPORT (numero_aeroport, nom_aeroport, ville, pays) VALUES (104, 'Heathrow', 'Londres', 'Royaume-Uni');
INSERT INTO AEROPORT (numero_aeroport, nom_aeroport, ville, pays) VALUES (105, 'Dubai International', 'Dubai', 'Émirats Arabes Unis');
INSERT INTO AEROPORT (numero_aeroport, nom_aeroport, ville, pays) VALUES (106, 'Orly', 'Paris', 'France');

-- 3. REMPLISSAGE DE LA TABLE VOL
INSERT INTO VOL (numero_vol, date_debut, heure_debut, date_arrivee, heure_arrivee, id_compagnie, numero_aeroport_dep, numero_aeroport_arr) 
VALUES (100, TO_DATE('2026-06-01', 'YYYY-MM-DD'), TO_TIMESTAMP('08:00:00', 'HH24:MI:SS'), TO_DATE('2026-06-01', 'YYYY-MM-DD'), TO_TIMESTAMP('09:30:00', 'HH24:MI:SS'), 1, 101, 104);

INSERT INTO VOL (numero_vol, date_debut, heure_debut, date_arrivee, heure_arrivee, id_compagnie, numero_aeroport_dep, numero_aeroport_arr) 
VALUES (100, TO_DATE('2026-06-02', 'YYYY-MM-DD'), TO_TIMESTAMP('08:00:00', 'HH24:MI:SS'), TO_DATE('2026-06-02', 'YYYY-MM-DD'), TO_TIMESTAMP('09:30:00', 'HH24:MI:SS'), 1, 101, 104);

INSERT INTO VOL (numero_vol, date_debut, heure_debut, date_arrivee, heure_arrivee, id_compagnie, numero_aeroport_dep, numero_aeroport_arr) 
VALUES (250, TO_DATE('2026-06-01', 'YYYY-MM-DD'), TO_TIMESTAMP('10:15:00', 'HH24:MI:SS'), TO_DATE('2026-06-01', 'YYYY-MM-DD'), TO_TIMESTAMP('12:45:00', 'HH24:MI:SS'), 2, 102, 101);

INSERT INTO VOL (numero_vol, date_debut, heure_debut, date_arrivee, heure_arrivee, id_compagnie, numero_aeroport_dep, numero_aeroport_arr) 
VALUES (442, TO_DATE('2026-06-01', 'YYYY-MM-DD'), TO_TIMESTAMP('14:00:00', 'HH24:MI:SS'), TO_DATE('2026-06-02', 'YYYY-MM-DD'), TO_TIMESTAMP('02:00:00', 'HH24:MI:SS'), 5, 105, 101);

INSERT INTO VOL (numero_vol, date_debut, heure_debut, date_arrivee, heure_arrivee, id_compagnie, numero_aeroport_dep, numero_aeroport_arr) 
VALUES (88, TO_DATE('2026-06-01', 'YYYY-MM-DD'), TO_TIMESTAMP('16:30:00', 'HH24:MI:SS'), TO_DATE('2026-06-01', 'YYYY-MM-DD'), TO_TIMESTAMP('19:00:00', 'HH24:MI:SS'), 3, 103, 104);

INSERT INTO VOL (numero_vol, date_debut, heure_debut, date_arrivee, heure_arrivee, id_compagnie, numero_aeroport_dep, numero_aeroport_arr) 
VALUES (88, TO_DATE('2026-06-02', 'YYYY-MM-DD'), TO_TIMESTAMP('16:30:00', 'HH24:MI:SS'), TO_DATE('2026-06-02', 'YYYY-MM-DD'), TO_TIMESTAMP('19:00:00', 'HH24:MI:SS'), 3, 103, 104);

INSERT INTO VOL (numero_vol, date_debut, heure_debut, date_arrivee, heure_arrivee, id_compagnie, numero_aeroport_dep, numero_aeroport_arr) 
VALUES (312, TO_DATE('2026-06-03', 'YYYY-MM-DD'), TO_TIMESTAMP('07:45:00', 'HH24:MI:SS'), TO_DATE('2026-06-03', 'YYYY-MM-DD'), TO_TIMESTAMP('08:50:00', 'HH24:MI:SS'), 1, 106, 102);

INSERT INTO VOL (numero_vol, date_debut, heure_debut, date_arrivee, heure_arrivee, id_compagnie, numero_aeroport_dep, numero_aeroport_arr) 
VALUES (905, TO_DATE('2026-06-03', 'YYYY-MM-DD'), TO_TIMESTAMP('21:00:00', 'HH24:MI:SS'), TO_DATE('2026-06-04', 'YYYY-MM-DD'), TO_TIMESTAMP('06:30:00', 'HH24:MI:SS'), 4, 104, 103);

-- 4. REMPLISSAGE DE LA TABLE TERMINAL
INSERT INTO TERMINAL (numero_vol, numero_aeroport, date_debut, heure_debut, id_terminal) 
VALUES (100, 101, TO_DATE('2026-06-01', 'YYYY-MM-DD'), TO_TIMESTAMP('08:00:00', 'HH24:MI:SS'), 2);

INSERT INTO TERMINAL (numero_vol, numero_aeroport, date_debut, heure_debut, id_terminal) 
VALUES (100, 101, TO_DATE('2026-06-02', 'YYYY-MM-DD'), TO_TIMESTAMP('08:00:00', 'HH24:MI:SS'), 2);

INSERT INTO TERMINAL (numero_vol, numero_aeroport, date_debut, heure_debut, id_terminal) 
VALUES (250, 102, TO_DATE('2026-06-01', 'YYYY-MM-DD'), TO_TIMESTAMP('10:15:00', 'HH24:MI:SS'), 1);

INSERT INTO TERMINAL (numero_vol, numero_aeroport, date_debut, heure_debut, id_terminal) 
VALUES (442, 105, TO_DATE('2026-06-01', 'YYYY-MM-DD'), TO_TIMESTAMP('14:00:00', 'HH24:MI:SS'), 3);

INSERT INTO TERMINAL (numero_vol, numero_aeroport, date_debut, heure_debut, id_terminal) 
VALUES (88, 103, TO_DATE('2026-06-01', 'YYYY-MM-DD'), TO_TIMESTAMP('16:30:00', 'HH24:MI:SS'), 4);

INSERT INTO TERMINAL (numero_vol, numero_aeroport, date_debut, heure_debut, id_terminal) 
VALUES (312, 106, TO_DATE('2026-06-03', 'YYYY-MM-DD'), TO_TIMESTAMP('07:45:00', 'HH24:MI:SS'), 1);

INSERT INTO TERMINAL (numero_vol, numero_aeroport, date_debut, heure_debut, id_terminal) 
VALUES (905, 104, TO_DATE('2026-06-03', 'YYYY-MM-DD'), TO_TIMESTAMP('21:00:00', 'HH24:MI:SS'), 5);

COMMIT;
