CREATE TABLE COMPAGNIE (
    id_compagnie INTEGER NOT NULL,
    nom_comp VARCHAR2(38),
    PRIMARY KEY(id_compagnie)
);

CREATE TABLE AEROPORT (
    numero_aeroport INTEGER NOT NULL,
    nom_aeroport VARCHAR2(38),
    ville VARCHAR2(38),
    pays VARCHAR2(38),
    PRIMARY KEY(numero_aeroport)
);

CREATE TABLE TERMINAL (
    numero_aeroport INTEGER NOT NULL,
    id_terminal INTEGER,
    nom_terminal VARCHAR2(38),
    PRIMARY KEY(numero_aeroport, id_terminal),
    FOREIGN KEY (numero_aeroport) REFERENCES AEROPORT (numero_aeroport)
);

CREATE TABLE VOL (
    numero_vol INTEGER NOT NULL,
    date_debut DATE NOT NULL,
    heure_debut TIMESTAMP,
    date_arrivee DATE,
    heure_arrivee TIMESTAMP,
    id_compagnie INTEGER,
    numero_aeroport_dep INTEGER,
    id_terminal_dep INTEGER,
    numero_aeroport_arr INTEGER,
    id_terminal_arr INTEGER,
    PRIMARY KEY(numero_vol, date_debut, heure_debut),
    FOREIGN KEY (id_compagnie) REFERENCES COMPAGNIE (id_compagnie),
    FOREIGN KEY (numero_aeroport_dep, id_terminal_dep) REFERENCES TERMINAL (numero_aeroport, id_terminal),
    FOREIGN KEY (numero_aeroport_arr, id_terminal_arr) REFERENCES TERMINAL (numero_aeroport, id_terminal)
);

