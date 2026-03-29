// --- 1. COUCHE API ---
// Gère uniquement les communications avec le serveur.
export class VolAPI {
    static BASE_URL = 'http://127.0.0.1:5000/vol/';

    static async getVols() {
        try {
            const response = await fetch(this.BASE_URL);
            if (!response.ok) throw new Error("Erreur réseau");
            
            const json = await response.json();
            
            return json.aller || (Array.isArray(json) ? json : []);
        } catch (error) {
            console.error("Erreur lors de la récupération des vols:", error);
            return [];
        }
    }

    static async getVolById(idVol) {
        try{
            const response = await fetch(this.BASE_URL + `${idVol}`)
            if (!response.ok) throw new Error("Erreur réseau");

            const json = await response.json();
            return json;
        } catch(error) {
            console.error(`Erreur lors de la récupération du vol (id: ${idVol})`, error);
            return [];
        }
    }

    static async createVol(dateDebut, heureDebut, dateArrivee, heureArrivee, idCompagnie, numeroAeroportDep, numeroAeroportArr, idTerminalDep, idTerminalArr) {
        try {
            const response = await fetch(this.BASE_URL, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(
                    { date_debut: dateDebut,
                      heure_debut: heureDebut,
                      date_arrivee: dateArrivee,
                      heure_arrivee: heureArrivee,
                      id_compagnie: idCompagnie,
                      numero_aeroport_dep: numeroAeroportDep,
                      numero_aeroport_arr: numeroAeroportArr,
                      id_terminal_dep: idTerminalDep,
                      id_terminal_arr: idTerminalArr
                    })
            });

            if (!response.ok) {
                const errorData = await response.json();
                throw new Error(errorData.message || "Erreur de création");
            }

            return await response.json();
        } catch (error) {
            console.error("Erreur création:", error);
            throw error;
        }
    }

    static async modifyVol(idVol, dateDebut, heureDebut, dateArrivee, heureArrivee, idCompagnie, numeroAeroportDep, numeroAeroportArr, idTerminalDep, idTerminalArr) {
        try {
            const response = await fetch(this.BASE_URL + `${idVol}`, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(
                    { date_debut: dateDebut,
                      heure_debut: heureDebut,
                      date_arrivee: dateArrivee,
                      heure_arrivee: heureArrivee,
                      id_compagnie: idCompagnie,
                      numero_aeroport_dep: numeroAeroportDep,
                      numero_aeroport_arr: numeroAeroportArr,
                      id_terminal_dep: idTerminalDep,
                      id_terminal_arr: idTerminalArr
                    })
            });
            if (!response.ok) {
                const errorData = await response.json();
                throw new Error(errorData.message || "Erreur de modification");
            }

            return await response.json();
        } catch (error) {
            console.error("Erreur modification:", error);
            throw error;
        }
    }

    static async deleteVol(idVol) {
        try{
            const response = await fetch(this.BASE_URL + `${idVol}`, {
                method: 'DELETE'
            });
            if (!response.ok) {
                const errorData = await response.json();
                throw new Error(errorData.message || "Erreur de suppression");
            }

            return await response.json();
        } catch (error) {
            console.error("Erreur suppression:", error);
            throw error;
        }
    }
}