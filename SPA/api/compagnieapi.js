// --- 1. COUCHE API ---
// Gère uniquement les communications avec le serveur.
class CompagnieAPI {
    static BASE_URL = 'http://localhost:5000/api/compagnies';

    static async getCompagnies() {
        try {
            const response = await fetch(this.BASE_URL);
            if (!response.ok) throw new Error("Erreur réseau");
            
            return await response.json(); 
        } catch (error) {
            console.error("Erreur lors de la récupération des compagnies:", error);
            return [];
        }
    }

    static async createCompagnie(nomCompagnie) {
        try {
            const response = await fetch(this.BASE_URL, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ nom_compagnie: nomCompagnie })
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

    static async modifyCompagnie(idCompagnie, nomCompagnie) {
        try {
            const response = await fetch(this.BASE_URL + `/${idCompagnie}`, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ nom_compagnie: nomCompagnie })
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

    static async deleteCompagnie(idCompagnie) {
        try{
            const response = await fetch(this.BASE_URL + `/${idCompagnie}`, {
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