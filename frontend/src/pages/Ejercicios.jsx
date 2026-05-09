import { useEffect, useState } from 'react'
import api from '../api/client'

export default function Ejercicios() {
  const [ejercicios, setEjercicios] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  useEffect(() => {
    api.get('/api/ejercicios')
      .then(res => setEjercicios(res.data.data))
      .catch(() => setError('No se pudo cargar el catálogo'))
      .finally(() => setLoading(false))
  }, [])

  return (
    <div className="p-6 max-w-5xl mx-auto">
      <h2 className="text-2xl font-bold text-gray-800 mb-6">Catálogo de ejercicios</h2>

      {loading && <p className="text-gray-400">Cargando...</p>}
      {error && <p className="text-red-500">{error}</p>}

      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
        {ejercicios.map(ej => (
          <div key={ej.id} className="bg-white rounded-xl shadow-sm border border-gray-200 p-4">
            {ej.gifUrl && (
              <img src={ej.gifUrl} alt={ej.nombre} className="w-full h-40 object-cover rounded-lg mb-3" />
            )}
            <p className="font-semibold text-gray-800">{ej.nombre}</p>
            <p className="text-xs text-blue-600 font-medium mt-1">{ej.musculoObjetivo}</p>
            <p className="text-sm text-gray-500 mt-1">{ej.descripcion}</p>
          </div>
        ))}
      </div>
    </div>
  )
}
