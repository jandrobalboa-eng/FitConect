import { useEffect, useState, useMemo } from 'react'
import api from '../api/client'

// Término de búsqueda en inglés para cada ejercicio → wger search API
const EXERCISE_SEARCH_TERM = {
  'Press de banca con barra':            'bench press barbell',
  'Press inclinado con mancuernas':      'incline dumbbell press',
  'Aperturas con mancuernas':            'dumbbell fly chest',
  'Fondos en paralelas':                 'chest dips',
  'Press en máquina de pecho':           'chest press machine',
  'Dominadas':                           'pull-ups',
  'Remo con barra':                      'barbell row bent over',
  'Jalón al pecho en polea':             'lat pulldown cable',
  'Remo con mancuerna':                  'one arm dumbbell row',
  'Peso muerto':                         'deadlift barbell',
  'Press militar con barra':             'barbell overhead press military',
  'Elevaciones laterales con mancuernas':'lateral raise dumbbell',
  'Pájaros con mancuernas':              'bent over lateral raise rear delt',
  'Face pull en polea':                  'face pull cable',
  'Curl de bíceps con barra':            'barbell bicep curl',
  'Curl alternado con mancuernas':       'alternating dumbbell curl',
  'Curl martillo':                       'hammer curl dumbbell',
  'Curl en polea baja':                  'cable curl low pulley bicep',
  'Press francés con barra Z':           'skull crusher EZ bar tricep',
  'Extensión de tríceps en polea alta':  'tricep pushdown cable',
  'Fondos de tríceps en banco':          'bench dips tricep',
  'Sentadilla con barra':                'barbell squat',
  'Prensa de piernas':                   'leg press machine',
  'Zancadas con mancuernas':             'dumbbell lunges',
  'Extensión de cuádriceps en máquina':  'leg extension machine',
  'Curl femoral tumbado':                'lying leg curl hamstring',
  'Peso muerto rumano':                  'romanian deadlift',
  'Hip thrust con barra':                'hip thrust barbell glute',
  'Patada de glúteo en polea':           'cable kickback glute',
  'Plancha abdominal':                   'plank abdominal',
  'Crunch abdominal':                    'crunches abdominal',
  'Elevación de piernas':                'leg raise hanging',
  'Russian twist':                       'russian twist obliques',
  'Burpees':                             'burpees',
  'Mountain climbers':                   'mountain climbers',
  'Salto a la comba':                    'jump rope',
}

const CACHE_KEY = 'fitconnect_wger_images_v2'
const CACHE_TTL = 7 * 24 * 60 * 60 * 1000

function loadCache() {
  try {
    const raw = localStorage.getItem(CACHE_KEY)
    if (!raw) return null
    const { ts, data } = JSON.parse(raw)
    return Date.now() - ts < CACHE_TTL ? data : null
  } catch { return null }
}

function saveCache(data) {
  try { localStorage.setItem(CACHE_KEY, JSON.stringify({ ts: Date.now(), data })) } catch {}
}

async function searchWgerImage(term) {
  try {
    const res = await fetch(
      `https://wger.de/api/v2/exercise/search/?term=${encodeURIComponent(term)}&language=english&format=json`
    )
    if (!res.ok) return null
    const json = await res.json()
    const hit = json.suggestions?.find(s => s.data?.image)
    return hit?.data?.image ?? null
  } catch { return null }
}

async function buildImageMap(ejercicios) {
  const cached = loadCache()
  if (cached) return cached

  const entries = await Promise.all(
    ejercicios.map(async ej => {
      const term = EXERCISE_SEARCH_TERM[ej.nombre]
      if (!term) return [ej.nombre, null]
      const img = await searchWgerImage(term)
      return [ej.nombre, img]
    })
  )
  const map = Object.fromEntries(entries)
  saveCache(map)
  return map
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
  const [imageMap, setImageMap] = useState(null)

  useEffect(() => {
    api.get('/api/ejercicios')
      .then(res => setEjercicios(res.data.data))
      .catch(() => setError('No se pudo cargar el catálogo'))
      .finally(() => setLoading(false))
  }, [])

  useEffect(() => {
    if (ejercicios.length === 0) return
    buildImageMap(ejercicios).then(setImageMap).catch(() => setImageMap({}))
  }, [ejercicios])

  const enriched = useMemo(() => {
    if (!imageMap) return ejercicios.map(ej => ({ ...ej, displayImage: ej.gifUrl ?? null }))
    return ejercicios.map(ej => ({
      ...ej,
      displayImage: ej.gifUrl ?? imageMap[ej.nombre] ?? null,
    }))
  }, [ejercicios, imageMap])

  const isReady = !loading && imageMap !== null

  return (
    <div className="flex-grow max-w-[1440px] w-full mx-auto px-10 py-lg">
      <div className="space-y-md mb-lg border-b border-outline-variant pb-md">
        <h1 className="text-4xl font-extrabold text-primary tracking-tight">Catálogo de ejercicios</h1>
        <p className="text-on-surface-variant">Biblioteca completa de movimientos y guías de forma.</p>
      </div>

      {error && <p className="text-sm mb-md" style={{ color: '#ba1a1a' }}>{error}</p>}

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
