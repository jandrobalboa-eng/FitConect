import { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { useAuth } from '../context/AuthContext'
import api from '../api/client'
import FitBot from '../components/FitBot'

export default function DashboardEntrenador() {
  const { user } = useAuth()
  const [tab, setTab] = useState('clientes')
  const [clientes, setClientes] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  useEffect(() => {
    api.get('/api/usuarios/clientes')
      .then(res => setClientes(res.data.data))
      .catch(() => setError('No se pudieron cargar los clientes'))
      .finally(() => setLoading(false))
  }, [])

  const firstName = user.nombre?.split(' ')[0] || user.nombre

  const tabClass = (key) =>
    `flex items-center gap-xs px-md py-sm text-sm font-semibold transition-colors border-b-2 ${
      tab === key
        ? 'border-secondary text-secondary'
        : 'border-transparent text-on-surface-variant hover:text-on-surface'
    }`

  return (
    <div className="flex-grow max-w-[1440px] w-full mx-auto px-10 py-lg space-y-xl">
      {/* Welcome Hero */}
      <section className="space-y-sm">
        <h1 className="text-5xl font-extrabold text-primary tracking-tight">Buenos días, {firstName}.</h1>
        <p className="text-on-surface-variant text-lg max-w-2xl">
          {user.especialidad || 'Panel de entrenador'} — Gestiona tus clientes y crea rutinas.
        </p>
      </section>

      {/* Quick actions */}
      <section className="grid grid-cols-1 md:grid-cols-2 gap-gutter">
        <Link
          to="/crear-rutina"
          className="group flex flex-col items-start p-md bg-primary-container rounded-xl hover:shadow-lg transition-all duration-300 text-left"
        >
          <div className="w-14 h-14 rounded-lg bg-secondary flex items-center justify-center text-white mb-md group-hover:scale-110 transition-transform">
            <span className="material-symbols-outlined text-[32px]">add_circle</span>
          </div>
          <h3 className="text-2xl font-bold text-white mb-xs">Crear rutina</h3>
          <p className="text-on-primary-container text-sm">Diseña y asigna programas de entrenamiento a tus clientes.</p>
          <div className="mt-lg self-end material-symbols-outlined text-secondary">arrow_forward</div>
        </Link>

        <Link
          to="/ejercicios"
          className="group flex flex-col items-start p-md bg-surface-container-lowest rounded-xl border border-outline-variant/30 hover:shadow-lg transition-all duration-300 text-left"
          style={{ boxShadow: '0 4px 15px rgba(15,23,42,0.05)' }}
        >
          <div className="w-14 h-14 rounded-lg bg-surface-container-highest flex items-center justify-center text-primary mb-md group-hover:scale-110 transition-transform">
            <span className="material-symbols-outlined text-[32px]">fitness_center</span>
          </div>
          <h3 className="text-2xl font-bold text-primary mb-xs">Ejercicios</h3>
          <p className="text-on-surface-variant text-sm">Consulta el catálogo de ejercicios disponibles.</p>
          <div className="mt-lg self-end material-symbols-outlined text-secondary opacity-0 group-hover:opacity-100 transition-opacity">
            arrow_forward
          </div>
        </Link>
      </section>

      {/* Tabs */}
      <section>
        <div className="flex gap-0 border-b border-outline-variant mb-lg">
          <button onClick={() => setTab('clientes')} className={tabClass('clientes')}>
            <span className="material-symbols-outlined text-[18px]">group</span>
            Mis clientes
          </button>
          <button onClick={() => setTab('fitbot')} className={tabClass('fitbot')}>
            <span className="material-symbols-outlined text-[18px]">smart_toy</span>
            FitBot
          </button>
        </div>

        {tab === 'clientes' && (
          <div className="space-y-md">
            <span className="text-sm text-on-surface-variant">{clientes.length} clientes activos</span>
            {loading && <p className="text-on-surface-variant text-sm">Cargando...</p>}
            {error && <p className="text-sm" style={{ color: '#ba1a1a' }}>{error}</p>}
            {!loading && !error && clientes.length === 0 && (
              <p className="text-on-surface-variant text-sm">No tienes clientes asignados aún.</p>
            )}
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-gutter">
              {clientes.map(cliente => {
                const initials = cliente.nombre
                  ? cliente.nombre.split(' ').map(n => n[0]).join('').slice(0, 2).toUpperCase()
                  : '?'
                return (
                  <div key={cliente.id}
                    className="bg-surface-container-lowest rounded-xl border border-outline-variant/30 p-md flex items-center gap-md hover:shadow-md transition-all"
                    style={{ boxShadow: '0 4px 15px rgba(15,23,42,0.04)' }}>
                    <div className="w-12 h-12 rounded-full bg-secondary-container flex items-center justify-center text-on-secondary-container font-bold text-base shrink-0">
                      {initials}
                    </div>
                    <div className="min-w-0">
                      <p className="font-bold text-on-surface">{cliente.nombre}</p>
                      <p className="text-sm text-on-surface-variant truncate">{cliente.email}</p>
                      {cliente.objetivo && (
                        <p className="text-xs text-secondary mt-1">Objetivo: {cliente.objetivo}</p>
                      )}
                    </div>
                  </div>
                )
              })}
            </div>
          </div>
        )}

        {tab === 'fitbot' && (
          <div className="bg-surface-container-lowest rounded-xl border border-outline-variant/30" style={{ boxShadow: '0 4px 15px rgba(15,23,42,0.04)' }}>
            <div className="p-md border-b border-outline-variant flex items-center gap-sm">
              <div className="w-10 h-10 rounded-full bg-secondary-container flex items-center justify-center shrink-0">
                <span className="material-symbols-outlined text-on-secondary-container">smart_toy</span>
              </div>
              <div>
                <p className="font-bold text-on-surface">FitBot</p>
                <p className="text-xs text-on-surface-variant">Asistente IA · Llama 3.3 70B via Groq</p>
              </div>
            </div>
            <FitBot />
          </div>
        )}
      </section>
    </div>
  )
}
