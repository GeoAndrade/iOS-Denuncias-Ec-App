# DenunciasEcuador (SwiftUI + SwiftData)

## Objetivo académico
Aplicación iOS 17+ diseñada como laboratorio para documentar denuncias ciudadanas sin backend. El ejercicio cubre autenticación básica, persistencia local con SwiftData, formularios con validaciones contextualizadas y exploración de reportes públicos guardados localmente.

## Requisitos
- Xcode 15.4+ / iOS 17 SDK.
- Dispositivo o simulador iPhone con iOS 17.
- macOS con permisos para ejecutar SwiftData.

## Arquitectura
```
DenunciasEcuador/
├─ App/                  # Punto de entrada + RootView
├─ Data/Models/          # User y Report con SwiftData
├─ Data/Ecuador…         # Catálogo Provincia/Ciudad y seeder
├─ Features/
│  ├─ Auth/              # LoginView + AuthViewModel
│  ├─ Home/              # Formulario con resumen previo al guardado
│  ├─ Historico/         # Lista combinada (privadas propias + públicas)
│  └─ Components/        # Header, TabView, celdas reutilizables
├─ Services/             # SessionService con @AppStorage
├─ Utils/                # Validadores de correo/contraseña
└─ Resources/            # Assets del proyecto (Xcode Assets)
```

## Cómo ejecutar
1. Abrir `Denuncias Ec App.xcodeproj` en Xcode.
2. Seleccionar un simulador iPhone (iOS 17+) y compilar (`⌘+R`).
3. SwiftData usa almacenamiento on-device. Si necesitas restablecer los datos precargados, elimina la app del simulador y vuelve a ejecutar (el seeder crea 10 denuncias públicas de ejemplo automáticamente si la base está vacía).

## Guía de prueba (nuestro QA)
1. **Login/Registro**: ingresar correo y contraseña (≥6). Si el correo no existe se crea el usuario y se guarda la sesión mediante `@AppStorage("currentUserEmail")`.
2. **Persistencia de sesión**: cerrar la app y reabrir; debe aterrizar directamente en el `MainTabView` sin volver al login.
3. **Formulario**: en Home llenar título, descripción, fecha/hora, provincia y ciudad seleccionando del catálogo ecuatoriano (el campo de ciudad se habilita según la provincia). Los errores se muestran debajo de cada campo obligatorio.
4. **Resumen y guardado**: al pulsar “Guardar denuncia” se muestra una alerta nativa con el resumen (título, ubicación, fecha, visibilidad y tipo). Solo al confirmar se persiste el reporte y se limpia el formulario.
5. **Histórico combinado**: segunda pestaña lista las denuncias ordenadas desc; incluye todas las públicas (de cualquier usuario) y solo las privadas del usuario actual. Cada fila muestra correo del autor, ubicación “Provincia, Ciudad” y fecha en español.
6. **Cerrar sesión**: botón en el header → alerta de confirmación. Se limpia la sesión y se vuelve al login.

## Diseño y UX
- Tab bar con efecto “liquid glass” vía `.toolbarBackground(.ultraThinMaterial, for: .tabBar)`.
- Header en Home muestra saludo, correo seleccionable y botón de logout con alerta nativa.
- Formulario encapsulado en `ReportFormView` con campos etiquetados, pickers estilo cápsula centrados, validación por campo y resumen previo al guardado.
- Alertas nativas para logout y confirmación de denuncias, con fondos adaptativos (blanco en tema claro, negro en oscuro).
- Login describe la app, centra los campos y usa un botón compacto con ícono acorde análogo al de guardar denuncias.

## Limitaciones deliberadas
- Contraseñas guardadas en texto plano (solo académico, **no apto para producción**).
- No existe backend ni sincronización remota. Toda la data reside en SwiftData local (seed + entradas del usuario).
- Sin soporte para recuperación de cuentas ni políticas avanzadas de seguridad.

## Resultados esperados
Podemos validar el flujo Login → Home → Registrar denuncia (con resumen) → Histórico combinado para demostrar el dominio básico de SwiftUI, SwiftData, seeding condicional de datos y estados de sesión con `@AppStorage`.
