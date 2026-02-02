-- Requete A

select distinct A2.ville from VOL as V 
join AEROPORT as A1 on V.numero_aeroport_dep = A1.numero_aeroport
join AEROPORT as A2 on V.numero_aeroport_arr = A2.numero_aeroport
where A1.ville = "Paris";

-- Requete C