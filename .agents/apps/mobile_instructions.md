---
name: mobile_instructions
description: Reglas y contexto tecnológico específico para el desarrollo de la App Móvil (CalculaPe)
---

# Instrucciones de la Aplicación: mobile

## 1. Jerarquía de Conocimiento
Al desarrollar en esta aplicación, obedeces la siguiente jerarquía:
1. Reglas globales (`AGENTS.md`)
2. Estas instrucciones (`mobile_instructions.md`)
3. Archivos de solución históricos (`/.agents/knowledge/solutions/`)

## 2. Stack Tecnológico
* **Framework:** React Native con Expo (Development Build / Expo Go para desarrollo rápido MVP).
* **Lenguaje:** TypeScript estricto.
* **Enrutamiento:** Expo Router (File-based routing).
* **UI/Estilos:** React Native Paper (Material Design).
* **Estado:** Zustand (si es necesario para estado global).
* **Almacenamiento Local:** `expo-sqlite`.

## 3. Patrones y Reglas Arquitectónicas
* **Offline-First:** Toda escritura o lectura primaria debe hacerse sobre `expo-sqlite`. La sincronización con Supabase (backend) ocurre en un proceso separado (Delta Sync).
* **Procesamiento Híbrido:** El escaneo debe priorizar la lectura rápida por QR (Parser SUNAT). El OCR de visión computacional es exclusivamente un fallback de segunda opción.
* **Manejo de Imágenes:** Siempre comprimir la imagen en el cliente antes de interactuar con Supabase Storage para optimizar ancho de banda y almacenamiento (Límite de tamaño: ~300KB).

## 4. Estructura de Directorios (Propuesta)
```text
/mobile
  /app           # Rutas de Expo Router
  /components    # Componentes UI reutilizables
  /core
    /database    # Lógica de SQLite local
    /sync        # Motor de sincronización (Delta Sync) con Supabase
    /parsers     # Lógica de extracción (Factory Pattern para QR)
  /services      # Clientes HTTP, Integraciones (IA, FCM)
  /store         # Zustand stores
```
