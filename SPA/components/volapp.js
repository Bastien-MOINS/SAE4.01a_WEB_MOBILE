import { VolAPI } from "../api/volapi.js";
import { CompagnieAPI } from "../api/compagnieapi.js";
import { AeroportAPI } from "../api/aeroportapi.js";
import { TerminalAPI } from "../api/terminalapi.js";

export class VolSubViewApp {
    constructor(containerId) {
        this.container = document.getElementById(containerId);
        
        // L'État central de l'application (State)
        this.state = {
            vols: [],
            idVol: null, // si null post, sinon put ou delete
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
        await this.loadVols();
        // Une fois les données chargées, on met à jour l'UI dans la div route
        if (this.container) {
             this.container.innerHTML = await this.renderGetVol();
        }
        // On écoute les événements globaux
        this.bindEvents();
    }

    async loadVols() {
        try {
            this.state.vols = await VolAPI.getVols();
        } catch (e) {
            console.error(e);
            this.state.vols = []; // Fallback en cas d'erreur
        }
    }

    // Vue du composant get vol
    async renderGetVol() {
        this.state.idVol = null;
        let rows = '';
        
        for (const vol of this.state.vols) {
            const idV = vol.numero_vol;
            let nomCompagnie = "Non définie";
            let nomAeroportDep = "Non définie";
            let nomAeroportArr = "Non définie";
            let nomTerminalDep = "Non définie";
            let nomTerminalArr = "Non définie";
            try {
                const responseCompagnie = await CompagnieAPI.getCompagnieById(vol.id_compagnie);
                nomCompagnie = responseCompagnie.nom_compagnie;
                const responseAeroportDep = await AeroportAPI.getAeroportById(vol.numero_aeroport_dep);
                nomAeroportDep = responseAeroportDep.nom_aeroport;
                const responseAeroportArr = await AeroportAPI.getAeroportById(vol.numero_aeroport_arr);
                nomAeroportArr = responseAeroportArr.nom_aeroport;
                const responseTerminalDep = await TerminalAPI.getTerminalById(vol.id_terminal_dep);
                nomTerminalDep = responseTerminalDep.nom_terminal;
                const responseTerminalArr = await TerminalAPI.getTerminalById(vol.id_terminal_arr);
                nomTerminalArr = responseTerminalArr.nom_terminal;

            } catch(e) {
                console.error("Compagnie non existante", e);
            }
            console.log(nomCompagnie);
            rows += `
                <tr class="border-b border-gray-200 hover:bg-gray-50 transition-colors">
                    <td class="px-6 py-4 text-center border-r border-gray-200">${idV}</td>
                    <td class="px-6 py-4 border-r border-gray-200 font-bold">
                        <div class="flex flex-col text-center">
                            <div class="py-2">${vol.date_debut} - ${vol.date_arrivee}</div>
                            <div class="py-2">${vol.heure_debut} - ${vol.heure_arrivee}</div>
                        </div>
                    </td>
                    <td class="px-6 py-4 border-r border-gray-200 font-bold text-center">${nomCompagnie}</td>
                    <td class="px-6 py-4 border-r border-gray-200 font-bold text-center">
                        <div class="flex flex-col items-center justify-center space-y-2">
                            <span class="px-4 py-2 rounded-full bg-slate-600 text-white shadow text-sm whitespace-nowrap">${nomAeroportDep}</span>
                            <span class="text-sm border border-slate-600 text-slate-600 px-3 py-1 rounded-md bg-white">${nomTerminalDep}</span>
                        </div>
                    </td>
                    <td class="px-6 py-4 border-r border-gray-200 font-bold text-center">
                        <div class="flex flex-col items-center justify-center space-y-2">
                            <span class="px-4 py-2 rounded-full bg-slate-600 text-white shadow text-sm whitespace-nowrap">${nomAeroportArr}</span>
                            <span class="text-sm border border-slate-600 text-slate-600 px-3 py-1 rounded-md bg-white">${nomTerminalArr}</span>
                        </div>
                    </td>
                    <td class="px-6 py-4 text-center">
                        <button class="btn-put text-gray-500 hover:text-blue-600 transition-colors mx-2" data-id="${idV}"><i class="fas fa-edit text-xl"></i></button>
                        <button class="btn-delete text-gray-500 hover:text-red-600 transition-colors mx-2" data-id="${idV}"><i class="fas fa-trash-alt text-xl"></i></button>
                    </td>
                </tr>
            `;
        };
        return `
        <div class="flex flex-col h-full bg-white font-nunito">
            <div class="p-6 border-b border-gray-200 flex justify-between items-center bg-gray-50 rounded-t-xl">
                <h2 class="text-3xl font-bold">Liste des vols</h2>
                <div class="search-wrapper flex items-center bg-white border border-gray-300 rounded-lg px-3 py-2 shadow-sm">
                    <i class="fa-solid fa-search text-gray-400 mr-2"></i>
                    <input class="outline-none text-lg bg-transparent" id="searchBar"
                        onkeyup="searchBarFunction(5)" placeholder="Rechercher...">
                </div>
            </div>
            <div class="overflow-x-auto flex-1 h-full">
                <table id="table" class="w-full text-left border-collapse border border-gray-200 shadow-sm rounded-none">
                    <thead class="sticky top-0 bg-gray-100 z-10 shadow-sm">
                        <tr class="text-gray-700 uppercase tracking-wider text-xl border-b border-gray-300">
                            <th class="px-6 py-4 text-center border-r border-gray-200 w-24">ID</th>
                            <th class="px-6 py-4 border-r border-gray-200 text-center w-64">Horaire du Vol</th>
                            <th class="px-6 py-4 border-r border-gray-200 text-center w-32">Nom de Compagnie</th>
                            <th class="px-6 py-4 border-r border-gray-200 text-center w-32">Lieu de départ</th>
                            <th class="px-6 py-4 border-r border-gray-200 text-center w-32">Lieu d'arrivé</th>
                            <th class="px-6 py-4 text-center w-32">Actions</th>
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

    // Vue du composant choose vol by ID
    async renderPickVolID(){
        let putordelete = "modifier";
        if (this.state.isDeleting){
            putordelete = "supprimer (⚠️ Il n'y aura plus de retour en arrière possible!)";
        }

       await new Promise(resolve => setTimeout(resolve, 50));

        let idVol = prompt(`Veuillez donnez l'id de le vol que vous souhaiteriez ${putordelete}`);
        
        if (!idVol){
            document.getElementById('btn-get')?.click();
            return;
        } else {
            if (this.state.isDeleting){
                if (confirm('Voulez-vous vraiment supprimer ce vol ?')) {
                    try {
                        await VolAPI.deleteVol(idVol);
                        this.showToast("Vol supprimée avec succès.");
                        document.getElementById('btn-get')?.click();
                    } catch(error) {
                        alert(`Impossible de supprimer ce vol:\n ${error}`);
                        console.error(error);
                        document.getElementById('btn-get')?.click();
                    }
                } else {
                    document.getElementById('btn-get')?.click();
                }
                return;
            }
            // Logique pour le PUT
            this.state.idVol = idVol;
            this.PutPost();
        }
    }

    // Vue du composant post/put vol
    async renderPutPostVol(){
        // Récupération des données pour les listes
        this.cache = {
            aeroports: await AeroportAPI.getAeroports().catch(() => []),
            terminaux: await TerminalAPI.getTerminaux().catch(() => []),
            compagnies: await CompagnieAPI.getCompagnies().catch(() => [])
        };

        let http = "Ajouter un vol";
        let iconClass = "fa-circle-plus text-green-600";
        const vol = {
            date_depart: '', date_arrivee: '',
            heure_depart: '', heure_arrivee: '',
            aeroport_depart: '', aeroport_arrivee: '',
            terminal_depart: '', terminal_arrivee: '',
            compagnie: ''
        };
        const idVol = this.state.idVol;

        if (idVol){
            try{
                const response = await VolAPI.getVolById(idVol);
                vol.date_depart = response.date_debut;
                vol.date_arrivee = response.date_arrivee;
                vol.heure_depart = response.heure_debut;
                vol.heure_arrivee = response.heure_arrivee;
                
                const currentAeroportDep = this.cache.aeroports.find(a => a.numero_aeroport === response.numero_aeroport_dep);
                const currentAeroportArr = this.cache.aeroports.find(a => a.numero_aeroport === response.numero_aeroport_arr);
                const currentTerminalDep = this.cache.terminaux.find(t => t.id_terminal === response.id_terminal_dep);
                const currentTerminalArr = this.cache.terminaux.find(t => t.id_terminal === response.id_terminal_arr);
                const currentCompagnie = this.cache.compagnies.find(c => c.id_compagnie === response.id_compagnie);

                vol.aeroport_depart = currentAeroportDep ? currentAeroportDep.nom_aeroport : '';
                vol.aeroport_arrivee = currentAeroportArr ? currentAeroportArr.nom_aeroport : '';
                vol.terminal_depart = currentTerminalDep ? currentTerminalDep.nom_terminal : '';
                vol.terminal_arrivee = currentTerminalArr ? currentTerminalArr.nom_terminal : '';
                vol.compagnie = currentCompagnie ? currentCompagnie.nom_compagnie : '';
                
                http = "Modifier le vol";
                iconClass = "fa-edit text-lime-600";
            } catch(error) {
                alert ("Vol non existante, veuillez réessayer plus tard.");
                document.getElementById('btn-get')?.click(); // Retour au GET (et sa couleur) si l'ID est invalide
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
                    
                    <div class="p-8 flex-1 flex flex-col items-center justify-center overflow-y-auto">
                        <div class="w-full max-w-4xl p-8 rounded-xl border shadow-sm ${idVol ? 'bg-lime-50 border-lime-200' : 'bg-green-50 border-green-200'}">
                            
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                                <!-- Date de départ -->
                                <div>
                                    <label class="block text-xl font-bold mb-2 ${idVol ? 'text-lime-900' : 'text-green-900'}">Date de départ*</label>
                                    <input type="date" id="dateDepart" value="${vol.date_depart}" 
                                        class="w-full px-4 py-3 text-lg border border-gray-300 rounded-lg focus:outline-none focus:ring-4 ${idVol ? 'focus:ring-lime-200' : 'focus:ring-green-200'} transition-all" />
                                </div>

                                <!-- Date d'arrivée -->
                                <div>
                                    <label class="block text-xl font-bold mb-2 ${idVol ? 'text-lime-900' : 'text-green-900'}">Date d'arrivée*</label>
                                    <input type="date" id="dateArrivee" value="${vol.date_arrivee}" 
                                        class="w-full px-4 py-3 text-lg border border-gray-300 rounded-lg focus:outline-none focus:ring-4 ${idVol ? 'focus:ring-lime-200' : 'focus:ring-green-200'} transition-all" />
                                </div>

                                <!-- Heure de départ -->
                                <div>
                                    <label class="block text-xl font-bold mb-2 ${idVol ? 'text-lime-900' : 'text-green-900'}">Heure de départ*</label>
                                    <input type="time" id="heureDepart" value="${vol.heure_depart}" 
                                        class="w-full px-4 py-3 text-lg border border-gray-300 rounded-lg focus:outline-none focus:ring-4 ${idVol ? 'focus:ring-lime-200' : 'focus:ring-green-200'} transition-all" />
                                </div>

                                <!-- Heure d'arrivée -->
                                <div>
                                    <label class="block text-xl font-bold mb-2 ${idVol ? 'text-lime-900' : 'text-green-900'}">Heure d'arrivée*</label>
                                    <input type="time" id="heureArrivee" value="${vol.heure_arrivee}" 
                                        class="w-full px-4 py-3 text-lg border border-gray-300 rounded-lg focus:outline-none focus:ring-4 ${idVol ? 'focus:ring-lime-200' : 'focus:ring-green-200'} transition-all" />
                                </div>

                                <!-- Aéroport de départ -->
                                <div>
                                    <label class="block text-xl font-bold mb-2 ${idVol ? 'text-lime-900' : 'text-green-900'}">Aéroport de départ*</label>
                                    <input list="aeroports" id="aeroportDepart" value="${vol.aeroport_depart}" placeholder="Sélectionner ou chercher..."
                                        class="w-full px-4 py-3 text-lg border border-gray-300 rounded-lg focus:outline-none focus:ring-4 ${idVol ? 'focus:ring-lime-200' : 'focus:ring-green-200'} transition-all" />
                                </div>

                                <!-- Aéroport d'arrivée -->
                                <div>
                                    <label class="block text-xl font-bold mb-2 ${idVol ? 'text-lime-900' : 'text-green-900'}">Aéroport d'arrivée*</label>
                                    <input list="aeroports" id="aeroportArrivee" value="${vol.aeroport_arrivee}" placeholder="Sélectionner ou chercher..."
                                        class="w-full px-4 py-3 text-lg border border-gray-300 rounded-lg focus:outline-none focus:ring-4 ${idVol ? 'focus:ring-lime-200' : 'focus:ring-green-200'} transition-all" />
                                </div>

                                <!-- Terminal de départ -->
                                <div>
                                    <label class="block text-xl font-bold mb-2 ${idVol ? 'text-lime-900' : 'text-green-900'}">Terminal de départ*</label>
                                    <input list="terminauxDepart" id="terminalDepart" value="${vol.terminal_depart}" placeholder="Sélectionner ou chercher..." disabled
                                        class="w-full px-4 py-3 text-lg border border-gray-300 rounded-lg focus:outline-none focus:ring-4 disabled:bg-gray-100 disabled:cursor-not-allowed ${idVol ? 'focus:ring-lime-200' : 'focus:ring-green-200'} transition-all" />
                                </div>

                                <!-- Terminal d'arrivée -->
                                <div>
                                    <label class="block text-xl font-bold mb-2 ${idVol ? 'text-lime-900' : 'text-green-900'}">Terminal d'arrivée*</label>
                                    <input list="terminauxArrivee" id="terminalArrivee" value="${vol.terminal_arrivee}" placeholder="Sélectionner ou chercher..." disabled
                                        class="w-full px-4 py-3 text-lg border border-gray-300 rounded-lg focus:outline-none focus:ring-4 disabled:bg-gray-100 disabled:cursor-not-allowed ${idVol ? 'focus:ring-lime-200' : 'focus:ring-green-200'} transition-all" />
                                </div>

                                <!-- Compagnie -->
                                <div class="md:col-span-2">
                                    <label class="block text-xl font-bold mb-2 ${idVol ? 'text-lime-900' : 'text-green-900'}">Compagnie*</label>
                                    <input list="compagnies" id="compagnie" value="${vol.compagnie}" placeholder="Sélectionner ou chercher..."
                                        class="w-full px-4 py-3 text-lg border border-gray-300 rounded-lg focus:outline-none focus:ring-4 ${idVol ? 'focus:ring-lime-200' : 'focus:ring-green-200'} transition-all" />
                                </div>
                            </div>
                            
                            <!-- DATALISTS DYNAMIQUES -->
                            <datalist id="aeroports">
                                ${this.cache.aeroports.map(a => `<option value="${a.nom_aeroport}"></option>`).join('')}
                            </datalist>
                            <datalist id="terminauxDepart"></datalist>
                            <datalist id="terminauxArrivee"></datalist>
                            <datalist id="compagnies">
                                ${this.cache.compagnies.map(c => `<option value="${c.nom_compagnie}"></option>`).join('')}
                            </datalist>
                            
                            <div class="flex justify-end gap-4 mt-8 pt-6 border-t ${idVol ? 'border-lime-200' : 'border-green-200'}">
                                <button type="button" id="btn-get"
                                    class="px-6 py-3 text-xl font-bold text-gray-600 bg-white hover:bg-gray-100 border border-gray-300 rounded-lg transition-colors">
                                    Annuler
                                </button>
                                <button type="button" id="btn-add" disabled
                                    class="px-8 py-3 text-xl font-bold text-white opacity-50 cursor-not-allowed ${idVol ? 'bg-lime-600 hover:bg-lime-700' : 'bg-green-600 hover:bg-green-700'} rounded-lg transition-colors shadow-md hover:shadow-lg">
                                    ${idVol ? "Mettre à jour" : "Ajouter le vol"}
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
        document.body.addEventListener('input', (e) => {
            if (!document.getElementById('route')?.contains(this.container)) return;

            // Filtrage dynamique :
            if (e.target.id === 'aeroportDepart') {
                this.updateTerminalsList('aeroportDepart', 'terminauxDepart', 'terminalDepart');
            }
            if (e.target.id === 'aeroportArrivee') {
                this.updateTerminalsList('aeroportArrivee', 'terminauxArrivee', 'terminalArrivee');
            }

            // Validation :
            this.validateForm();
        });

        document.body.addEventListener('click', async (e) => {
            // S'assurer que le container principal existe encore sinon on ne fait rien
            if (!document.getElementById('route')?.contains(this.container)) return;

            // 1. Clic sur "Get"
            if (e.target.id === 'btn-get') {
                await this.loadVols();
                this.container.innerHTML = await this.renderGetVol();
                return;
            }

            // 2. Clic sur "Post"
            if (e.target.id === 'btn-post') {
                this.state.isDeleting = false;
                this.state.idVol = null;
                this.PutPost();
                return;
            }

            // 3. Clic sur "Put" et "Delete"
            if (e.target.id === 'btn-put' && !e.target.classList.contains('btn-put')) {
                this.state.isDeleting = false;
                this.renderPickVolID();
                return;
            }
            if (e.target.id === 'btn-delete' && !e.target.classList.contains('btn-delete')) {
                this.state.isDeleting = true;
                this.renderPickVolID();
                return;
            }

            // --- Événements INTERNES au formulaire (#route) ---

            // Clic sur le bouton "Ajouter" ou "Modifier" (validation du formulaire)
            if (e.target.id === 'btn-add') {
                if (document.getElementById('btn-add').disabled) return;

                const aeroDepInput = document.getElementById('aeroportDepart').value.trim();
                const aeroArrInput = document.getElementById('aeroportArrivee').value.trim();
                const termDepInput = document.getElementById('terminalDepart').value.trim();
                const termArrInput = document.getElementById('terminalArrivee').value.trim();
                const compInput = document.getElementById('compagnie').value.trim();

                const aeroDep = this.cache.aeroports.find(a => a.nom_aeroport === aeroDepInput);
                const aeroArr = this.cache.aeroports.find(a => a.nom_aeroport === aeroArrInput);
                const termDep = this.cache.terminaux.find(t => t.nom_terminal === termDepInput && t.numero_aeroport === aeroDep.numero_aeroport);
                const termArr = this.cache.terminaux.find(t => t.nom_terminal === termArrInput && t.numero_aeroport === aeroArr.numero_aeroport);
                const comp = this.cache.compagnies.find(c => c.nom_compagnie === compInput);

                const dateDebut = document.getElementById('dateDepart').value;
                const heureDebut = document.getElementById('heureDepart').value;
                const dateArrivee = document.getElementById('dateArrivee').value;
                const heureArrivee = document.getElementById('heureArrivee').value;

                try {
                    if (this.state.idVol) {
                        await VolAPI.modifyVol(
                            this.state.idVol, dateDebut, heureDebut, dateArrivee, heureArrivee,
                            comp.id_compagnie, aeroDep.numero_aeroport, aeroArr.numero_aeroport,
                            termDep.id_terminal, termArr.id_terminal
                        );
                        this.showToast("Vol modifié avec succès.");
                    } else {
                        await VolAPI.createVol(
                            dateDebut, heureDebut, dateArrivee, heureArrivee,
                            comp.id_compagnie, aeroDep.numero_aeroport, aeroArr.numero_aeroport,
                            termDep.id_terminal, termArr.id_terminal
                        );
                        this.showToast("Vol créé avec succès.");
                    }
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
                this.state.idVol = parseInt(putBtn.getAttribute('data-id'));
                this.PutPost();
                return;
            }

            // Gestion pour les boutons des lignes du tableau (Supprimer)
            const deleteBtn = e.target.closest('.btn-delete');
            if (deleteBtn) {
                e.preventDefault();
                const idV = parseInt(deleteBtn.getAttribute('data-id'));
                
                
                // Attente légère pour que l'UI dessine le rouge avant le confirm() bloquant
                await new Promise(resolve => setTimeout(resolve, 50));
                
                if (confirm('Voulez-vous vraiment supprimer ce vol ?')) {
                    try {
                        await VolAPI.deleteVol(idV);
                        this.showToast("Vol supprimée avec succès.");
                        document.getElementById('btn-get')?.click();
                    } catch(error) {
                        alert(`Impossible de supprimer ce vol.\n${error}`);
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
        const html = await this.renderPutPostVol();
        if (html) {
            this.container.innerHTML = html;
            // Initialiser la validation et les terminaux dès le rendu (utile pour le state PUT)
            this.updateTerminalsList('aeroportDepart', 'terminauxDepart', 'terminalDepart');
            this.updateTerminalsList('aeroportArrivee', 'terminauxArrivee', 'terminalArrivee');
            this.validateForm();
        }
    }

    updateTerminalsList(aeroportInputId, datalistId, terminalInputId) {
        const aeroportInput = document.getElementById(aeroportInputId);
        const datalist = document.getElementById(datalistId);
        const terminalInput = document.getElementById(terminalInputId);
        if (!aeroportInput || !datalist || !terminalInput || !this.cache) return;

        // On cherche l'aéroport qui correspond à la valeur saisie
        const selectedAeroport = this.cache.aeroports.find(a => a.nom_aeroport === aeroportInput.value.trim());
        
        if (selectedAeroport) {
            // Filtrer les terminaux ayant le bon numéro d'aéroport
            const filteredTerminals = this.cache.terminaux.filter(t => t.numero_aeroport === selectedAeroport.numero_aeroport);
            datalist.innerHTML = filteredTerminals.map(t => `<option value="${t.nom_terminal}"></option>`).join('');
            
            // Activer l'input terminal
            terminalInput.disabled = false;
            
            // Vérifier si la valeur actuelle du terminal est valide par rapport à la nouvelle liste
            const isCurrentTerminalValid = filteredTerminals.find(t => t.nom_terminal === terminalInput.value.trim());
            if (!isCurrentTerminalValid) {
                terminalInput.value = ''; // Réinitialiser si non valide
            }

        } else {
            // Si l'aéroport n'est pas encore valide, on vide le datalist et on désactive l'input
            datalist.innerHTML = '';
            terminalInput.value = '';
            terminalInput.disabled = true;
        }
    }

    validateForm() {
        const btnAdd = document.getElementById('btn-add');
        if (!btnAdd) return;

        const ids = ['dateDepart', 'dateArrivee', 'heureDepart', 'heureArrivee', 
                     'aeroportDepart', 'aeroportArrivee', 'terminalDepart', 'terminalArrivee', 'compagnie'];
        
        // Vérifie si TOUS les champs requis sont (au moins) remplis et valides
        let isValid = true;

        const dateDepStr = document.getElementById('dateDepart')?.value;
        const dateArrStr = document.getElementById('dateArrivee')?.value;
        const heureDepStr = document.getElementById('heureDepart')?.value;
        const heureArrStr = document.getElementById('heureArrivee')?.value;

        // Validation temporelle : un vol ne peut pas arriver avant d'être parti
        if (dateDepStr && dateArrStr && heureDepStr && heureArrStr) {
            const datetimeDep = new Date(`${dateDepStr}T${heureDepStr}`);
            const datetimeArr = new Date(`${dateArrStr}T${heureArrStr}`);
            if (datetimeArr <= datetimeDep) {
                isValid = false;
            }
            // Vérifier aussi si le vol de départ et d'arrivée ont le même aéroport
            const aeroDepStr = document.getElementById('aeroportDepart')?.value.trim();
            const aeroArrStr = document.getElementById('aeroportArrivee')?.value.trim();
            if (aeroDepStr && aeroArrStr && aeroDepStr === aeroArrStr) {
                isValid = false; // Ne peut pas atterrir au même aéroport
            }
        }

        for (const id of ids) {
            const el = document.getElementById(id);
            if (!el || el.value.trim() === '') {
                isValid = false;
                break;
            }

            // Validations spécifiques (les listes)
            if (id === 'aeroportDepart' || id === 'aeroportArrivee') {
                if (!this.cache.aeroports.find(a => a.nom_aeroport === el.value.trim())) isValid = false;
            }
            if (id === 'terminalDepart') {
                const aero = this.cache.aeroports.find(a => a.nom_aeroport === document.getElementById('aeroportDepart').value.trim());
                if (!aero || !this.cache.terminaux.find(t => t.nom_terminal === el.value.trim() && t.numero_aeroport === aero.numero_aeroport)) {
                    isValid = false;
                }
            }
            if (id === 'terminalArrivee') {
                const aero = this.cache.aeroports.find(a => a.nom_aeroport === document.getElementById('aeroportArrivee').value.trim());
                if (!aero || !this.cache.terminaux.find(t => t.nom_terminal === el.value.trim() && t.numero_aeroport === aero.numero_aeroport)) {
                    isValid = false;
                }
            }
            if (id === 'compagnie') {
                if (!this.cache.compagnies.find(c => c.nom_compagnie === el.value.trim())) isValid = false;
            }
        }

        if (isValid) {
            btnAdd.disabled = false;
            btnAdd.classList.remove('opacity-50', 'cursor-not-allowed');
        } else {
            btnAdd.disabled = true;
            btnAdd.classList.add('opacity-50', 'cursor-not-allowed');
        }
    }
}