-- Requete A

select EQUIPAGE from VOL;

-- Requete B

select Nom, Fonction, count(*) as nbVols from VOL, table(VOL.equipage) 
where Fonction = 'Pilote' group by Nom, Fonction;

-- Requete C



-- Requete D


