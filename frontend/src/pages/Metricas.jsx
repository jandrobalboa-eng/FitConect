import { useEffect, useState } from 'react'
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts'
import api from '../api/client'

export default function Metricas() {
  const [metricas, setMetricas] = useState([])
  const [loading, setLoading] = useState(true)
  const [form, setForm] = useState({ fecha: '', peso: '', medidaCintura: '', medidaCadera: '', notas: '' })
  const [guardando, setGuardando] = useState(false)
  const [mensaje, setMensaje] = useState('')

  function cargarMetricas() {
    setLoading(true)
    api.get('/api/metricas/mis-metricas')
      .then(res => setMetricas(res.data.data))
      .catch(() => {})
      .finally(() => setLoading(false))
  }

  useEffect(() => { cargarMetricas() }, [])

  async function handleSubmit(e) {
    e.preventDefault()
    setGuardando(true)
    setMensaje('')
    try {
      await api.post('/api/metricas', {
        ...form,
        peso: parseFloat(form.peso),
        medidaCintura: form.medidaCintura ? parseFloat(form.medidaCintura) : null,
        medidaCadera: form.medidaCadera ? parseFloat(form.medidaCadera) : null,
      })
      setMensaje('Métrica guardada correctamente')
      setForm({ fecha: '', peso: '', medidaCintura: '', medidaCadera: '', notas: '' })
      cargarMetricas()
    } catch {
      setMensaje('Error al guardar la métrica')
    } finally {
      setGuardando(false)
    }
  }

  const datosGrafica = [...metricas].reverse().map(m => ({ fecha: m.fecha, peso: m.peso }))
  const tendencia = metricas.length >= 2
    ? (metricas[0].peso - metricas[1].peso).toFixed(1)
    : null

  return (
    <div className="flex-grow max-w-[1440px] mx-auto w-full px-margin-desktop py-lg">
      <div className="grid grid-cols-1 md:grid-cols-12 gap-gutter items-start">

        {/* Left: Form + Tip */}
        <section className="md:col-span-4 space-y-gutter">
          <div
            className="bg-surface-container-lowest p-md rounded-xl shadow-sm border border-outline-variant/30"
          >
            <h2 className="text-2xl font-bold text-primary mb-sm">Registrar métrica</h2>
            <p className="text-sm text-on-surface-variant mb-md">
              Registra tus medidas regularmente para un seguimiento preciso.
            </p>
            <form onSubmit={handleSubmit} className="space-y-md">
              <div className="space-y-xs">
                <label className="block text-sm font-semibold text-on-surface">Fecha</label>
                <input
                  type="date"
                  required
                  value={form.fecha}
                  onChange={e => setForm({ ...form, fecha: e.target.value })}
                  className="w-full bg-surface-container-low border border-outline-variant rounded-lg px-4 py-3 focus:ring-2 focus:ring-secondary focus:border-secondary outline-none transition-all text-sm"
                />
              </div>
              <div className="space-y-xs">
                <label className="block text-sm font-semibold text-on-surface">Peso (kg)</label>
                <input
                  type="number"
                  step="0.1"
                  required
                  value={form.peso}
                  onChange={e => setForm({ ...form, peso: e.target.value })}
                  placeholder="75.0"
                  className="w-full bg-surface-container-low border border-outline-variant rounded-lg px-4 py-3 focus:ring-2 focus:ring-secondary focus:border-secondary outline-none transition-all text-sm"
                />
              </div>
              <div className="space-y-xs">
                <label className="block text-sm font-semibold text-on-surface">Cintura (cm)</label>
                <input
                  type="number"
                  step="0.1"
                  value={form.medidaCintura}
                  onChange={e => setForm({ ...form, medidaCintura: e.target.value })}
                  placeholder="82.0"
                  className="w-full bg-surface-container-low border border-outline-variant rounded-lg px-4 py-3 focus:ring-2 focus:ring-secondary focus:border-secondary outline-none transition-all text-sm"
                />
              </div>
              <div className="space-y-xs">
                <label className="block text-sm font-semibold text-on-surface">Cadera (cm)</label>
                <input
                  type="number"
                  step="0.1"
                  value={form.medidaCadera}
                  onChange={e => setForm({ ...form, medidaCadera: e.target.value })}
                  placeholder="95.0"
                  className="w-full bg-surface-container-low border border-outline-variant rounded-lg px-4 py-3 focus:ring-2 focus:ring-secondary focus:border-secondary outline-none transition-all text-sm"
                />
              </div>
              <div className="space-y-xs">
                <label className="block text-sm font-semibold text-on-surface">Notas</label>
                <textarea
                  value={form.notas}
                  onChange={e => setForm({ ...form, notas: e.target.value })}
                  rows={2}
                  placeholder="¿Cómo te encuentras hoy?"
                  className="w-full bg-surface-container-low border border-outline-variant rounded-lg px-4 py-3 focus:ring-2 focus:ring-secondary focus:border-secondary outline-none transition-all text-sm resize-none"
                />
              </div>
              {mensaje && (
                <p className={`text-sm ${mensaje.includes('Error') ? 'text-red-600' : 'text-green-600'}`}>
                  {mensaje}
                </p>
              )}
              <button
                type="submit"
                disabled={guardando}
                className="w-full bg-primary text-on-primary py-3 rounded-lg text-sm font-semibold tracking-wide active:scale-95 transition-transform hover:opacity-90 shadow-lg disabled:opacity-50"
              >
                {guardando ? 'Guardando...' : 'Guardar métrica'}
              </button>
            </form>
          </div>

          <div className="bg-primary-container p-md rounded-xl relative overflow-hidden">
            <div className="relative z-10">
              <span
                className="material-symbols-outlined text-secondary-fixed mb-sm block"
                style={{ fontVariationSettings: "'FILL' 1" }}
              >
                lightbulb
              </span>
              <h3 className="text-sm font-bold text-on-primary-container mb-xs">Consejo Pro</h3>
              <p className="text-sm text-on-primary-container opacity-80">
                Registra tus métricas a la misma hora cada mañana para obtener datos de tendencia más precisos.
              </p>
            </div>
            <div className="absolute -right-4 -bottom-4 opacity-10 pointer-events-none">
              <span className="material-symbols-outlined text-[120px] text-on-primary-container">monitoring</span>
            </div>
          </div>
        </section>

        {/* Right: Chart + History */}
        <section className="md:col-span-8 space-y-gutter">
          <div className="bg-surface-container-lowest p-md rounded-xl shadow-sm border border-outline-variant/30">
            <div className="flex justify-between items-end mb-md">
              <div>
                <h2 className="text-2xl font-bold text-primary">Evolución del peso</h2>
                <p className="text-sm text-on-surface-variant">Historial completo</p>
              </div>
              {tendencia !== null && (
                <span
                  className="px-3 py-1 text-xs font-bold rounded-full"
                  style={{
                    background: parseFloat(tendencia) <= 0 ? '#d8e2ff' : '#ffdad6',
                    color: parseFloat(tendencia) <= 0 ? '#001a42' : '#93000a',
                  }}
                >
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
                  <Tooltip
                    contentStyle={{ borderRadius: '8px', border: '1px solid #c6c6cd', fontSize: '13px' }}
                  />
                  <Line
                    type="monotone"
                    dataKey="peso"
                    stroke="#0058be"
                    strokeWidth={2.5}
                    dot={{ r: 4, fill: '#0058be' }}
                    activeDot={{ r: 6 }}
                  />
                </LineChart>
              </ResponsiveContainer>
            ) : (
              <div className="h-[220px] flex items-center justify-center text-on-surface-variant text-sm">
                Registra al menos 2 métricas para ver la gráfica.
              </div>
            )}
          </div>

          <div className="bg-surface-container-lowest rounded-xl shadow-sm border border-outline-variant/30 overflow-hidden">
            <div className="px-md py-sm border-b border-outline-variant">
              <h2 className="text-2xl font-bold text-primary">Historial</h2>
            </div>
            {loading && <p className="text-on-surface-variant text-sm px-md py-md">Cargando...</p>}
            {!loading && metricas.length === 0 && (
              <p className="text-on-surface-variant text-sm px-md py-md">Aún no tienes métricas registradas.</p>
            )}
            {metricas.length > 0 && (
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
            )}
          </div>
        </section>
      </div>
    </div>
  )
}
