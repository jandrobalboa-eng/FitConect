# CONTEXTO_CLAUDE.md
# FitConnect — Contexto del proyecto para Claude
# Pegar este archivo ENTERO al inicio de cada conversación nueva con Claude

---

## ¿Qué es FitConnect?
Plataforma de asesorías fitness online. Conecta entrenadores personales con sus clientes.
Proyecto final de ciclo DAM (Desarrollo de Aplicaciones Multiplataforma) — IES Augustóbriga.
Equipo: Alexander Ugarte, Antonio Núñez, Juan Carlos Huete.
Plazo: 1 mes.

---

## Stack tecnológico

| Capa | Tecnología |
|------|-----------|
| Backend | Java 21 + Spring Boot 3.2 + Spring Security + JWT (jjwt 0.12) |
| Base de datos | MySQL 8.0 |
| ORM | Spring Data JPA / Hibernate |
| Frontend web | React 18 + Vite + Recharts |
| App móvil | Flutter + Riverpod + Dio |
| Control de versiones | Git + GitHub |
| Diseño | Figma |

---

## Arquitectura

```
[React Web App :3000]  ──┐
                          ├──► [Spring Boot API REST :8080] ──► [MySQL :3306]
[Flutter App Android]  ──┘
```

Toda la comunicación es REST + JSON. Autenticación con JWT Bearer token en el header `Authorization`.

---

## Estructura de paquetes del backend

```
com.fitconnect/
├── FitConnectApplication.java       ← Arranque principal
├── config/
│   └── SecurityConfig.java          ← CORS, rutas públicas, Spring Security
├── controller/
│   └── AuthController.java          ← /api/auth/register y /api/auth/login
├── dto/
│   ├── request/
│   │   ├── LoginRequest.java
│   │   └── RegisterRequest.java
│   └── response/
│       ├── ApiResponse.java          ← Wrapper genérico { success, message, data }
│       └── AuthResponse.java
├── entity/
│   ├── User.java                    ← Un solo User con enum Rol (cliente/entrenador/admin)
│   ├── Rutina.java
│   ├── Ejercicio.java
│   ├── RutinaEjercicio.java         ← Tabla intermedia Rutina ↔ Ejercicio
│   └── Entities.java                ← MetricaCorporal, Suscripcion, PlanAlimentacion,
│                                       Conversacion, Mensaje
├── exception/
│   └── GlobalExceptionHandler.java  ← Manejo centralizado de errores
├── repository/
│   └── Repositories.java            ← JPA repos: UserRepository, RutinaRepository...
├── security/
│   ├── JwtService.java              ← Generar y validar tokens JWT
│   └── JwtAuthFilter.java           ← Filtro que lee el header Authorization
└── service/
    └── AuthService.java             ← Lógica de registro y login
```

---

## Modelo de datos (resumen de tablas MySQL)

| Tabla | Descripción |
|-------|-------------|
| `User` | Todos los usuarios. Campo `rol`: cliente / entrenador / admin |
| `Suscripcion` | Relación cliente ↔ entrenador. Estados: Activa / Cancelada / Expirada |
| `Ejercicio` | Catálogo de ejercicios. `es_predefinido=TRUE` si lo creó admin |
| `Rutina` | Rutina asignada por entrenador a cliente |
| `RutinaEjercicio` | Ejercicios dentro de una rutina (series, reps, día) |
| `PlanAlimentacion` | Plan de dieta asignado por entrenador a cliente (campo JSON) |
| `MetricaCorporal` | Registros de peso y medidas del cliente por fecha |
| `Conversacion` | 1 conversación por par cliente-entrenador |
| `Mensaje` | Mensajes dentro de una conversación (texto o video) |

---

## Formato estándar de respuesta de la API

```json
{
  "success": true,
  "message": "OK",
  "data": { ... }
}
```

En caso de error:
```json
{
  "success": false,
  "message": "Descripción del error",
  "data": null
}
```

---

## Endpoints implementados hasta ahora

| Método | Ruta | Auth | Descripción |
|--------|------|------|-------------|
| POST | `/api/auth/register` | No | Registrar usuario nuevo |
| POST | `/api/auth/login` | No | Login, devuelve JWT |
| GET | `/api/auth/health` | No | Comprueba que el servidor está vivo |

**Cómo usar el token en Postman:**
- Header: `Authorization: Bearer <token_aquí>`

---

## Datos de prueba (seed en schema.sql)
Contraseña de todos los usuarios de prueba: **password123**

| Email | Rol |
|-------|-----|
| entrenador@fitconnect.com | entrenador |
| cliente1@fitconnect.com | cliente |
| cliente2@fitconnect.com | cliente |
| admin@fitconnect.com | admin |

---

## Reglas de código que seguimos

1. Todos los endpoints devuelven `ApiResponse<T>` — nunca el objeto directo.
2. Validaciones con `@Valid` en los request bodies.
3. Errores controlados en `GlobalExceptionHandler` — no try/catch en los controllers.
4. Nombres en español para entidades y campos (igual que en la BD).
5. Lombok en todas las entidades y servicios.
6. `FetchType.LAZY` en todas las relaciones para evitar N+1.

---

## Convenciones Git

- Rama principal: `main` (solo código estable)
- Rama de desarrollo: `develop`
- Ramas de feature: `feature/nombre-de-la-feature`
- Ejemplo: `feature/rutinas-crud`, `feature/chat-mensajes`
- Nunca pushear directamente a `main`

---

## Responsabilidades del equipo

| Persona | Área |
|---------|------|
| Alexander | Backend (Spring Boot, API REST, seguridad, despliegue) |
| Antonio | BD (MySQL, queries) + Frontend web (React) |
| Juan Carlos | App móvil (Flutter, Android) |

---

## Próximos endpoints a implementar (siguiente prioridad)

1. `GET /api/usuarios/me` — perfil del usuario autenticado
2. `GET /api/usuarios/clientes` — lista de clientes del entrenador
3. `POST /api/rutinas` — crear rutina
4. `GET /api/rutinas/mis-rutinas` — rutinas del cliente autenticado
5. `GET /api/ejercicios` — catálogo de ejercicios
6. `POST /api/metricas` — registrar métrica corporal
7. `GET /api/metricas/mis-metricas` — métricas del cliente

---
*Última actualización: Semana 1 — Backend base implementado*
