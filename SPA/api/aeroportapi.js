// --- 1. COUCHE API ---
// Gère uniquement les communications avec le serveur.
export class AeroportAPI {
    static BASE_URL = 'http://127.0.0.1:5000/aeroports/';

    static async getAeroports() {
        try {
            const response = await fetch(this.BASE_URL);
            if (!response.ok) throw new Error("Erreur réseau");
            
            const json = await response.json();
            return json;
        } catch (error) {
            console.error("Erreur lors de la récupération des aeroports:", error);
            return [];
        }
    }

    static async getAeroportById(idAeroport) {
        try{
            const response = await fetch(this.BASE_URL + `${idAeroport}`)
            if (!response.ok) throw new Error("Erreur réseau");

            const json = await response.json();
            return json;
        } catch(error) {
            console.error(`Erreur lors de la récupération de l'aéroport (id: ${idAeroport})`, error);
            return [];
        }
    }

    static async createAeroport(nomAeroport, ville, pays, longitude, latitude) {
        try {
            const response = await fetch(this.BASE_URL, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(
                    { nom_aeroport: nomAeroport,
                      ville: ville,
                      pays: pays,
                      longitude: longitude,
                      latitude: latitude
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

    static async modifyAeroport(idAeroport, nomAeroport, ville, pays) {
        try {
            const response = await fetch(this.BASE_URL + `${idAeroport}`, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(
                    { nom_aeroport: nomAeroport,
                      ville: ville,
                      pays: pays
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

    static async deleteAeroport(idAeroport) {
        try{
            const response = await fetch(this.BASE_URL + `${idAeroport}`, {
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