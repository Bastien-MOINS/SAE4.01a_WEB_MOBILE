-- Requete A

select EQUIPAGE from VOL;

-- Requete B

select Nom, Fonction, count(*) as nbVols from VOL, table(VOL.equipage) 
where Fonction = 'Pilote' group by Nom, Fonction;

-- Requete C

select numero_vol, nom_indice, valeur * poids as impact 
from VOL, table(VOL.indice_qualite);

-- Requete D

select nom_indice, avg(valeur * poids) as impact_moyen 
from VOL, table(VOL.indice_qualite) group by nom_indice;