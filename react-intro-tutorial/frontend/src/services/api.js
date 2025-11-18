// Configuración base de la API
const API_BASE_URL = '/api'

// Función auxiliar para manejar respuestas HTTP
const handleResponse = async (response) => {
  if (!response.ok) {
    const error = await response.json()
    throw new Error(error.error || 'Error en la petición')
  }
  return response.json()
}

// GET: Obtener todos los usuarios
export const getUsers = async () => {
  const response = await fetch(`${API_BASE_URL}/users`)
  return handleResponse(response)
}

// GET: Obtener un usuario por ID
export const getUser = async (id) => {
  const response = await fetch(`${API_BASE_URL}/users/${id}`)
  return handleResponse(response)
}

// POST: Crear un nuevo usuario
export const createUser = async (userData) => {
  const response = await fetch(`${API_BASE_URL}/users`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(userData),
  })
  return handleResponse(response)
}

// PUT: Actualizar un usuario existente
export const updateUser = async (id, userData) => {
  const response = await fetch(`${API_BASE_URL}/users/${id}`, {
    method: 'PUT',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(userData),
  })
  return handleResponse(response)
}

// DELETE: Eliminar un usuario
export const deleteUser = async (id) => {
  const response = await fetch(`${API_BASE_URL}/users/${id}`, {
    method: 'DELETE',
  })
  return handleResponse(response)
}
