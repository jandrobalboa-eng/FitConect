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

  return (
    <div className="p-6 max-w-4xl mx-auto">
      <h2 className="text-2xl font-bold text-gray-800 mb-6">Mis métricas</h2>

      {datosGrafica.length > 1 && (
        <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-4 mb-6">
          <h3 className="text-sm font-semibold text-gray-600 mb-3">Evolución del peso (kg)</h3>
          <ResponsiveContainer width="100%" height={200}>
            <LineChart data={datosGrafica}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="fecha" tick={{ fontSize: 11 }} />
              <YAxis domain={['auto', 'auto']} tick={{ fontSize: 11 }} />
              <Tooltip />
              <Line type="monotone" dataKey="peso" stroke="#2563eb" strokeWidth={2} dot={{ r: 3 }} />
            </LineChart>
          </ResponsiveContainer>
        </div>
      )}

      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-4">
          <h3 className="text-lg font-semibold text-gray-700 mb-4">Registrar nueva métrica</h3>
          <form onSubmit={handleSubmit} className="space-y-3">
            <div>
              <label className="block text-sm text-gray-600 mb-1">Fecha</label>
              <input type="date" required value={form.fecha}
                onChange={e => setForm({ ...form, fecha: e.target.value })}
                className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm" />
            </div>
            <div>
              <label className="block text-sm text-gray-600 mb-1">Peso (kg)</label>
              <input type="number" step="0.1" required value={form.peso}
                onChange={e => setForm({ ...form, peso: e.target.value })}
                className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm" />
            </div>
            <div>
              <label className="block text-sm text-gray-600 mb-1">Cintura (cm)</label>
              <input type="number" step="0.1" value={form.medidaCintura}
                onChange={e => setForm({ ...form, medidaCintura: e.target.value })}
                className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm" />
            </div>
            <div>
              <label className="block text-sm text-gray-600 mb-1">Cadera (cm)</label>
              <input type="number" step="0.1" value={form.medidaCadera}
                onChange={e => setForm({ ...form, medidaCadera: e.target.value })}
                className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm" />
            </div>
            <div>
              <label className="block text-sm text-gray-600 mb-1">Notas</label>
              <textarea value={form.notas}
                onChange={e => setForm({ ...form, notas: e.target.value })}
                rows={2}
                className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm" />
            </div>
            {mensaje && <p className={mensaje.includes('Error') ? 'text-red-500 text-sm' : 'text-green-600 text-sm'}>{mensaje}</p>}
            <button type="submit" disabled={guardando}
              className="w-full bg-blue-600 text-white py-2 rounded-lg hover:bg-blue-700 disabled:opacity-50 text-sm">
              {guardando ? 'Guardando...' : 'Guardar métrica'}
            </button>
          </form>
        </div>

        <div>
          <h3 className="text-lg font-semibold text-gray-700 mb-4">Historial</h3>
          {loading && <p className="text-gray-400 text-sm">Cargando...</p>}
          <div className="space-y-2">
            {metricas.map(m => (
              <div key={m.id} className="bg-white rounded-lg border border-gray-200 p-3">
                <div className="flex justify-between items-center">
                  <span className="text-sm font-medium text-gray-700">{m.fecha}</span>
                  <span className="text-blue-600 font-bold">{m.peso} kg</span>
                </div>
                {(m.medidaCintura || m.medidaCadera) && (
                  <p className="text-xs text-gray-500 mt-1">
                    {m.medidaCintura && `Cintura: ${m.medidaCintura}cm`}
                    {m.medidaCintura && m.medidaCadera && ' · '}
                    {m.medidaCadera && `Cadera: ${m.medidaCadera}cm`}
                  </p>
                )}
                {m.notas && <p className="text-xs text-gray-400 mt-1 italic">"{m.notas}"</p>}
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  )
}
