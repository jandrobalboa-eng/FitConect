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
    <div className="flex-grow max-w-[1440px] w-full mx-auto px-10 py-lg">
      <div className="space-y-md mb-lg border-b border-outline-variant pb-md">
        <h1 className="text-4xl font-extrabold text-primary tracking-tight">Mis rutinas</h1>
        <p className="text-on-surface-variant">Programas de entrenamiento asignados por tu entrenador.</p>
      </div>

      {loading && <p className="text-on-surface-variant text-sm">Cargando...</p>}
      {error && <p className="text-sm" style={{ color: '#ba1a1a' }}>{error}</p>}
      {!loading && !error && rutinas.length === 0 && (
        <p className="text-on-surface-variant text-sm">Tu entrenador aún no te ha asignado ninguna rutina.</p>
      )}

      <div className="space-y-base">
        {rutinas.map(rutina => (
          <div
            key={rutina.id}
            className="bg-surface-container-lowest rounded-xl border border-outline-variant/30 overflow-hidden"
            style={{ boxShadow: '0 4px 15px rgba(15,23,42,0.04)' }}
          >
            <button
              onClick={() => setAbierta(abierta === rutina.id ? null : rutina.id)}
              className="w-full text-left p-md flex justify-between items-center hover:bg-surface-container-low transition-colors"
            >
              <div className="flex items-center gap-md">
                <div className="w-11 h-11 rounded-lg bg-secondary-container flex items-center justify-center text-on-secondary-container shrink-0">
                  <span className="material-symbols-outlined">fitness_center</span>
                </div>
                <div>
                  <p className="font-bold text-on-surface">{rutina.nombre}</p>
                  {rutina.descripcion && (
                    <p className="text-sm text-on-surface-variant">{rutina.descripcion}</p>
                  )}
                </div>
              </div>
              <span className="material-symbols-outlined text-on-surface-variant ml-4 shrink-0 transition-transform duration-200" style={{ transform: abierta === rutina.id ? 'rotate(180deg)' : 'none' }}>
                expand_more
              </span>
            </button>

            {abierta === rutina.id && (
              <div className="border-t border-outline-variant/30 p-md">
                <p className="text-xs text-on-surface-variant mb-md">
                  Entrenador: <span className="font-semibold text-secondary">{rutina.entrenadorNombre}</span>
                  {' · '}Asignada: {rutina.fechaAsignacion}
                </p>
                <div className="space-y-sm">
                  {rutina.ejercicios?.map(ej => (
                    <div key={ej.id} className="flex items-center gap-md bg-surface-container-low rounded-lg p-sm">
                      {ej.gifUrl && (
                        <img src={ej.gifUrl} alt={ej.nombre} className="w-14 h-14 object-cover rounded-lg shrink-0" />
                      )}
                      <div className="min-w-0">
                        <p className="font-semibold text-on-surface text-sm">{ej.nombre}</p>
                        <p className="text-xs text-on-surface-variant mt-0.5">
                          {ej.series} series · {ej.repeticiones} reps · Descanso {ej.descanso}
                        </p>
                        <p className="text-xs text-secondary font-semibold mt-0.5">{ej.diaSemana}</p>
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
