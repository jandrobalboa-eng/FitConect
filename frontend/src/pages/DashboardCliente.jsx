import { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { useAuth } from '../context/AuthContext'
import api from '../api/client'
import FitBot from '../components/FitBot'

export default function DashboardCliente() {
  const { user } = useAuth()
  const [rutinas, setRutinas] = useState([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    api.get('/api/rutinas/mis-rutinas')
      .then(res => setRutinas(res.data.data))
      .catch(() => {})
      .finally(() => setLoading(false))
  }, [])

  const firstName = user.nombre?.split(' ')[0] || user.nombre

  return (
    <div className="flex-grow max-w-[1440px] w-full mx-auto px-10 py-lg space-y-xl">
      {/* Welcome Hero */}
      <section className="space-y-sm">
        <h1 className="text-5xl font-extrabold text-primary tracking-tight">Buenos días, {firstName}.</h1>
        <p className="text-on-surface-variant text-lg max-w-2xl">
          {user.objetivo ? `Objetivo: ${user.objetivo}` : 'Tu panel de rendimiento está listo.'}
        </p>
      </section>

      {/* Shortcut Cards */}
      <section className="grid grid-cols-1 md:grid-cols-3 gap-gutter">
        <Link
          to="/mis-rutinas"
          className="group flex flex-col items-start p-md bg-surface-container-lowest rounded-xl border border-outline-variant/30 hover:shadow-lg transition-all duration-300 text-left"
          style={{ boxShadow: '0 4px 15px rgba(15,23,42,0.05)' }}
        >
          <div className="w-14 h-14 rounded-lg bg-secondary-container flex items-center justify-center text-on-secondary-container mb-md group-hover:scale-110 transition-transform">
            <span className="material-symbols-outlined text-[32px]">calendar_today</span>
          </div>
          <h3 className="text-2xl font-bold text-primary mb-xs">Rutinas</h3>
          <p className="text-on-surface-variant text-sm">Accede a tus programas de entrenamiento semanales.</p>
          <div className="mt-lg self-end material-symbols-outlined text-secondary opacity-0 group-hover:opacity-100 transition-opacity">
            arrow_forward
          </div>
        </Link>

        <Link
          to="/metricas"
          className="group flex flex-col items-start p-md bg-primary-container rounded-xl hover:shadow-lg transition-all duration-300 text-left"
        >
          <div className="w-14 h-14 rounded-lg bg-secondary flex items-center justify-center text-white mb-md group-hover:scale-110 transition-transform">
            <span className="material-symbols-outlined text-[32px]">monitoring</span>
          </div>
          <h3 className="text-2xl font-bold text-white mb-xs">Métricas</h3>
          <p className="text-on-primary-container text-sm">Explora tus datos fisiológicos y tu progreso.</p>
          <div className="mt-lg self-end material-symbols-outlined text-secondary">trending_up</div>
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
          <p className="text-on-surface-variant text-sm">Explora el catálogo de movimientos y guías.</p>
          <div className="mt-lg self-end material-symbols-outlined text-secondary opacity-0 group-hover:opacity-100 transition-opacity">
            arrow_forward
          </div>
        </Link>
      </section>

      {/* Recently Assigned Routines */}
      <section className="space-y-md">
        <div className="flex justify-between items-end border-b border-outline-variant pb-md">
          <h2 className="text-2xl font-bold text-primary">Rutinas asignadas recientemente</h2>
          <Link to="/mis-rutinas" className="text-secondary text-sm font-semibold hover:underline">
            Ver todas
          </Link>
        </div>

        {loading && <p className="text-on-surface-variant text-sm">Cargando...</p>}
        {!loading && rutinas.length === 0 && (
          <p className="text-on-surface-variant text-sm">Tu entrenador aún no te ha asignado ninguna rutina.</p>
        )}

        <div className="grid grid-cols-1 gap-base">
          {rutinas.slice(0, 3).map(rutina => (
            <div
              key={rutina.id}
              className="flex flex-col md:flex-row md:items-center justify-between p-md bg-surface hover:bg-surface-container-low transition-colors rounded-lg cursor-default border-b border-outline-variant/20"
            >
              <div className="flex items-center gap-md">
                <div className="w-12 h-12 rounded-lg bg-secondary-container flex items-center justify-center text-on-secondary-container shrink-0">
                  <span className="material-symbols-outlined">fitness_center</span>
                </div>
                <div>
                  <p className="text-xs font-bold text-secondary uppercase tracking-widest mb-xs">
                    {rutina.entrenadorNombre}
                  </p>
                  <h4 className="text-xl font-bold text-primary">{rutina.nombre}</h4>
                  {rutina.descripcion && (
                    <p className="text-sm text-on-surface-variant mt-0.5">{rutina.descripcion}</p>
                  )}
                </div>
              </div>
              <div className="mt-md md:mt-0 text-right shrink-0">
                <p className="text-xs text-on-surface-variant">Asignada el</p>
                <p className="text-base font-bold text-primary">{rutina.fechaAsignacion}</p>
              </div>
            </div>
          ))}
        </div>
      </section>

      {/* FitBot */}
      <section>
        <div className="flex items-center gap-sm border-b border-outline-variant pb-md mb-lg">
          <span className="material-symbols-outlined text-secondary">smart_toy</span>
          <h2 className="text-2xl font-bold text-primary">FitBot</h2>
        </div>

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
      </section>
    </div>
  )
}
