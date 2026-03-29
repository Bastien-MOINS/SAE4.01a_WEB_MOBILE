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

    /**
     * Notification ephémère (Toast) qui s'affiche sans bloquer les actions de l'utilisateur
     * @param {String} message 
     * @param {String} type "success" si l'action est réussi, sinon autre (cela modifie la couleur du pop-up)
     * @param {number} duration Le temps que le pop-up reste à l'écran
     */
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

    // Vue du composant get Compagnies
    renderGetCompagnie() {
        this.state.idCompagnie = null;
        let rows = '';
        this.state.compagnies.forEach(compagnie => {
            const idC = compagnie.id_compagnie;
            rows += `
                <tr class="border-b border-gray-200 hover:bg-gray-50 transition-colors">
                    <td class="px-6 py-4 text-center border-r border-gray-200">${idC}</td>
                    <td class="px-6 py-4 border-r border-gray-200 font-bold">${compagnie.nom_compagnie}</td>
                    <td class="px-6 py-4 text-center">
                        <button class="btn-put text-gray-500 hover:text-blue-600 transition-colors mx-2" data-id="${idC}"><i class="fas fa-edit text-xl"></i></button>
                        <button class="btn-delete text-gray-500 hover:text-red-600 transition-colors mx-2" data-id="${idC}"><i class="fas fa-trash-alt text-xl"></i></button>
                    </td>
                </tr>
            `;
        });
        return `
        <div class="flex flex-col h-full bg-white font-nunito">
            <div class="p-6 border-b border-gray-200 flex justify-between items-center bg-gray-50 rounded-t-xl">
                <h2 class="text-3xl font-bold">Liste des compagnies</h2>
                <div class="search-wrapper flex items-center bg-white border border-gray-300 rounded-lg px-3 py-2 shadow-sm">
                    <i class="fa-solid fa-search text-gray-400 mr-2"></i>
                    <input class="outline-none text-lg bg-transparent" id="searchBar"
                        onkeyup="searchBarFunction(2)" placeholder="Rechercher...">
                </div>
            </div>
            <div class="overflow-x-auto flex-1 p-6">
                <table id="table" class="w-full text-left border-collapse border border-gray-200 shadow-sm rounded-lg overflow-hidden">
                    <thead>
                        <tr class="bg-gray-100 text-gray-700 uppercase tracking-wider text-xl border-b border-gray-300">
                            <th class="px-6 py-4 text-center border-r border-gray-200 w-32">ID</th>
                            <th class="px-6 py-4 border-r border-gray-200">Nom de Compagnie</th>
                            <th class="px-6 py-4 text-center w-40">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        ${rows}
                    </tbody>
                </table>
            </div>
        </div>
        `;
    }

    // Vue du composant pick Compagnie by ID
    async renderPickCompagnieID(){
        let putordelete = "modifier";
        if (this.state.isDeleting){
            putordelete = "supprimer (⚠️ Il n'y aura plus de retour en arrière possible!)";
        }

       await new Promise(resolve => setTimeout(resolve, 50));

        let idCompagnie = prompt(`Veuillez donnez l'id de la compagnie que vous souhaiteriez ${putordelete}`);
        
        if (!idCompagnie){
            document.getElementById('btn-get')?.click();
            return;
        } else {
            if (this.state.isDeleting){
                if (confirm('Voulez-vous vraiment supprimer cette compagnie ?')) {
                    try {
                        await CompagnieAPI.deleteCompagnie(idCompagnie);
                        this.showToast("Compagnie supprimée avec succès.");
                        document.getElementById('btn-get')?.click();
                    } catch(error) {
                        alert(`Impossible de supprimer cette compagnie:\n ${error}`);
                        console.error(error);
                        document.getElementById('btn-get')?.click();
                    }
                } else {
                    document.getElementById('btn-get')?.click();
                }
                return;
            }
            // Logique pour le PUT
            this.state.idCompagnie = idCompagnie;
            this.PutPost();
        }
    }

    // Vue du composant post/put Compagnie
    async renderPutPostCompagnie(){
        let http = "Ajouter une compagnie";
        let iconClass = "fa-circle-plus text-green-600";
        const compagnie = {nom: ''};
        const idCompagnie = this.state.idCompagnie;

        if (idCompagnie){
            try{
                const response = await CompagnieAPI.getCompagnieById(idCompagnie);
                compagnie.nom = response.nom_compagnie;
                http = "Modifier la compagnie";
                iconClass = "fa-edit text-lime-600";
            } catch(error) {
                alert ("Compagnie non existante, veuillez réessayer plus tard.");
                document.getElementById('btn-get')?.click();
                return ''; // Arrête le rendu
            }
        }

        return `
                <div class="flex flex-col h-full bg-white font-nunito">
                    <div class="p-6 border-b border-gray-200 flex justify-between items-center bg-gray-50 rounded-t-xl">
                        <div class="flex items-center gap-3">
                            <i class="fa-solid ${iconClass} text-3xl"></i>
                            <h2 class="text-3xl font-bold">${http}</h2>
                        </div>
                    </div>
                    
                    <div class="p-8 flex-1 flex flex-col items-center justify-center">
                        <div class="w-full max-w-lg p-8 rounded-xl border shadow-sm ${idCompagnie ? 'bg-lime-50 border-lime-200' : 'bg-green-50 border-green-200'}">
                            <div class="mb-6">
                                <label class="block text-2xl font-bold mb-3 ${idCompagnie ? 'text-lime-900' : 'text-green-900'}">Nom de la compagnie</label>
                                <input type="text" id="addNomC" value="${compagnie.nom}" 
                                    class="w-full px-4 py-3 text-xl border border-gray-300 rounded-lg focus:outline-none focus:ring-4 ${idCompagnie ? 'focus:ring-lime-200' : 'focus:ring-green-200'} transition-all"
                                    placeholder="Ex: Air France" />
                            </div>
                            
                            <div class="flex justify-end gap-4 mt-8 pt-6 border-t ${idCompagnie ? 'border-lime-200' : 'border-green-200'}">
                                <button type="button" id="btn-get"
                                    class="px-6 py-3 text-xl font-bold text-gray-600 bg-white hover:bg-gray-100 border border-gray-300 rounded-lg transition-colors">
                                    Annuler
                                </button>
                                <button type="button" id="btn-add"
                                    class="px-8 py-3 text-xl font-bold text-white ${idCompagnie ? 'bg-lime-600 hover:bg-lime-700' : 'bg-green-600 hover:bg-green-700'} rounded-lg transition-colors shadow-md hover:shadow-lg">
                                    ${idCompagnie ? "Mettre à jour" : "Ajouter la compagnie"}
                                </button>
                            </div>
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
                await this.loadCompagnies();
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

                    // Retour sur GET après validation réussie
                    document.getElementById('btn-get')?.click();
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
                this.PutPost();
                return;
            }

            // Gestion pour les boutons des lignes du tableau (Supprimer)
            const deleteBtn = e.target.closest('.btn-delete');
            if (deleteBtn) {
                e.preventDefault();
                const idC = parseInt(deleteBtn.getAttribute('data-id'));
                
                
                // Attente légère pour que l'UI dessine le rouge avant le confirm() bloquant
                await new Promise(resolve => setTimeout(resolve, 50));
                
                if (confirm('Voulez-vous vraiment supprimer cette compagnie ?')) {
                    try {
                        await CompagnieAPI.deleteCompagnie(idC);
                        this.showToast("Compagnie supprimée avec succès.");
                        document.getElementById('btn-get')?.click();
                    } catch(error) {
                        alert(`Impossible de supprimer cette compagnie.\n${error}`);
                        document.getElementById('btn-get')?.click();
                    }
                } else {
                    document.getElementById('btn-get')?.click();
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