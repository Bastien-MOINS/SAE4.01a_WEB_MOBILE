import { CompagnieSubViewApp } from "./components/compagnieapp.js";
import { VolSubViewApp } from "./components/volapp.js";
import { TerminalSubViewApp } from "./components/terminalapp.js";
import { AeroportSubViewApp } from "./components/aeroportapp.js";

const routes = {
  '': {
    linkLabel: 'Vols',
    content: () => new VolSubViewApp('app')
  },
  '#/': {
    linkLabel: 'Vols',
    content: () => new VolSubViewApp('app')
  },
  '#/compagnies': {
    linkLabel: 'Compagnies',
    content: () => new CompagnieSubViewApp('app')
  },
  '#/vols': {
    linkLabel: 'Vols',
    content: () => new VolSubViewApp('app')
  },
  '#/terminaux': {
    linkLabel: 'Terminaux',
    content: () => new TerminalSubViewApp('app')
  },
  '#/aeroports': {
    linkLabel: 'Aéroports',
    content: () => new AeroportSubViewApp('app')
  }
};

const app = document.querySelector('#app');
const nav = document.querySelector('#nav');

const renderNavlinks = () => {
    const navFragment = document.createDocumentFragment();
    Object.keys(routes).forEach(route => {
        if (route === '') return;

        const { linkLabel } = routes[route];

        const linkElement = document.createElement('a');
        linkElement.href = route;
        linkElement.textContent = linkLabel;
        navFragment.appendChild(linkElement);
    });

    nav.append(navFragment);
};

const renderContent = route => {
    const match = routes[route] || routes[''];
    app.innerHTML = typeof match.content === 'function' ? match.content() : match.content;
};

const registerHashChange = () => {
    window.addEventListener('hashchange', () => {
        const route = window.location.hash;
        renderContent(route);
    });
};

const renderInitialPage = () => {
    const route = window.location.hash;
    renderContent(route);
};

(function bootup() {
    renderNavlinks();
    registerHashChange();
    renderInitialPage();
})();
