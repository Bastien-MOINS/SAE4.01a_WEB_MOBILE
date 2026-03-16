import { CompagnieSubViewApp } from "../components/compagnieapp.js";

// --- 2. CLASSE PRINCIPALE (App / Contrôleur + Vue) ---
class MainApp {
    constructor(containerId) {
        this.container = document.getElementById(containerId);
        
        // L'État central de l'application (State)
        this.state = {
            nom: ""
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

    // --- GÉNÉRATION DU HTML (Vues) ---

    // Vue principale
    async render() {
        console.log("Ajout du render MAIN"); //debug
        
        let routeContent = "";
        if (this.state.nom === "vol") {
            routeContent = "voici les vols";
        } else if (this.state.nom === "terminal") {
            routeContent = "voic les terminaux";
        } else if (this.state.nom === "aeroport") {
            routeContent = "voici les aeroports";
        }

        this.container.innerHTML = `
            <header>
                <nav id="nav1">
                    <ol>
                        <li class="font-jersey color-black"><i class="fa-solid fa-plane"></i></li>
                        <li class="font-jersey color-black took"><button id="btn-compagnies" type="button">Compagnies</button></li>
                        <li class="font-jersey color-black"><button id="btn-vols" type="button">Vols</button></li>
                        <li class="font-jersey color-black"><button id="btn-terminaux" type="button">Terminaux</button></li>
                        <li class="font-jersey color-black"><button id="btn-aeroports" type="button">Aéroports</button></li>
                    </ol>
                </nav> 
            </header>
            <div id='main'>
                <div id="http">
                    <ol>
                        <li class="font-jersey color-white took"><button id="btn-get" type="button">GET</button></li>
                        <li class="font-jersey color-white"><button id="btn-post" type="button">POST</button></li>
                        <li class="font-jersey color-white"><button id="btn-put" type="button">PUT</button></li>
                        <li class="font-jersey color-white"><button id="btn-delete" type="button">DELETE</button></li>
                    </ol>
                </div>
                <div id="route">
                    ${routeContent}
                </div>
            </div>
        `;

        // Une fois le HTML injecté dans le DOM, la div #route existe.
        // On peut maintenant instancier la sous-vue qui a besoin de s'y accrocher.
        if (this.state.nom === "compagnie") {
            new CompagnieSubViewApp("route");
        }
    }

    // --- GESTION DES ÉVÉNEMENTS (Délégation d'événements) ---
    // Au lieu de mettre des addEventListener de partout qui se perdent quand le HTML est recréé (render),
    // On met un seul écouteur sur le conteneur principal.
    bindEvents() {
        this.container.addEventListener('click', async (e) => {
            // 1. Clic sur "Compagnies"
            if (e.target.id === 'btn-compagnies') {
                this.setState({ nom: "compagnie" });
            }

            // 2. Clic sur "Vols"
            if (e.target.id === 'btn-vols') {
                this.setState({ nom: "vol" });
            }

            // 3. Clic sur "Terminaux"
            if (e.target.id === 'btn-terminaux') {
                this.setState({ nom: "terminal" });
            }

            // 3. Clic sur "Aéroports"
            if (e.target.id === 'btn-aeroports') {
                this.setState({ nom: "aeroport" });
            }
        });
    }
}
const main = new MainApp("app");