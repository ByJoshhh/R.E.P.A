// public/anexos.js - Versión Modularizada FINAL y SEGURA

import { initAnexo1, cargarDatosAnexo1 } from './js/anexo1.js';
import { initAnexo2, cargarIntegrantes } from './js/anexo2.js';
import { initAnexo3, cargarDatosAnexo3 } from './js/anexo3.js';
import { initAnexo4, cargarDatosAnexo4 } from './js/anexo4.js';
import { initAnexo5, cargarEmbarcaciones } from './js/anexo5.js';
// 1. IMPORTAMOS LA FUNCIÓN DE LOGOUT SEGURO
import { logoutUser } from './js/utils.js'; 

document.addEventListener('DOMContentLoaded', () => {
    // =======================================================
    // == 1. SELECTORES Y VARIABLES GLOBALES
    // =======================================================
    const body = document.body;
    const themeToggle = document.getElementById('theme-toggle');
    const openBtn = document.getElementById('sidebar-open-btn');
    const closeBtn = document.getElementById('sidebar-close-btn');
    const overlay = document.getElementById('sidebar-overlay');
    const tabLinks = document.querySelectorAll('.tab-link');
    const tabContents = document.querySelectorAll('.tab-content');
    const sidebarUserName = document.getElementById('sidebar-user-name');
    const logoutBtn = document.getElementById('logout-btn-sidebar');
    const logoutModal = document.getElementById('logout-modal');
    const mainCancelButton = document.getElementById('cancel-anexo-btn');
    const cancelModal = document.getElementById('cancel-confirm-modal');
    const infoModal = document.getElementById('info-modal');
    const infoModalTitle = document.getElementById('info-modal-title');
    const infoModalMessage = document.getElementById('info-modal-message');
    const infoModalIcon = document.getElementById('info-modal-icon');
    const infoModalCloseBtn = document.getElementById('info-modal-close-btn');

    const authToken = localStorage.getItem('authToken');
    const currentUser = JSON.parse(sessionStorage.getItem('currentUser'));

    // =======================================================
    // == 2. FUNCIONES AUXILIARES GLOBALES
    // =======================================================
    const showInfoModal = (title, message, isSuccess = true, onConfirm = null) => {
        if (!infoModal) return;
        infoModalTitle.textContent = title;
        infoModalMessage.textContent = message;
        infoModalIcon.className = 'modal-icon fas';
        infoModalIcon.classList.add(isSuccess ? 'fa-check-circle' : 'fa-times-circle', isSuccess ? 'success' : 'error');
        infoModal.classList.add('visible');
        
        const confirmHandler = () => {
            infoModal.classList.remove('visible');
            if (onConfirm) onConfirm();
            infoModalCloseBtn.removeEventListener('click', confirmHandler);
        };
        infoModalCloseBtn.addEventListener('click', confirmHandler, { once: true });
    };
    
    // =======================================================
    // == 3. LÓGICA DE UI GENERAL Y SEGURIDAD
    // =======================================================
    
    // CAMBIO DE SEGURIDAD: Verificación agresiva (incluye botón "Atrás")
    const enforceSecurity = () => {
        const token = localStorage.getItem('authToken');
        const user = sessionStorage.getItem('currentUser');
        if (!token || !user) {
            localStorage.removeItem('authToken');
            sessionStorage.removeItem('currentUser');
            window.location.replace('/home.html');
            return false;
        }
        return true;
    };

    window.addEventListener('pageshow', (event) => {
        if (event.persisted || (window.performance && window.performance.navigation.type === 2)) {
            enforceSecurity();
        }
    });

    if (!enforceSecurity()) return;

    if (sidebarUserName) { sidebarUserName.textContent = currentUser.email; }

    if (themeToggle) {
        const themeIcon = themeToggle.querySelector('i');
        const applyTheme = (theme) => {
            if (theme === 'dark') {
                body.classList.add('dark-mode');
                if(themeIcon) { themeIcon.classList.remove('fa-moon'); themeIcon.classList.add('fa-sun'); }
                localStorage.setItem('theme', 'dark');
            } else {
                body.classList.remove('dark-mode');
                if(themeIcon) { themeIcon.classList.remove('fa-sun'); themeIcon.classList.add('fa-moon'); }
                localStorage.setItem('theme', 'light');
            }
        };
        // Corrección leve en lógica toggle para consistencia
        const savedTheme = localStorage.getItem('theme') || 'light';
        applyTheme(savedTheme);
        themeToggle.addEventListener('click', () => {
            const newTheme = body.classList.contains('dark-mode') ? 'light' : 'dark';
            applyTheme(newTheme);
        });
    }

    if (window.innerWidth > 992) { document.body.classList.add('sidebar-open'); }
    if (openBtn) openBtn.addEventListener('click', () => { document.body.classList.toggle('sidebar-open'); });
    if (closeBtn) closeBtn.addEventListener('click', () => { document.body.classList.remove('sidebar-open'); });
    if (overlay) overlay.addEventListener('click', () => { document.body.classList.remove('sidebar-open'); });

    // 3. CAMBIO DE SEGURIDAD: Lógica de Logout
    if (logoutBtn && logoutModal) {
        logoutBtn.addEventListener('click', (e) => { e.preventDefault(); logoutModal.classList.add('visible'); });
        const closeModal = () => logoutModal.classList.remove('visible');
        document.getElementById('cancel-logout-btn').addEventListener('click', closeModal);
        logoutModal.addEventListener('click', (e) => { if (e.target === logoutModal) closeModal(); });
        
        document.getElementById('confirm-logout-btn').addEventListener('click', () => {
            logoutUser(); // <--- Usamos la función importada de utils.js
        });
    }
    
    if (mainCancelButton && cancelModal) {
        mainCancelButton.addEventListener('click', () => cancelModal.classList.add('visible'));
        const closeModal = () => cancelModal.classList.remove('visible');
        document.getElementById('deny-cancel-btn').addEventListener('click', closeModal);
        cancelModal.addEventListener('click', (e) => { if (e.target === cancelModal) closeModal(); });
        
        // Navegación interna (aquí href está bien, pero replace es opcional si no quieres que vuelvan al modal)
        document.getElementById('confirm-cancel-btn').addEventListener('click', () => { window.location.href = 'datos-personales.html'; });
    }

    // =======================================================
    // == NAVEGACIÓN Y CARGA INICIAL
    // =======================================================
    const switchTab = (tabId) => {
        tabContents.forEach(c => c.classList.remove('active'));
        tabLinks.forEach(l => l.classList.remove('active'));
        const activeContent = document.getElementById(tabId);
        const activeLink = document.querySelector(`.tab-link[data-tab="${tabId}"]`);
        if(activeContent) activeContent.classList.add('active');
        if(activeLink) activeLink.classList.add('active');
    };
    
    const actualizarEstadoTabs = (perfil) => {
        const anexo1Completo = perfil && perfil.anexo1_completo;
        const anexo2Completo = perfil && perfil.anexo2_completo;
        const anexo3Completo = perfil && perfil.anexo3_completo;
        const anexo4Completo = perfil && perfil.anexo4_completo;
        const actividad = perfil ? perfil.actividad : null;

        let anexo5Unlocked = false;
        if (actividad === 'pesca') {
            anexo5Unlocked = anexo3Completo;
        } else if (actividad === 'acuacultura') {
            anexo5Unlocked = anexo4Completo;
        } else {
            anexo5Unlocked = anexo3Completo && anexo4Completo;
        }

        const updateTabStatus = (tabId, isUnlocked) => {
            const tab = document.querySelector(`.tab-link[data-tab="${tabId}"]`);
            if (!tab) return;
            tab.classList.toggle('disabled', !isUnlocked);
            const lockIcon = tab.querySelector('.fa-lock');
            const infoIcon = tab.querySelector('.fa-info-circle');
            if (lockIcon) lockIcon.style.display = isUnlocked ? 'none' : 'inline-block';
            if (infoIcon) infoIcon.style.display = isUnlocked ? 'none' : 'inline-block';
        };

        updateTabStatus('anexo2', anexo1Completo);
        updateTabStatus('anexo3', anexo2Completo);
        updateTabStatus('anexo4', anexo2Completo);
        updateTabStatus('anexo5', anexo5Unlocked);

        const anexo3Tab = document.querySelector('.tab-link[data-tab="anexo3"]');
        const anexo4Tab = document.querySelector('.tab-link[data-tab="anexo4"]');
        if (anexo3Tab) anexo3Tab.style.display = '';
        if (anexo4Tab) anexo4Tab.style.display = '';

        if (actividad === 'pesca' && anexo4Tab) anexo4Tab.style.display = 'none';
        else if (actividad === 'acuacultura' && anexo3Tab) anexo3Tab.style.display = 'none';
    };
    
    const inicializarPaginaAnexos = async () => {
        try {
            const response = await fetch('/api/perfil', { headers: { 'Authorization': `Bearer ${authToken}` } });
            if (response.status === 401) { // Si el token expiró mientras navegaba
                 logoutUser(); 
                 return;
            }
            const perfil = response.ok ? await response.json() : null;
            actualizarEstadoTabs(perfil);
        } catch (error) {
            console.error("Error al verificar el estado del perfil:", error);
            actualizarEstadoTabs(null);
        }

        let hash = window.location.hash.substring(1) || 'anexo1';
        
        const tab = document.querySelector(`.tab-link[data-tab="${hash}"]`);
        if (tab && tab.classList.contains('disabled')) {
            hash = 'anexo1';
            window.location.hash = hash;
        }

        switchTab(hash);
        
        switch (hash) {
            case 'anexo1': await cargarDatosAnexo1(authToken); break;
            case 'anexo2': await cargarIntegrantes(authToken); break;
            case 'anexo3': await cargarDatosAnexo3(authToken); break;
            case 'anexo4': await cargarDatosAnexo4(authToken); break;
            case 'anexo5': await cargarEmbarcaciones(authToken); break;
            default: await cargarDatosAnexo1(authToken); break;
        }
    };
    
    tabLinks.forEach(link => {
        link.addEventListener('click', (e) => {
            if(!e.currentTarget.classList.contains('disabled')) {
                const tabId = e.currentTarget.dataset.tab;
                window.location.hash = tabId;
                inicializarPaginaAnexos();
            } else {
                showInfoModal('Pestaña Bloqueada', 'Debes completar los datos del anexo anterior para poder desbloquear y llenar esta sección.', false);
            }
        });
    });

    // INICIALIZACIÓN DE MÓDULOS
    initAnexo1(authToken, showInfoModal);
    initAnexo2(authToken, showInfoModal);
    initAnexo3(authToken, showInfoModal);
    initAnexo4(authToken, showInfoModal);
    initAnexo5(authToken, showInfoModal);
    
    inicializarPaginaAnexos();
});