# CONTEXTO FRONTEND — FitConnect
# Para Antonio — React 18 + Vite
# Pegar este archivo ENTERO al inicio de cada conversación con Claude

---

## Qué es FitConnect
Plataforma de asesorías fitness online. Conecta entrenadores con clientes.
Proyecto DAM — IES Augustóbriga. Plazo: 1 mes.
Equipo: Alexander (backend), Antonio (frontend React), Juan Carlos (Flutter Android).

---

## Tu stack
- React 18 + Vite
- Recharts (para gráficas de métricas)
- La API está en `http://localhost:8080`

---

## Lo más importante: cómo funciona la autenticación

1. El usuario hace login → la API devuelve un **JWT token**
2. Ese token hay que guardarlo (en `localStorage` o contexto)
3. En TODAS las peticiones protegidas hay que enviar ese token en el header:

```
Authorization: Bearer <token_aquí>
```

Sin ese header, la API devuelve **403 Forbidden**.

---

## Formato estándar de respuesta de la API

**Siempre** llega así:
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

Siempre leer `data` para obtener los datos reales.

---

## Roles de usuario

Hay 3 roles: `entrenador`, `cliente`, `admin`.
El rol llega en la respuesta del login. Úsalo para mostrar distintas vistas.

---

## Todos los endpoints disponibles

### AUTH (sin token)

#### POST `/api/auth/register`
```json
// Body:
{
  "nombre": "Antonio García",
  "email": "antonio@gmail.com",
  "password": "123456",
  "rol": "cliente"        // "cliente" | "entrenador" | "admin"
}

// Respuesta data:
{
  "token": "eyJ...",
  "email": "antonio@gmail.com",
  "nombre": "Antonio García",
  "rol": "cliente",
  "id": 5
}
```

#### POST `/api/auth/login`
```json
// Body:
{
  "email": "entrenador@fitconnect.com",
  "password": "password123"
}

// Respuesta data:
{
  "token": "eyJ...",
  "email": "entrenador@fitconnect.com",
  "nombre": "Carlos Ruiz",
  "rol": "entrenador",
  "id": 1
}
```

---

### USUARIOS (requieren token)

#### GET `/api/usuarios/me`
Devuelve el perfil del usuario logueado.
```json
// Respuesta data:
{
  "id": 1,
  "email": "entrenador@fitconnect.com",
  "nombre": "Carlos Ruiz",
  "rol": "entrenador",
  "fechaRegistro": "2024-01-15T10:30:00",

  // Solo si es entrenador:
  "especialidad": "Fuerza y musculación",
  "biografia": "10 años de experiencia...",
  "valoracion": 4.8,

  // Solo si es cliente:
  "altura": 1.75,
  "objetivo": "Perder peso",
  "fechaInicio": "2024-01-01"
}
```

#### GET `/api/usuarios/clientes`
Solo para entrenadores. Devuelve sus clientes con suscripción activa.
```json
// Respuesta data: array de UsuarioResponse (mismo formato que /me)
[
  { "id": 2, "nombre": "María López", "rol": "cliente", ... },
  { "id": 3, "nombre": "Pedro Sánchez", "rol": "cliente", ... }
]
```

---

### EJERCICIOS (requieren token)

#### GET `/api/ejercicios`
Catálogo de ejercicios.
- Si es **entrenador**: ve los predefinidos + los que él creó
- Si es **cliente**: solo los predefinidos
```json
// Respuesta data:
[
  {
    "id": 1,
    "nombre": "Press de banca",
    "descripcion": "Ejercicio de pecho con barra",
    "gifUrl": "https://...",
    "musculoObjetivo": "Pecho",
    "esPredefinido": true
  }
]
```

---

### RUTINAS (requieren token)

#### POST `/api/rutinas`
Solo entrenadores. Crea una rutina y la asigna a un cliente.
```json
// Body:
{
  "clienteId": 2,
  "nombre": "Rutina fuerza semana 1",
  "descripcion": "Enfocada en tren superior",
  "ejercicios": [
    {
      "ejercicioId": 1,
      "series": 3,
      "repeticiones": "12",
      "descanso": "60s",
      "diaSemana": "Lunes"    // Lunes|Martes|Miércoles|Jueves|Viernes|Sábado|Domingo
    }
  ]
}

// Respuesta data:
{
  "id": 1,
  "nombre": "Rutina fuerza semana 1",
  "descripcion": "Enfocada en tren superior",
  "fechaAsignacion": "2026-05-03",
  "entrenadorNombre": "Carlos Ruiz",
  "clienteNombre": "María López",
  "ejercicios": [
    {
      "id": 1,
      "nombre": "Press de banca",
      "musculoObjetivo": "Pecho",
      "gifUrl": "https://...",
      "series": 3,
      "repeticiones": "12",
      "descanso": "60s",
      "diaSemana": "Lunes"
    }
  ]
}
```

#### GET `/api/rutinas/mis-rutinas`
Para clientes. Devuelve todas sus rutinas asignadas.
```json
// Respuesta data: array de RutinaResponse (mismo formato que el POST)
[
  { "id": 1, "nombre": "Rutina fuerza semana 1", ... }
]
```

---

### MÉTRICAS (requieren token)

#### POST `/api/metricas`
Para clientes. Registra peso y medidas corporales.
```json
// Body:
{
  "fecha": "2026-05-03",
  "peso": 75.5,
  "medidaCintura": 82.0,
  "medidaCadera": 95.0,
  "notas": "Me noto con más energía"
}

// Respuesta data:
{
  "id": 1,
  "fecha": "2026-05-03",
  "peso": 75.5,
  "medidaCintura": 82.0,
  "medidaCadera": 95.0,
  "notas": "Me noto con más energía"
}
```

#### GET `/api/metricas/mis-metricas`
Para clientes. Devuelve su historial ordenado de más reciente a más antiguo.
```json
// Respuesta data: array de MetricaResponse
[
  { "id": 3, "fecha": "2026-05-03", "peso": 75.5, ... },
  { "id": 2, "fecha": "2026-04-20", "peso": 76.2, ... },
  { "id": 1, "fecha": "2026-04-01", "peso": 77.0, ... }
]
```
> Este array es perfecto para alimentar una gráfica de Recharts con el peso a lo largo del tiempo.

---

## Usuarios de prueba (contraseña: `password123`)

| Email | Rol |
|-------|-----|
| entrenador@fitconnect.com | entrenador |
| cliente1@fitconnect.com | cliente |
| cliente2@fitconnect.com | cliente |
| admin@fitconnect.com | admin |

---

## Ejemplo de llamada con fetch (JavaScript)

```js
// Login
const res = await fetch('http://localhost:8080/api/auth/login', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ email: 'entrenador@fitconnect.com', password: 'password123' })
});
const json = await res.json();
const token = json.data.token;
localStorage.setItem('token', token);

// Petición protegida
const token = localStorage.getItem('token');
const perfil = await fetch('http://localhost:8080/api/usuarios/me', {
  headers: { 'Authorization': `Bearer ${token}` }
});
const data = await perfil.json();
console.log(data.data); // aquí están los datos del usuario
```

---

## Pantallas que necesita el frontend (sugerencia)

| Pantalla | Rol | Endpoints que usa |
|----------|-----|------------------|
| Login / Registro | Todos | POST /auth/login, POST /auth/register |
| Dashboard entrenador | Entrenador | GET /usuarios/me, GET /usuarios/clientes |
| Crear rutina | Entrenador | GET /ejercicios, POST /rutinas |
| Dashboard cliente | Cliente | GET /usuarios/me, GET /rutinas/mis-rutinas |
| Gráfica progreso | Cliente | GET /metricas/mis-metricas (Recharts LineChart) |
| Registrar métricas | Cliente | POST /metricas |
| Catálogo ejercicios | Todos | GET /ejercicios |

---

## Lo que el backend NO tiene aún (no intentes llamarlo)

- Suscripciones (vincular cliente con entrenador)
- Editar perfil (PUT /api/usuarios/me)
- Plan de alimentación
- Chat / Mensajería

---

*Backend hecho por Alexander — rama main en GitHub: https://github.com/jandrobalboa-eng/FitConect*
