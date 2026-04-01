vol_direct(101, cdg, gig, 2, 8, 1, 2, 1). vol_direct(102, gig, scl, 10, 14, 1, 1, 1). vol_direct(103, cdg, lhr, 1, 3, 2, 1, 3).

aeroport_ville(1, cdg, paris, france). aeroport_ville(2, gig, rio, bresil). aeroport_ville(3, scl, santiago, chili). aeroport_ville(4, lhr, londres, uk).

plusPetit(8, 10).

% 3 requête Datalog
% 1. On définit ce qu'est un simple vol direct valide entre deux villes (1 étape)
etape(VilleDep, VilleArr, TDep, TArr) :- 
    vol_direct(_, AeroDep, AeroArr, TDep, TArr, _, _, _), 
    aeroport_ville(_, AeroDep, VilleDep, _), 
    aeroport_ville(_, AeroArr, VilleArr, _).

% 2. CAS DE BASE IMPAIR : 1 seul vol est un trajet impair.
connexion_impair(VilleDepart, VilleArrivee, TempsDepart, TempsArrivee) :- 
    etape(VilleDepart, VilleArrivee, TempsDepart, TempsArrivee),
    VilleDepart != VilleArrivee.

% 3. CHEMIN PAIR : C'est 1 étape + 1 chemin impair qui la suit.
connexion_pair(VilleDepart, VilleArrivee, TempsDepart, TempsArrivee) :- 
    etape(VilleDepart, VilleEscale, TempsDepart, TArrEscale), 
    connexion_impair(VilleEscale, VilleArrivee, TDepSuivant, TempsArrivee), 
    plusPetit(TArrEscale, TDepSuivant).

% 4. CHEMIN IMPAIR (plus long) : C'est 1 étape + 1 chemin pair qui la suit.
connexion_impair(VilleDepart, VilleArrivee, TempsDepart, TempsArrivee) :- 
    connexion(VilleDepart, VilleEscale, TempsDepart, TArrEscale), 
    connexion_pair(VilleEscale, VilleArrivee, TDepSuivant, TempsArrivee), 
    plusPetit(TArrEscale, TDepSuivant),
    VilleDepart != VilleArrivee.

% Query : connexion_impair(VilleDepart, VilleArrivee, HeureDepart, HeureArrivee)