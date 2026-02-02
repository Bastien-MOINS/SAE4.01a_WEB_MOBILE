-- Requete A

select distinct A2.ville from VOL as V 
join AEROPORT as A1 on V.numero_aeroport_dep = A1.numero_aeroport
join AEROPORT as A2 on V.numero_aeroport_arr = A2.numero_aeroport
where A1.ville = "Paris";

delimiter |
create or replace procedure vol_direct_depuis_une_ville(ville_demmande varchar(255))
begin
    select distinct A2.ville from VOL as V
    join AEROPORT as A1 on V.numero_aeroport_dep = A1.numero_aeroport
    join AEROPORT as A2 on V.numero_aeroport_arr = A2.numero_aeroport
    where A1.ville = ville_demmande;
end |
delimiter ;

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