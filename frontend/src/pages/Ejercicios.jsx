import { useEffect, useState, useMemo } from 'react'
import api from '../api/client'

// Mapeo de nuestros grupos musculares a los IDs de categoría de wger
const MUSCLE_TO_WGER = {
  'Pecho': 12,
  'Espalda': 10,
  'Hombros': 15,
  'Bíceps': 8,
  'Tríceps': 8,
  'Cuádriceps': 14,
  'Isquiotibiales': 14,
  'Glúteos': 14,
  'Core': 13,
  'Cardio': 13,
}

async function fetchWgerImages(categoryId) {
  const res = await fetch(
    `https://wger.de/api/v2/exerciseinfo/?format=json&category=${categoryId}&limit=20`
  )
  if (!res.ok) return []
  const data = await res.json()
  return data.results
    .flatMap(ex => (ex.images || []).filter(img => img.is_main))
    .map(img => img.image)
    .filter(Boolean)
}

function ExerciseImage({ url, nombre }) {
  const [failed, setFailed] = useState(false)

  if (!url || failed) {
    return (
      <div className="w-full h-48 bg-surface-container-high flex items-center justify-center">
        <span className="material-symbols-outlined text-[48px] text-on-surface-variant opacity-30">
          fitness_center
        </span>
      </div>
    )
  }
  return (
    <img
      src={url}
      alt={nombre}
      className="w-full h-48 object-cover"
      onError={() => setFailed(true)}
    />
  )
}

export default function Ejercicios() {
  const [ejercicios, setEjercicios] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')
  const [wgerImages, setWgerImages] = useState({})
  const [wgerLoading, setWgerLoading] = useState(true)

  useEffect(() => {
    api.get('/api/ejercicios')
      .then(res => setEjercicios(res.data.data))
      .catch(() => setError('No se pudo cargar el catálogo'))
      .finally(() => setLoading(false))
  }, [])

  useEffect(() => {
    const uniqueCategories = [...new Set(Object.values(MUSCLE_TO_WGER))]
    Promise.all(
      uniqueCategories.map(async catId => [catId, await fetchWgerImages(catId)])
    )
      .then(entries => setWgerImages(Object.fromEntries(entries)))
      .catch(() => {})
      .finally(() => setWgerLoading(false))
  }, [])

  // Asigna imágenes de wger a los ejercicios que no tienen gifUrl
  const enriched = useMemo(() => {
    const counters = {}
    return ejercicios.map(ej => {
      if (ej.gifUrl) return { ...ej, displayImage: ej.gifUrl }
      const catId = MUSCLE_TO_WGER[ej.musculoObjetivo]
      const imgs = wgerImages[catId] || []
      if (!imgs.length) return { ...ej, displayImage: null }
      counters[catId] = counters[catId] ?? 0
      const img = imgs[counters[catId] % imgs.length]
      counters[catId]++
      return { ...ej, displayImage: img }
    })
  }, [ejercicios, wgerImages])

  const isReady = !loading && !wgerLoading

  return (
    <div className="flex-grow max-w-[1440px] w-full mx-auto px-10 py-lg">
      <div className="space-y-md mb-lg border-b border-outline-variant pb-md">
        <h1 className="text-4xl font-extrabold text-primary tracking-tight">Catálogo de ejercicios</h1>
        <p className="text-on-surface-variant">Biblioteca completa de movimientos y guías de forma.</p>
      </div>

      {error && <p className="text-sm mb-md" style={{ color: '#ba1a1a' }}>{error}</p>}

      {/* Skeleton mientras carga */}
      {!isReady && (
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-gutter">
          {Array.from({ length: 9 }).map((_, i) => (
            <div key={i} className="bg-surface-container-lowest rounded-xl border border-outline-variant/30 overflow-hidden animate-pulse">
              <div className="w-full h-48 bg-surface-container-high" />
              <div className="p-md space-y-sm">
                <div className="h-4 bg-surface-container-high rounded w-3/4" />
                <div className="h-3 bg-surface-container-high rounded w-1/4" />
                <div className="h-3 bg-surface-container-high rounded w-full" />
              </div>
            </div>
          ))}
        </div>
      )}

      {isReady && (
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-gutter">
          {enriched.map(ej => (
            <div
              key={ej.id}
              className="bg-surface-container-lowest rounded-xl border border-outline-variant/30 overflow-hidden hover:shadow-lg transition-all duration-300"
              style={{ boxShadow: '0 4px 15px rgba(15,23,42,0.04)' }}
            >
              <ExerciseImage url={ej.displayImage} nombre={ej.nombre} />
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
      )}
    </div>
  )
}
