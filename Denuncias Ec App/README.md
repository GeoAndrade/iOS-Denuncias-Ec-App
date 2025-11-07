# DenunciasEcuador (SwiftUI + SwiftData)

## Objetivo académico
Aplicación iOS 17+ diseñada como laboratorio universitario para documentar denuncias ciudadanas sin backend. El ejercicio cubre autenticación básica, persistencia local con SwiftData y consulta segmentada de reportes públicos.

## Requisitos
- Xcode 15.4+ / iOS 17 SDK.
- Dispositivo o simulador iPhone con iOS 17.
- macOS con permisos para ejecutar SwiftData.

## Arquitectura ligera
```
DenunciasEcuador/
├─ App/                  # Punto de entrada + RootView
├─ Data/Models/          # User y Report con SwiftData
├─ Features/
│  ├─ Auth/              # LoginView + AuthViewModel
│  ├─ Home/              # Formulario, consulta pública y view models
│  ├─ Historico/         # Lista del usuario autenticado
│  └─ Components/        # Header, TabView, celdas reutilizables
├─ Services/             # SessionService con @AppStorage
├─ Utils/                # Validadores de correo/contraseña
└─ Resources/            # Assets del proyecto (Xcode Assets)
```

## Cómo correrla
1. Abrir `Denuncias Ec App.xcodeproj` en Xcode.
2. Seleccionar un simulador iPhone (iOS 17+) y compilar (`⌘+R`).
3. SwiftData usa almacenamiento on-device, no requiere configuraciones extra.

## Guía de prueba (QA estudiantil)
1. **Login/Registro**: ingresar correo y contraseña (≥6). Si el correo no existe se crea el usuario y se guarda la sesión mediante `@AppStorage("currentUserEmail")`.
2. **Persistencia de sesión**: cerrar la app y reabrir; debe aterrizar directamente en el `MainTabView` sin permitir volver al login.
3. **Crear denuncia**: en Home llenar título, descripción, fecha, ciudad, visibilidad y tipo; pulsar “Guardar denuncia”. Aparece confirmación y el histórico se actualiza.
4. **Denuncias públicas**: en la misma Home usar el selector `Último día | Última semana` para consultar todas las denuncias públicas de cualquier usuario.
5. **Histórico personal**: segunda pestaña del TabBar (“glass effect” con `.ultraThinMaterial`) lista todas las denuncias propias ordenadas desc.
6. **Cerrar sesión**: icono rojo en el header → confirmar. Se limpia la sesión y se vuelve al login.

## Diseño y UX
- Tab bar con efecto “liquid glass” vía `.toolbarBackground(.ultraThinMaterial, for: .tabBar)`.
- Header en Home muestra saludo y correo (texto seleccionable) + botón de logout con `confirmationDialog`.
- Formulario encapsulado en `ReportFormView` con validaciones mínimas y estados vacíos descriptivos.
- Consultas públicas gobernadas por `PublicReportsViewModel` con filtros por rango (último día/semana) usando `FetchDescriptor`.

## Limitaciones deliberadas
- Contraseñas guardadas en texto plano (solo con fines académicos, **no apto para producción**).
- No existe backend ni sincronización remota. Toda la data reside en SwiftData local.
- Sin soporte para recuperación de cuentas ni políticas avanzadas de seguridad.

## Resultados esperados
El estudiantado puede validar el flujo Login → Home → Registrar denuncia → Histórico, además de explorar los reportes públicos recientes, demostrando dominio básico de SwiftUI, SwiftData y estados de sesión con `@AppStorage`.
