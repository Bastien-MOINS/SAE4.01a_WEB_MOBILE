-- -- Requetes A

-- select ville from VOL as V from AEROPORT as A1, AEROPORT as A2
-- where V.num_vol_dep = A1.numero_aeroport and V.num_vol_arr = A2.numero_aeroport
-- and a1.ville = "Paris"; 

-- Requetes C
SELECT CorrespondanceFinale.ville

FROM VOL as V1 join AEROPORT CorrespondanceFinale 
on V1.numero_aeroport_arr = CorrespondanceFinale.numero_aeroport
join AEROPORT CorrespondanceDepart 
on V1.numero_aeroport_dep = CorrespondanceDepart.numero_aeroport

WHERE exists (
    SELECT CorrespondanceDepart1.ville, AeroportDepart1.ville
    FROM VOL as V2 join AEROPORT CorrespondanceDepart1 
    on V2.numero_aeroport_dep = CorrespondanceDepart1.numero_aeroport
    join AEROPORT AeroportDepart1 
    on V2.numero_aeroport_arr = AeroportDepart1.numero_aeroport
    join VOL as V3
    WHERE V1.numero_vol = V2.numero_vol 
    and V2.numero_aeroport_arr = V3.numero_aeroport_dep 
    and DATE_ADD(V2.date_arrivee, INTERVAL 1 DAY) < V3.date_debut 
    and V2.date_arrivee > V3.date_debut 
    and  exists (
        SELECT AeroportArrivee.ville
        FROM VOL as V4 join AEROPORT AeroportDepart
        on AeroportDepart.numero_aeroport = V4.numero_aeroport_dep 
        join AEROPORT AeroportArrivee 
        on AeroportArrivee.numero_aeroport = V4.numero_aeroport_arr 
        WHERE V4.numero_vol = V3.numero_vol and AeroportDepart.ville = 'Paris'
    )
)