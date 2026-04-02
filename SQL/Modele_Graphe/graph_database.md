// ==========================================
// 1. CRÉATION DES COMPAGNIES
// ==========================================
MERGE (c1:Compagnie {id_compagnie: 1, nom_comp: 'Air France'})
MERGE (c2:Compagnie {id_compagnie: 2, nom_comp: 'Lufthansa'})
MERGE (c3:Compagnie {id_compagnie: 3, nom_comp: 'Delta Airlines'})
MERGE (c4:Compagnie {id_compagnie: 4, nom_comp: 'British Airways'})
MERGE (c5:Compagnie {id_compagnie: 5, nom_comp: 'Emirates'})

// ==========================================
// 2. CRÉATION DES AÉROPORTS
// ==========================================
MERGE (a101:Aeroport {numero_aeroport: 101, nom_aeroport: 'Charles de Gaulle', ville: 'Paris', pays: 'France'})
MERGE (a102:Aeroport {numero_aeroport: 102, nom_aeroport: 'Frankfurt Airport', ville: 'Francfort', pays: 'Allemagne'})
MERGE (a103:Aeroport {numero_aeroport: 103, nom_aeroport: 'JFK International', ville: 'New York', pays: 'USA'})
MERGE (a104:Aeroport {numero_aeroport: 104, nom_aeroport: 'Heathrow', ville: 'Londres', pays: 'Royaume-Uni'})
MERGE (a105:Aeroport {numero_aeroport: 105, nom_aeroport: 'Dubai International', ville: 'Dubai', pays: 'Émirats Arabes Unis'})
MERGE (a106:Aeroport {numero_aeroport: 106, nom_aeroport: 'Orly', ville: 'Paris', pays: 'France'})

// ==========================================
// 3. CRÉATION DES TERMINAUX ET LIAISONS AUX AÉROPORTS
// ==========================================
// Terminaux de départ (selon tes INSERTS)
MERGE (t101_2:Terminal {id_terminal: 2, numero_aeroport: 101})
MERGE (t101_2)-[:APPARTIENT]->(a101)

MERGE (t102_1:Terminal {id_terminal: 1, numero_aeroport: 102})
MERGE (t102_1)-[:APPARTIENT]->(a102)

MERGE (t105_3:Terminal {id_terminal: 3, numero_aeroport: 105})
MERGE (t105_3)-[:APPARTIENT]->(a105)

MERGE (t103_4:Terminal {id_terminal: 4, numero_aeroport: 103})
MERGE (t103_4)-[:APPARTIENT]->(a103)

MERGE (t106_1:Terminal {id_terminal: 1, numero_aeroport: 106})
MERGE (t106_1)-[:APPARTIENT]->(a106)

MERGE (t104_5:Terminal {id_terminal: 5, numero_aeroport: 104})
MERGE (t104_5)-[:APPARTIENT]->(a104)

// Terminaux d'arrivée génériques (car non spécifiés dans ton SQL)
MERGE (t101_arr:Terminal {id_terminal: 0, numero_aeroport: 101})
MERGE (t101_arr)-[:APPARTIENT]->(a101)

MERGE (t102_arr:Terminal {id_terminal: 0, numero_aeroport: 102})
MERGE (t102_arr)-[:APPARTIENT]->(a102)

MERGE (t103_arr:Terminal {id_terminal: 0, numero_aeroport: 103})
MERGE (t103_arr)-[:APPARTIENT]->(a103)

MERGE (t104_arr:Terminal {id_terminal: 0, numero_aeroport: 104})
MERGE (t104_arr)-[:APPARTIENT]->(a104)

// ==========================================
// 4. CRÉATION DES VOLS ET DES RELATIONS
// ==========================================
// VOL 100 - Jour 1 (01/06/2026)
CREATE (v100_j1:Vol {numero_vol: 100, date_debut: '2026-06-01', heure_debut: '08:00:00'})
CREATE (v100_j1)-[:IDENTIFIER_PAR]->(c1)
CREATE (v100_j1)-[:PARS {date_debut: '2026-06-01', heure_debut: '08:00:00'}]->(t101_2)
CREATE (v100_j1)-[:ARRIVE {date_arrivee: '2026-06-01', heure_arrivee: '09:30:00'}]->(t104_arr)

// VOL 100 - Jour 2 (02/06/2026)
CREATE (v100_j2:Vol {numero_vol: 100, date_debut: '2026-06-02', heure_debut: '08:00:00'})
CREATE (v100_j2)-[:IDENTIFIER_PAR]->(c1)
CREATE (v100_j2)-[:PARS {date_debut: '2026-06-02', heure_debut: '08:00:00'}]->(t101_2)
CREATE (v100_j2)-[:ARRIVE {date_arrivee: '2026-06-02', heure_arrivee: '09:30:00'}]->(t104_arr)

// VOL 250 (01/06/2026)
CREATE (v250:Vol {numero_vol: 250, date_debut: '2026-06-01', heure_debut: '10:15:00'})
CREATE (v250)-[:IDENTIFIER_PAR]->(c2)
CREATE (v250)-[:PARS {date_debut: '2026-06-01', heure_debut: '10:15:00'}]->(t102_1)
CREATE (v250)-[:ARRIVE {date_arrivee: '2026-06-01', heure_arrivee: '12:45:00'}]->(t101_arr)

// VOL 442 (01/06/2026)
CREATE (v442:Vol {numero_vol: 442, date_debut: '2026-06-01', heure_debut: '14:00:00'})
CREATE (v442)-[:IDENTIFIER_PAR]->(c5)
CREATE (v442)-[:PARS {date_debut: '2026-06-01', heure_debut: '14:00:00'}]->(t105_3)
CREATE (v442)-[:ARRIVE {date_arrivee: '2026-06-02', heure_arrivee: '02:00:00'}]->(t101_arr)

// VOL 88 - Jour 1 (01/06/2026)
CREATE (v88_j1:Vol {numero_vol: 88, date_debut: '2026-06-01', heure_debut: '16:30:00'})
CREATE (v88_j1)-[:IDENTIFIER_PAR]->(c3)
CREATE (v88_j1)-[:PARS {date_debut: '2026-06-01', heure_debut: '16:30:00'}]->(t103_4)
CREATE (v88_j1)-[:ARRIVE {date_arrivee: '2026-06-01', heure_arrivee: '19:00:00'}]->(t104_arr)

// VOL 88 - Jour 2 (02/06/2026)
CREATE (v88_j2:Vol {numero_vol: 88, date_debut: '2026-06-02', heure_debut: '16:30:00'})
CREATE (v88_j2)-[:IDENTIFIER_PAR]->(c3)
CREATE (v88_j2)-[:PARS {date_debut: '2026-06-02', heure_debut: '16:30:00'}]->(t103_4) // Utilisation du même terminal par déduction
CREATE (v88_j2)-[:ARRIVE {date_arrivee: '2026-06-02', heure_arrivee: '19:00:00'}]->(t104_arr)

// VOL 312 (03/06/2026)
CREATE (v312:Vol {numero_vol: 312, date_debut: '2026-06-03', heure_debut: '07:45:00'})
CREATE (v312)-[:IDENTIFIER_PAR]->(c1)
CREATE (v312)-[:PARS {date_debut: '2026-06-03', heure_debut: '07:45:00'}]->(t106_1)
CREATE (v312)-[:ARRIVE {date_arrivee: '2026-06-03', heure_arrivee: '08:50:00'}]->(t102_arr)

// VOL 905 (03/06/2026)
CREATE (v905:Vol {numero_vol: 905, date_debut: '2026-06-03', heure_debut: '21:00:00'})
CREATE (v905)-[:IDENTIFIER_PAR]->(c4)
CREATE (v905)-[:PARS {date_debut: '2026-06-03', heure_debut: '21:00:00'}]->(t104_5)
CREATE (v905)-[:ARRIVE {date_arrivee: '2026-06-04', heure_arrivee: '06:30:00'}]->(t103_arr)

// Question 3.

MATCH chemin = shortestPath((A1:Aeroport)-[:APPARTIENT|PARS|ARRIVE*]-(A2:Aeroport))
WHERE A1.ville <> A2.ville
RETURN A1.ville, A2.ville, length(chemin) as longueur
ORDER BY A1.ville