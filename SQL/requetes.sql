-- Requete A

SELECT DISTINCT A2.ville 
FROM VOL V
JOIN AEROPORT A1 ON V.numero_aeroport_dep = A1.numero_aeroport
JOIN AEROPORT A2 ON V.numero_aeroport_arr = A2.numero_aeroport
WHERE A1.ville = 'Paris';


-- Requete B

SELECT DISTINCT Aeroport_Final.ville 
-- premier vol depart->correspondance
FROM VOL V1
JOIN AEROPORT Aeroport_Depart ON V1.numero_aeroport_dep = Aeroport_Depart.numero_aeroport
-- deuxieme vol correspondance->arrivee
JOIN VOL V2 ON V1.numero_aeroport_arr = V2.numero_aeroport_dep
JOIN AEROPORT Aeroport_Final ON V2.numero_aeroport_arr = Aeroport_Final.numero_aeroport
WHERE Aeroport_Depart.ville = 'Paris' 
AND (V2.date_debut > V1.date_arrivee OR (V2.date_debut = V1.date_arrivee AND V2.heure_debut > V1.heure_arrivee))
AND (V2.date_debut < V1.date_arrivee + 1 OR (V2.date_debut = V1.date_arrivee + 1 AND V2.heure_debut <= V1.heure_arrivee));


-- Requete C

SELECT DISTINCT Aeroport_Final.ville 
-- premier vol depart->correspondance
FROM VOL V1
JOIN AEROPORT Aeroport_Depart ON V1.numero_aeroport_dep = Aeroport_Depart.numero_aeroport
-- deuxieme vol correspondance1->correspondance2
JOIN VOL V2 ON V1.numero_aeroport_arr = V2.numero_aeroport_dep
-- troisieme vol correspondance2->arrivee
JOIN VOL V3 ON V2.numero_aeroport_arr = V3.numero_aeroport_dep
JOIN AEROPORT Aeroport_Final ON V3.numero_aeroport_arr = Aeroport_Final.numero_aeroport
WHERE Aeroport_Depart.ville = 'Paris' 
AND (V2.date_debut > V1.date_arrivee OR (V2.date_debut = V1.date_arrivee AND V2.heure_debut > V1.heure_arrivee))
AND (V2.date_debut < V1.date_arrivee + 1 OR (V2.date_debut = V1.date_arrivee + 1 AND V2.heure_debut <= V1.heure_arrivee))
AND (V3.date_debut > V2.date_arrivee OR (V3.date_debut = V2.date_arrivee AND V3.heure_debut > V2.heure_arrivee))
AND (V3.date_debut < V2.date_arrivee + 1 OR (V3.date_debut = V2.date_arrivee + 1 AND V3.heure_debut <= V2.heure_arrivee));


-- Requete D

WITH Voyages (numero_aeroport_arrivee, date_arrivee, heure_arrivee, ville_arrivee) AS (
    SELECT 
        V.numero_aeroport_arr, 
        V.date_arrivee, 
        V.heure_arrivee,
        A_Arr.ville
    FROM VOL V
    JOIN AEROPORT A_Dep ON V.numero_aeroport_dep = A_Dep.numero_aeroport
    JOIN AEROPORT A_Arr ON V.numero_aeroport_arr = A_Arr.numero_aeroport
    WHERE A_Dep.ville = 'Paris'
    UNION ALL
    SELECT 
        VSuivant.numero_aeroport_arr, 
        VSuivant.date_arrivee, 
        VSuivant.heure_arrivee,
        ASuivant.ville
    FROM Voyages
    JOIN VOL VSuivant ON Voyages.numero_aeroport_arrivee = VSuivant.numero_aeroport_dep
    JOIN AEROPORT ASuivant ON VSuivant.numero_aeroport_arr = ASuivant.numero_aeroport 
    WHERE 
        (VSuivant.date_debut > Voyages.date_arrivee OR (VSuivant.date_debut = Voyages.date_arrivee AND VSuivant.heure_debut > Voyages.heure_arrivee))
        AND (VSuivant.date_debut < Voyages.date_arrivee + 1 OR (VSuivant.date_debut = Voyages.date_arrivee + 1 AND VSuivant.heure_debut <= Voyages.heure_arrivee))
)
SELECT DISTINCT ville_arrivee FROM Voyages;

