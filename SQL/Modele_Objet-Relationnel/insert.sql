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

-- 3. REMPLISSAGE DE LA TABLE TERMINAL
-- Il faut créer les terminaux avant les vols car VOL reference TERMINAL (numero_aeroport, id_terminal)
INSERT INTO TERMINAL (numero_aeroport, id_terminal, nom_terminal) VALUES (101, 2, 'Terminal 2E');
INSERT INTO TERMINAL (numero_aeroport, id_terminal, nom_terminal) VALUES (101, 1, 'Terminal 1');
INSERT INTO TERMINAL (numero_aeroport, id_terminal, nom_terminal) VALUES (102, 1, 'Terminal 1');
INSERT INTO TERMINAL (numero_aeroport, id_terminal, nom_terminal) VALUES (103, 4, 'Terminal 4');
INSERT INTO TERMINAL (numero_aeroport, id_terminal, nom_terminal) VALUES (104, 5, 'Terminal 5');
INSERT INTO TERMINAL (numero_aeroport, id_terminal, nom_terminal) VALUES (105, 3, 'Terminal 3');
INSERT INTO TERMINAL (numero_aeroport, id_terminal, nom_terminal) VALUES (106, 1, 'Terminal Sud');

-- 4. REMPLISSAGE DE LA TABLE VOL
-- Les insertions de vols incluent maintenant les Terminaux (dep/arr), l'Equipage (TABLE) et les Indices (VARRAY)
INSERT INTO VOL (numero_vol, date_debut, heure_debut, date_arrivee, heure_arrivee, id_compagnie, numero_aeroport_dep, id_terminal_dep, numero_aeroport_arr, id_terminal_arr, equipage, indice_qualite) 
VALUES (100, TO_DATE('2026-06-01', 'YYYY-MM-DD'), TO_TIMESTAMP('08:00:00', 'HH24:MI:SS'), TO_DATE('2026-06-01', 'YYYY-MM-DD'), TO_TIMESTAMP('09:30:00', 'HH24:MI:SS'), 1, 101, 2, 104, 5, 
        EQUIPAGE(equipageV('Jean Martin', 'Pilote'), equipageV('Alice L.', 'Copilote')), 
        INDICESQUALITE(indQualV('Ponctualite', 9, 0.5), indQualV('Confort', 8, 0.5)));

INSERT INTO VOL (numero_vol, date_debut, heure_debut, date_arrivee, heure_arrivee, id_compagnie, numero_aeroport_dep, id_terminal_dep, numero_aeroport_arr, id_terminal_arr, equipage, indice_qualite) 
VALUES (100, TO_DATE('2026-06-02', 'YYYY-MM-DD'), TO_TIMESTAMP('08:00:00', 'HH24:MI:SS'), TO_DATE('2026-06-02', 'YYYY-MM-DD'), TO_TIMESTAMP('09:30:00', 'HH24:MI:SS'), 1, 101, 2, 104, 5,
        EQUIPAGE(equipageV('Paul G.', 'Pilote'), equipageV('Sarah M.', 'Hotesse')),
        INDICESQUALITE(indQualV('Ponctualite', 10, 0.5)));

INSERT INTO VOL (numero_vol, date_debut, heure_debut, date_arrivee, heure_arrivee, id_compagnie, numero_aeroport_dep, id_terminal_dep, numero_aeroport_arr, id_terminal_arr, equipage, indice_qualite) 
VALUES (250, TO_DATE('2026-06-01', 'YYYY-MM-DD'), TO_TIMESTAMP('10:15:00', 'HH24:MI:SS'), TO_DATE('2026-06-01', 'YYYY-MM-DD'), TO_TIMESTAMP('12:45:00', 'HH24:MI:SS'), 2, 102, 1, 101, 1,
        EQUIPAGE(equipageV('Hans Zimmer', 'Pilote')),
        INDICESQUALITE(indQualV('Ponctualite', 7, 0.6), indQualV('Service', 8, 0.4)));

INSERT INTO VOL (numero_vol, date_debut, heure_debut, date_arrivee, heure_arrivee, id_compagnie, numero_aeroport_dep, id_terminal_dep, numero_aeroport_arr, id_terminal_arr, equipage, indice_qualite) 
VALUES (442, TO_DATE('2026-06-01', 'YYYY-MM-DD'), TO_TIMESTAMP('14:00:00', 'HH24:MI:SS'), TO_DATE('2026-06-02', 'YYYY-MM-DD'), TO_TIMESTAMP('02:00:00', 'HH24:MI:SS'), 5, 105, 3, 101, 2,
        EQUIPAGE(equipageV('Ahmed K.', 'Pilote'), equipageV('Marie D.', 'Chef de cabine')),
        INDICESQUALITE(indQualV('Confort', 10, 0.8)));

INSERT INTO VOL (numero_vol, date_debut, heure_debut, date_arrivee, heure_arrivee, id_compagnie, numero_aeroport_dep, id_terminal_dep, numero_aeroport_arr, id_terminal_arr, equipage, indice_qualite) 
VALUES (88, TO_DATE('2026-06-01', 'YYYY-MM-DD'), TO_TIMESTAMP('16:30:00', 'HH24:MI:SS'), TO_DATE('2026-06-01', 'YYYY-MM-DD'), TO_TIMESTAMP('19:00:00', 'HH24:MI:SS'), 3, 103, 4, 104, 5,
        EQUIPAGE(equipageV('John Doe', 'Pilote')),
        INDICESQUALITE(indQualV('Ponctualite', 8, 0.5), indQualV('Repas', 6, 0.5)));

INSERT INTO VOL (numero_vol, date_debut, heure_debut, date_arrivee, heure_arrivee, id_compagnie, numero_aeroport_dep, id_terminal_dep, numero_aeroport_arr, id_terminal_arr, equipage, indice_qualite) 
VALUES (88, TO_DATE('2026-06-02', 'YYYY-MM-DD'), TO_TIMESTAMP('16:30:00', 'HH24:MI:SS'), TO_DATE('2026-06-02', 'YYYY-MM-DD'), TO_TIMESTAMP('19:00:00', 'HH24:MI:SS'), 3, 103, 4, 104, 5,
        EQUIPAGE(equipageV('Jane Smith', 'Pilote')),
        NULL);

INSERT INTO VOL (numero_vol, date_debut, heure_debut, date_arrivee, heure_arrivee, id_compagnie, numero_aeroport_dep, id_terminal_dep, numero_aeroport_arr, id_terminal_arr, equipage, indice_qualite) 
VALUES (312, TO_DATE('2026-06-03', 'YYYY-MM-DD'), TO_TIMESTAMP('07:45:00', 'HH24:MI:SS'), TO_DATE('2026-06-03', 'YYYY-MM-DD'), TO_TIMESTAMP('08:50:00', 'HH24:MI:SS'), 1, 106, 1, 102, 1,
        EQUIPAGE(equipageV('Luc B.', 'Pilote')),
        INDICESQUALITE());

INSERT INTO VOL (numero_vol, date_debut, heure_debut, date_arrivee, heure_arrivee, id_compagnie, numero_aeroport_dep, id_terminal_dep, numero_aeroport_arr, id_terminal_arr, equipage, indice_qualite) 
VALUES (905, TO_DATE('2026-06-03', 'YYYY-MM-DD'), TO_TIMESTAMP('21:00:00', 'HH24:MI:SS'), TO_DATE('2026-06-04', 'YYYY-MM-DD'), TO_TIMESTAMP('06:30:00', 'HH24:MI:SS'), 4, 104, 5, 103, 4,
        EQUIPAGE(equipageV('William T.', 'Pilote'), equipageV('Kate M.', 'Hotesse')),
        INDICESQUALITE(indQualV('Ponctualite', 9, 0.7), indQualV('Proprete', 9, 0.3)));

INSERT INTO VOL (numero_vol, date_debut, heure_debut, id_compagnie, numero_aeroport_dep, id_terminal_dep, numero_aeroport_arr, id_terminal_arr, equipage, indice_qualite) 
VALUES (105, TO_DATE('2026-06-05', 'YYYY-MM-DD'), TO_TIMESTAMP('10:00:00', 'HH24:MI:SS'), 1, 101, 2, 102, 1,
        EQUIPAGE(equipageV('Jean Martin', 'Pilote'), equipageV('Alice L.', 'Copilote')), 
        INDICESQUALITE(indQualV('Confort', 9, 0.5)));

INSERT INTO VOL (numero_vol, date_debut, heure_debut, id_compagnie, numero_aeroport_dep, id_terminal_dep, numero_aeroport_arr, id_terminal_arr, equipage, indice_qualite) 
VALUES (260, TO_DATE('2026-06-10', 'YYYY-MM-DD'), TO_TIMESTAMP('15:30:00', 'HH24:MI:SS'), 2, 102, 1, 105, 3,
        EQUIPAGE(equipageV('Hans Zimmer', 'Pilote')),
        INDICESQUALITE(indQualV('Prix', 10, 1)));

INSERT INTO VOL (numero_vol, date_debut, heure_debut, id_compagnie, numero_aeroport_dep, id_terminal_dep, numero_aeroport_arr, id_terminal_arr, equipage, indice_qualite) 
VALUES (110, TO_DATE('2026-06-15', 'YYYY-MM-DD'), TO_TIMESTAMP('09:00:00', 'HH24:MI:SS'), 1, 101, 1, 106, 1,
        EQUIPAGE(equipageV('Jean Martin', 'Pilote')),
        NULL);
COMMIT;
