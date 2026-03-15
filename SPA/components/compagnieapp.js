export class CompagnieSubViewApp {
    constructor(containerId) {
        this.container = document.getElementById(containerId);
        
        // L'État central de l'application (State)
        this.state = {
            compagnies: [],
            idCompagnie: null // si null on get ou pos, sinon on put ou delete
        };

        // Initialisation de l'application
        this.init();
    }

    async init() {
        await this.loadCompagnies();
        // Une fois les données chargées, on dessine l'UI
        this.renderGetCompagnie();
        // On écoute les événements globaux
        this.bindEvents();
    }

    async loadTasks() {
        try {
            this.state.tasks = await CompagnieAPI.getCompagnies();
        } catch (e) {
            console.error(e);
            this.state.compagnies = []; // Fallback en cas d'erreur
        }
    }


    static async renderGetCompagnie(){
        this.state.idCompagnie = null;
        return `
        <div class="">
            <div class="">
                <h2 class="">Liste</h2>
                <button
                    class=""><i
                        class=""></i> Ajouter Une Compagnie</button>
            </div>
            <div class="">
                <input class="" id=""
                    onkeyup="searchByName()" placeholder="Chercher par nom...">
            </div>
            <table class="">
                <thead>
                    <tr class="">
                        <th class="">Horaires</th>
                        <th class="">Nom de Compagnie</th>
                        <th class="">Aéroport de départ</th>
                        <th class="">Aéroport d'arrivé</th>
                        <th class="">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <tr class="">
                        <td class=""></td>
                        <td class=""></td>
                        <td class=""></td>
                        <td class=""></td>
                        <td class="">
                            <button
                                class=""><i class="fas fa-edit"></i></button>
                            <a href="" class=""><i
                                    class="fas fa-trash-alt"></i></a>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        `
    }

    static async renderPutPostCompagnie(){
        const Compagnie = this.state.currentTask || { nom: '' };
        return `
            <div class="">
                <div class="">
                    <div class="">
                        <div class="">
                            <i class=""></i>
                            <h3 class="">Ajouter Une Compagnie</h3>
                        </div>
                        <button class="">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                        <div class="mb-4 flex justify-between items-center">
                            <div>
                                <label for="addPrenomE" class="block text-gray-700 font-medium mb-2">Prénom</label>
                                {{ add_form.prenomE(id='addPrenomE', class_='border border-gray-300 rounded px-3 py-2 w-full
                                focus:outline-none focus:ring-2 focus:ring-blue-500', required=True) }}
                            </div>
                            <div>
                                <label for="addNomE" class="block text-gray-700 font-medium mb-2">Nom</label>
                                {{ add_form.nomE(id='addNomE', class_='border border-gray-300 rounded px-3 py-2 w-full
                                focus:outline-none focus:ring-2 focus:ring-blue-500', required=True) }}
                            </div>
                        </div>
                        <div class="mb-4">
                            <label for="addEmailE" class="block text-gray-700 font-medium mb-2">Email</label>
                            {{ add_form.emailE(id='addEmailE', class_='border border-gray-300 rounded px-3 py-2 w-full
                            focus:outline-none focus:ring-2 focus:ring-blue-500', required=True) }}
                        </div>
                        <div class="mb-4">
                            <label for="addGroupeE" class="block text-gray-700 font-medium mb-2">Groupe</label>
                            {{ add_form.groupeE(id='addGroupeE', class_='border border-gray-300 rounded px-3 py-2 w-full
                            focus:outline-none focus:ring-2 focus:ring-blue-500', required=True) }}
                        </div>
                        <div class="flex justify-end gap-2">
                            <button type="button" onclick="closeAddModal()"
                                class="bg-gray-300 hover:bg-gray-400 text-gray-800 font-bold py-2 px-4 rounded">
                                Annuler
                            </button>
                            <button type="submit"
                                class="bg-grey-button hover:bg-grey-button-hover text-white font-bold py-2 px-4 rounded">
                                Ajouter
                            </button>
                        </div>
                    </form>
                </div>
            </div>
            `
        }
        else
        
    }

    // --- GESTION DES ÉVÉNEMENTS (Délégation d'événements) ---
    // Au lieu de mettre des addEventListener de partout qui se perdent quand le HTML est recréé (render),
    // On met un seul écouteur sur le conteneur principal.

    bindEvents() {
        this.container.addEventListener('click', async (e) => {
            // 1. Clic sur "Actualiser"
            if (e.target.id === 'btn-refresh') {
                await this.loadTasks();
                this.setState({ currentTask: null, isCreating: false });
            }

            // 2. Clic sur "Nouvelle Tâche"
            if (e.target.id === 'btn-new') {
                this.setState({ currentTask: null, isCreating: true });
            }

            // 3. Clic sur une tâche de la liste
            if (e.target.closest('.task-item')) {
                const li = e.target.closest('.task-item');
                const id = parseInt(li.dataset.id, 10);
                const task = this.state.tasks.find(t => t.id === id);
                if (task) {
                    this.setState({ currentTask: task, isCreating: false });
                }
            }

            // 4. Clic sur "Supprimer la tâche courante"
            if (e.target.id === 'btn-del' && this.state.currentTask) {
                if (confirm('Voulez-vous supprimer cette tâche ?')) {
                    await TodoAPI.deleteTask(this.state.currentTask.id);
                    await this.loadTasks();
                    this.setState({ currentTask: null });
                }
            }

            // 5. Clic sur le bouton de sauvegarde (Création ou Mise à jour)
            if (e.target.id === 'btn-save') {
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
                await this.loadTasks();
                this.setState({ isCreating: false, currentTask: null });
            }
        });
    }
}