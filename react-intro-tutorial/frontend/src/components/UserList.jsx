import UserCard from './UserCard'

function UserList({ users, loading, onEdit, onDelete }) {
  // Mostrar mensaje de carga
  if (loading) {
    return (
      <div className="bg-white rounded-lg shadow-md p-6">
        <div className="flex justify-center items-center h-64">
          <div className="text-gray-500 text-lg">Cargando usuarios...</div>
        </div>
      </div>
    )
  }

  // Mostrar mensaje si no hay usuarios
  if (users.length === 0) {
    return (
      <div className="bg-white rounded-lg shadow-md p-6">
        <div className="flex justify-center items-center h-64">
          <div className="text-center">
            <p className="text-gray-500 text-lg mb-2">No hay usuarios registrados</p>
            <p className="text-gray-400">Crea tu primer usuario usando el formulario</p>
          </div>
        </div>
      </div>
    )
  }

  // Mostrar lista de usuarios
  return (
    <div className="bg-white rounded-lg shadow-md p-6">
      <h2 className="text-2xl font-bold mb-4 text-gray-800">
        Lista de Usuarios ({users.length})
      </h2>
      
      <div className="space-y-3">
        {users.map(user => (
          <UserCard
            key={user.id}
            user={user}
            onEdit={onEdit}
            onDelete={onDelete}
          />
        ))}
      </div>
    </div>
  )
}

export default UserList
