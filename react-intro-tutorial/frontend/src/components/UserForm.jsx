import { useState, useEffect } from 'react'

function UserForm({ onSave, editingUser, onCancel }) {
  // Estado local del formulario
  const [formData, setFormData] = useState({
    name: '',
    email: ''
  })

  // useEffect para cargar datos cuando se edita un usuario
  useEffect(() => {
    if (editingUser) {
      setFormData({
        name: editingUser.name,
        email: editingUser.email
      })
    } else {
      setFormData({
        name: '',
        email: ''
      })
    }
  }, [editingUser])

  // Manejar cambios en los inputs
  const handleChange = (e) => {
    const { name, value } = e.target
    setFormData(prev => ({
      ...prev,
      [name]: value
    }))
  }

  // Manejar el envío del formulario
  const handleSubmit = (e) => {
    e.preventDefault()
    
    // Validación básica
    if (!formData.name.trim() || !formData.email.trim()) {
      alert('Por favor completa todos los campos')
      return
    }

    // Llamar a la función onSave del componente padre
    onSave(formData)
    
    // Limpiar el formulario
    setFormData({ name: '', email: '' })
  }

  return (
    <div className="bg-white rounded-lg shadow-md p-6">
      <h2 className="text-2xl font-bold mb-4 text-gray-800">
        {editingUser ? 'Editar Usuario' : 'Nuevo Usuario'}
      </h2>
      
      <form onSubmit={handleSubmit} className="space-y-4">
        {/* Campo Nombre */}
        <div>
          <label 
            htmlFor="name" 
            className="block text-sm font-medium text-gray-700 mb-1"
          >
            Nombre
          </label>
          <input
            type="text"
            id="name"
            name="name"
            value={formData.name}
            onChange={handleChange}
            className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            placeholder="Ingresa el nombre"
            required
          />
        </div>

        {/* Campo Email */}
        <div>
          <label 
            htmlFor="email" 
            className="block text-sm font-medium text-gray-700 mb-1"
          >
            Email
          </label>
          <input
            type="email"
            id="email"
            name="email"
            value={formData.email}
            onChange={handleChange}
            className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            placeholder="correo@ejemplo.com"
            required
          />
        </div>

        {/* Botones */}
        <div className="flex gap-2">
          <button
            type="submit"
            className="flex-1 bg-blue-600 text-white py-2 px-4 rounded-md hover:bg-blue-700 transition-colors focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2"
          >
            {editingUser ? 'Actualizar' : 'Crear'}
          </button>
          
          {editingUser && (
            <button
              type="button"
              onClick={onCancel}
              className="flex-1 bg-gray-300 text-gray-700 py-2 px-4 rounded-md hover:bg-gray-400 transition-colors focus:outline-none focus:ring-2 focus:ring-gray-500 focus:ring-offset-2"
            >
              Cancelar
            </button>
          )}
        </div>
      </form>
    </div>
  )
}

export default UserForm
