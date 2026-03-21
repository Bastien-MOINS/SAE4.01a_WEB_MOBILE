import { CompagnieSubViewApp } from "../components/compagnieapp.js";
import { VolSubViewApp } from "../components/volapp.js"
import { TerminalSubViewApp } from "../components/terminalapp.js"
import { AeroportSubViewApp } from "../components/aeroportapp.js"

// --- 2. CLASSE PRINCIPALE (App / Contrôleur + Vue) ---
class MainApp {
    constructor(containerId) {
        this.container = document.getElementById(containerId);
        
        // L'État central de l'application (State)
        this.state = {
            nom: "vol", // entité sélectionnée par défaut
            action: "GET" // action HTTP sélectionnée par défaut
        };

        // Initialisation de l'application
        this.init();
    }

    async init() {
        this.render();
        // On écoute les événements globaux
        this.bindEvents();
    }

    async loadTasks() {
        try {
            this.state.tasks = await TodoAPI.fetchTasks();
        } catch (e) {
            console.error(e);
            this.state.tasks = []; // Fallback en cas d'erreur
        }
    }

    // --- MISE À JOUR DE L'ÉTAT ET RÉACTUALISATION ---
    
    // quand l'état change, on redessine l'interface
    setState(newState) {
        this.state = { ...this.state, ...newState };
        this.render();
    }

    getGradientClass() {
        if (this.state.action === "POST") return "from-green-900 to-green-600";
        if (this.state.action === "PUT") return "from-amber-900 to-amber-600";
        if (this.state.action === "DELETE") return "from-red-900 to-red-600";
        return "from-slate-900 to-slate-600"; // GET default
    }

    // Vue principale
    async render() {
        
        let routeContent = "";

        const getNavClass = (navNom) => {
            return this.state.nom === navNom 
                ? "bg-gray-300 text-black shadow-inner" 
                : "bg-gray-100 text-gray-700 hover:bg-gray-200";
        };

        const getActionClass = (navAction, baseColor, selectedColor) => {
            return this.state.action === navAction
                ? selectedColor + " text-white font-bold"
                : baseColor + " text-white hover:opacity-90";
        };

        this.container.innerHTML = `
            <div class="flex flex-col h-screen bg-gray-50 font-jersey text-lg">
                <header class="flex h-16 bg-gray-100 border-b border-black">
                    <div class="flex items-center justify-center w-32 border-r border-black bg-gray-100 text-3xl">
                        <i class="fa-solid fa-plane"></i>
                    </div>
                    <nav class="flex flex-1">
                        <button id="btn-compagnies" class="flex-1 text-2xl font-bold uppercase border-r border-black transition-colors ${getNavClass('compagnie')}">Compagnie</button>
                        <button id="btn-vols" class="flex-1 text-2xl font-bold uppercase border-r border-black transition-colors ${getNavClass('vol')}">Vols</button>
                        <button id="btn-terminaux" class="flex-1 text-2xl font-bold uppercase border-r border-black transition-colors ${getNavClass('terminal')}">Terminaux</button>
                        <button id="btn-aeroports" class="flex-1 text-2xl font-bold uppercase transition-colors ${getNavClass('aeroport')}">Aéroports</button>
                    </nav>
                </header>

                <div class="flex flex-1 overflow-hidden">
                    <aside class="w-32 flex flex-col border-r border-black">
                        <button id="btn-get" class="flex-1 text-3xl tracking-widest transition-all border-b border-black ${getActionClass('GET', 'bg-slate-500', 'bg-slate-700')}">GET</button>
                        <button id="btn-post" class="flex-1 text-3xl tracking-widest transition-all border-b border-black ${getActionClass('POST', 'bg-green-500', 'bg-green-700')}">POST</button>
                        <button id="btn-put" class="flex-1 text-3xl tracking-widest transition-all border-b border-black ${getActionClass('PUT', 'bg-amber-500', 'bg-amber-700')}">PUT</button>
                        <button id="btn-delete" class="flex-1 text-3xl tracking-widest transition-all ${getActionClass('DELETE', 'bg-red-500', 'bg-red-700')}">DELETE</button>
                    </aside>

                    <main id="main-content" class="flex-1 flex flex-col justify-start items-center p-8 bg-gradient-to-r ${this.getGradientClass()} transition-all duration-300 overflow-y-auto">
                        <div id="route" class="bg-white text-black w-full max-w-5xl rounded-xl shadow-2xl overflow-hidden min-h-[500px] border flex flex-col">
                            ${routeContent}
                        </div>
                    </main>
                </div>
            </div>
        `;

        // Une fois le HTML injecté dans le DOM, la div #route existe.
        // On peut maintenant instancier la sous-vue qui a besoin de s'y accrocher.
        if (this.state.nom === "compagnie") {
            new CompagnieSubViewApp("route");
        }
        else if (this.state.nom === "vol") {
            new VolSubViewApp("route");
        }
        else if (this.state.nom === "terminal") {
            new TerminalSubViewApp("route");
        }
        else if (this.state.nom === "aeroport") {
            new AeroportSubViewApp("route");
        }
    }

    // --- GESTION DES ÉVÉNEMENTS (Délégation d'événements) ---
    // Au lieu de mettre des addEventListener de partout qui se perdent quand le HTML est recréé (render),
    // On met un seul écouteur sur le conteneur principal.
    bindEvents() {
        this.container.addEventListener('click', async (e) => {
            // 1. Bouton du <nav> des tables
            if (e.target.id === 'btn-compagnies') {
                this.setState({ nom: "compagnie", action: "GET" });
            }
            else if (e.target.id === 'btn-vols') {
                this.setState({ nom: "vol", action: "GET" });
            }
            else if (e.target.id === 'btn-terminaux') {
                this.setState({ nom: "terminal", action: "GET" });
            }
            else if (e.target.id === 'btn-aeroports') {
                this.setState({ nom: "aeroport", action: "GET" });
            }

            // 2. HTTP Action clicks
            // Nous mettons simplement à jour les classes des actions sans tout réafficher
            // car un affichage complet détruit le conteneur #route dont dépendent les sous-applications.
            if (e.target.id === 'btn-get' || e.target.closest('.btn-get')) {
                this.state.action = "GET";
                this.updateActionUI();
            }
            else if (e.target.id === 'btn-post' || e.target.closest('.btn-post')) {
                this.state.action = "POST";
                this.updateActionUI();
            }
            else if (e.target.id === 'btn-put' || e.target.closest('.btn-put')) {
                this.state.action = "PUT";
                this.updateActionUI();
            }
            else if (e.target.id === 'btn-delete' || e.target.closest('.btn-delete')) {
                this.state.action = "DELETE";
                this.updateActionUI();
            }
        });
    }

    updateActionUI() {
        const getActionClass = (navAction, baseColor, selectedColor) => {
            return this.state.action === navAction
                ? selectedColor + " text-white font-bold flex-1 text-3xl tracking-widest transition-all border-b border-black"
                : baseColor + " text-white hover:opacity-90 flex-1 text-3xl tracking-widest transition-all border-b border-black";
        };

        const btnGet = document.getElementById('btn-get');
        if (btnGet) btnGet.className = getActionClass('GET', 'bg-slate-500', 'bg-slate-700');

        const btnPost = document.getElementById('btn-post');
        if (btnPost) btnPost.className = getActionClass('POST', 'bg-green-500', 'bg-green-700');

        const btnPut = document.getElementById('btn-put');
        if (btnPut) btnPut.className = getActionClass('PUT', 'bg-amber-500', 'bg-amber-700');

        const btnDelete = document.getElementById('btn-delete');
        if (btnDelete) btnDelete.className = getActionClass('DELETE', 'bg-red-500', 'bg-red-700');

        const mainContent = document.getElementById('main-content');
        if (mainContent) {
            mainContent.className = `flex-1 flex justify-center items-start p-8 bg-gradient-to-r ${this.getGradientClass()} transition-all duration-300 overflow-y-auto`;
        }
    }
}
const main = new MainApp("app");