function UserCard({ user, onEdit, onDelete }) {
  return (
    <div className="border border-gray-200 rounded-lg p-4 hover:shadow-md transition-shadow">
      <div className="flex justify-between items-start">
        {/* Información del usuario */}
        <div className="flex-1">
          <h3 className="text-lg font-semibold text-gray-800">{user.name}</h3>
          <p className="text-gray-600 text-sm mt-1">{user.email}</p>
          <p className="text-gray-400 text-xs mt-2">ID: {user.id}</p>
        </div>

        {/* Botones de acción */}
        <div className="flex gap-2 ml-4">
          <button
            onClick={() => onEdit(user)}
            className="bg-yellow-500 text-white px-3 py-1 rounded hover:bg-yellow-600 transition-colors text-sm focus:outline-none focus:ring-2 focus:ring-yellow-500 focus:ring-offset-2"
            aria-label={`Editar usuario ${user.name}`}
          >
            Editar
          </button>
          <button
            onClick={() => onDelete(user.id)}
            className="bg-red-500 text-white px-3 py-1 rounded hover:bg-red-600 transition-colors text-sm focus:outline-none focus:ring-2 focus:ring-red-500 focus:ring-offset-2"
            aria-label={`Eliminar usuario ${user.name}`}
          >
            Eliminar
          </button>
        </div>
      </div>
    </div>
  )
}

export default UserCard
