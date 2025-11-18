import { useState, useEffect } from 'react'
import UserList from './components/UserList'
import UserForm from './components/UserForm'
import { getUsers, createUser, updateUser, deleteUser } from './services/api'

function App() {
  // Estado para almacenar la lista de usuarios
  const [users, setUsers] = useState([])
  
  // Estado para controlar la carga de datos
  const [loading, setLoading] = useState(true)
  
  // Estado para manejar errores
  const [error, setError] = useState(null)
  
  // Estado para el usuario que se está editando
  const [editingUser, setEditingUser] = useState(null)

  // useEffect: Hook que se ejecuta cuando el componente se monta
  // El array vacío [] significa que solo se ejecuta una vez al inicio
  useEffect(() => {
    fetchUsers()
  }, [])

  // Función para obtener todos los usuarios
  const fetchUsers = async () => {
    try {
      setLoading(true)
      setError(null)
      const data = await getUsers()
      setUsers(data)
    } catch (err) {
      setError('Error al cargar los usuarios')
      console.error(err)
    } finally {
      setLoading(false)
    }
  }

  // Función para crear o actualizar un usuario
  const handleSaveUser = async (userData) => {
    try {
      if (editingUser) {
        // Actualizar usuario existente
        await updateUser(editingUser.id, userData)
      } else {
        // Crear nuevo usuario
        await createUser(userData)
      }
      
      // Recargar la lista de usuarios
      await fetchUsers()
      
      // Limpiar el formulario
      setEditingUser(null)
    } catch (err) {
      setError('Error al guardar el usuario')
      console.error(err)
    }
  }

  // Función para eliminar un usuario
  const handleDeleteUser = async (userId) => {
    if (window.confirm('¿Estás seguro de eliminar este usuario?')) {
      try {
        await deleteUser(userId)
        await fetchUsers()
      } catch (err) {
        setError('Error al eliminar el usuario')
        console.error(err)
      }
    }
  }

  // Función para preparar la edición de un usuario
  const handleEditUser = (user) => {
    setEditingUser(user)
  }

  // Función para cancelar la edición
  const handleCancelEdit = () => {
    setEditingUser(null)
  }

  return (
    <div className="flex flex-col min-h-screen bg-gray-100">
      {/* Header */}
      <header className="bg-blue-600 text-white shadow-lg">
        <div className="container mx-auto px-4 py-6">
          <h1 className="text-3xl font-bold">Gestión de Usuarios</h1>
        </div>
      </header>

      {/* Main Content */}
      <main className="container mx-auto px-4 py-8 flex-grow">
        {/* Mostrar errores si existen */}
        {error && (
          <div className="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4" role="alert">
            <p>{error}</p>
          </div>
        )}

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          {/* Formulario de Usuario */}
          <div className="lg:col-span-1">
            <UserForm
              onSave={handleSaveUser}
              editingUser={editingUser}
              onCancel={handleCancelEdit}
            />
          </div>

          {/* Lista de Usuarios */}
          <div className="lg:col-span-2">
            <UserList
              users={users}
              loading={loading}
              onEdit={handleEditUser}
              onDelete={handleDeleteUser}
            />
          </div>
        </div>
      </main>

      {/* Footer */}
      <footer className="bg-gray-800 text-white mt-12">
        <div className="container mx-auto px-4 py-6 text-center">
          <p>Fundamentos de React.js</p>
        </div>
      </footer>
    </div>
  )
}

export default App
