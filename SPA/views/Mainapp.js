import { CompagnieSubViewApp } from "../components/compagnieapp";

// --- 2. CLASSE PRINCIPALE (App / Contrôleur + Vue) ---
class TodoApp {
    constructor(containerId) {
        this.container = document.getElementById(containerId);
        
        // L'État central de l'application (State)
        this.state = {
            tasks: [],
            currentTask: null, // Si null, mode création. Sinon, mode édition
            isCreating: false  // Pour savoir si on affiche le formulaire de création
        };

        // Initialisation de l'application
        this.init();
    }

    async init() {
        await this.loadTasks();
        // Une fois les données chargées, on dessine l'UI
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

    // --- GÉNÉRATION DU HTML (Vues) ---

    // Vue principale
    render() {
        this.container.innerHTML = `
            <header>
                <nav id="nav1">
                    <ol>
                        <li class="font-jersey color-black"><i class="fa-solid fa-plane"></i></li>
                        <li class="font-jersey color-black took">type="button">Compagnies</button></li>
                        <li class="font-jersey color-black">type="button">Vols</button></li>
                        <li class="font-jersey color-black">type="button">Terminaux</button></li>
                        <li class="font-jersey color-black">type="button">Aéroports</button></li>
                    </ol>
                </nav> 
            </header>
            <div id='main'>
                <div id="http">
                    <ol>
                        <li class="font-jersey color-white"><i class="fa-solid fa-plane"></i></li>
                        <li class="font-jersey color-white took">type="button">GET</button></li>
                        <li class="font-jersey color-white">type="button">POST</button></li>
                        <li class="font-jersey color-white">type="button">PUT</button></li>
                        <li class="font-jersey color-white">type="button">DELETE</button></li>
                    </ol>
                </div>
                <div id="route">
                    ${CompagnieSubViewApp.renderGetCompagnie()}
                </div>
            </div>
        `;
    }
}