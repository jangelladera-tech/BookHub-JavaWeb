const pptxgen = require('pptxgenjs');
const path = require('path');
const fs = require('fs');

async function createPresentation() {
    const pres = new pptxgen();
    pres.layout = 'LAYOUT_16x9';
    pres.author = 'Equipo BookHub';
    pres.company = 'BookHub';
    pres.title = 'BookHub - Plataforma de Gestión y Acceso Bibliotecario';

    // Colores corporativos de BookHub
    const C_DARK_BG = '0B132B';
    const C_CARD_BG = '1C2541';
    const C_CARD_BORDER = '3A506B';
    const C_PRIMARY = '4F46E5';
    const C_CYAN = '00C2CB';
    const C_AMBER = 'F59E0B';
    const C_WHITE = 'FFFFFF';
    const C_TEXT_LIGHT = 'E2E8F0';
    const C_TEXT_MUTED = '94A3B8';

    // Helper: Fondo degradado sutil simulado con rectángulo oscuro
    function applySlideBackground(slide, titleCategory) {
        slide.background = { color: C_DARK_BG };
        
        // Barra decorativa superior
        slide.addShape(pres.ShapeType.rect, {
            x: 0, y: 0, w: '100%', h: 0.1,
            fill: { color: C_CYAN }
        });

        // Categoría / Breadcrumb superior
        if (titleCategory) {
            slide.addText(titleCategory.toUpperCase(), {
                x: 0.8, y: 0.35, w: 8, h: 0.3,
                fontSize: 10, bold: true, color: C_CYAN,
                fontFace: 'Arial'
            });
        }

        // Pie de página
        slide.addText('BookHub • Sistema de Gestión y Acceso Bibliotecario', {
            x: 0.8, y: 7.1, w: 6, h: 0.3,
            fontSize: 9, color: C_TEXT_MUTED, fontFace: 'Arial'
        });
    }

    // ==========================================
    // DIAPOSITIVA 1: PORTADA
    // ==========================================
    {
        const s1 = pres.addSlide();
        s1.background = { color: C_DARK_BG };

        // Acentos decorativos de fondo
        s1.addShape(pres.ShapeType.roundRect, {
            x: 0.8, y: 0.8, w: 11.7, h: 5.9,
            rectRadius: 0.2,
            fill: { color: C_CARD_BG },
            line: { color: C_CARD_BORDER, width: 1.5 }
        });

        // Etiqueta superior
        s1.addText('PROPUESTA DE VALOR • IDENTIDAD INSTITUCIONAL', {
            x: 1.4, y: 1.3, w: 10, h: 0.4,
            fontSize: 12, bold: true, color: C_CYAN, fontFace: 'Arial', tracking: 2
        });

        // Título principal
        s1.addText('BOOKHUB', {
            x: 1.4, y: 1.8, w: 10, h: 1.1,
            fontSize: 48, bold: true, color: C_WHITE, fontFace: 'Arial'
        });

        // Subtítulo
        s1.addText('Ecosistema Digital Inteligente para la Gestión Bibliotecaria y el Acceso Democrático a la Lectura', {
            x: 1.4, y: 3.0, w: 9.5, h: 0.8,
            fontSize: 18, color: C_TEXT_LIGHT, fontFace: 'Arial'
        });

        // Tarjetas resumen en la portada
        const features = [
            { t: '¿Quiénes Somos?', d: 'Plataforma integral que une lectores y biblioteca.' },
            { t: 'Diferencial Clave', d: 'Búsqueda por voz, accesibilidad universal y control en vivo.' },
            { t: 'Beneficio al Usuario', d: 'Ahorro de tiempo, préstamos ágiles y hábitos de lectura.' }
        ];

        features.forEach((f, idx) => {
            const posX = 1.4 + idx * 3.4;
            s1.addShape(pres.ShapeType.roundRect, {
                x: posX, y: 4.2, w: 3.2, h: 1.8,
                rectRadius: 0.15,
                fill: { color: '24324F' },
                line: { color: C_CARD_BORDER, width: 1 }
            });

            s1.addText(f.t, {
                x: posX + 0.2, y: 4.4, w: 2.8, h: 0.4,
                fontSize: 14, bold: true, color: C_CYAN, fontFace: 'Arial'
            });

            s1.addText(f.d, {
                x: posX + 0.2, y: 4.9, w: 2.8, h: 0.9,
                fontSize: 11, color: C_TEXT_LIGHT, fontFace: 'Arial'
            });
        });
    }

    // ==========================================
    // DIAPOSITIVA 2: ¿QUIÉNES SOMOS?
    // ==========================================
    {
        const s2 = pres.addSlide();
        applySlideBackground(s2, 'Identidad y Propósito');

        s2.addText('¿Quiénes Somos como Plataforma?', {
            x: 0.8, y: 0.65, w: 11.5, h: 0.7,
            fontSize: 28, bold: true, color: C_WHITE, fontFace: 'Arial'
        });

        // Bloque Introductorio
        s2.addShape(pres.ShapeType.roundRect, {
            x: 0.8, y: 1.5, w: 11.7, h: 1.4,
            rectRadius: 0.15,
            fill: { color: C_CARD_BG },
            line: { color: C_PRIMARY, width: 1.5 }
        });

        s2.addText([
            { text: 'BookHub ', options: { bold: true, color: C_CYAN } },
            { text: 'es una solución web integral diseñada para modernizar la experiencia bibliotecaria tanto para los ', options: { color: C_TEXT_LIGHT } },
            { text: 'lectores ', options: { bold: true, color: C_WHITE } },
            { text: '(estudiantes, investigadores y autodidactas) como para los ', options: { color: C_TEXT_LIGHT } },
            { text: 'administradores bibliotecarios', options: { bold: true, color: C_WHITE } },
            { text: '. Nacemos con el propósito de eliminar las barreras de acceso a los libros físicos y digitales, sustituyendo procesos manuales por una gestión ágil, transparente y moderna.', options: { color: C_TEXT_LIGHT } }
        ], {
            x: 1.1, y: 1.65, w: 11.1, h: 1.1,
            fontSize: 14, fontFace: 'Arial'
        });

        // 3 Pilares Fundamentales
        const pilares = [
            {
                num: '01',
                titulo: 'Democratización Cultural',
                desc: 'Permitimos que cualquier persona consulte el catálogo completo en tiempo real, conozca la disponibilidad de ejemplares y acceda a préstamos sin burocracia.'
            },
            {
                num: '02',
                titulo: 'Gestión Eficiente y Precisa',
                desc: 'Automatizamos la trazabilidad de préstamos, el control riguroso de inventario, la alerta de ejemplares agotados y las devoluciones a tiempo.'
            },
            {
                num: '03',
                titulo: 'Comunidad y Sostenibilidad',
                desc: 'Fomentamos la circulación colaborativa del conocimiento mediante un módulo transparente de donación y validación de nuevos libros.'
            }
        ];

        pilares.forEach((p, idx) => {
            const posX = 0.8 + idx * 4.0;
            s2.addShape(pres.ShapeType.roundRect, {
                x: posX, y: 3.2, w: 3.7, h: 3.5,
                rectRadius: 0.15,
                fill: { color: C_CARD_BG },
                line: { color: C_CARD_BORDER, width: 1 }
            });

            s2.addText(p.num, {
                x: posX + 0.3, y: 3.4, w: 1.5, h: 0.5,
                fontSize: 24, bold: true, color: C_CYAN, fontFace: 'Arial'
            });

            s2.addText(p.titulo, {
                x: posX + 0.3, y: 4.0, w: 3.1, h: 0.6,
                fontSize: 16, bold: true, color: C_WHITE, fontFace: 'Arial'
            });

            s2.addText(p.desc, {
                x: posX + 0.3, y: 4.7, w: 3.1, h: 1.8,
                fontSize: 12, color: C_TEXT_LIGHT, fontFace: 'Arial'
            });
        });
    }

    // ==========================================
    // DIAPOSITIVA 3: ¿QUÉ NOS DIFERENCIA DE LAS DEMÁS?
    // ==========================================
    {
        const s3 = pres.addSlide();
        applySlideBackground(s3, 'Ventaja Competitiva y Diferenciadores');

        s3.addText('¿Qué Diferencia a BookHub de las Demás Plataformas?', {
            x: 0.8, y: 0.65, w: 11.5, h: 0.7,
            fontSize: 28, bold: true, color: C_WHITE, fontFace: 'Arial'
        });

        const diferenciales = [
            {
                titulo: 'Búsqueda por Voz & Filtros en Vivo',
                desc: 'A diferencia de sistemas rígidos tradicionales, BookHub permite dictar por voz el título o autor deseado, filtrando al instante por categorías sin recargar la página.',
                color: C_CYAN
            },
            {
                titulo: 'Panel de Accesibilidad Universal (A11y)',
                desc: 'Incorporamos herramientas nativas de inclusión: tipografía adaptada para dislexia, modos de alto contraste, escala de fuentes y lectura asistida por voz.',
                color: C_AMBER
            },
            {
                titulo: 'Trazabilidad y Stock en Tiempo Real',
                desc: 'Los lectores ven disponibilidad exacta de ejemplares; los administradores cuentan con semáforos de stock bajo, alertas de morosidad y cálculo automático de sanciones.',
                color: '38BDF8'
            },
            {
                titulo: 'Ecosistema de Donaciones Comunitarias',
                desc: 'No es solo un catálogo cerrado: integra un circuito donde los usuarios proponen libros en donación y los bibliotecarios los validan e incorporan al acervo.',
                color: 'A855F7'
            }
        ];

        diferenciales.forEach((d, idx) => {
            const col = idx % 2;
            const row = Math.floor(idx / 2);
            const posX = 0.8 + col * 5.95;
            const posY = 1.6 + row * 2.6;

            s3.addShape(pres.ShapeType.roundRect, {
                x: posX, y: posY, w: 5.75, h: 2.35,
                rectRadius: 0.15,
                fill: { color: C_CARD_BG },
                line: { color: d.color, width: 1.5 }
            });

            s3.addText(d.titulo, {
                x: posX + 0.35, y: posY + 0.25, w: 5.0, h: 0.45,
                fontSize: 16, bold: true, color: C_WHITE, fontFace: 'Arial'
            });

            s3.addText(d.desc, {
                x: posX + 0.35, y: posY + 0.8, w: 5.0, h: 1.35,
                fontSize: 12, color: C_TEXT_LIGHT, fontFace: 'Arial'
            });
        });
    }

    // ==========================================
    // DIAPOSITIVA 4: ¿CÓMO USUARIO QUÉ HARÍA INGRESANDO?
    // ==========================================
    {
        const s4 = pres.addSlide();
        applySlideBackground(s4, 'Experiencia del Lector (User Journey)');

        s4.addText('¿Como Usuario Qué Haría al Ingresar a BookHub?', {
            x: 0.8, y: 0.65, w: 11.5, h: 0.7,
            fontSize: 28, bold: true, color: C_WHITE, fontFace: 'Arial'
        });

        const pasos = [
            {
                paso: 'PASO 1',
                titulo: 'Explorar el Catálogo',
                accion: 'El usuario accede y navega visualmente por portadas, categorías (Novelas, Programación, Historia, etc.) y recomendaciones destacadas.'
            },
            {
                paso: 'PASO 2',
                titulo: 'Búsqueda Inteligente',
                accion: 'Escribe palabras clave o pulsa el botón "Dictar" para buscar por voz con reconocimiento inmediato y sin fricciones.'
            },
            {
                paso: 'PASO 3',
                titulo: 'Ficha y Disponibilidad',
                accion: 'Abre el detalle del libro para leer la sinopsis, año, autor y verificar en vivo si hay ejemplares disponibles para préstamo inmediato.'
            },
            {
                paso: 'PASO 4',
                titulo: 'Solicitar Préstamo',
                accion: 'Con un solo clic solicita el ejemplar. El sistema registra las fechas de entrega y devolución esperada de manera automática.'
            },
            {
                paso: 'PASO 5',
                titulo: 'Control y Donaciones',
                accion: 'Supervisa en "Mis Préstamos" sus plazos y devoluciones, o ingresa al módulo de Donar para aportar nuevos libros a la comunidad.'
            }
        ];

        pasos.forEach((p, idx) => {
            const posX = 0.8 + idx * 2.38;
            s4.addShape(pres.ShapeType.roundRect, {
                x: posX, y: 1.6, w: 2.22, h: 5.1,
                rectRadius: 0.15,
                fill: { color: C_CARD_BG },
                line: { color: C_CARD_BORDER, width: 1 }
            });

            // Badge Paso
            s4.addShape(pres.ShapeType.roundRect, {
                x: posX + 0.2, y: 1.85, w: 1.82, h: 0.35,
                rectRadius: 0.1,
                fill: { color: C_PRIMARY }
            });

            s4.addText(p.paso, {
                x: posX + 0.2, y: 1.88, w: 1.82, h: 0.3,
                fontSize: 10, bold: true, color: C_WHITE, fontFace: 'Arial', align: 'center'
            });

            s4.addText(p.titulo, {
                x: posX + 0.2, y: 2.35, w: 1.82, h: 0.65,
                fontSize: 14, bold: true, color: C_CYAN, fontFace: 'Arial'
            });

            s4.addText(p.accion, {
                x: posX + 0.2, y: 3.1, w: 1.82, h: 3.4,
                fontSize: 11, color: C_TEXT_LIGHT, fontFace: 'Arial'
            });
        });
    }

    // ==========================================
    // DIAPOSITIVA 5: ¿EN QUÉ ME BENEFICIA Y AYUDA?
    // ==========================================
    {
        const s5 = pres.addSlide();
        applySlideBackground(s5, 'Beneficios y Valor para el Usuario');

        s5.addText('¿En Qué me Beneficia y Ayuda BookHub?', {
            x: 0.8, y: 0.65, w: 11.5, h: 0.7,
            fontSize: 28, bold: true, color: C_WHITE, fontFace: 'Arial'
        });

        const beneficios = [
            {
                icono: '⏱️',
                titulo: 'Ahorro Radical de Tiempo',
                detalle: 'No tienes que ir físicamente a la biblioteca a adivinar si el libro está en estantería. En segundos sabes si está disponible y puedes reservarlo de inmediato.'
            },
            {
                icono: '📅',
                titulo: 'Cero Multas y Mejor Organización',
                detalle: 'Desde "Mis Préstamos" supervisas tus fechas de vencimiento con estados claros (Prestado, Devuelto, Moroso), evitando sanciones por retrasos.'
            },
            {
                icono: '👓',
                titulo: 'Lectura Cómoda y Sin Barreras',
                detalle: 'Si sufres de fatiga visual o dislexia, adaptas la interfaz al instante con fuentes especializadas, alto contraste o dictado por voz.'
            },
            {
                icono: '📚',
                titulo: 'Acceso Centralizado al Conocimiento',
                detalle: 'Todo tu acervo académico, profesional y literario en una sola plataforma disponible 24/7 desde cualquier computadora o dispositivo móvil.'
            }
        ];

        beneficios.forEach((b, idx) => {
            const posX = 0.8 + idx * 3.0;
            s5.addShape(pres.ShapeType.roundRect, {
                x: posX, y: 1.6, w: 2.8, h: 5.1,
                rectRadius: 0.15,
                fill: { color: C_CARD_BG },
                line: { color: C_CARD_BORDER, width: 1 }
            });

            s5.addText(b.icono, {
                x: posX + 0.2, y: 1.9, w: 2.4, h: 0.6,
                fontSize: 28, align: 'center'
            });

            s5.addText(b.titulo, {
                x: posX + 0.2, y: 2.6, w: 2.4, h: 0.8,
                fontSize: 15, bold: true, color: C_WHITE, fontFace: 'Arial', align: 'center'
            });

            s5.addText(b.detalle, {
                x: posX + 0.2, y: 3.5, w: 2.4, h: 3.0,
                fontSize: 11.5, color: C_TEXT_LIGHT, fontFace: 'Arial'
            });
        });
    }

    // ==========================================
    // DIAPOSITIVA 6: CONCLUSIÓN Y RESUMEN EJECUTIVO
    // ==========================================
    {
        const s6 = pres.addSlide();
        applySlideBackground(s6, 'Conclusión y Síntesis');

        s6.addText('El Puente Entre el Lector y el Conocimiento', {
            x: 0.8, y: 0.65, w: 11.5, h: 0.7,
            fontSize: 28, bold: true, color: C_WHITE, fontFace: 'Arial'
        });

        // Contenedor principal de síntesis
        s6.addShape(pres.ShapeType.roundRect, {
            x: 0.8, y: 1.6, w: 11.7, h: 4.0,
            rectRadius: 0.15,
            fill: { color: C_CARD_BG },
            line: { color: C_CYAN, width: 2 }
        });

        s6.addText('Síntesis de Propuesta de Valor', {
            x: 1.2, y: 1.9, w: 10.9, h: 0.4,
            fontSize: 18, bold: true, color: C_CYAN, fontFace: 'Arial'
        });

        const puntos = [
            '• BookHub trasciende el concepto de una biblioteca tradicional convirtiéndola en un servicio digital ágil, interactivo y accesible.',
            '• Resuelve los 3 principales dolores del usuario: pérdida de tiempo en búsquedas manuales, falta de trazabilidad en préstamos e inaccesibilidad.',
            '• Ofrece a la institución una arquitectura sólida en Java Web MVC (Jakarta EE + Maven) que garantiza escalabilidad y facilidad de mantenimiento.',
            '• Es una plataforma humana: promueve la donación de libros, fomenta el hábito lector y no deja a nadie atrás gracias a sus herramientas inclusivas.'
        ];

        s6.addText(puntos.join('\n\n'), {
            x: 1.2, y: 2.5, w: 10.9, h: 2.8,
            fontSize: 13, color: C_TEXT_LIGHT, fontFace: 'Arial'
        });

        // Banner inferior de llamado
        s6.addShape(pres.ShapeType.roundRect, {
            x: 0.8, y: 5.8, w: 11.7, h: 0.9,
            rectRadius: 0.1,
            fill: { color: C_PRIMARY }
        });

        s6.addText('BookHub: Más que una biblioteca, tu punto de encuentro con la lectura.', {
            x: 1.0, y: 6.0, w: 11.3, h: 0.5,
            fontSize: 14, bold: true, color: C_WHITE, fontFace: 'Arial', align: 'center'
        });
    }

    const outputPath = path.resolve(__dirname, 'BookHub_Presentacion.pptx');
    await pres.writeFile({ fileName: outputPath });
    console.log(`Presentación generada exitosamente en: ${outputPath}`);
}

createPresentation().catch(err => {
    console.error('Error generando PPTX:', err);
    process.exit(1);
});
