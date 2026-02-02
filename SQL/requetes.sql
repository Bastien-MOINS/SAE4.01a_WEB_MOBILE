-- Requetes A

select ville from VOL as V from AEROPORT as A1, AEROPORT as A2
where V.num_vol_dep = A1.numero_aeroport and V.num_vol_arr = A2.numero_aeroport
and a1.ville = "Paris"; 

-- Requetes C