import { CompagnieAPI } from "../api/compagnieapi.js";

export class CompagnieSubViewApp {
    constructor(containerId) {
        this.container = document.getElementById(containerId);
        
        // L'État central de l'application (State)
        this.state = {
            compagnies: [],
            idCompagnie: null, // si null post, sinon put ou delete
            isDeleting: false // si false put, sinon delete
        };

        // Initialisation de l'application
        this.init();
    }

    async init() {
        await this.loadCompagnies();
        // Une fois les données chargées, on met à jour l'UI dans la div route
        if (this.container) {
             this.container.innerHTML = this.renderGetCompagnie();
        }
        // On écoute les événements globaux
        // this.bindEvents();
    }

    async loadCompagnies() {
        try {
            this.state.compagnies = await CompagnieAPI.getCompagnies();
        } catch (e) {
            console.error(e);
            this.state.compagnies = []; // Fallback en cas d'erreur
        }
    }


    renderGetCompagnie() {
        console.log("Ajout du render GET-COMPAGNIE"); //debug
        this.state.idCompagnie = null;
        let rows = '';
        this.state.compagnies.forEach(compagnie => {
            console.log(compagnie.nom_compagnie);
            rows += `
                <tr class="">
                    <td class="">${compagnie.nom_compagnie}</td>
                    <td class="">
                        <button class=""><i class="fas fa-edit"></i></button>
                        <a href="" class=""><i class="fas fa-trash-alt"></i></a>
                    </td>
                </tr>
            `;
        });
        return `
        <div class="">
            <div class="">
                <input class="" id="searchBar"
                    onkeyup="searchByName()" placeholder="Chercher par nom...">
            </div>
            <table class="table">
                <thead>
                    <tr class="">
                        <th class="">Nom de Compagnie</th>
                        <th class="">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    ${rows}
                </tbody>
            </table>
        </div>
        `;
    }

    static async renderPutPostCompagnie(){
        console.log("Ajout du render PUT-OR-POST-COMPAGNIE"); //debug
        const http = "Ajouter Une Compagnie";
        const compagnie = {nom: ''};
        const idCompagnie = this.state.idCompagnie;
        if (idCompagnie){
            const json = CompagnieAPI.getCompagnies();
            compagnie[nom] = json[idCompagnie].nom_compagnie;
            http = "Modifier Une Compagnie";
        }

        return `
            <div class="">
                <div class="">
                    <div class="">
                        <div class="">
                            <i class="fa-solid fa-circle-plus"></i>
                            <h3 class="">${http}</h3>
                        </div>
                        <button class="">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                        <div class="mb-4 flex justify-between items-center">
                            <div>
                                <label for="addNomC" class="">Nom de Compagnie</label>
                            </div>
                        </div>
                        <div class="">
                            <button type="button"
                                class="">
                                Annuler
                            </button>
                            <button type="submit"
                                class="">
                                Ajouter
                            </button>
                        </div>
                    </form>
                </div>
            </div>
            `
        }

    // --- GESTION DES ÉVÉNEMENTS (Délégation d'événements) ---
    // Au lieu de mettre des addEventListener de partout qui se perdent quand le HTML est recréé (render),
    // On met un seul écouteur sur le conteneur principal.
    bindEvents() {
        this.container.addEventListener('click', async (e) => {
            // 1. Clic sur "Compagnie"
            if (e.target.id === 'btn-get') {
                this.setState({ currentTask: null, isCreating: true });
            }

            // 2. Clic sur "Vols"
            if (e.target.id === 'btn-post') {
                this.setState({ currentTask: null, isCreating: true });
            }

            // 3. Clic sur "Terminaux"
            if (e.target.id === 'btn-put') {
                this.setState({ currentTask: null, isCreating: true });
            }

            // 4. Clic sur le bouton "Modifier une Compagnie"
            if (e.target.id === 'btn-delete') {
                const title = document.getElementById('input-title').value;
                const description = document.getElementById('input-desc').value;
                const done = document.getElementById('input-done').checked;

                if (!title) return alert("Le titre est requis.");

                if (this.state.currentTask) {
                    // Update
                    await TodoAPI.updateTask(this.state.currentTask.id, { title, description, done });
                } else {
                    // Create
                    await TodoAPI.createTask({ title, description, done });
                }
                
                // On recharge la liste après modification
                await this.loadCompagnies();
                this.setState({ isCreating: false, currentTask: null });
            }
        });
    } 
}