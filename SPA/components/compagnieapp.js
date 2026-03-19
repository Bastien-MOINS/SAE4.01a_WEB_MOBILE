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

    showToast(message, type = "success", duration = 3000) {
        const oldToast = document.getElementById("app-toast");
        if (oldToast) oldToast.remove();

        const toast = document.createElement("div");
        toast.id = "app-toast";
        toast.textContent = message;
        toast.style.position = "fixed";
        toast.style.top = "20px";
        toast.style.right = "20px";
        toast.style.padding = "12px 16px";
        toast.style.borderRadius = "8px";
        toast.style.color = "#fff";
        toast.style.zIndex = "9999";
        toast.style.backgroundColor = type === "success" ? "#16a34a" : "#dc2626";
        toast.style.boxShadow = "0 6px 18px rgba(0,0,0,0.2)";
        toast.style.opacity = "1";
        toast.style.transition = "opacity 0.3s ease";

        document.body.appendChild(toast);

        setTimeout(() => {
            toast.style.opacity = "0";
            setTimeout(() => toast.remove(), 300);
        }, duration);
    }

    async init() {
        await this.loadCompagnies();
        // Une fois les données chargées, on met à jour l'UI dans la div route
        if (this.container) {
             this.container.innerHTML = this.renderGetCompagnie();
        }
        // On écoute les événements globaux
        this.bindEvents();
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
            // On récupère l'identifiant (à adapter avec le vrai nom de ton ID côté BDD, ex: id ou idCompagnie)
            const idC = compagnie.id_compagnie;
            console.log(idC);

            rows += `
                <tr class="">
                    <td class="">${idC}</td>
                    <td class="">${compagnie.nom_compagnie}</td>
                    <td class="">
                        <button class="btn-put" data-id="${idC}"><i class="fas fa-edit"></i></button>
                        <button class="btn-delete" data-id="${idC}"><i class="fas fa-trash-alt"></i></button>
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
                        <th class="">Id de compagnie</th>
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

    async renderPickCompagnieID(){
        console.log("Ajout du render CHOOSE AN ID"); //debug
        let putordelete = "modifier";
        if (this.state.isDeleting){
            putordelete = "supprimer (⚠️ Il n'y aura plus de retour en arrière possible!)";
        }
        let idCompagnie = prompt(`Veuillez donnez l'id de la compagnie que vous souhaiteriez ${putordelete}`);
        if (!idCompagnie){
            return ;
        } else {
            if (this.state.isDeleting){
                if (confirm('Voulez-vous vraiment supprimer cette compagnie ?')) {
                    try {
                        await CompagnieAPI.deleteCompagnie(idCompagnie);
                        this.showToast("Compagnie supprimée avec succès.");
                        await this.loadCompagnies();
                        this.container.innerHTML = this.renderGetCompagnie();
                    } catch(error) {
                        alert(`Impossible de supprimer cette compagnie:\n ${error}`);
                        console.error(error);
                    }
                }
                return;
            }
            this.state.idCompagnie = idCompagnie;
            this.PutPost();
        }
    }

    async renderPutPostCompagnie(){
        console.log("Ajout du render PUT-OR-POST-COMPAGNIE"); //debug
        let http = "Ajouter Une Compagnie";
        const compagnie = {nom: ''};
        const idCompagnie = this.state.idCompagnie;

        if (idCompagnie){
            try{
                const response = await CompagnieAPI.getCompagnieById(idCompagnie);
                compagnie.nom = response.nom_compagnie;
                http = "Modifier Une Compagnie";
            } catch(error) {
                alert ("Compagnie non existante, veuillez réessayer plus tard.");
                return ''; // Arrête le rendu
            }
        }

        return `
                <div class="">
                    <div class="">
                        <div class="">
                            <i class="fa-solid fa-circle-plus"></i>
                            <h3 class="">${http}</h3>
                        </div>
                    </div>
                        <div class="mb-4 flex justify-between items-center">
                            <div>
                                <label class="">Nom de Compagnie</label>
                                <!-- Ajout du vrai champ input manquant -->
                                <input type="text" id="addNomC" value="${compagnie.nom}" />
                            </div>
                        </div>
                        <div class="">
                            <button type="button"
                                id="btn-get">
                                Annuler
                            </button>
                            <button type="button"
                                id="btn-add">
                                ${idCompagnie ? "Modifier" : "Ajouter"}
                            </button>
                        </div>
                    </div>
                </div>
            `
        }

    // --- GESTION DES ÉVÉNEMENTS (Délégation d'événements) ---
    // Au lieu de mettre des addEventListener de partout qui se perdent quand le HTML est recréé (render),
    // On met un seul écouteur sur le conteneur principal.
    bindEvents() {
        document.body.addEventListener('click', async (e) => {
            // S'assurer que le container principal existe encore sinon on ne fait rien
            if (!document.getElementById('route')?.contains(this.container)) return;

            // 1. Clic sur "Get"
            if (e.target.id === 'btn-get') {
                this.container.innerHTML = this.renderGetCompagnie();
                return;
            }

            // 2. Clic sur "Post"
            if (e.target.id === 'btn-post') {
                this.state.isDeleting = false;
                this.state.idCompagnie = null;
                this.PutPost();
                return;
            }

            // 3. Clic sur "Put" et "Delete"
            if (e.target.id === 'btn-put' && !e.target.classList.contains('btn-put')) {
                this.state.isDeleting = false;
                this.renderPickCompagnieID();
                return;
            }
            if (e.target.id === 'btn-delete' && !e.target.classList.contains('btn-delete')) {
                this.state.isDeleting = true;
                this.renderPickCompagnieID();
                return;
            }

            // --- Événements INTERNES au formulaire (#route) ---

            // Clic sur le bouton "Ajouter" ou "Modifier" (validation du formulaire)
            if (e.target.id === 'btn-add') {
                const inputNom = document.getElementById('addNomC');
                if (!inputNom) return; 

                const nom = inputNom.value.trim();
                if (!nom) return alert("Le nom est requis.");

                try {
                    if (this.state.idCompagnie) {
                        // Update
                        await CompagnieAPI.modifyCompagnie(this.state.idCompagnie, nom);
                        this.showToast("Compagnie modifiée avec succès.");
                    } else {
                        // Create
                        await CompagnieAPI.createCompagnie(nom);
                        this.showToast("Compagnie créée avec succès.");
                    }

                    await this.loadCompagnies();
                    this.container.innerHTML = this.renderGetCompagnie();
                } catch (error) {
                    console.error(error);
                    alert("La création ou la modification est impossible pour le moment.");
                }
                return;
            }

            // Gestion pour les boutons des lignes du tableau (Modifier)
            const putBtn = e.target.closest('.btn-put');
            if (putBtn) {
                this.state.isDeleting = false;
                this.state.idCompagnie = parseInt(putBtn.getAttribute('data-id'));
                // On passe directement au formulaire de modification sans faire de prompt
                this.PutPost();
                return;
            }

            // Gestion pour les boutons des lignes du tableau (Supprimer)
            const deleteBtn = e.target.closest('.btn-delete');
            if (deleteBtn) {
                e.preventDefault();
                const idC = parseInt(deleteBtn.getAttribute('data-id'));
                if (confirm('Voulez-vous vraiment supprimer cette compagnie ?')) {
                    try {
                        await CompagnieAPI.deleteCompagnie(idC);
                        this.showToast("Compagnie supprimée avec succès.");
                        await this.loadCompagnies();
                        this.container.innerHTML = this.renderGetCompagnie();
                    } catch(error) {
                        alert(`Impossible de supprimer cette compagnie.\n${error}`);
                    }
                }
                return;
            }
        });
    } 
    async PutPost() {
        const html = await this.renderPutPostCompagnie();
        if (html) {
            this.container.innerHTML = html;
        }
    }
}