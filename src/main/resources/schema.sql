-- ============================================================
-- FitConnect - Script SQL completo
-- Ejecutar en MySQL Workbench antes de arrancar el backend
-- ============================================================

CREATE DATABASE IF NOT EXISTS fitness_app
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE fitness_app;

-- ============================================================
-- USUARIOS (clientes, entrenadores y admins en una sola tabla)
-- ============================================================
CREATE TABLE IF NOT EXISTS User (
    id               INT AUTO_INCREMENT PRIMARY KEY,
    email            VARCHAR(255) UNIQUE NOT NULL,
    password_hash    VARCHAR(255) NOT NULL,
    nombre           VARCHAR(100) NOT NULL,
    fecha_registro   DATETIME DEFAULT CURRENT_TIMESTAMP,
    rol              ENUM('cliente', 'entrenador', 'admin') NOT NULL,
    -- Campos de cliente
    altura           DECIMAL(5,2),
    objetivo         TEXT,
    fecha_inicio     DATE,
    -- Campos de entrenador
    especialidad     VARCHAR(100),
    biografia        TEXT,
    valoracion       DECIMAL(3,2)
);

-- ============================================================
-- SUSCRIPCIONES
-- ============================================================
CREATE TABLE IF NOT EXISTS Suscripcion (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id      INT NOT NULL,
    entrenador_id   INT NOT NULL,
    fecha_inicio    DATE NOT NULL,
    fecha_fin       DATE NOT NULL,
    estado          ENUM('Activa', 'Cancelada', 'Expirada') NOT NULL DEFAULT 'Activa',
    tipo_pago       ENUM('Mensual', 'Anual') NOT NULL,
    FOREIGN KEY (cliente_id)    REFERENCES User(id) ON DELETE CASCADE,
    FOREIGN KEY (entrenador_id) REFERENCES User(id) ON DELETE CASCADE
);

-- ============================================================
-- EJERCICIOS
-- ============================================================
CREATE TABLE IF NOT EXISTS Ejercicio (
    id               INT AUTO_INCREMENT PRIMARY KEY,
    nombre           VARCHAR(255) NOT NULL,
    descripcion      TEXT,
    gif_url          VARCHAR(500),
    musculo_objetivo VARCHAR(100),
    es_predefinido   BOOLEAN DEFAULT TRUE,
    creado_por       INT,
    FOREIGN KEY (creado_por) REFERENCES User(id) ON DELETE SET NULL
);

-- ============================================================
-- RUTINAS
-- ============================================================
CREATE TABLE IF NOT EXISTS Rutina (
    id               INT AUTO_INCREMENT PRIMARY KEY,
    entrenador_id    INT NOT NULL,
    cliente_id       INT NOT NULL,
    nombre           VARCHAR(255) NOT NULL,
    descripcion      TEXT,
    fecha_asignacion DATE NOT NULL,
    FOREIGN KEY (entrenador_id) REFERENCES User(id) ON DELETE CASCADE,
    FOREIGN KEY (cliente_id)    REFERENCES User(id) ON DELETE CASCADE
);

-- ============================================================
-- RUTINA-EJERCICIO (tabla intermedia muchos a muchos)
-- ============================================================
CREATE TABLE IF NOT EXISTS RutinaEjercicio (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    rutina_id    INT NOT NULL,
    ejercicio_id INT NOT NULL,
    series       INT,
    repeticiones VARCHAR(50),
    descanso     VARCHAR(20),
    dia_semana   ENUM('Lunes','Martes','Miércoles','Jueves','Viernes','Sábado','Domingo'),
    FOREIGN KEY (rutina_id)    REFERENCES Rutina(id)   ON DELETE CASCADE,
    FOREIGN KEY (ejercicio_id) REFERENCES Ejercicio(id) ON DELETE CASCADE
);

-- ============================================================
-- PLANES DE ALIMENTACION
-- ============================================================
CREATE TABLE IF NOT EXISTS PlanAlimentacion (
    id               INT AUTO_INCREMENT PRIMARY KEY,
    entrenador_id    INT NOT NULL,
    cliente_id       INT NOT NULL,
    nombre           VARCHAR(255) NOT NULL,
    descripcion      TEXT,
    contenido        JSON,
    fecha_asignacion DATE NOT NULL,
    FOREIGN KEY (entrenador_id) REFERENCES User(id) ON DELETE CASCADE,
    FOREIGN KEY (cliente_id)    REFERENCES User(id) ON DELETE CASCADE
);

-- ============================================================
-- METRICAS CORPORALES
-- ============================================================
CREATE TABLE IF NOT EXISTS MetricaCorporal (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id     INT NOT NULL,
    fecha          DATE NOT NULL,
    peso           DECIMAL(5,2),
    medida_cintura DECIMAL(5,2),
    medida_cadera  DECIMAL(5,2),
    notas          TEXT,
    FOREIGN KEY (cliente_id) REFERENCES User(id) ON DELETE CASCADE
);

-- ============================================================
-- CONVERSACIONES (1 por par cliente-entrenador)
-- ============================================================
CREATE TABLE IF NOT EXISTS Conversacion (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id    INT NOT NULL,
    entrenador_id INT NOT NULL,
    UNIQUE KEY uq_conversacion (cliente_id, entrenador_id),
    FOREIGN KEY (cliente_id)    REFERENCES User(id) ON DELETE CASCADE,
    FOREIGN KEY (entrenador_id) REFERENCES User(id) ON DELETE CASCADE
);

-- ============================================================
-- MENSAJES
-- ============================================================
CREATE TABLE IF NOT EXISTS Mensaje (
    id               INT AUTO_INCREMENT PRIMARY KEY,
    conversacion_id  INT NOT NULL,
    remitente_id     INT NOT NULL,
    contenido        TEXT,
    tipo             ENUM('texto', 'video') NOT NULL DEFAULT 'texto',
    url_archivo      VARCHAR(500),
    fecha_envio      DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (conversacion_id) REFERENCES Conversacion(id) ON DELETE CASCADE,
    FOREIGN KEY (remitente_id)    REFERENCES User(id) ON DELETE CASCADE
);

-- ============================================================
-- DATOS DE PRUEBA (seed)
-- Contraseña de todos: "password123" (ya hasheada con BCrypt)
-- ============================================================

INSERT INTO User (email, password_hash, nombre, rol, especialidad, biografia) VALUES
('entrenador@fitconnect.com',
 '$2a$10$N.zmdr9zkPElP9sTGHuJMuBqDxbX4P0yzSo5kGkuFOMb1nHRoFtxK',
 'Carlos López', 'entrenador', 'Fuerza y musculación',
 'Entrenador certificado con 5 años de experiencia');

INSERT INTO User (email, password_hash, nombre, rol, altura, objetivo) VALUES
('cliente1@fitconnect.com',
 '$2a$10$N.zmdr9zkPElP9sTGHuJMuBqDxbX4P0yzSo5kGkuFOMb1nHRoFtxK',
 'Juan García', 'cliente', 1.78, 'Ganar músculo');

INSERT INTO User (email, password_hash, nombre, rol, altura, objetivo) VALUES
('cliente2@fitconnect.com',
 '$2a$10$N.zmdr9zkPElP9sTGHuJMuBqDxbX4P0yzSo5kGkuFOMb1nHRoFtxK',
 'María Pérez', 'cliente', 1.65, 'Perder grasa');

INSERT INTO User (email, password_hash, nombre, rol) VALUES
('admin@fitconnect.com',
 '$2a$10$N.zmdr9zkPElP9sTGHuJMuBqDxbX4P0yzSo5kGkuFOMb1nHRoFtxK',
 'Admin FitConnect', 'admin');

INSERT INTO Ejercicio (nombre, descripcion, musculo_objetivo, es_predefinido) VALUES
('Press banca', 'Tumbado en banco, bajar barra al pecho y subir', 'Pecho', TRUE),
('Sentadilla', 'Pies a la anchura de hombros, bajar hasta paralelo', 'Piernas', TRUE),
('Peso muerto', 'Barra en el suelo, subir manteniendo espalda recta', 'Espalda baja', TRUE),
('Pull over', 'Tumbado, bajar mancuerna por detrás de la cabeza', 'Espalda', TRUE),
('Curl de bíceps', 'De pie, subir mancuernas alternando brazos', 'Bíceps', TRUE),
('Press militar', 'De pie o sentado, empujar barra por encima de la cabeza', 'Hombros', TRUE);
