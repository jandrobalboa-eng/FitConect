import { useEffect, useState } from 'react'
import { useAuth } from '../context/AuthContext'
import api from '../api/client'

export default function DashboardEntrenador() {
  const { user } = useAuth()
  const [clientes, setClientes] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  useEffect(() => {
    api.get('/api/usuarios/clientes')
      .then(res => setClientes(res.data.data))
      .catch(() => setError('No se pudieron cargar los clientes'))
      .finally(() => setLoading(false))
  }, [])

  return (
    <div className="p-6 max-w-4xl mx-auto">
      <h2 className="text-2xl font-bold text-gray-800 mb-1">Bienvenido, {user.nombre}</h2>
      <p className="text-gray-500 mb-6">Panel de entrenador — {user.especialidad || 'Sin especialidad'}</p>

      <h3 className="text-lg font-semibold text-gray-700 mb-3">Mis clientes</h3>

      {loading && <p className="text-gray-400">Cargando...</p>}
      {error && <p className="text-red-500">{error}</p>}

      {!loading && !error && clientes.length === 0 && (
        <p className="text-gray-400">No tienes clientes asignados aún.</p>
      )}

      <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
        {clientes.map(cliente => (
          <div key={cliente.id} className="bg-white rounded-xl shadow-sm border border-gray-200 p-4">
            <p className="font-semibold text-gray-800">{cliente.nombre}</p>
            <p className="text-sm text-gray-500">{cliente.email}</p>
            {cliente.objetivo && (
              <p className="text-sm text-blue-600 mt-1">Objetivo: {cliente.objetivo}</p>
            )}
          </div>
        ))}
      </div>
    </div>
  )
}
