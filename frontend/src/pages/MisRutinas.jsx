import { useEffect, useState } from 'react'
import api from '../api/client'

export default function MisRutinas() {
  const [rutinas, setRutinas] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')
  const [abierta, setAbierta] = useState(null)

  useEffect(() => {
    api.get('/api/rutinas/mis-rutinas')
      .then(res => setRutinas(res.data.data))
      .catch(() => setError('No se pudieron cargar tus rutinas'))
      .finally(() => setLoading(false))
  }, [])

  return (
    <div className="p-6 max-w-4xl mx-auto">
      <h2 className="text-2xl font-bold text-gray-800 mb-6">Mis rutinas</h2>

      {loading && <p className="text-gray-400">Cargando...</p>}
      {error && <p className="text-red-500">{error}</p>}
      {!loading && !error && rutinas.length === 0 && (
        <p className="text-gray-400">Tu entrenador aún no te ha asignado ninguna rutina.</p>
      )}

      <div className="space-y-4">
        {rutinas.map(rutina => (
          <div key={rutina.id} className="bg-white rounded-xl shadow-sm border border-gray-200">
            <button
              onClick={() => setAbierta(abierta === rutina.id ? null : rutina.id)}
              className="w-full text-left p-4 flex justify-between items-center"
            >
              <div>
                <p className="font-semibold text-gray-800">{rutina.nombre}</p>
                <p className="text-sm text-gray-500">{rutina.descripcion}</p>
              </div>
              <span className="text-gray-400">{abierta === rutina.id ? '▲' : '▼'}</span>
            </button>

            {abierta === rutina.id && (
              <div className="border-t border-gray-100 p-4">
                <p className="text-xs text-gray-400 mb-3">Entrenador: {rutina.entrenadorNombre} · Asignada: {rutina.fechaAsignacion}</p>
                <div className="space-y-2">
                  {rutina.ejercicios?.map(ej => (
                    <div key={ej.id} className="flex items-center gap-3 bg-gray-50 rounded-lg p-3">
                      {ej.gifUrl && (
                        <img src={ej.gifUrl} alt={ej.nombre} className="w-12 h-12 object-cover rounded" />
                      )}
                      <div>
                        <p className="font-medium text-gray-800 text-sm">{ej.nombre}</p>
                        <p className="text-xs text-gray-500">
                          {ej.series} series · {ej.repeticiones} reps · Descanso {ej.descanso}
                        </p>
                        <p className="text-xs text-blue-600">{ej.diaSemana}</p>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            )}
          </div>
        ))}
      </div>
    </div>
  )
}
