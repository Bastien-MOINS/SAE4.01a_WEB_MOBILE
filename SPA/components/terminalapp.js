import { TerminalAPI } from "../api/terminalapi.js";
import { AeroportAPI } from "../api/aeroportapi.js";

export class TerminalSubViewApp {
    constructor(containerId) {
        this.container = document.getElementById(containerId);
        
        // L'État central de l'application (State)
        this.state = {
            terminaux: [],
            aeroports: [],
            idTerminal: null, // si null post, sinon put ou delete
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
        await this.loadTerminaux();
        // Une fois les données chargées, on met à jour l'UI dans la div route
        if (this.container) {
             this.container.innerHTML = await this.renderGetTerminaux();
        }
        // On écoute les événements globaux
        this.bindEvents();
    }

    async loadTerminaux() {
        try {
            this.state.terminaux = await TerminalAPI.getTerminaux();
        } catch (e) {
            console.error(e);
            this.state.terminaux = []; // Fallback en cas d'erreur
        }
    }


    async renderGetTerminaux() {
        this.state.idTerminal = null;
        let rows = '';
        for (const terminal of this.state.terminaux) {
            const idT = terminal.id_terminal;
            let nomAeroport = "Aéroport Inconnu";
            try {
                const response = await AeroportAPI.getAeroportById(terminal.numero_aeroport);
                nomAeroport = response.nom_aeroport;
            } catch (error) {
                console.error("Impossible de récupérer l'aéroport associé", error);
            }
            rows += `
                <tr class="border-b border-gray-200 hover:bg-gray-50 transition-colors">
                    <td class="px-6 py-4 text-center border-r border-gray-200">${idT}</td>
                    <td class="px-6 py-4 border-r border-gray-200 font-bold">${terminal.nom_terminal}</td>
                    <td class="px-6 py-4 border-r border-gray-200 font-bold">${nomAeroport}</td>
                    <td class="px-6 py-4 text-center">
                        <button class="btn-put text-gray-500 hover:text-blue-600 transition-colors mx-2" data-id="${idT}"><i class="fas fa-edit text-xl"></i></button>
                        <button class="btn-delete text-gray-500 hover:text-red-600 transition-colors mx-2" data-id="${idT}"><i class="fas fa-trash-alt text-xl"></i></button>
                    </td>
                </tr>
            `;
        }
        return `
        <div class="flex flex-col h-full bg-white font-nunito">
            <div class="p-6 border-b border-gray-200 flex justify-between items-center bg-gray-50 rounded-t-xl">
                <h2 class="text-3xl font-bold">Liste des terminaux</h2>
                <div class="search-wrapper flex items-center bg-white border border-gray-300 rounded-lg px-3 py-2 shadow-sm">
                    <i class="fa-solid fa-search text-gray-400 mr-2"></i>
                    <input class="outline-none text-lg bg-transparent" id="searchBar"
                        onkeyup="searchBarFunction(3)" placeholder="Rechercher...">
                </div>
            </div>
            <div class="overflow-x-auto flex-1 p-6">
                <table id="table" class="w-full text-left border-collapse border border-gray-200 shadow-sm rounded-lg overflow-hidden">
                    <thead>
                        <tr class="bg-gray-100 text-gray-700 uppercase tracking-wider text-xl border-b border-gray-300">
                            <th class="px-6 py-4 text-center border-r border-gray-200 w-32">ID</th>
                            <th class="px-6 py-4 border-r border-gray-200">Nom de Terminal</th>
                            <th class="px-6 py-4 border-r border-gray-200">Nom d'Aéroport</th>
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

    async renderPickTerminalID(){
        let putordelete = "modifier";
        if (this.state.isDeleting){
            putordelete = "supprimer (⚠️ Il n'y aura plus de retour en arrière possible!)";
        }

       await new Promise(resolve => setTimeout(resolve, 50));

        let idTerminal = prompt(`Veuillez donnez l'id de le terminal que vous souhaiteriez ${putordelete}`);
        
        if (!idTerminal){
            document.getElementById('btn-get')?.click();
            return;
        } else {
            if (this.state.isDeleting){
                if (confirm('Voulez-vous vraiment supprimer cette terminal ?')) {
                    try {
                        await TerminalAPI.deleteTerminal(idTerminal);
                        this.showToast("Terminal supprimée avec succès.");
                        document.getElementById('btn-get')?.click();
                    } catch(error) {
                        alert(`Impossible de supprimer cette terminal:\n ${error}`);
                        console.error(error);
                        document.getElementById('btn-get')?.click();
                    }
                } else {
                    document.getElementById('btn-get')?.click();
                }
                return;
            }
            // Logique pour le PUT
            this.state.idTerminal = idTerminal;
            this.PutPost();
        }
    }

    async renderPutPostTerminal(){
        this.aeroports = await AeroportAPI.getAeroports().catch(() => []);
        let http = "Ajouter un terminal";
        let iconClass = "fa-circle-plus text-green-600";
        const terminal = {nom_terminal: '', nom_aeroport: ''};
        const idTerminal = this.state.idTerminal;

        if (idTerminal){
            try{
                const response = await TerminalAPI.getTerminalById(idTerminal);
                terminal.nom_terminal = response.nom_terminal;
                const aeroport = await AeroportAPI.getAeroportById(response.numero_aeroport)
                terminal.nom_aeroport = aeroport.nom_aeroport
                http = "Modifier le terminal";
                iconClass = "fa-edit text-lime-600";
            } catch(error) {
                alert ("Terminal non existant, veuillez réessayer plus tard.");
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
                        <div class="w-full max-w-lg p-8 rounded-xl border shadow-sm ${idTerminal ? 'bg-lime-50 border-lime-200' : 'bg-green-50 border-green-200'}">
                            <div class="mb-6">
                                <label class="block text-2xl font-bold mb-3 ${idTerminal ? 'text-lime-900' : 'text-green-900'}">Nom de le terminal</label>
                                <input type="text" id="addNomT" value="${terminal.nom_terminal}" 
                                    class="w-full px-4 py-3 text-xl border border-gray-300 rounded-lg focus:outline-none focus:ring-4 ${idTerminal ? 'focus:ring-lime-200' : 'focus:ring-green-200'} transition-all"
                                    placeholder="Ex: Terminal 1" />
                            </div>

                            <div class="mb-6">
                                <label class="block text-2xl font-bold mb-3 ${idTerminal ? 'text-lime-900' : 'text-green-900'}">Aéroport</label>
                                <input list="aeroports" type="text" id="addAeroport" value="${terminal.nom_aeroport}" 
                                    class="w-full px-4 py-3 text-xl border border-gray-300 rounded-lg focus:outline-none focus:ring-4 ${idTerminal ? 'focus:ring-lime-200' : 'focus:ring-green-200'} transition-all"
                                    placeholder="--Veuillez sélectionner un aéroport--" />
                            </div>
                            
                            <datalist id="aeroports">
                                ${this.aeroports.map(a => `<option value="${a.nom_aeroport}"></option>`).join('')}
                            </datalist>

                            <div class="flex justify-end gap-4 mt-8 pt-6 border-t ${idTerminal ? 'border-lime-200' : 'border-green-200'}">
                                <button type="button" id="btn-get"
                                    class="px-6 py-3 text-xl font-bold text-gray-600 bg-white hover:bg-gray-100 border border-gray-300 rounded-lg transition-colors">
                                    Annuler
                                </button>
                                <button type="button" id="btn-add"
                                    class="px-8 py-3 text-xl font-bold text-white ${idTerminal ? 'bg-lime-600 hover:bg-lime-700' : 'bg-green-600 hover:bg-green-700'} rounded-lg transition-colors shadow-md hover:shadow-lg">
                                    ${idTerminal ? "Mettre à jour" : "Ajouter le terminal"}
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
                await this.loadTerminaux(); 
                this.container.innerHTML = await this.renderGetTerminaux();
                return;
            }

            // 2. Clic sur "Post"
            if (e.target.id === 'btn-post') {
                this.state.isDeleting = false;
                this.state.idTerminal = null;
                this.PutPost();
                return;
            }

            // 3. Clic sur "Put" et "Delete"
            if (e.target.id === 'btn-put' && !e.target.classList.contains('btn-put')) {
                this.state.isDeleting = false;
                this.renderPickTerminalID();
                return;
            }
            if (e.target.id === 'btn-delete' && !e.target.classList.contains('btn-delete')) {
                this.state.isDeleting = true;
                this.renderPickTerminalID();
                return;
            }

            // --- Événements INTERNES au formulaire (#route) ---

            // Clic sur le bouton "Ajouter" ou "Modifier" (validation du formulaire)
            if (e.target.id === 'btn-add') {
                const inputNom = document.getElementById('addNomT');
                const aeroportNom = document.getElementById('addAeroport');
                if (!inputNom || !aeroportNom) return; 

                const nom = inputNom.value.trim();
                if (!nom) return alert("Le nom est requis.");
                
                const nom_aeroport = aeroportNom.value.trim();
                const aero = this.aeroports?.find(a => a.nom_aeroport === nom_aeroport);
                
                if (!aero) return alert("Veuillez sélectionner un aéroport valide dans la liste.");

                console.log("Objet Aéroport complet :", aero);
                console.log("ID envoyé à l'API :", aero.numero_aeroport);

                try {
                    if (this.state.idTerminal) {
                        // Update
                        await TerminalAPI.modifyTerminal(this.state.idTerminal, nom, aero.numero_aeroport);
                        this.showToast("Terminal modifiée avec succès.");
                    } else {
                        // Create
                        await TerminalAPI.createTerminal(nom, aero.numero_aeroport);
                        this.showToast("Terminal créée avec succès.");
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
                this.state.idTerminal = parseInt(putBtn.getAttribute('data-id'));
                this.PutPost();
                return;
            }

            // Gestion pour les boutons des lignes du tableau (Supprimer)
            const deleteBtn = e.target.closest('.btn-delete');
            if (deleteBtn) {
                e.preventDefault();
                const idT = parseInt(deleteBtn.getAttribute('data-id'));
                
                
                // Attente légère pour que l'UI dessine le rouge avant le confirm() bloquant
                await new Promise(resolve => setTimeout(resolve, 50));
                
                if (confirm('Voulez-vous vraiment supprimer cette terminal ?')) {
                    try {
                        await TerminalAPI.deleteTerminal(idT);
                        this.showToast("Terminal supprimée avec succès.");
                        document.getElementById('btn-get')?.click();
                    } catch(error) {
                        alert(`Impossible de supprimer cette terminal.\n${error}`);
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
        const html = await this.renderPutPostTerminal();
        if (html) {
            this.container.innerHTML = html;
        }
    }
}