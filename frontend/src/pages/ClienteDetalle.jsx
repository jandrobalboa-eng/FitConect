import { useEffect, useState } from 'react'
import { useParams, useLocation, Link } from 'react-router-dom'
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts'
import api from '../api/client'

export default function ClienteDetalle() {
  const { id } = useParams()
  const { state } = useLocation()
  const cliente = state?.cliente

  const [tab, setTab] = useState('rutinas')
  const [rutinas, setRutinas] = useState([])
  const [metricas, setMetricas] = useState([])
  const [loadingRutinas, setLoadingRutinas] = useState(true)
  const [loadingMetricas, setLoadingMetricas] = useState(true)
  const [errorRutinas, setErrorRutinas] = useState('')
  const [errorMetricas, setErrorMetricas] = useState('')
  const [rutinaAbierta, setRutinaAbierta] = useState(null)

  useEffect(() => {
    api.get(`/api/rutinas/cliente/${id}`)
      .then(res => setRutinas(res.data.data ?? []))
      .catch(() => setErrorRutinas('No se pudieron cargar las rutinas de este cliente.'))
      .finally(() => setLoadingRutinas(false))

    api.get(`/api/metricas/cliente/${id}`)
      .then(res => setMetricas(res.data.data ?? []))
      .catch(() => setErrorMetricas('No se pudieron cargar las métricas de este cliente.'))
      .finally(() => setLoadingMetricas(false))
  }, [id])

  const initials = cliente?.nombre
    ? cliente.nombre.split(' ').map(n => n[0]).join('').slice(0, 2).toUpperCase()
    : '?'

  const datosGrafica = [...metricas].reverse().map(m => ({ fecha: m.fecha, peso: parseFloat(m.peso) }))
  const tendencia = metricas.length >= 2
    ? (parseFloat(metricas[0].peso) - parseFloat(metricas[1].peso)).toFixed(1)
    : null

  const tabClass = (key) =>
    `flex items-center gap-xs px-md py-sm text-sm font-semibold transition-colors border-b-2 ${
      tab === key
        ? 'border-secondary text-secondary'
        : 'border-transparent text-on-surface-variant hover:text-on-surface'
    }`

  const diasLabel = {
    lunes: 'Lunes', martes: 'Martes', miercoles: 'Miércoles',
    jueves: 'Jueves', viernes: 'Viernes', sabado: 'Sábado', domingo: 'Domingo'
  }

  return (
    <div className="flex-grow max-w-[1440px] w-full mx-auto px-10 py-lg space-y-xl">

      {/* Back */}
      <Link to="/" className="inline-flex items-center gap-xs text-sm text-on-surface-variant hover:text-secondary transition-colors">
        <span className="material-symbols-outlined text-[18px]">arrow_back</span>
        Volver al panel
      </Link>

      {/* Client profile header */}
      <section className="flex flex-col sm:flex-row items-start sm:items-center gap-md p-md bg-surface-container-lowest rounded-xl border border-outline-variant/30"
        style={{ boxShadow: '0 4px 15px rgba(15,23,42,0.04)' }}>
        <div className="w-16 h-16 rounded-full bg-secondary-container flex items-center justify-center text-on-secondary-container font-bold text-2xl shrink-0">
          {initials}
        </div>
        <div className="flex-grow min-w-0">
          <h1 className="text-3xl font-extrabold text-primary tracking-tight">
            {cliente?.nombre ?? `Cliente #${id}`}
          </h1>
          <p className="text-on-surface-variant text-sm mt-xs">{cliente?.email}</p>
          {cliente?.objetivo && (
            <p className="text-sm text-secondary font-semibold mt-xs">Objetivo: {cliente.objetivo}</p>
          )}
        </div>
        <div className="flex gap-lg shrink-0 text-sm text-on-surface-variant">
          {cliente?.altura && (
            <div className="text-center">
              <p className="text-xs uppercase tracking-wide font-bold">Altura</p>
              <p className="text-xl font-bold text-on-surface">{cliente.altura} cm</p>
            </div>
          )}
          {cliente?.fechaInicio && (
            <div className="text-center">
              <p className="text-xs uppercase tracking-wide font-bold">Cliente desde</p>
              <p className="text-base font-bold text-on-surface">{cliente.fechaInicio}</p>
            </div>
          )}
        </div>
      </section>

      {/* Tabs */}
      <section>
        <div className="flex gap-0 border-b border-outline-variant mb-lg">
          <button onClick={() => setTab('rutinas')} className={tabClass('rutinas')}>
            <span className="material-symbols-outlined text-[18px]">calendar_today</span>
            Rutinas asignadas
          </button>
          <button onClick={() => setTab('metricas')} className={tabClass('metricas')}>
            <span className="material-symbols-outlined text-[18px]">monitoring</span>
            Métricas y progreso
          </button>
        </div>

        {/* ── RUTINAS ── */}
        {tab === 'rutinas' && (
          <div className="space-y-md">
            {loadingRutinas && (
              <p className="text-on-surface-variant text-sm">Cargando rutinas...</p>
            )}
            {!loadingRutinas && errorRutinas && (
              <div className="flex items-start gap-sm p-md bg-surface-container-low rounded-xl border border-outline-variant/30 text-sm text-on-surface-variant">
                <span className="material-symbols-outlined text-[20px] shrink-0 mt-0.5">info</span>
                <div>
                  <p className="font-semibold text-on-surface">Datos no disponibles</p>
                  <p className="mt-xs">{errorRutinas}</p>
                  <p className="mt-xs text-xs opacity-70">Endpoint requerido: <code className="bg-surface-container px-1 rounded">GET /api/rutinas/cliente/{'{id}'}</code></p>
                </div>
              </div>
            )}
            {!loadingRutinas && !errorRutinas && rutinas.length === 0 && (
              <p className="text-on-surface-variant text-sm">Este cliente no tiene rutinas asignadas.</p>
            )}
            {rutinas.map(rutina => (
              <div key={rutina.id}
                className="bg-surface-container-lowest rounded-xl border border-outline-variant/30 overflow-hidden"
                style={{ boxShadow: '0 4px 15px rgba(15,23,42,0.04)' }}>
                <button
                  onClick={() => setRutinaAbierta(rutinaAbierta === rutina.id ? null : rutina.id)}
                  className="w-full flex items-center justify-between p-md text-left hover:bg-surface-container-low transition-colors"
                >
                  <div className="flex items-center gap-md">
                    <div className="w-10 h-10 rounded-lg bg-secondary-container flex items-center justify-center text-on-secondary-container shrink-0">
                      <span className="material-symbols-outlined">fitness_center</span>
                    </div>
                    <div>
                      <h3 className="font-bold text-on-surface">{rutina.nombre}</h3>
                      {rutina.descripcion && (
                        <p className="text-sm text-on-surface-variant mt-0.5">{rutina.descripcion}</p>
                      )}
                    </div>
                  </div>
                  <div className="flex items-center gap-md shrink-0 ml-md">
                    <div className="text-right">
                      <p className="text-xs text-on-surface-variant">Asignada el</p>
                      <p className="text-sm font-bold text-primary">{rutina.fechaAsignacion}</p>
                    </div>
                    <span className="material-symbols-outlined text-on-surface-variant transition-transform"
                      style={{ transform: rutinaAbierta === rutina.id ? 'rotate(180deg)' : 'rotate(0deg)' }}>
                      expand_more
                    </span>
                  </div>
                </button>

                {rutinaAbierta === rutina.id && rutina.ejercicios?.length > 0 && (
                  <div className="border-t border-outline-variant">
                    <div className="overflow-x-auto">
                      <table className="w-full text-sm">
                        <thead>
                          <tr className="bg-surface-container-low border-b border-outline-variant">
                            <th className="text-left px-md py-sm text-xs font-bold text-on-surface-variant uppercase tracking-wide">Ejercicio</th>
                            <th className="text-center px-md py-sm text-xs font-bold text-on-surface-variant uppercase tracking-wide">Día</th>
                            <th className="text-center px-md py-sm text-xs font-bold text-on-surface-variant uppercase tracking-wide">Series</th>
                            <th className="text-center px-md py-sm text-xs font-bold text-on-surface-variant uppercase tracking-wide">Reps</th>
                            <th className="text-center px-md py-sm text-xs font-bold text-on-surface-variant uppercase tracking-wide">Descanso</th>
                          </tr>
                        </thead>
                        <tbody className="divide-y divide-outline-variant">
                          {rutina.ejercicios.map(ej => (
                            <tr key={ej.id} className="hover:bg-surface-container-low transition-colors">
                              <td className="px-md py-sm">
                                <p className="font-semibold text-on-surface">{ej.nombre}</p>
                                {ej.musculoObjetivo && (
                                  <p className="text-xs text-on-surface-variant mt-0.5">{ej.musculoObjetivo}</p>
                                )}
                              </td>
                              <td className="px-md py-sm text-center text-on-surface-variant">
                                {diasLabel[ej.diaSemana] ?? ej.diaSemana ?? '—'}
                              </td>
                              <td className="px-md py-sm text-center font-bold text-primary">{ej.series ?? '—'}</td>
                              <td className="px-md py-sm text-center text-on-surface">{ej.repeticiones ?? '—'}</td>
                              <td className="px-md py-sm text-center text-on-surface-variant">{ej.descanso ?? '—'}</td>
                            </tr>
                          ))}
                        </tbody>
                      </table>
                    </div>
                  </div>
                )}

                {rutinaAbierta === rutina.id && (!rutina.ejercicios || rutina.ejercicios.length === 0) && (
                  <div className="border-t border-outline-variant px-md py-sm text-sm text-on-surface-variant">
                    Esta rutina no tiene ejercicios añadidos.
                  </div>
                )}
              </div>
            ))}
          </div>
        )}

        {/* ── MÉTRICAS ── */}
        {tab === 'metricas' && (
          <div className="space-y-gutter">
            {loadingMetricas && (
              <p className="text-on-surface-variant text-sm">Cargando métricas...</p>
            )}
            {!loadingMetricas && errorMetricas && (
              <div className="flex items-start gap-sm p-md bg-surface-container-low rounded-xl border border-outline-variant/30 text-sm text-on-surface-variant">
                <span className="material-symbols-outlined text-[20px] shrink-0 mt-0.5">info</span>
                <div>
                  <p className="font-semibold text-on-surface">Datos no disponibles</p>
                  <p className="mt-xs">{errorMetricas}</p>
                  <p className="mt-xs text-xs opacity-70">Endpoint requerido: <code className="bg-surface-container px-1 rounded">GET /api/metricas/cliente/{'{id}'}</code></p>
                </div>
              </div>
            )}

            {!loadingMetricas && !errorMetricas && (
              <>
                {/* Weight chart */}
                <div className="bg-surface-container-lowest p-md rounded-xl border border-outline-variant/30"
                  style={{ boxShadow: '0 4px 15px rgba(15,23,42,0.04)' }}>
                  <div className="flex justify-between items-end mb-md">
                    <div>
                      <h2 className="text-xl font-bold text-primary">Evolución del peso</h2>
                      <p className="text-sm text-on-surface-variant">Historial completo</p>
                    </div>
                    {tendencia !== null && (
                      <span className="px-3 py-1 text-xs font-bold rounded-full"
                        style={{
                          background: parseFloat(tendencia) <= 0 ? '#d8e2ff' : '#ffdad6',
                          color: parseFloat(tendencia) <= 0 ? '#001a42' : '#93000a',
                        }}>
                        Tendencia: {tendencia > 0 ? '+' : ''}{tendencia} kg
                      </span>
                    )}
                  </div>
                  {datosGrafica.length > 1 ? (
                    <ResponsiveContainer width="100%" height={220}>
                      <LineChart data={datosGrafica}>
                        <CartesianGrid strokeDasharray="3 3" stroke="#c6c6cd" />
                        <XAxis dataKey="fecha" tick={{ fontSize: 11, fill: '#45464d' }} />
                        <YAxis domain={['auto', 'auto']} tick={{ fontSize: 11, fill: '#45464d' }} />
                        <Tooltip contentStyle={{ borderRadius: '8px', border: '1px solid #c6c6cd', fontSize: '13px' }} />
                        <Line type="monotone" dataKey="peso" stroke="#0058be" strokeWidth={2.5}
                          dot={{ r: 4, fill: '#0058be' }} activeDot={{ r: 6 }} />
                      </LineChart>
                    </ResponsiveContainer>
                  ) : (
                    <div className="h-[220px] flex items-center justify-center text-on-surface-variant text-sm">
                      {metricas.length === 0
                        ? 'El cliente aún no ha registrado métricas.'
                        : 'Se necesitan al menos 2 registros para mostrar la gráfica.'}
                    </div>
                  )}
                </div>

                {/* History table */}
                {metricas.length > 0 && (
                  <div className="bg-surface-container-lowest rounded-xl border border-outline-variant/30 overflow-hidden"
                    style={{ boxShadow: '0 4px 15px rgba(15,23,42,0.04)' }}>
                    <div className="px-md py-sm border-b border-outline-variant">
                      <h2 className="text-xl font-bold text-primary">Historial de métricas</h2>
                    </div>
                    <div className="overflow-x-auto">
                      <table className="w-full text-sm">
                        <thead>
                          <tr className="border-b border-outline-variant bg-surface-container-low">
                            <th className="text-left px-md py-sm text-xs font-bold text-on-surface-variant uppercase tracking-wide">Fecha</th>
                            <th className="text-right px-md py-sm text-xs font-bold text-on-surface-variant uppercase tracking-wide">Peso (kg)</th>
                            <th className="text-right px-md py-sm text-xs font-bold text-on-surface-variant uppercase tracking-wide">Cintura (cm)</th>
                            <th className="text-right px-md py-sm text-xs font-bold text-on-surface-variant uppercase tracking-wide">Cadera (cm)</th>
                            <th className="text-left px-md py-sm text-xs font-bold text-on-surface-variant uppercase tracking-wide">Notas</th>
                          </tr>
                        </thead>
                        <tbody className="divide-y divide-outline-variant">
                          {metricas.map(m => (
                            <tr key={m.id} className="hover:bg-surface-container-low transition-colors">
                              <td className="px-md py-sm font-semibold text-on-surface">{m.fecha}</td>
                              <td className="px-md py-sm text-right font-bold text-primary">{m.peso}</td>
                              <td className="px-md py-sm text-right text-on-surface">{m.medidaCintura ?? '—'}</td>
                              <td className="px-md py-sm text-right text-on-surface">{m.medidaCadera ?? '—'}</td>
                              <td className="px-md py-sm text-on-surface-variant italic text-xs max-w-[200px] truncate">{m.notas || '—'}</td>
                            </tr>
                          ))}
                        </tbody>
                      </table>
                    </div>
                  </div>
                )}

                {metricas.length === 0 && (
                  <p className="text-on-surface-variant text-sm">El cliente aún no ha registrado métricas.</p>
                )}
              </>
            )}
          </div>
        )}
      </section>
    </div>
  )
}
