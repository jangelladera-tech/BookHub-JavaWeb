const pptxgen = require('pptxgenjs');
const path = require('path');
const fs = require('fs');

async function createPresentation() {
    const pres = new pptxgen();

    // DEFINICIÓN EXACTA DE DIMENSIONES PANORÁMICAS 16:9 (Widescreen PowerPoint)
    // 13.333 pulgadas de ancho x 7.5 pulgadas de alto
    pres.defineLayout({ name: 'WIDE_16_9', width: 13.333, height: 7.5 });
    pres.layout = 'WIDE_16_9';

    pres.author = 'Equipo BookHub';
    pres.company = 'BookHub';
    pres.title = 'BookHub - Presentación Oficial';

    // Paleta de Colores de la Marca BookHub
    const C_DARK_BG = '0B132B';
    const C_CARD_BG = '1C2541';
    const C_CARD_BORDER = '3A506B';
    const C_PRIMARY = '4F46E5';
    const C_CYAN = '00C2CB';
    const C_AMBER = 'F59E0B';
    const C_WHITE = 'FFFFFF';
    const C_TEXT_LIGHT = 'E2E8F0';
    const C_TEXT_MUTED = '94A3B8';

    const logoPath = path.resolve(__dirname, 'favicon-180x180.png');
    const hasLogo = fs.existsSync(logoPath);

    // Plantilla base para cada diapositiva de contenido
    function applySlideBackground(slide, titleCategory) {
        slide.background = { color: C_DARK_BG };
        
        // Línea superior decorativa
        slide.addShape(pres.ShapeType.rect, {
            x: 0, y: 0, w: 13.333, h: 0.08,
            fill: { color: C_CYAN }
        });

        // Categoría / Breadcrumb
        if (titleCategory) {
            slide.addText(titleCategory.toUpperCase(), {
                x: 0.8, y: 0.28, w: 8, h: 0.28,
                fontSize: 10, bold: true, color: C_CYAN,
                fontFace: 'Arial', margin: 0
            });
        }

        // Logo pequeño en esquina superior derecha
        if (hasLogo) {
            slide.addImage({
                path: logoPath,
                x: 12.15, y: 0.25, w: 0.45, h: 0.45
            });
        }

        // Pie de página
        slide.addText('BookHub • Sistema de Gestión y Acceso Bibliotecario', {
            x: 0.8, y: 7.05, w: 7, h: 0.3,
            fontSize: 9, color: C_TEXT_MUTED, fontFace: 'Arial', margin: 0
        });
    }

    // ==========================================
    // DIAPOSITIVA 1: PORTADA
    // ==========================================
    {
        const s1 = pres.addSlide();
        s1.background = { color: C_DARK_BG };

        // Marco contenedor de la portada (centrado y contenido)
        s1.addShape(pres.ShapeType.roundRect, {
            x: 0.8, y: 0.65, w: 11.73, h: 6.1,
            rectRadius: 0.2,
            fill: { color: C_CARD_BG },
            line: { color: C_CARD_BORDER, width: 1.5 }
        });

        // Logo en la portada
        if (hasLogo) {
            s1.addImage({
                path: logoPath,
                x: 1.3, y: 1.05, w: 0.85, h: 0.85
            });
        }

        const startX = hasLogo ? 2.35 : 1.3;

        // Subtítulo superior
        s1.addText('PROPUESTA DE VALOR • IDENTIDAD INSTITUCIONAL', {
            x: startX, y: 1.1, w: 9.5, h: 0.35,
            fontSize: 11, bold: true, color: C_CYAN, fontFace: 'Arial', margin: 0
        });

        // Título BookHub
        s1.addText('BOOKHUB', {
            x: startX, y: 1.45, w: 9.5, h: 0.9,
            fontSize: 44, bold: true, color: C_WHITE, fontFace: 'Arial', margin: 0
        });

        // Subtítulo descriptivo
        s1.addText('Ecosistema Digital Inteligente para la Gestión Bibliotecaria y el Acceso Democrático a la Lectura', {
            x: 1.3, y: 2.6, w: 10.7, h: 0.7,
            fontSize: 16, color: C_TEXT_LIGHT, fontFace: 'Arial', margin: 0
        });

        // 3 Tarjetas resumen inferiores
        const features = [
            { t: '¿Quiénes Somos?', d: 'Plataforma web integral que une a lectores y administradores.' },
            { t: 'Diferencial Clave', d: 'Búsqueda por voz, accesibilidad A11y e inventario en tiempo real.' },
            { t: 'Beneficio al Usuario', d: 'Ahorro de tiempo, préstamos inmediatos y control de lecturas.' }
        ];

        features.forEach((f, idx) => {
            const posX = 1.3 + idx * 3.65;
            s1.addShape(pres.ShapeType.roundRect, {
                x: posX, y: 3.7, w: 3.4, h: 2.4,
                rectRadius: 0.15,
                fill: { color: '24324F' },
                line: { color: C_CARD_BORDER, width: 1 }
            });

            s1.addText(f.t, {
                x: posX + 0.25, y: 3.95, w: 2.9, h: 0.4,
                fontSize: 14, bold: true, color: C_CYAN, fontFace: 'Arial', margin: 0
            });

            s1.addText(f.d, {
                x: posX + 0.25, y: 4.5, w: 2.9, h: 1.3,
                fontSize: 11.5, color: C_TEXT_LIGHT, fontFace: 'Arial', margin: 0
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
            x: 0.8, y: 0.55, w: 11.5, h: 0.65,
            fontSize: 26, bold: true, color: C_WHITE, fontFace: 'Arial', margin: 0
        });

        // Caja de definición
        s2.addShape(pres.ShapeType.roundRect, {
            x: 0.8, y: 1.35, w: 11.73, h: 1.25,
            rectRadius: 0.15,
            fill: { color: C_CARD_BG },
            line: { color: C_PRIMARY, width: 1.5 }
        });

        s2.addText([
            { text: 'BookHub ', options: { bold: true, color: C_CYAN } },
            { text: 'es una solución web integral diseñada para modernizar la experiencia bibliotecaria tanto para los ', options: { color: C_TEXT_LIGHT } },
            { text: 'lectores ', options: { bold: true, color: C_WHITE } },
            { text: '(estudiantes, investigadores y autodidactas) como para los ', options: { color: C_TEXT_LIGHT } },
            { text: 'administradores de biblioteca', options: { bold: true, color: C_WHITE } },
            { text: '. Nacemos con el propósito de eliminar las barreras de acceso a los libros físicos y digitales, reemplazando procesos manuales por una gestión ágil, transparente y moderna.', options: { color: C_TEXT_LIGHT } }
        ], {
            x: 1.05, y: 1.5, w: 11.2, h: 0.95,
            fontSize: 13, fontFace: 'Arial', margin: 0
        });

        // 3 Pilares
        const pilares = [
            {
                num: '01',
                titulo: 'Democratización Cultural',
                desc: 'Permite que cualquier persona consulte el catálogo completo en tiempo real, conozca la disponibilidad de ejemplares y acceda a préstamos sin burocracia.'
            },
            {
                num: '02',
                titulo: 'Gestión Eficiente y Precisa',
                desc: 'Automatiza la trazabilidad de préstamos, el control de inventario físico, la alerta de ejemplares agotados y las devoluciones a tiempo.'
            },
            {
                num: '03',
                titulo: 'Comunidad y Sostenibilidad',
                desc: 'Fomenta la circulación colaborativa del conocimiento mediante un módulo transparente de donación y validación de nuevos libros.'
            }
        ];

        pilares.forEach((p, idx) => {
            const posX = 0.8 + idx * 3.99;
            s2.addShape(pres.ShapeType.roundRect, {
                x: posX, y: 2.8, w: 3.75, h: 3.9,
                rectRadius: 0.15,
                fill: { color: C_CARD_BG },
                line: { color: C_CARD_BORDER, width: 1 }
            });

            s2.addText(p.num, {
                x: posX + 0.3, y: 3.05, w: 1.5, h: 0.45,
                fontSize: 22, bold: true, color: C_CYAN, fontFace: 'Arial', margin: 0
            });

            s2.addText(p.titulo, {
                x: posX + 0.3, y: 3.65, w: 3.15, h: 0.55,
                fontSize: 15, bold: true, color: C_WHITE, fontFace: 'Arial', margin: 0
            });

            s2.addText(p.desc, {
                x: posX + 0.3, y: 4.35, w: 3.15, h: 2.0,
                fontSize: 12, color: C_TEXT_LIGHT, fontFace: 'Arial', margin: 0
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
            x: 0.8, y: 0.55, w: 11.5, h: 0.65,
            fontSize: 26, bold: true, color: C_WHITE, fontFace: 'Arial', margin: 0
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
                desc: 'Los lectores ven la disponibilidad exacta de ejemplares; los administradores cuentan con semáforos de stock bajo, alertas de morosidad y cálculo automático de sanciones.',
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
            const posX = 0.8 + col * 5.98;
            const posY = 1.4 + row * 2.55;

            s3.addShape(pres.ShapeType.roundRect, {
                x: posX, y: posY, w: 5.75, h: 2.3,
                rectRadius: 0.15,
                fill: { color: C_CARD_BG },
                line: { color: d.color, width: 1.5 }
            });

            s3.addText(d.titulo, {
                x: posX + 0.35, y: posY + 0.25, w: 5.05, h: 0.45,
                fontSize: 15, bold: true, color: C_WHITE, fontFace: 'Arial', margin: 0
            });

            s3.addText(d.desc, {
                x: posX + 0.35, y: posY + 0.8, w: 5.05, h: 1.3,
                fontSize: 12, color: C_TEXT_LIGHT, fontFace: 'Arial', margin: 0
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
            x: 0.8, y: 0.55, w: 11.5, h: 0.65,
            fontSize: 26, bold: true, color: C_WHITE, fontFace: 'Arial', margin: 0
        });

        const pasos = [
            {
                paso: 'PASO 1',
                titulo: 'Explorar Catálogo',
                accion: 'Accede y navega visualmente por portadas, categorías (Novelas, Programación, etc.) y libros destacados.'
            },
            {
                paso: 'PASO 2',
                titulo: 'Búsqueda por Voz',
                accion: 'Escribe palabras clave o pulsa el botón "Dictar" para buscar por voz con reconocimiento inmediato.'
            },
            {
                paso: 'PASO 3',
                titulo: 'Ficha y Stock',
                accion: 'Abre el detalle del libro para leer la sinopsis, año, autor y verificar en vivo si hay ejemplares en sala.'
            },
            {
                paso: 'PASO 4',
                titulo: 'Solicitar Préstamo',
                accion: 'Con un clic solicita el libro; el sistema calcula las fechas de entrega y devolución esperada de forma automática.'
            },
            {
                paso: 'PASO 5',
                titulo: 'Control y Aportes',
                accion: 'Supervisa en "Mis Préstamos" sus plazos, o ingresa al módulo de Donar para aportar nuevos libros a la comunidad.'
            }
        ];

        pasos.forEach((p, idx) => {
            const posX = 0.8 + idx * 2.39;
            s4.addShape(pres.ShapeType.roundRect, {
                x: posX, y: 1.45, w: 2.18, h: 5.2,
                rectRadius: 0.15,
                fill: { color: C_CARD_BG },
                line: { color: C_CARD_BORDER, width: 1 }
            });

            // Badge del paso
            s4.addShape(pres.ShapeType.roundRect, {
                x: posX + 0.15, y: 1.7, w: 1.88, h: 0.35,
                rectRadius: 0.08,
                fill: { color: C_PRIMARY }
            });

            s4.addText(p.paso, {
                x: posX + 0.15, y: 1.75, w: 1.88, h: 0.25,
                fontSize: 10, bold: true, color: C_WHITE, fontFace: 'Arial', align: 'center', margin: 0
            });

            s4.addText(p.titulo, {
                x: posX + 0.15, y: 2.25, w: 1.88, h: 0.6,
                fontSize: 13.5, bold: true, color: C_CYAN, fontFace: 'Arial', margin: 0
            });

            s4.addText(p.accion, {
                x: posX + 0.15, y: 2.95, w: 1.88, h: 3.4,
                fontSize: 11, color: C_TEXT_LIGHT, fontFace: 'Arial', margin: 0
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
            x: 0.8, y: 0.55, w: 11.5, h: 0.65,
            fontSize: 26, bold: true, color: C_WHITE, fontFace: 'Arial', margin: 0
        });

        const beneficios = [
            {
                icono: '⏱️',
                titulo: 'Ahorro Radical de Tiempo',
                detalle: 'No tienes que ir físicamente a la biblioteca a adivinar si el libro está en estantería. En segundos sabes si está disponible y lo reservas de inmediato.'
            },
            {
                icono: '📅',
                titulo: 'Cero Multas y Organización',
                detalle: 'Desde "Mis Préstamos" supervisas tus fechas de vencimiento con estados claros (Prestado, Devuelto, Moroso), evitando sanciones por retrasos.'
            },
            {
                icono: '👓',
                titulo: 'Lectura Inclusiva y Cómoda',
                detalle: 'Si sufres de fatiga visual o dislexia, adaptas la interfaz al instante con tipografías especializadas, alto contraste o dictado por voz.'
            },
            {
                icono: '📚',
                titulo: 'Acceso Centralizado 24/7',
                detalle: 'Todo tu acervo académico, profesional y literario en una sola plataforma disponible las 24 horas desde cualquier computadora o teléfono.'
            }
        ];

        beneficios.forEach((b, idx) => {
            const posX = 0.8 + idx * 2.99;
            s5.addShape(pres.ShapeType.roundRect, {
                x: posX, y: 1.45, w: 2.78, h: 5.2,
                rectRadius: 0.15,
                fill: { color: C_CARD_BG },
                line: { color: C_CARD_BORDER, width: 1 }
            });

            s5.addText(b.icono, {
                x: posX + 0.2, y: 1.75, w: 2.38, h: 0.6,
                fontSize: 28, align: 'center', margin: 0
            });

            s5.addText(b.titulo, {
                x: posX + 0.2, y: 2.5, w: 2.38, h: 0.75,
                fontSize: 14.5, bold: true, color: C_WHITE, fontFace: 'Arial', align: 'center', margin: 0
            });

            s5.addText(b.detalle, {
                x: posX + 0.2, y: 3.4, w: 2.38, h: 2.9,
                fontSize: 11.5, color: C_TEXT_LIGHT, fontFace: 'Arial', margin: 0
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
            x: 0.8, y: 0.55, w: 11.5, h: 0.65,
            fontSize: 26, bold: true, color: C_WHITE, fontFace: 'Arial', margin: 0
        });

        // Contenedor principal
        s6.addShape(pres.ShapeType.roundRect, {
            x: 0.8, y: 1.4, w: 11.73, h: 3.8,
            rectRadius: 0.15,
            fill: { color: C_CARD_BG },
            line: { color: C_CYAN, width: 2 }
        });

        s6.addText('Síntesis de Propuesta de Valor', {
            x: 1.15, y: 1.65, w: 11.0, h: 0.4,
            fontSize: 17, bold: true, color: C_CYAN, fontFace: 'Arial', margin: 0
        });

        const puntos = [
            '• BookHub trasciende la biblioteca física tradicional, convirtiéndola en un servicio digital ágil, interactivo e inclusivo.',
            '• Resuelve los tres dolores principales del usuario: pérdida de tiempo en búsquedas manuales, falta de trazabilidad en préstamos y barreras de accesibilidad.',
            '• Ofrece a la institución una arquitectura sólida en Java Web MVC (Jakarta EE + Maven) que garantiza escalabilidad y facilidad de mantenimiento.',
            '• Es una plataforma humana y colaborativa: promueve la donación de libros, fomenta el hábito lector y no deja a nadie atrás gracias a sus herramientas de accesibilidad.'
        ];

        s6.addText(puntos.join('\n\n'), {
            x: 1.15, y: 2.25, w: 11.0, h: 2.7,
            fontSize: 12.5, color: C_TEXT_LIGHT, fontFace: 'Arial', margin: 0
        });

        // Banner inferior de llamado
        s6.addShape(pres.ShapeType.roundRect, {
            x: 0.8, y: 5.45, w: 11.73, h: 1.1,
            rectRadius: 0.1,
            fill: { color: C_PRIMARY }
        });

        s6.addText('BookHub: Más que una biblioteca, tu punto de encuentro con la lectura.', {
            x: 1.0, y: 5.8, w: 11.33, h: 0.4,
            fontSize: 14, bold: true, color: C_WHITE, fontFace: 'Arial', align: 'center', margin: 0
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
