import { useEffect, useState, useRef } from 'react'
import api from '../api/client'

const STORAGE_KEY = 'fitconnect_historial'

function loadHistorial() {
  try { return JSON.parse(localStorage.getItem(STORAGE_KEY)) || [] }
  catch { return [] }
}
function saveHistorial(data) {
  localStorage.setItem(STORAGE_KEY, JSON.stringify(data))
}

export default function MisRutinas() {
  const [tab, setTab] = useState('rutinas')
  const [rutinas, setRutinas] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')
  const [abierta, setAbierta] = useState(null)
  const [historial, setHistorial] = useState(loadHistorial)
  const [sesion, setSesion] = useState(null)
  const [editando, setEditando] = useState(null)
  const [timerSeg, setTimerSeg] = useState(60)
  const [timerRestante, setTimerRestante] = useState(null)
  const [timerActivo, setTimerActivo] = useState(false)
  const intervalRef = useRef(null)

  useEffect(() => {
    api.get('/api/rutinas/mis-rutinas')
      .then(res => setRutinas(res.data.data))
      .catch(() => setError('No se pudieron cargar tus rutinas'))
      .finally(() => setLoading(false))
  }, [])

  useEffect(() => {
    if (timerActivo) {
      intervalRef.current = setInterval(() => {
        setTimerRestante(t => {
          if (t <= 1) { setTimerActivo(false); clearInterval(intervalRef.current); return 0 }
          return t - 1
        })
      }, 1000)
    }
    return () => clearInterval(intervalRef.current)
  }, [timerActivo])

  function iniciarDescanso(seg) {
    clearInterval(intervalRef.current)
    setTimerRestante(seg)
    setTimerActivo(true)
  }

  function iniciarEntrenamiento(rutina) {
    setSesion({
      id: Date.now().toString(),
      rutinaId: rutina.id,
      rutinaNombre: rutina.nombre,
      fecha: new Date().toISOString().split('T')[0],
      inicio: Date.now(),
      ejercicios: (rutina.ejercicios || []).map(ej => ({
        nombre: ej.nombre,
        seriesPlaneadas: ej.series || 3,
        descanso: ej.descanso || '60s',
        seriesHechas: []
      }))
    })
    setTab('sesion')
  }

  function agregarSerie(ejIdx) {
    setSesion(s => {
      const ejs = [...s.ejercicios]
      ejs[ejIdx] = { ...ejs[ejIdx], seriesHechas: [...ejs[ejIdx].seriesHechas, { peso: '', reps: '', rir: '' }] }
      return { ...s, ejercicios: ejs }
    })
  }

  function actualizarSerie(ejIdx, si, campo, valor) {
    setSesion(s => {
      const ejs = [...s.ejercicios]
      const series = [...ejs[ejIdx].seriesHechas]
      series[si] = { ...series[si], [campo]: valor }
      ejs[ejIdx] = { ...ejs[ejIdx], seriesHechas: series }
      return { ...s, ejercicios: ejs }
    })
  }

  function quitarSerie(ejIdx, si) {
    setSesion(s => {
      const ejs = [...s.ejercicios]
      ejs[ejIdx] = { ...ejs[ejIdx], seriesHechas: ejs[ejIdx].seriesHechas.filter((_, i) => i !== si) }
      return { ...s, ejercicios: ejs }
    })
  }

  function finalizarEntrenamiento() {
    const entrada = { ...sesion, duracion: Math.round((Date.now() - sesion.inicio) / 60000) }
    const nuevo = [entrada, ...historial]
    setHistorial(nuevo)
    saveHistorial(nuevo)
    setSesion(null)
    setTimerRestante(null)
    setTimerActivo(false)
    setTab('historial')
  }

  function cancelarSesion() {
    if (window.confirm('¿Cancelar el entrenamiento? Los datos no se guardarán.')) {
      setSesion(null)
      setTimerRestante(null)
      setTimerActivo(false)
      setTab('rutinas')
    }
  }

  function borrarEntrada(id) {
    if (window.confirm('¿Borrar este entrenamiento del historial?')) {
      const nuevo = historial.filter(h => h.id !== id)
      setHistorial(nuevo)
      saveHistorial(nuevo)
    }
  }

  function guardarEdicion(entrada) {
    const nuevo = historial.map(h => h.id === entrada.id ? entrada : h)
    setHistorial(nuevo)
    saveHistorial(nuevo)
    setEditando(null)
  }

  const tabClass = (key) =>
    `px-md py-sm text-sm font-semibold transition-colors border-b-2 ${
      tab === key
        ? 'border-secondary text-secondary'
        : 'border-transparent text-on-surface-variant hover:text-on-surface'
    }`

  return (
    <div className="flex-grow max-w-[1440px] w-full mx-auto px-10 py-lg">
      <div className="space-y-md mb-lg border-b border-outline-variant pb-md">
        <h1 className="text-4xl font-extrabold text-primary tracking-tight">Entrenamiento</h1>
        <p className="text-on-surface-variant">Tus rutinas y registro de sesiones.</p>
      </div>

      {tab !== 'sesion' && (
        <div className="flex gap-0 border-b border-outline-variant mb-lg">
          <button onClick={() => setTab('rutinas')} className={tabClass('rutinas')}>Mis rutinas</button>
          <button onClick={() => setTab('historial')} className={tabClass('historial')}>
            Historial ({historial.length})
          </button>
        </div>
      )}

      {/* TAB: Rutinas */}
      {tab === 'rutinas' && (
        <div className="space-y-base">
          {loading && <p className="text-on-surface-variant text-sm">Cargando...</p>}
          {error && <p className="text-sm" style={{ color: '#ba1a1a' }}>{error}</p>}
          {!loading && !error && rutinas.length === 0 && (
            <p className="text-on-surface-variant text-sm">Tu entrenador aún no te ha asignado ninguna rutina.</p>
          )}
          {rutinas.map(rutina => (
            <div key={rutina.id} className="bg-surface-container-lowest rounded-xl border border-outline-variant/30 overflow-hidden" style={{ boxShadow: '0 4px 15px rgba(15,23,42,0.04)' }}>
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
                    {rutina.descripcion && <p className="text-sm text-on-surface-variant">{rutina.descripcion}</p>}
                  </div>
                </div>
                <span className="material-symbols-outlined text-on-surface-variant ml-4 shrink-0 transition-transform duration-200"
                  style={{ transform: abierta === rutina.id ? 'rotate(180deg)' : 'none' }}>
                  expand_more
                </span>
              </button>
              {abierta === rutina.id && (
                <div className="border-t border-outline-variant/30 p-md">
                  <p className="text-xs text-on-surface-variant mb-md">
                    Entrenador: <span className="font-semibold text-secondary">{rutina.entrenadorNombre}</span>
                    {' · '}Asignada: {rutina.fechaAsignacion}
                  </p>
                  <div className="space-y-sm mb-md">
                    {rutina.ejercicios?.map(ej => (
                      <div key={ej.id} className="flex items-center gap-md bg-surface-container-low rounded-lg p-sm">
                        {ej.gifUrl && <img src={ej.gifUrl} alt={ej.nombre} className="w-14 h-14 object-cover rounded-lg shrink-0" />}
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
                  <button onClick={() => iniciarEntrenamiento(rutina)}
                    className="w-full bg-secondary text-on-secondary py-3 rounded-lg text-sm font-semibold tracking-wide hover:opacity-90 active:scale-95 transition-all flex items-center justify-center gap-2">
                    <span className="material-symbols-outlined text-[20px]">play_arrow</span>
                    Iniciar entrenamiento
                  </button>
                </div>
              )}
            </div>
          ))}
        </div>
      )}

      {/* TAB: Historial */}
      {tab === 'historial' && (
        <div>
          {historial.length === 0 && (
            <div className="text-center py-xl">
              <span className="material-symbols-outlined text-[64px] text-outline-variant block mb-md">history</span>
              <p className="text-on-surface-variant">Aún no has registrado ningún entrenamiento.</p>
              <p className="text-sm text-on-surface-variant mt-xs">Inicia uno desde la pestaña "Mis rutinas".</p>
            </div>
          )}
          <div className="space-y-base">
            {historial.map(entrada => (
              <div key={entrada.id} className="bg-surface-container-lowest rounded-xl border border-outline-variant/30" style={{ boxShadow: '0 4px 15px rgba(15,23,42,0.04)' }}>
                <div className="p-md flex justify-between items-start">
                  <div>
                    <p className="font-bold text-on-surface">{entrada.rutinaNombre}</p>
                    <p className="text-xs text-on-surface-variant mt-0.5">{entrada.fecha} · {entrada.duracion} min</p>
                  </div>
                  <div className="flex gap-xs">
                    <button onClick={() => setEditando(entrada)} className="w-8 h-8 flex items-center justify-center rounded-lg hover:bg-surface-container text-on-surface-variant hover:text-secondary transition-colors">
                      <span className="material-symbols-outlined text-[18px]">edit</span>
                    </button>
                    <button onClick={() => borrarEntrada(entrada.id)} className="w-8 h-8 flex items-center justify-center rounded-lg hover:bg-surface-container text-on-surface-variant hover:text-error transition-colors">
                      <span className="material-symbols-outlined text-[18px]">delete</span>
                    </button>
                  </div>
                </div>
                <div className="border-t border-outline-variant/30 p-md space-y-md">
                  {entrada.ejercicios.filter(ej => ej.seriesHechas.length > 0).map((ej, i) => (
                    <div key={i}>
                      <p className="text-sm font-semibold text-on-surface mb-sm">{ej.nombre}</p>
                      <div className="overflow-x-auto">
                        <table className="text-xs w-full">
                          <thead>
                            <tr className="text-on-surface-variant">
                              <th className="text-left pr-md pb-xs font-semibold">Serie</th>
                              <th className="text-left pr-md pb-xs font-semibold">Peso (kg)</th>
                              <th className="text-left pr-md pb-xs font-semibold">Reps</th>
                              <th className="text-left pb-xs font-semibold">RIR</th>
                            </tr>
                          </thead>
                          <tbody>
                            {ej.seriesHechas.map((s, si) => (
                              <tr key={si} className="text-on-surface">
                                <td className="pr-md py-0.5">{si + 1}</td>
                                <td className="pr-md py-0.5">{s.peso || '—'}</td>
                                <td className="pr-md py-0.5">{s.reps || '—'}</td>
                                <td className="py-0.5">{s.rir || '—'}</td>
                              </tr>
                            ))}
                          </tbody>
                        </table>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* SESIÓN ACTIVA */}
      {tab === 'sesion' && sesion && (
        <div>
          <div className="flex justify-between items-center mb-lg border-b border-outline-variant pb-md">
            <div>
              <h2 className="text-2xl font-bold text-on-surface">{sesion.rutinaNombre}</h2>
              <p className="text-sm text-on-surface-variant">{sesion.fecha}</p>
            </div>
            <button onClick={cancelarSesion} className="text-sm text-on-surface-variant hover:text-error transition-colors">
              Cancelar
            </button>
          </div>

          {/* Timer de descanso */}
          <div className="bg-surface-container-lowest border border-outline-variant/30 rounded-xl p-md mb-lg flex flex-wrap items-center gap-md">
            <span className="material-symbols-outlined text-secondary text-[28px]">timer</span>
            <input type="number" value={timerSeg} min="5" max="300" step="5"
              onChange={e => setTimerSeg(parseInt(e.target.value) || 60)}
              className="w-20 border border-outline-variant rounded-lg px-2 py-1 text-sm text-center" />
            <span className="text-sm text-on-surface-variant">seg</span>
            <button onClick={() => iniciarDescanso(timerSeg)}
              className="bg-secondary text-on-secondary px-md py-1.5 rounded-lg text-sm font-semibold hover:opacity-90">
              Iniciar descanso
            </button>
            {timerRestante !== null && (
              <span className={`text-2xl font-bold tabular-nums ${timerRestante === 0 ? 'text-error' : 'text-secondary'}`}>
                {timerRestante === 0 ? '¡Listo!' : `${timerRestante}s`}
              </span>
            )}
          </div>

          <div className="space-y-md">
            {sesion.ejercicios.map((ej, ejIdx) => (
              <div key={ejIdx} className="bg-surface-container-lowest rounded-xl border border-outline-variant/30 p-md">
                <div className="flex justify-between items-center mb-md">
                  <h3 className="font-bold text-on-surface">{ej.nombre}</h3>
                  <span className="text-xs text-on-surface-variant">{ej.seriesPlaneadas} series · Descanso {ej.descanso}</span>
                </div>

                {ej.seriesHechas.length > 0 && (
                  <div className="overflow-x-auto mb-sm">
                    <table className="text-sm w-full">
                      <thead>
                        <tr className="text-xs text-on-surface-variant uppercase tracking-wide">
                          <th className="text-left pr-md pb-xs">Serie</th>
                          <th className="text-left pr-md pb-xs">Peso (kg)</th>
                          <th className="text-left pr-md pb-xs">Reps</th>
                          <th className="text-left pr-md pb-xs">RIR</th>
                          <th></th>
                        </tr>
                      </thead>
                      <tbody>
                        {ej.seriesHechas.map((s, si) => (
                          <tr key={si}>
                            <td className="pr-md py-1 text-on-surface-variant">{si + 1}</td>
                            <td className="pr-md py-1">
                              <input type="number" step="0.5" value={s.peso} placeholder="kg"
                                onChange={e => actualizarSerie(ejIdx, si, 'peso', e.target.value)}
                                className="w-20 border border-outline-variant rounded px-2 py-1 text-sm" />
                            </td>
                            <td className="pr-md py-1">
                              <input type="number" value={s.reps} placeholder="reps"
                                onChange={e => actualizarSerie(ejIdx, si, 'reps', e.target.value)}
                                className="w-20 border border-outline-variant rounded px-2 py-1 text-sm" />
                            </td>
                            <td className="pr-md py-1">
                              <input type="number" min="0" max="5" value={s.rir} placeholder="RIR"
                                onChange={e => actualizarSerie(ejIdx, si, 'rir', e.target.value)}
                                className="w-20 border border-outline-variant rounded px-2 py-1 text-sm" />
                            </td>
                            <td className="py-1">
                              <button onClick={() => quitarSerie(ejIdx, si)} className="text-on-surface-variant hover:text-error">
                                <span className="material-symbols-outlined text-[18px]">close</span>
                              </button>
                            </td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                )}

                <button onClick={() => agregarSerie(ejIdx)}
                  className="text-sm text-secondary font-semibold flex items-center gap-xs hover:underline">
                  <span className="material-symbols-outlined text-[18px]">add_circle</span>
                  Añadir serie
                </button>
              </div>
            ))}
          </div>

          <button onClick={finalizarEntrenamiento}
            className="mt-lg w-full bg-primary text-on-primary py-4 rounded-xl font-bold text-base tracking-wide hover:opacity-90 active:scale-95 transition-all flex items-center justify-center gap-2">
            <span className="material-symbols-outlined">check_circle</span>
            Finalizar entrenamiento
          </button>
        </div>
      )}

      {/* MODAL EDITAR */}
      {editando && (
        <EditarEntrenamiento entrada={editando} onGuardar={guardarEdicion} onCancelar={() => setEditando(null)} />
      )}
    </div>
  )
}

function EditarEntrenamiento({ entrada, onGuardar, onCancelar }) {
  const [datos, setDatos] = useState(JSON.parse(JSON.stringify(entrada)))

  function actualizarSerie(ejIdx, si, campo, valor) {
    setDatos(d => {
      const ejs = [...d.ejercicios]
      const series = [...ejs[ejIdx].seriesHechas]
      series[si] = { ...series[si], [campo]: valor }
      ejs[ejIdx] = { ...ejs[ejIdx], seriesHechas: series }
      return { ...d, ejercicios: ejs }
    })
  }

  return (
    <div className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4">
      <div className="bg-surface-container-lowest rounded-xl w-full max-w-2xl max-h-[90vh] overflow-y-auto shadow-xl">
        <div className="p-md border-b border-outline-variant flex justify-between items-center">
          <h2 className="font-bold text-on-surface">Editar entrenamiento</h2>
          <button onClick={onCancelar} className="material-symbols-outlined text-on-surface-variant hover:text-on-surface">close</button>
        </div>
        <div className="p-md space-y-md">
          <div className="flex gap-md">
            <div className="flex-1">
              <label className="text-xs font-semibold text-on-surface-variant block mb-xs">Fecha</label>
              <input type="date" value={datos.fecha}
                onChange={e => setDatos(d => ({ ...d, fecha: e.target.value }))}
                className="w-full border border-outline-variant rounded-lg px-3 py-2 text-sm" />
            </div>
            <div className="w-32">
              <label className="text-xs font-semibold text-on-surface-variant block mb-xs">Duración (min)</label>
              <input type="number" value={datos.duracion}
                onChange={e => setDatos(d => ({ ...d, duracion: parseInt(e.target.value) || 0 }))}
                className="w-full border border-outline-variant rounded-lg px-3 py-2 text-sm" />
            </div>
          </div>
          {datos.ejercicios.filter(ej => ej.seriesHechas.length > 0).map((ej, ejIdx) => (
            <div key={ejIdx}>
              <p className="text-sm font-bold text-on-surface mb-sm">{ej.nombre}</p>
              <div className="grid grid-cols-4 gap-xs text-xs text-on-surface-variant font-semibold mb-xs px-1">
                <span>Serie</span><span>Peso (kg)</span><span>Reps</span><span>RIR</span>
              </div>
              {ej.seriesHechas.map((s, si) => (
                <div key={si} className="grid grid-cols-4 gap-xs mb-xs items-center">
                  <span className="text-xs text-on-surface-variant text-center py-2">{si + 1}</span>
                  <input type="number" step="0.5" value={s.peso} placeholder="kg"
                    onChange={e => actualizarSerie(ejIdx, si, 'peso', e.target.value)}
                    className="border border-outline-variant rounded px-2 py-1.5 text-sm" />
                  <input type="number" value={s.reps} placeholder="reps"
                    onChange={e => actualizarSerie(ejIdx, si, 'reps', e.target.value)}
                    className="border border-outline-variant rounded px-2 py-1.5 text-sm" />
                  <input type="number" min="0" max="5" value={s.rir} placeholder="RIR"
                    onChange={e => actualizarSerie(ejIdx, si, 'rir', e.target.value)}
                    className="border border-outline-variant rounded px-2 py-1.5 text-sm" />
                </div>
              ))}
            </div>
          ))}
        </div>
        <div className="p-md border-t border-outline-variant flex gap-sm justify-end">
          <button onClick={onCancelar} className="px-md py-2 text-sm text-on-surface-variant border border-outline-variant rounded-lg hover:bg-surface-container">Cancelar</button>
          <button onClick={() => onGuardar(datos)} className="px-md py-2 text-sm bg-secondary text-on-secondary rounded-lg font-semibold hover:opacity-90">Guardar</button>
        </div>
      </div>
    </div>
  )
}
