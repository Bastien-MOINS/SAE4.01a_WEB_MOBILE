CREATE OR REPLACE TABLE VOL (
    numero_vol INT(8),
    date_debut DATE,
    heure_debut TIME(6),
    date_arrivee DATE,
    heure_arrivee TIME(6),
    id_compagnie INT(8),
    PRIMARY KEY(numero_vol, date_debut, heure_debut)
);

CREATE OR REPLACE TABLE AEROPORT (
    numero_aeroport INT(8),
    nom_aeroport VARCHAR(38),
    ville VARCHAR(38),
    pays VARCHAR(38),
    PRIMARY KEY(numero_aeroport)
);

CREATE OR REPLACE TABLE COMPAGNIE (
    id_compagnie INT(8),
    nom_comp VARCHAR(38),
    PRIMARY KEY(id_compagnie)
);

CREATE OR REPLACE TABLE TERMINAL (
    numero_vol INT(8),
    numero_aeroport INT(8),
    date_debut DATE,
    heure_debut TIME(6),
    id_terminal INT(8),
    PRIMARY KEY(numero_vol, numero_aeroport, date_debut, heure_debut)
);

ALTER TABLE VOL ADD FOREIGN KEY (id_compagnie) REFERENCES COMPAGNIE (id_compagnie);
ALTER TABLE TERMINAL ADD FOREIGN KEY (numero_vol, date_debut, heure_depart) REFERENCES VOL (numero_vol, date_debut, date_arrivee);
ALTER TABLE TERMINAL ADD FOREIGN KEY (numero_aeroport) REFERENCES AEROPORT (numero_aeroport);
