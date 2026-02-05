-- -- Requete A

-- select distinct A2.ville from VOL as V 
join AEROPORT as A1 on V.numero_aeroport_dep = A1.numero_aeroport
join AEROPORT as A2 on V.numero_aeroport_arr = A2.numero_aeroport
-- where A1.ville = "Paris";

delimiter |
create or replace procedure vol_direct_depuis_une_ville(ville_demmande varchar(255))
begin
    select distinct A2.ville from VOL as V
    join AEROPORT as A1 on V.numero_aeroport_dep = A1.numero_aeroport
    join AEROPORT as A2 on V.numero_aeroport_arr = A2.numero_aeroport
--     where A1.ville = ville_demmande;
end |
delimiter ;

-- Requete B

SELECT DISTINCT Aeroport_Final.ville 
-- premier vol depart->correspondance
FROM VOL AS V1
JOIN AEROPORT AS Aeroport_Depart ON V1.numero_aeroport_dep = Aeroport_Depart.numero_aeroport
-- deuxieme vol correspondance->arrivee
JOIN VOL AS V2 ON V1.numero_aeroport_arr = V2.numero_aeroport_dep
JOIN AEROPORT AS Aeroport_Final ON V2.numero_aeroport_arr = Aeroport_Final.numero_aeroport
WHERE Aeroport_Depart.ville = 'Paris' 
AND (V2.date_debut > V1.date_arrivee OR (V2.date_debut = V1.date_arrivee AND V2.heure_debut > V1.heure_arrivee))
AND (V2.date_debut < DATE_ADD(V1.date_arrivee, INTERVAL 1 DAY) OR (V2.date_debut = DATE_ADD(V1.date_arrivee, INTERVAL 1 DAY) 
AND V2.heure_debut <= V1.heure_arrivee));

-- Requete C

SELECT DISTINCT Aeroport_Final.ville 
-- premier vol depart->correspondance
FROM VOL AS V1
JOIN AEROPORT AS Aeroport_Depart ON V1.numero_aeroport_dep = Aeroport_Depart.numero_aeroport
-- deuxieme vol correspondance1->correspondance2
JOIN VOL AS V2 ON V1.numero_aeroport_arr = V2.numero_aeroport_dep
-- troisieme vol correspondance2->arrivee
JOIN VOL AS V3 ON V2.numero_aeroport_arr = V3.numero_aeroport_dep
JOIN AEROPORT AS Aeroport_Final ON V3.numero_aeroport_arr = Aeroport_Final.numero_aeroport
WHERE Aeroport_Depart.ville = 'Paris' 
AND (V2.date_debut > V1.date_arrivee OR (V2.date_debut = V1.date_arrivee AND V2.heure_debut > V1.heure_arrivee))
AND (V2.date_debut < DATE_ADD(V1.date_arrivee, INTERVAL 1 DAY) OR (V2.date_debut = DATE_ADD(V1.date_arrivee, INTERVAL 1 DAY) 
AND V2.heure_debut <= V1.heure_arrivee))
AND (V3.date_debut > V2.date_arrivee OR (V3.date_debut = V2.date_arrivee AND V3.heure_debut > V2.heure_arrivee))
AND (V3.date_debut < DATE_ADD(V2.date_arrivee, INTERVAL 1 DAY) OR (V3.date_debut = DATE_ADD(V2.date_arrivee, INTERVAL 1 DAY) 
AND V3.heure_debut <= V2.heure_arrivee));


-- Requete D

with recursive villes_accessibles() as (
    select A2.numero_aeroport, A2.nom_aeroport, A2.ville, 1 as nb_correspondances
    from VOL as V
    join AEROPORT as A1 on V.numero_aeroport_dep = A1.numero_aeroport
    join AEROPORT as A2 on V.numero_aeroport_arr = A2.numero_aeroport
    where A1.ville = "Paris";

    union all

    select VV.numero_aeroport, VV.nom_aeroport, VV.ville, VA.nb_correspondances + 1
    from VOL as VV
    join AEROPORT as AA1 on VV.numero_aeroport_dep = AA1.numero_aeroport
    join AEROPORT as AA2 on VV.numero_aeroport_arr = AA2.numero_aeroport
    inner join villes_accessibles VA on VA.numero_aeroport = VV.numero_aeroport
    where AA1.ville = VA.ville;
)
select * from villes_accessibles order by nb_correspondances;
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