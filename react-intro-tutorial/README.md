# Proyecto Educativo: React.js Frontend

Aplicación frontend React para aprender los fundamentos del desarrollo front-end consumiendo una API REST en Flask.

## 📚 Documentación Educativa

Lee el documento completo **"Fundamentos de Front End con React.js.md"** para una guía detallada de todos los conceptos de React utilizados en este proyecto.

## 🎯 Objetivo

Este proyecto está diseñado para enseñar:
- Fundamentos de React.js (componentes, hooks, estado, props)
- Consumo de APIs REST
- Manejo de formularios
- Estilizado con Tailwind CSS
- Mejores prácticas de desarrollo front-end

## 🏗️ Estructura del Proyecto

```
.
├── Fundamentos de Front End con React.js.md  # 📖 GUÍA EDUCATIVA COMPLETA
└── frontend/                                 # Aplicación React
    ├── src/
    │   ├── App.jsx                          # Componente principal
    │   ├── components/                      # Componentes reutilizables
    │   └── services/                        # Servicios de API
    └── package.json
```

## 🚀 Instalación y Ejecución

### Prerequisito: Backend (Flask API)

Asegúrate de que tu API Flask esté corriendo en `http://localhost:8000`

```bash
python app.py
```

### Frontend (React)

1. **Navegar a la carpeta frontend:**
```bash
cd frontend
```

2. **Instalar dependencias:**
```bash
npm install
```

3. **Iniciar el servidor de desarrollo:**
```bash
npm run dev
```

La aplicación estará disponible en `http://localhost:3000`

## 🎓 Conceptos de React Cubiertos

### Fundamentos
- ✅ Componentes funcionales
- ✅ JSX
- ✅ Props
- ✅ Estado (useState)
- ✅ Efectos (useEffect)
- ✅ Manejo de eventos

### Patrones
- ✅ Lifting state up
- ✅ Composición de componentes
- ✅ Renderizado condicional
- ✅ Listas y keys

### Integración
- ✅ Fetch API
- ✅ Async/Await
- ✅ Manejo de errores
- ✅ Loading states

### Estilos
- ✅ Tailwind CSS
- ✅ Responsive design
- ✅ Accesibilidad

## 📋 Funcionalidades

- ✨ **Crear** nuevos usuarios
- 📖 **Listar** todos los usuarios
- ✏️ **Editar** usuarios existentes
- 🗑️ **Eliminar** usuarios
- 🎨 Interfaz moderna y accesible con Tailwind CSS
- 📱 Diseño responsive
- ⚡ Actualizaciones en tiempo real

## 🛠️ Tecnologías

### Frontend
- React 18
- Vite
- Tailwind CSS
- JavaScript ES6+

### Backend (Prerequisito)
- Tu API Flask en puerto 8000

## 📖 Endpoints de la API (Backend Flask)

Tu API Flask debe tener estos endpoints disponibles:

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | `/api/users` | Obtener todos los usuarios |
| GET | `/api/users/<id>` | Obtener un usuario específico |
| POST | `/api/users` | Crear un nuevo usuario |
| PUT | `/api/users/<id>` | Actualizar un usuario |
| DELETE | `/api/users/<id>` | Eliminar un usuario |

## 🎯 Ejercicios Propuestos

Para practicar y mejorar tus habilidades:

1. Agregar validación de formularios
2. Implementar búsqueda de usuarios
3. Añadir paginación
4. Crear un sistema de notificaciones
5. Implementar modo oscuro
6. Agregar más campos al usuario (teléfono, dirección, etc.)

## 📚 Recursos de Aprendizaje

- [Documentación oficial de React](https://react.dev)
- [Guía de Tailwind CSS](https://tailwindcss.com/docs)
- [MDN Web Docs - Fetch API](https://developer.mozilla.org/es/docs/Web/API/Fetch_API)

## 🤝 Contribuciones

Este es un proyecto educativo. Siéntete libre de:
- Hacer fork del proyecto
- Experimentar con el código
- Agregar nuevas funcionalidades
- Mejorar la documentación

## 📝 Notas

- Este es un proyecto frontend que consume tu API Flask existente.
- Asegúrate de que tu API Flask tenga CORS habilitado.
- El proxy de Vite redirige `/api` a `http://localhost:8000`.

## 🎓 Nivel

**Junior Front-End Developer**

Este proyecto cubre todos los conceptos fundamentales que un desarrollador front-end junior debe conocer para trabajar con React.js.

---

**¡Feliz aprendizaje! 🚀**
