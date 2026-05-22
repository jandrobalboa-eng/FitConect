import { useEffect, useState } from 'react'
import { BarChart, Bar, XAxis, YAxis, Tooltip, ResponsiveContainer, PieChart, Pie, Cell } from 'recharts'
import api from '../api/client'

const COLORES = ['#4ade80', '#22c55e', '#16a34a']

export default function DashboardAdmin() {
  const [stats, setStats] = useState(null)
  const [cargando, setCargando] = useState(true)

  useEffect(() => {
    api.get('/api/planes/stats')
      .then(r => setStats(r.data.data))
      .catch(() => setStats(null))
      .finally(() => setCargando(false))
  }, [])

  if (cargando) {
    return (
      <div className="min-h-screen bg-gray-950 flex items-center justify-center">
        <div className="animate-spin w-8 h-8 border-2 border-green-500 border-t-transparent rounded-full" />
      </div>
    )
  }

  if (!stats) {
    return (
      <div className="min-h-screen bg-gray-950 text-white flex items-center justify-center">
        <p className="text-gray-400">No tienes acceso a esta sección.</p>
      </div>
    )
  }

  const dist = stats.distribucion
  const barData = [
    { name: 'Básico', cantidad: dist.basico.cantidad, ingresos: Number(dist.basico.ingresos) },
    { name: 'Pro',    cantidad: dist.pro.cantidad,    ingresos: Number(dist.pro.ingresos) },
    { name: 'Premium',cantidad: dist.premium.cantidad,ingresos: Number(dist.premium.ingresos) },
  ]
  const pieData = barData.filter(d => d.cantidad > 0)

  const kpis = [
    { label: 'MRR', valor: `€${Number(stats.mrr).toFixed(0)}`, sub: 'Ingresos mensuales recurrentes', color: 'text-green-400' },
    { label: 'ARR', valor: `€${Number(stats.arr).toFixed(0)}`, sub: 'Ingresos anuales proyectados', color: 'text-green-300' },
    { label: 'Ticket medio', valor: `€${Number(stats.ticketMedio).toFixed(2)}`, sub: 'Por entrenador/mes', color: 'text-blue-400' },
    { label: 'Suscripciones', valor: stats.totalSuscripciones, sub: 'Planes activos', color: 'text-purple-400' },
  ]

  return (
    <div className="min-h-screen bg-gray-950 text-white p-6">
      <div className="max-w-6xl mx-auto">

        {/* Header */}
        <div className="mb-8">
          <h1 className="text-3xl font-bold">Panel de Control</h1>
          <p className="text-gray-400 mt-1">Métricas financieras de FitConnect</p>
        </div>

        {/* KPIs */}
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-8">
          {kpis.map(kpi => (
            <div key={kpi.label} className="bg-gray-900 rounded-xl p-5 border border-gray-800">
              <p className="text-gray-400 text-xs uppercase tracking-wider">{kpi.label}</p>
              <p className={`text-3xl font-bold mt-1 ${kpi.color}`}>{kpi.valor}</p>
              <p className="text-gray-500 text-xs mt-1">{kpi.sub}</p>
            </div>
          ))}
        </div>

        {/* Usuarios */}
        <div className="grid grid-cols-3 gap-4 mb-8">
          {[
            { label: 'Usuarios totales', valor: stats.usuarios.total, icon: '👥' },
            { label: 'Entrenadores', valor: stats.usuarios.entrenadores, icon: '💪' },
            { label: 'Clientes', valor: stats.usuarios.clientes, icon: '🏃' },
          ].map(u => (
            <div key={u.label} className="bg-gray-900 rounded-xl p-5 border border-gray-800 text-center">
              <span className="text-3xl">{u.icon}</span>
              <p className="text-2xl font-bold mt-2">{u.valor}</p>
              <p className="text-gray-400 text-sm mt-1">{u.label}</p>
            </div>
          ))}
        </div>

        {/* Gráficas */}
        <div className="grid md:grid-cols-2 gap-6">

          {/* Ingresos por plan */}
          <div className="bg-gray-900 rounded-xl p-6 border border-gray-800">
            <h2 className="font-semibold mb-4 text-gray-200">Ingresos por plan (€/mes)</h2>
            <ResponsiveContainer width="100%" height={220}>
              <BarChart data={barData} barSize={40}>
                <XAxis dataKey="name" stroke="#6b7280" tick={{ fill: '#9ca3af', fontSize: 12 }} />
                <YAxis stroke="#6b7280" tick={{ fill: '#9ca3af', fontSize: 12 }} />
                <Tooltip
                  contentStyle={{ background: '#111827', border: '1px solid #374151', borderRadius: 8 }}
                  formatter={(v) => [`€${v}`, 'Ingresos']}
                />
                <Bar dataKey="ingresos" radius={[6, 6, 0, 0]}>
                  {barData.map((_, i) => <Cell key={i} fill={COLORES[i]} />)}
                </Bar>
              </BarChart>
            </ResponsiveContainer>
          </div>

          {/* Distribución de planes */}
          <div className="bg-gray-900 rounded-xl p-6 border border-gray-800">
            <h2 className="font-semibold mb-4 text-gray-200">Distribución de suscripciones</h2>
            {pieData.length === 0 ? (
              <div className="flex items-center justify-center h-48 text-gray-500">
                <p>Sin suscripciones activas todavía</p>
              </div>
            ) : (
              <div className="flex items-center gap-6">
                <ResponsiveContainer width="60%" height={200}>
                  <PieChart>
                    <Pie data={pieData} dataKey="cantidad" cx="50%" cy="50%" outerRadius={80} label={({ name, percent }) => `${(percent*100).toFixed(0)}%`}>
                      {pieData.map((_, i) => <Cell key={i} fill={COLORES[i]} />)}
                    </Pie>
                    <Tooltip
                      contentStyle={{ background: '#111827', border: '1px solid #374151', borderRadius: 8 }}
                      formatter={(v) => [v, 'Entrenadores']}
                    />
                  </PieChart>
                </ResponsiveContainer>
                <div className="flex flex-col gap-3">
                  {barData.map((d, i) => (
                    <div key={d.name} className="flex items-center gap-2 text-sm">
                      <span className="w-3 h-3 rounded-full" style={{ background: COLORES[i] }} />
                      <span className="text-gray-300">{d.name}</span>
                      <span className="text-gray-500 ml-1">{d.cantidad} entrenadores</span>
                    </div>
                  ))}
                </div>
              </div>
            )}
          </div>

        </div>

        {/* Tabla detalle planes */}
        <div className="mt-6 bg-gray-900 rounded-xl border border-gray-800 overflow-hidden">
          <div className="p-5 border-b border-gray-800">
            <h2 className="font-semibold text-gray-200">Detalle por plan</h2>
          </div>
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-gray-800 text-gray-400">
                <th className="text-left p-4">Plan</th>
                <th className="text-right p-4">Precio/mes</th>
                <th className="text-right p-4">Entrenadores</th>
                <th className="text-right p-4">Ingresos/mes</th>
                <th className="text-right p-4">% del MRR</th>
              </tr>
            </thead>
            <tbody>
              {barData.map((d, i) => {
                const mrr = Number(stats.mrr)
                const pct = mrr > 0 ? ((d.ingresos / mrr) * 100).toFixed(1) : '0'
                const precios = [9, 19, 39]
                return (
                  <tr key={d.name} className="border-b border-gray-800/50 hover:bg-gray-800/30">
                    <td className="p-4">
                      <span className="flex items-center gap-2">
                        <span className="w-2 h-2 rounded-full" style={{ background: COLORES[i] }} />
                        {d.name}
                      </span>
                    </td>
                    <td className="p-4 text-right text-gray-300">€{precios[i]}</td>
                    <td className="p-4 text-right text-gray-300">{d.cantidad}</td>
                    <td className="p-4 text-right font-semibold" style={{ color: COLORES[i] }}>€{d.ingresos.toFixed(2)}</td>
                    <td className="p-4 text-right text-gray-400">{pct}%</td>
                  </tr>
                )
              })}
              <tr className="bg-gray-800/30 font-semibold">
                <td className="p-4 text-white">Total</td>
                <td className="p-4" />
                <td className="p-4 text-right text-white">{stats.totalSuscripciones}</td>
                <td className="p-4 text-right text-green-400">€{Number(stats.mrr).toFixed(2)}</td>
                <td className="p-4 text-right text-gray-400">100%</td>
              </tr>
            </tbody>
          </table>
        </div>

      </div>
    </div>
  )
}