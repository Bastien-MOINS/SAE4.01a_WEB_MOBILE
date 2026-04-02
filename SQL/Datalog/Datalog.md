% 1.

vol_direct(NumeroVol, AeroportDepart, AeroportArrivee, TempsDepart, TempsArrivee, IdCompagnie IdTerminalDepart, IdTerminalArrivee)
aeroport_ville(NumeroAeroport, Aeroport, Ville, Pays)

% donnees

vol_direct(101, cdg, gig, 2, 8, 1, 2, 1).
vol_direct(102, gig, scl, 10, 14, 1, 1, 1).
vol_direct(103, cdg, lhr, 1, 3, 2, 1, 3).

aeroport_ville(1, cdg, paris, france).
aeroport_ville(2, gig, rio, bresil).
aeroport_ville(3, scl, santiago, chili).
aeroport_ville(4, lhr, londres, uk).

plusPetit(8, 10).

% 2.

% vols directs
connexion(VilleDepart, VilleArrivee, TempsDepart, TempsArrivee) :- 
    vol_direct(NumeroVol, AeroDepart, AeroportArr, TempsDepart, TempsArrivee, IdCompagnie, TerminalDepart, TermArrivee),
    aeroport_ville(NumA1, AeroportDepart, VilleDepart, Pays1),
    aeroport_ville(NumA2, AeroportArrivee, VilleArrivee, Pays2).

% vols avec correspondances
connexion(VilleDepart, VilleArrivee, TempsDepart, TempsArrivee) :- 
    vol_direct(NumVol1, AeroDepart, AeroportEscale, TempsDepart, TempsArriveeEscale, IdCompagnie1, TermDepart1, TermArrivee1),
    aeroport_ville(NumA1, AeroportEscale, VilleDepart, Pays1),
    aeroport_ville(NumA2, AeroportEscale, VilleEscale, Pays2),
    connexion(VilleEscale, VilleArrivee, TempsDepartEscale, TempsArrivee),
    plusPetit(TempsArriveeEscale, TempsDepartEscale).

% res a enter dans la query

connexion(VilleDepart, VilleArrivee, HeureDepart, HeureArrivee)?