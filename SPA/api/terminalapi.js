// --- 1. COUCHE API ---
// Gère uniquement les communications avec le serveur.
export class TerminalAPI {
    static BASE_URL = 'http://127.0.0.1:5000/terminal/';

    static async getTerminaux() {
        try {
            const response = await fetch(this.BASE_URL);
            if (!response.ok) throw new Error("Erreur réseau");
            
            const json = await response.json();
            return json;
        } catch (error) {
            console.error("Erreur lors de la récupération des terminaux:", error);
            return [];
        }
    }

    static async getTerminalById(idTerminal) {
        try{
            const response = await fetch(this.BASE_URL + `${idTerminal}`)
            if (!response.ok) throw new Error("Erreur réseau");

            const json = await response.json();
            return json;
        } catch(error) {
            console.error(`Erreur lors de la récupération du terminal (id: ${idTerminal})`, error);
            return [];
        }
    }

    static async createTerminal(nomTerminal, numeroAeroport) {
        try {
            const response = await fetch(this.BASE_URL, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(
                    { nom_terminal: nomTerminal,
                      numero_aeroport: numeroAeroport
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

    static async modifyTerminal(idTerminal, nomTerminal, numeroAeroport) {
        try {
            const response = await fetch(this.BASE_URL + `${idTerminal}`, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ 
                    nom_terminal: nomTerminal,
                    numero_aeroport: numeroAeroport 
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

    static async deleteTerminal(idTerminal) {
        try{
            const response = await fetch(this.BASE_URL + `${idTerminal}`, {
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