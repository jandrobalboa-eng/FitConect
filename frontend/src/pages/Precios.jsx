import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import api from '../api/client'

const planes = [
  {
    tipo: 'BASICO',
    nombre: 'Básico',
    precio: 9,
    maxClientes: 5,
    descripcion: 'Perfecto para empezar tu carrera como entrenador online',
    features: [
      'Hasta 5 clientes',
      'Rutinas personalizadas',
      'Chat con clientes',
      'Soporte por email',
    ],
    destacado: false,
    color: 'border-gray-600',
    badge: null,
  },
  {
    tipo: 'PRO',
    nombre: 'Pro',
    precio: 19,
    maxClientes: 15,
    descripcion: 'Para entrenadores en crecimiento con más clientes',
    features: [
      'Hasta 15 clientes',
      'Todo lo del Básico',
      'Planes de alimentación',
      'Métricas avanzadas',
      'Soporte prioritario',
    ],
    destacado: true,
    color: 'border-green-500',
    badge: 'Más popular',
  },
  {
    tipo: 'PREMIUM',
    nombre: 'Premium',
    precio: 39,
    maxClientes: 999,
    descripcion: 'Sin límites para entrenadores profesionales',
    features: [
      'Clientes ilimitados',
      'Todo lo del Pro',
      'Informes semanales automáticos',
      'Acceso API',
      'Soporte 24/7',
    ],
    destacado: false,
    color: 'border-yellow-500',
    badge: '⚡ Pro máximo',
  },
]

export default function Precios() {
  const navigate = useNavigate()
  const [cargando, setCargando] = useState(null)
  const [exito, setExito] = useState(null)

  const handleSuscribir = async (tipo) => {
    const token = localStorage.getItem('token')
    if (!token) {
      navigate('/register')
      return
    }
    setCargando(tipo)
    try {
      await api.post(`/api/planes/suscribir/${tipo}`)
      setExito(tipo)
setTimeout(() => navigate('/'), 1500)    } catch (e) {
      alert(e.response?.data?.message || 'Error al suscribirse')
    } finally {
      setCargando(null)
    }
  }

  return (
    <div className="min-h-screen bg-gray-950 text-white">
      {/* Header */}
      <div className="text-center py-16 px-4">
        <span className="bg-green-500/20 text-green-400 text-sm font-medium px-4 py-1.5 rounded-full border border-green-500/30">
          Planes y precios
        </span>
        <h1 className="mt-6 text-4xl md:text-5xl font-bold">
          Elige tu plan y{' '}
          <span className="text-green-400">empieza hoy</span>
        </h1>
        <p className="mt-4 text-gray-400 text-lg max-w-2xl mx-auto">
          Sin permanencias. Cancela cuando quieras. 14 días de prueba gratis.
        </p>
      </div>

      {/* Cards */}
      <div className="max-w-6xl mx-auto px-4 pb-20 grid md:grid-cols-3 gap-8">
        {planes.map((plan) => (
          <div
            key={plan.tipo}
            className={`relative rounded-2xl border-2 ${plan.color} p-8 flex flex-col
              ${plan.destacado ? 'bg-gray-900 shadow-2xl shadow-green-500/10 scale-105' : 'bg-gray-900/50'}`}
          >
            {/* Badge */}
            {plan.badge && (
              <div className={`absolute -top-4 left-1/2 -translate-x-1/2 
                ${plan.destacado ? 'bg-green-500 text-black' : 'bg-yellow-500 text-black'}
                text-xs font-bold px-4 py-1.5 rounded-full`}>
                {plan.badge}
              </div>
            )}

            {/* Nombre y precio */}
            <div className="mb-6">
              <h2 className="text-xl font-bold text-white">{plan.nombre}</h2>
              <p className="text-gray-400 text-sm mt-1">{plan.descripcion}</p>
              <div className="mt-4 flex items-end gap-1">
                <span className="text-5xl font-extrabold text-white">€{plan.precio}</span>
                <span className="text-gray-400 mb-2">/mes</span>
              </div>
              <p className="text-xs text-gray-500 mt-1">
                {plan.maxClientes < 999
                  ? `Hasta ${plan.maxClientes} clientes`
                  : 'Clientes ilimitados'}
              </p>
            </div>

            {/* Features */}
            <ul className="flex-1 space-y-3 mb-8">
              {plan.features.map((f) => (
                <li key={f} className="flex items-center gap-2 text-sm text-gray-300">
                  <span className="text-green-400 font-bold">✓</span>
                  {f}
                </li>
              ))}
            </ul>

            {/* CTA */}
            <button
              onClick={() => handleSuscribir(plan.tipo)}
              disabled={cargando === plan.tipo || exito === plan.tipo}
              className={`w-full py-3 rounded-xl font-semibold text-sm transition-all
                ${plan.destacado
                  ? 'bg-green-500 hover:bg-green-400 text-black'
                  : 'bg-gray-700 hover:bg-gray-600 text-white'}
                ${(cargando === plan.tipo || exito === plan.tipo) ? 'opacity-60 cursor-not-allowed' : ''}`}
            >
              {exito === plan.tipo
                ? '✓ Activado'
                : cargando === plan.tipo
                ? 'Procesando...'
                : 'Empezar ahora'}
            </button>
          </div>
        ))}
      </div>

      {/* Garantía */}
      <div className="text-center pb-16 text-gray-500 text-sm">
        <p>💳 Sin tarjeta de crédito para la prueba · 🔒 Pago seguro · ↩️ Cancelación inmediata</p>
      </div>
    </div>
  )
}