# CONTEXTO FLUTTER — FitConnect
# Para Juan Carlos — Flutter + Riverpod + Dio
# Pegar este archivo ENTERO al inicio de cada conversación con Claude

---

## Qué es FitConnect
Plataforma de asesorías fitness online. Conecta entrenadores con clientes.
Proyecto DAM — IES Augustóbriga. Plazo: 1 mes.
Equipo: Alexander (backend Spring Boot), Antonio (frontend React), Juan Carlos (app Flutter Android).

---

## Tu stack
- Flutter + Riverpod (gestión de estado)
- Dio (peticiones HTTP)
- La API está en `http://10.0.2.2:8080` si usas emulador Android
- Si usas dispositivo físico en la misma red: `http://192.168.X.X:8080` (la IP de Alexander)

> ⚠️ En Android `localhost` no funciona para conectar con el PC. Usa `10.0.2.2` en el emulador.

---

## Lo más importante: autenticación con JWT

1. El usuario hace login → la API devuelve un **token**
2. Guardar ese token (con `flutter_secure_storage` o `shared_preferences`)
3. En TODAS las peticiones protegidas añadir el header:

```
Authorization: Bearer <token_aquí>
```

Sin ese header la API devuelve **403 Forbidden**.

### Ejemplo con Dio:

```dart
// Configuración base del cliente Dio
final dio = Dio(BaseOptions(
  baseUrl: 'http://10.0.2.2:8080',
  headers: {'Content-Type': 'application/json'},
));

// Añadir el token a todas las peticiones (interceptor)
dio.interceptors.add(InterceptorsWrapper(
  onRequest: (options, handler) {
    final token = ... // leer de storage
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  },
));
```

---

## Formato estándar de respuesta de la API

**Siempre** llega así — leer siempre el campo `data`:
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

## Roles de usuario

Hay 3 roles: `entrenador`, `cliente`, `admin`.
El rol llega en el login. La app mobile está pensada principalmente para **clientes**.

---

## Todos los endpoints disponibles

### AUTH (sin token)

#### POST `/api/auth/login`
```json
// Body:
{
  "email": "cliente1@fitconnect.com",
  "password": "password123"
}

// Respuesta data:
{
  "token": "eyJ...",
  "email": "cliente1@fitconnect.com",
  "nombre": "María López",
  "rol": "cliente",
  "id": 2
}
```

#### POST `/api/auth/register`
```json
// Body:
{
  "nombre": "Juan García",
  "email": "juan@gmail.com",
  "password": "123456",
  "rol": "cliente"
}
// Respuesta data: igual que login (devuelve token directamente)
```

#### GET `/api/auth/health`
Sin body. Devuelve texto: `FitConnect API funcionando`
Útil para comprobar que el servidor está vivo al arrancar la app.

---

### USUARIOS (requieren token)

#### GET `/api/usuarios/me`
Devuelve el perfil del usuario logueado.
```json
// Respuesta data:
{
  "id": 2,
  "email": "cliente1@fitconnect.com",
  "nombre": "María López",
  "rol": "cliente",
  "fechaRegistro": "2024-01-15T10:30:00",
  "altura": 1.65,
  "objetivo": "Perder peso",
  "fechaInicio": "2024-01-01",

  // Estos campos son null para clientes:
  "especialidad": null,
  "biografia": null,
  "valoracion": null
}
```

---

### EJERCICIOS (requieren token)

#### GET `/api/ejercicios`
Catálogo de ejercicios predefinidos.
```json
// Respuesta data:
[
  {
    "id": 1,
    "nombre": "Press de banca",
    "descripcion": "Ejercicio de pecho con barra",
    "gifUrl": "https://...",        // puede ser null
    "musculoObjetivo": "Pecho",
    "esPredefinido": true
  },
  {
    "id": 2,
    "nombre": "Sentadilla",
    "descripcion": "Ejercicio de piernas",
    "gifUrl": "https://...",
    "musculoObjetivo": "Piernas",
    "esPredefinido": true
  }
]
```

---

### RUTINAS (requieren token)

#### GET `/api/rutinas/mis-rutinas`
Las rutinas que el entrenador le ha asignado al cliente.
```json
// Respuesta data:
[
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
      },
      {
        "id": 2,
        "nombre": "Sentadilla",
        "musculoObjetivo": "Piernas",
        "gifUrl": null,
        "series": 4,
        "repeticiones": "10",
        "descanso": "90s",
        "diaSemana": "Miércoles"
      }
    ]
  }
]
```

Los días posibles para `diaSemana`: `Lunes`, `Martes`, `Miércoles`, `Jueves`, `Viernes`, `Sábado`, `Domingo`

---

### MÉTRICAS (requieren token)

#### POST `/api/metricas`
El cliente registra su peso y medidas del día.
```json
// Body:
{
  "fecha": "2026-05-03",       // formato YYYY-MM-DD
  "peso": 75.5,                // kg, puede ser null
  "medidaCintura": 82.0,       // cm, puede ser null
  "medidaCadera": 95.0,        // cm, puede ser null
  "notas": "Me noto mejor"     // puede ser null
}

// Respuesta data:
{
  "id": 1,
  "fecha": "2026-05-03",
  "peso": 75.5,
  "medidaCintura": 82.0,
  "medidaCadera": 95.0,
  "notas": "Me noto mejor"
}
```

#### GET `/api/metricas/mis-metricas`
Historial de métricas del cliente, ordenado de más reciente a más antiguo.
```json
// Respuesta data:
[
  { "id": 3, "fecha": "2026-05-03", "peso": 75.5, "medidaCintura": 82.0, "medidaCadera": 95.0, "notas": "Me noto mejor" },
  { "id": 2, "fecha": "2026-04-20", "peso": 76.2, "medidaCintura": 83.0, "medidaCadera": 95.5, "notas": null },
  { "id": 1, "fecha": "2026-04-01", "peso": 77.0, "medidaCintura": 84.0, "medidaCadera": 96.0, "notas": "Inicio" }
]
```
> Este array es perfecto para una gráfica de progreso de peso con `fl_chart`.

---

## Usuarios de prueba (contraseña: `password123`)

| Email | Rol |
|-------|-----|
| entrenador@fitconnect.com | entrenador |
| cliente1@fitconnect.com | cliente |
| cliente2@fitconnect.com | cliente |

---

## Ejemplo completo de llamadas con Dio

```dart
// ---- MODELOS ----

class AuthResponse {
  final String token;
  final String email;
  final String nombre;
  final String rol;
  final int id;

  AuthResponse.fromJson(Map<String, dynamic> json)
      : token = json['token'],
        email = json['email'],
        nombre = json['nombre'],
        rol = json['rol'],
        id = json['id'];
}

class MetricaResponse {
  final int id;
  final String fecha;
  final double? peso;
  final double? medidaCintura;
  final double? medidaCadera;
  final String? notas;

  MetricaResponse.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        fecha = json['fecha'],
        peso = json['peso']?.toDouble(),
        medidaCintura = json['medidaCintura']?.toDouble(),
        medidaCadera = json['medidaCadera']?.toDouble(),
        notas = json['notas'];
}

// ---- LLAMADAS ----

// Login
Future<AuthResponse> login(String email, String password) async {
  final res = await dio.post('/api/auth/login', data: {
    'email': email,
    'password': password,
  });
  return AuthResponse.fromJson(res.data['data']);
}

// Mis rutinas
Future<List<dynamic>> getMisRutinas() async {
  final res = await dio.get('/api/rutinas/mis-rutinas');
  return res.data['data'] as List;
}

// Registrar métrica
Future<void> registrarMetrica(double peso, String fecha) async {
  await dio.post('/api/metricas', data: {
    'fecha': fecha,
    'peso': peso,
  });
}

// Mis métricas
Future<List<MetricaResponse>> getMisMetricas() async {
  final res = await dio.get('/api/metricas/mis-metricas');
  return (res.data['data'] as List)
      .map((e) => MetricaResponse.fromJson(e))
      .toList();
}
```

---

## Pantallas que necesita la app (sugerencia)

| Pantalla | Endpoints que usa |
|----------|------------------|
| Login | POST /auth/login |
| Registro | POST /auth/register |
| Mi perfil | GET /usuarios/me |
| Mis rutinas | GET /rutinas/mis-rutinas |
| Detalle rutina | (datos del GET anterior, filtrar por día) |
| Catálogo ejercicios | GET /ejercicios |
| Registrar peso hoy | POST /metricas |
| Gráfica progreso | GET /metricas/mis-metricas |

---

## Lo que el backend NO tiene aún (no intentes llamarlo)

- Editar perfil (PUT /api/usuarios/me) — en desarrollo
- Suscribirse a un entrenador — en desarrollo
- Plan de alimentación — en desarrollo
- Chat — en desarrollo

---

*Backend hecho por Alexander — repo: https://github.com/jandrobalboa-eng/FitConect*
*La API corre en el puerto 8080 del PC de Alexander*
