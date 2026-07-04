// public/datos-personales.js

document.addEventListener('DOMContentLoaded', () => {
    // --- LÓGICA DE LA INTERFAZ (UI) ---
    const themeToggle = document.getElementById('theme-toggle');
    const body = document.body;
    if (themeToggle) {
        const themeIcon = themeToggle.querySelector('i');
        const applyTheme = (theme) => {
            if (theme === 'dark') {
                body.classList.add('dark-mode');
                if (themeIcon) { themeIcon.classList.remove('fa-moon'); themeIcon.classList.add('fa-sun'); }
                localStorage.setItem('theme', 'dark');
            } else {
                body.classList.remove('dark-mode');
                if (themeIcon) { themeIcon.classList.remove('fa-sun'); themeIcon.classList.add('fa-moon'); }
                localStorage.setItem('theme', 'light');
            }
        };
        const savedTheme = localStorage.getItem('theme') || 'light';
        applyTheme(savedTheme);
        themeToggle.addEventListener('click', () => {
            const currentTheme = body.classList.contains('dark-mode') ? 'light' : 'dark';
            applyTheme(currentTheme);
        });
    }
    const openBtn = document.getElementById('sidebar-open-btn');
    const closeBtn = document.getElementById('sidebar-close-btn');
    const overlay = document.getElementById('sidebar-overlay');
    if (window.innerWidth > 992) { document.body.classList.add('sidebar-open'); }
    if (openBtn && closeBtn && overlay) {
        openBtn.addEventListener('click', () => { document.body.classList.toggle('sidebar-open'); });
        closeBtn.addEventListener('click', () => { document.body.classList.remove('sidebar-open'); });
        overlay.addEventListener('click', () => { document.body.classList.remove('sidebar-open'); });
    }

    // --- LÓGICA DE AUTENTICACIÓN Y DATOS ---
    const authToken = localStorage.getItem('authToken');
    const currentUser = JSON.parse(sessionStorage.getItem('currentUser'));

    // Verificación de seguridad agresiva para el botón "Atrás" del navegador
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

    // Escuchar el evento pageshow para recargar si viene de la caché (botón Atrás)
    window.addEventListener('pageshow', (event) => {
        if (event.persisted || (window.performance && window.performance.navigation.type === 2)) {
            enforceSecurity();
        }
    });

    if (!enforceSecurity()) return;

    // --- MODAL DE INFORMACIÓN ---
    const infoModal = document.getElementById('info-modal');
    const infoModalTitle = document.getElementById('info-modal-title');
    const infoModalMessage = document.getElementById('info-modal-message');
    const infoModalCloseBtn = document.getElementById('info-modal-close-btn');

    const showInfoModal = (title, message) => {
        if (!infoModal) return;
        infoModalTitle.textContent = title;
        infoModalMessage.textContent = message;
        infoModal.classList.add('visible');
        
        const closeHandler = () => {
            infoModal.classList.remove('visible');
            infoModalCloseBtn.removeEventListener('click', closeHandler);
        };
        infoModalCloseBtn.addEventListener('click', closeHandler);
    };

    // Prevenir navegación en tarjetas bloqueadas y mostrar el modal
    const anexoContainer = document.querySelector('.anexo-management-container');
    if (anexoContainer) {
        anexoContainer.addEventListener('click', (e) => {
            const card = e.target.closest('.anexo-management-card');
            if (card && card.classList.contains('disabled')) {
                e.preventDefault(); 
                showInfoModal('Apartado Bloqueado', 'Debes completar los datos del anexo anterior para poder desbloquear y llenar esta sección.');
            }
        });
    }

    // --- MODAL DE CERRAR SESIÓN ---
    const logoutBtn = document.getElementById('logout-btn-sidebar');
    const logoutModal = document.getElementById('logout-modal');
    
    if (logoutBtn && logoutModal) {
        const cancelLogoutBtn = document.getElementById('cancel-logout-btn');
        const confirmLogoutBtn = document.getElementById('confirm-logout-btn');

        logoutBtn.addEventListener('click', (e) => {
            e.preventDefault();
            logoutModal.classList.add('visible');
        });

        const closeModal = () => {
            logoutModal.classList.remove('visible');
        };

        cancelLogoutBtn.addEventListener('click', closeModal);
        logoutModal.addEventListener('click', (e) => {
            if (e.target === logoutModal) {
                closeModal();
            }
        });

        confirmLogoutBtn.addEventListener('click', () => {
            // 1. Borramos credenciales
            sessionStorage.removeItem('currentUser');
            localStorage.removeItem('authToken');
            
            // 2. REDIRECCIÓN DESTRUCTIVA
            window.location.replace('/home.html'); 
        });
    }

    document.getElementById('sidebar-user-name').textContent = currentUser.email || 'Cargando...';
    document.getElementById('user-email-summary').textContent = currentUser.email || 'Cargando...';
    document.getElementById('user-curp-summary').textContent = currentUser.curp || 'Cargando...';

    const actualizarEstadoAnexos = (perfil) => {
        const anexoCards = {
            anexo1: document.getElementById('anexo1-card'),
            anexo2: document.getElementById('anexo2-card'),
            anexo3: document.getElementById('anexo3-card'),
            anexo4: document.getElementById('anexo4-card'),
            anexo5: document.getElementById('anexo5-card'),
        };
        const anexoBadges = {
            anexo1: anexoCards.anexo1?.querySelector('.status-badge'),
            anexo2: anexoCards.anexo2?.querySelector('.status-badge'),
            anexo3: anexoCards.anexo3?.querySelector('.status-badge'),
            anexo4: anexoCards.anexo4?.querySelector('.status-badge'),
            anexo5: anexoCards.anexo5?.querySelector('.status-badge'),
        };

        const anexoMap = {
            anexo1_completo: { card: anexoCards.anexo1, badge: anexoBadges.anexo1 },
            anexo2_completo: { card: anexoCards.anexo2, badge: anexoBadges.anexo2 },
            anexo3_completo: { card: anexoCards.anexo3, badge: anexoBadges.anexo3 },
            anexo4_completo: { card: anexoCards.anexo4, badge: anexoBadges.anexo4 },
            anexo5_completo: { card: anexoCards.anexo5, badge: anexoBadges.anexo5 },
        };

        const setStatus = (card, badge, text, statusClass, isEnabled) => {
            if (!card || !badge) return; 
            
            let iconHtml = '';
            if (text === 'Bloqueado') {
                iconHtml = '<i class="fas fa-lock"></i><i class="fas fa-info-circle" style="margin-left: 6px; font-size: 1.1em; cursor: pointer;" title="Haz clic para más información"></i> ';
            } else if (text === 'Completo') {
                iconHtml = '<i class="fas fa-check-circle"></i> ';
            } else if (text === 'Disponible' || text === 'Incompleto') {
                iconHtml = '<i class="fas fa-pen"></i> ';
            }

            badge.innerHTML = iconHtml + text;
            badge.className = 'status-badge'; 
            if (statusClass) {
                badge.classList.add(statusClass);
            }
            if (isEnabled) {
                card.classList.remove('disabled');
                card.title = ''; 
            } else {
                card.classList.add('disabled');
                card.title = 'Debes completar el anexo anterior para desbloquear este apartado';
            }
        };

        const anexo1Completo = perfil.anexo1_completo === true;
        const anexo2Completo = perfil.anexo2_completo === true;
        const anexo3Completo = perfil.anexo3_completo === true;
        const anexo4Completo = perfil.anexo4_completo === true;
        const anexo5Completo = perfil.anexo5_completo === true;
        const actividad = perfil.actividad;

        // Anexo 1
        setStatus(anexoCards.anexo1, anexoBadges.anexo1, anexo1Completo ? 'Completo' : 'Incompleto', anexo1Completo ? 'status-complete' : 'status-incomplete', true);

        // Anexo 2
        setStatus(anexoCards.anexo2, anexoBadges.anexo2, anexo2Completo ? 'Completo' : (anexo1Completo ? 'Disponible' : 'Bloqueado'), anexo2Completo ? 'status-complete' : (anexo1Completo ? 'status-available' : ''), anexo1Completo);

        // Anexo 3
        setStatus(anexoCards.anexo3, anexoBadges.anexo3, anexo3Completo ? 'Completo' : (anexo2Completo ? 'Disponible' : 'Bloqueado'), anexo3Completo ? 'status-complete' : (anexo2Completo ? 'status-available' : ''), anexo2Completo);

        // Anexo 4
        setStatus(anexoCards.anexo4, anexoBadges.anexo4, anexo4Completo ? 'Completo' : (anexo2Completo ? 'Disponible' : 'Bloqueado'), anexo4Completo ? 'status-complete' : (anexo2Completo ? 'status-available' : ''), anexo2Completo);

        // Anexo 5
        let anexo5Unlocked = false;
        if (actividad === 'pesca') {
            anexo5Unlocked = anexo3Completo;
        } else if (actividad === 'acuacultura') {
            anexo5Unlocked = anexo4Completo;
        } else { // 'ambas' u otro
            anexo5Unlocked = anexo3Completo && anexo4Completo;
        }
        
        setStatus(anexoCards.anexo5, anexoBadges.anexo5, anexo5Completo ? 'Completo' : (anexo5Unlocked ? 'Disponible' : 'Bloqueado'), anexo5Completo ? 'status-complete' : (anexo5Unlocked ? 'status-available' : ''), anexo5Unlocked);

        if (anexoCards.anexo3) anexoCards.anexo3.style.display = 'block';
        if (anexoCards.anexo4) anexoCards.anexo4.style.display = 'block';

        if (actividad === 'pesca') {
            if (anexoCards.anexo4) anexoCards.anexo4.style.display = 'none';
        } else if (actividad === 'acuacultura') {
            if (anexoCards.anexo3) anexoCards.anexo3.style.display = 'none';
        }
    };

    const cargarDatosDelPerfil = async () => {
        try {
            const response = await fetch('/api/perfil', {
                headers: { 'Authorization': `Bearer ${authToken}` }
            });
            if (!response.ok) throw new Error('No se pudieron cargar los datos del perfil.');
            
            const perfil = await response.json();
            
            if (!perfil) {
                console.log("Perfil no encontrado para el usuario.");
                return;
            }

            const nombreCompleto = [perfil.nombre, perfil.apellido_paterno, perfil.apellido_materno].filter(Boolean).join(' ');

            document.getElementById('sidebar-user-name').textContent = perfil.correo_electronico || currentUser.email;
            document.getElementById('user-email-summary').textContent = perfil.correo_electronico || currentUser.email;
            document.getElementById('user-curp-summary').textContent = perfil.curp || currentUser.curp;

            document.getElementById('razon-social-summary').textContent = nombreCompleto || 'No registrado';
            document.getElementById('municipio-summary').textContent = perfil.municipio || 'No registrado';

            // --- LÍNEAS NUEVAS AGREGADAS AQUÍ ---
            document.getElementById('sitio-desembarque-summary').textContent = perfil.sitio_desembarque || 'No registrado';
            
            // Usamos una pequeña validación para que si es undefined muestre '0'
            const numEmbarcaciones = (perfil.num_embarcaciones !== undefined && perfil.num_embarcaciones !== null) 
                                     ? perfil.num_embarcaciones 
                                     : '0';
            document.getElementById('num-embarcaciones-summary').textContent = numEmbarcaciones;
            // ------------------------------------

            actualizarEstadoAnexos(perfil);

        } catch (error) {
            console.error("Fallo al cargar perfil completo:", error);
        }
    };

    cargarDatosDelPerfil();

});