import { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { useAuth } from '../context/AuthContext'
import api from '../api/client'

export default function DashboardCliente() {
  const { user } = useAuth()
  const [rutinas, setRutinas] = useState([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    api.get('/api/rutinas/mis-rutinas')
      .then(res => setRutinas(res.data.data))
      .catch(() => {})
      .finally(() => setLoading(false))
  }, [])

  return (
    <div className="p-6 max-w-4xl mx-auto">
      <h2 className="text-2xl font-bold text-gray-800 mb-1">Bienvenido, {user.nombre}</h2>
      <p className="text-gray-500 mb-6">
        {user.objetivo ? `Objetivo: ${user.objetivo}` : 'Panel de cliente'}
      </p>

      <div className="grid grid-cols-1 sm:grid-cols-3 gap-4 mb-8">
        <Link to="/mis-rutinas" className="bg-blue-50 border border-blue-200 rounded-xl p-4 hover:bg-blue-100 text-center">
          <p className="text-3xl font-bold text-blue-600">{rutinas.length}</p>
          <p className="text-sm text-gray-600 mt-1">Rutinas asignadas</p>
        </Link>
        <Link to="/metricas" className="bg-green-50 border border-green-200 rounded-xl p-4 hover:bg-green-100 text-center">
          <p className="text-xl font-bold text-green-600">Métricas</p>
          <p className="text-sm text-gray-600 mt-1">Ver mi progreso</p>
        </Link>
        <Link to="/ejercicios" className="bg-purple-50 border border-purple-200 rounded-xl p-4 hover:bg-purple-100 text-center">
          <p className="text-xl font-bold text-purple-600">Ejercicios</p>
          <p className="text-sm text-gray-600 mt-1">Ver catálogo</p>
        </Link>
      </div>

      <h3 className="text-lg font-semibold text-gray-700 mb-3">Mis rutinas recientes</h3>
      {loading && <p className="text-gray-400">Cargando...</p>}
      {!loading && rutinas.length === 0 && (
        <p className="text-gray-400">Tu entrenador aún no te ha asignado ninguna rutina.</p>
      )}
      <div className="space-y-3">
        {rutinas.slice(0, 3).map(rutina => (
          <div key={rutina.id} className="bg-white rounded-xl shadow-sm border border-gray-200 p-4">
            <p className="font-semibold text-gray-800">{rutina.nombre}</p>
            <p className="text-sm text-gray-500">{rutina.descripcion}</p>
            <p className="text-xs text-gray-400 mt-1">Asignada: {rutina.fechaAsignacion}</p>
          </div>
        ))}
      </div>
    </div>
  )
}
