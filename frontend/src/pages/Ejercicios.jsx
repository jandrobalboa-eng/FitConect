import { useEffect, useState } from 'react'
import api from '../api/client'

function ExerciseImage({ url, nombre }) {
  const [broken, setBroken] = useState(false)
  if (!url || broken) {
    return (
      <div className="w-full h-44 bg-surface-container-high flex items-center justify-center">
        <span className="material-symbols-outlined text-[48px] text-on-surface-variant opacity-40">
          fitness_center
        </span>
      </div>
    )
  }
  return (
    <img
      src={url}
      alt={nombre}
      className="w-full h-44 object-cover"
      onError={() => setBroken(true)}
    />
  )
}

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
    <div className="flex-grow max-w-[1440px] w-full mx-auto px-10 py-lg">
      <div className="space-y-md mb-lg border-b border-outline-variant pb-md">
        <h1 className="text-4xl font-extrabold text-primary tracking-tight">Catálogo de ejercicios</h1>
        <p className="text-on-surface-variant">Biblioteca completa de movimientos y guías de forma.</p>
      </div>

      {loading && <p className="text-on-surface-variant text-sm">Cargando...</p>}
      {error && <p className="text-sm" style={{ color: '#ba1a1a' }}>{error}</p>}

      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-gutter">
        {ejercicios.map(ej => (
          <div
            key={ej.id}
            className="bg-surface-container-lowest rounded-xl border border-outline-variant/30 overflow-hidden hover:shadow-lg transition-all duration-300"
            style={{ boxShadow: '0 4px 15px rgba(15,23,42,0.04)' }}
          >
            <ExerciseImage url={ej.gifUrl} nombre={ej.nombre} />
            <div className="p-md">
              <p className="font-bold text-on-surface">{ej.nombre}</p>
              <span className="inline-block mt-1 px-2 py-0.5 bg-secondary-fixed text-on-secondary-fixed text-xs font-bold rounded-full uppercase tracking-wide">
                {ej.musculoObjetivo}
              </span>
              {ej.descripcion && (
                <p className="text-sm text-on-surface-variant mt-sm">{ej.descripcion}</p>
              )}
            </div>
          </div>
        ))}
      </div>
    </div>
  )
}
