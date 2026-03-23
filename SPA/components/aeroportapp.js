import { AeroportAPI } from "../api/aeroportapi.js";

export class AeroportSubViewApp {
    constructor(containerId) {
        this.container = document.getElementById(containerId);
        
        // L'État central de l'application (State)
        this.state = {
            aeroport: [],
            numAeroport: null, // si null post, sinon put ou delete
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
        await this.loadAeroports();
        // Une fois les données chargées, on met à jour l'UI dans la div route
        if (this.container) {
             this.container.innerHTML = this.renderGetAeroport();
        }
        // On écoute les événements globaux
        this.bindEvents();
    }

    async loadAeroports() {
        try {
            this.state.aeroport = await AeroportAPI.getAeroports();
        } catch (e) {
            console.error(e);
            this.state.aeroport = []; // Fallback en cas d'erreur
        }
    }

    // Vue du composant get Compagnie
    renderGetAeroport() {
        this.state.numAeroport = null;
        let rows = '';
        this.state.aeroport.forEach(aeroport => {
            const numA = aeroport.numero_aeroport;
            rows += `
                <tr class="border-b border-gray-200 hover:bg-gray-50 transition-colors">
                    <td class="px-6 py-4 text-center border-r border-gray-200">${numA}</td>
                    <td class="px-6 py-4 border-r border-gray-200 font-bold">${aeroport.nom_aeroport}</td>
                    <td class="px-6 py-4 border-r border-gray-200 font-bold">${aeroport.ville}</td>
                    <td class="px-6 py-4 border-r border-gray-200 font-bold">${aeroport.pays}</td>
                    <td class="px-6 py-4 text-center">
                        <button class="btn-put text-gray-500 hover:text-blue-600 transition-colors mx-2" data-id="${numA}"><i class="fas fa-edit text-xl"></i></button>
                        <button class="btn-delete text-gray-500 hover:text-red-600 transition-colors mx-2" data-id="${numA}"><i class="fas fa-trash-alt text-xl"></i></button>
                    </td>
                </tr>
            `;
        });
        return `
        <div class="flex flex-col h-full bg-white font-nunito">
            <div class="p-6 border-b border-gray-200 flex justify-between items-center bg-gray-50 rounded-t-xl">
                <h2 class="text-3xl font-bold">Liste des aeroport</h2>
                <div class="search-wrapper flex items-center bg-white border border-gray-300 rounded-lg px-3 py-2 shadow-sm">
                    <i class="fa-solid fa-search text-gray-400 mr-2"></i>
                    <input class="outline-none text-lg bg-transparent" id="searchBar"
                        onkeyup="searchBarFunction(4)" placeholder="Rechercher...">
                </div>
            </div>
            <div class="overflow-x-auto flex-1 p-6">
                <table id="table" class="w-full text-left border-collapse border border-gray-200 shadow-sm rounded-lg overflow-hidden">
                    <thead>
                        <tr class="bg-gray-100 text-gray-700 uppercase tracking-wider text-xl border-b border-gray-300">
                            <th class="px-6 py-4 text-center border-r border-gray-200 w-32">Num.</th>
                            <th class="px-6 py-4 border-r border-gray-200">Nom de Aeroport</th>
                            <th class="px-6 py-4 border-r border-gray-200">Ville</th>
                            <th class="px-6 py-4 border-r border-gray-200">Pays</th>
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
    async renderPickAeroportID(){
        let putordelete = "modifier";
        if (this.state.isDeleting){
            putordelete = "supprimer (⚠️ Il n'y aura plus de retour en arrière possible!)";
        }

       await new Promise(resolve => setTimeout(resolve, 50));

        let numAeroport = prompt(`Veuillez donnez l'id de la aeroport que vous souhaiteriez ${putordelete}`);
        
        if (!numAeroport){
            document.getElementById('btn-get')?.click();
            return;
        } else {
            if (this.state.isDeleting){
                if (confirm('Voulez-vous vraiment supprimer cette aeroport ?')) {
                    try {
                        await AeroportAPI.deleteAeroport(numAeroport);
                        this.showToast("Aéroport supprimée avec succès.");
                        document.getElementById('btn-get')?.click();
                    } catch(error) {
                        alert(`Impossible de supprimer cette aeroport:\n ${error}`);
                        console.error(error);
                        document.getElementById('btn-get')?.click();
                    }
                } else {
                    document.getElementById('btn-get')?.click();
                }
                return;
            }
            // Logique pour le PUT
            this.state.numAeroport = numAeroport;
            this.PutPost();
        }
    }

    // Vue du composant post/put Compagnie
    async renderPutPostAeroport(){
        let http = "Ajouter un aéroport";
        let iconClass = "fa-circle-plus text-green-600";
        const aeroport = {nom: '', ville:'', pays:''};
        const numAeroport = this.state.numAeroport;

        if (numAeroport){
            try{
                const response = await AeroportAPI.getAeroportById(numAeroport);
                aeroport.nom = response.nom_aeroport;
                aeroport.ville = response.ville;
                aeroport.pays = response.pays;
                http = "Modifier un aéroport";
                iconClass = "fa-edit text-lime-600";
            } catch(error) {
                alert ("Aéroport non existante, veuillez réessayer plus tard.");
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
                        <div class="w-full max-w-lg p-8 rounded-xl border shadow-sm ${numAeroport ? 'bg-lime-50 border-lime-200' : 'bg-green-50 border-green-200'}">
                            <div class="mb-6">
                                <label class="block text-2xl font-bold mb-3 ${numAeroport ? 'text-lime-900' : 'text-green-900'}">Nom de l'aéroport</label>
                                <input type="text" id="addNomA" value="${aeroport.nom}" 
                                    class="w-full px-4 py-3 text-xl border border-gray-300 rounded-lg focus:outline-none focus:ring-4 ${numAeroport ? 'focus:ring-lime-200' : 'focus:ring-green-200'} transition-all"
                                    placeholder="Ex: Charles de Gaulle" />
                            </div>
                            <div class="mb-6">
                                <label class="block text-2xl font-bold mb-3 ${numAeroport ? 'text-lime-900' : 'text-green-900'}">Ville</label>
                                <input type="text" id="addVilleA" value="${aeroport.ville}" 
                                    class="w-full px-4 py-3 text-xl border border-gray-300 rounded-lg focus:outline-none focus:ring-4 ${numAeroport ? 'focus:ring-lime-200' : 'focus:ring-green-200'} transition-all"
                                    placeholder="Ex: Paris" />
                            </div>
                            <div class="mb-6">
                                <label class="block text-2xl font-bold mb-3 ${numAeroport ? 'text-lime-900' : 'text-green-900'}">Pays</label>
                                <input type="text" id="addPaysA" value="${aeroport.pays}" 
                                    class="w-full px-4 py-3 text-xl border border-gray-300 rounded-lg focus:outline-none focus:ring-4 ${numAeroport ? 'focus:ring-lime-200' : 'focus:ring-green-200'} transition-all"
                                    placeholder="Ex: France" />
                            </div>
                            
                            <div class="flex justify-end gap-4 mt-8 pt-6 border-t ${numAeroport ? 'border-lime-200' : 'border-green-200'}">
                                <button type="button" id="btn-get"
                                    class="px-6 py-3 text-xl font-bold text-gray-600 bg-white hover:bg-gray-100 border border-gray-300 rounded-lg transition-colors">
                                    Annuler
                                </button>
                                <button type="button" id="btn-add"
                                    class="px-8 py-3 text-xl font-bold text-white ${numAeroport ? 'bg-lime-600 hover:bg-lime-700' : 'bg-green-600 hover:bg-green-700'} rounded-lg transition-colors shadow-md hover:shadow-lg">
                                    ${numAeroport ? "Mettre à jour" : "Ajouter l'aéroport"}
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
    async bindEvents() {
        document.body.addEventListener('click', async (e) => {
            // S'assurer que le container principal existe encore sinon on ne fait rien
            if (!document.getElementById('route')?.contains(this.container)) return;

            // 1. Clic sur "Get"
            if (e.target.id === 'btn-get') {
                await this.loadAeroports();
                this.container.innerHTML = this.renderGetAeroport();
                return;
            }

            // 2. Clic sur "Post"
            if (e.target.id === 'btn-post') {
                this.state.isDeleting = false;
                this.state.numAeroport = null;
                this.PutPost();
                return;
            }

            // 3. Clic sur "Put" et "Delete"
            if (e.target.id === 'btn-put' && !e.target.classList.contains('btn-put')) {
                this.state.isDeleting = false;
                this.renderPickAeroportID();
                return;
            }
            if (e.target.id === 'btn-delete' && !e.target.classList.contains('btn-delete')) {
                this.state.isDeleting = true;
                this.renderPickAeroportID();
                return;
            }

            // --- Événements INTERNES au formulaire (#route) ---

            // Clic sur le bouton "Ajouter" ou "Modifier" (validation du formulaire)
            if (e.target.id === 'btn-add') {
                const inputNom = document.getElementById('addNomA');
                const inputVille = document.getElementById('addVilleA');
                const inputPays = document.getElementById('addPaysA');
                if (!inputNom) return; 

                const nom = inputNom.value.trim();
                const ville = inputVille.value.trim();
                const pays = inputPays.value.trim();
                if (!nom) return alert("Le nom est requis.");
                if (!ville) return alert("La ville est requis.");
                if (!pays) return alert("Le pays est requis.");

                try {
                    if (this.state.numAeroport) {
                        // Update
                        await AeroportAPI.modifyAeroport(this.state.numAeroport, nom, ville, pays);
                        this.showToast("Aéroport modifiée avec succès.");
                    } else {
                        // Create
                        await AeroportAPI.createAeroport(nom, ville, pays);
                        this.showToast("Aéroport créée avec succès.");
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
                this.state.numAeroport = parseInt(putBtn.getAttribute('data-id'));
                this.PutPost();
                return;
            }

            // Gestion pour les boutons des lignes du tableau (Supprimer)
            const deleteBtn = e.target.closest('.btn-delete');
            if (deleteBtn) {
                e.preventDefault();
                const numA = parseInt(deleteBtn.getAttribute('data-id'));
                
                
                // Attente légère pour que l'UI dessine le rouge avant le confirm() bloquant
                await new Promise(resolve => setTimeout(resolve, 50));
                
                if (confirm('Voulez-vous vraiment supprimer cette aéroport ?')) {
                    try {
                        await AeroportAPI.deleteAeroport(numA);
                        this.showToast("Aéroport supprimée avec succès.");
                        document.getElementById('btn-get')?.click();
                    } catch(error) {
                        alert(`Impossible de supprimer cet aéroport.\n${error}`);
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
        const html = await this.renderPutPostAeroport();
        if (html) {
            this.container.innerHTML = html;
        }
    }
}