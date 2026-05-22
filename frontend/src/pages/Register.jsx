import { useState } from 'react'
import { useNavigate, Link } from 'react-router-dom'
import { useAuth } from '../context/AuthContext'

export default function Register() {
  const { register } = useAuth()
  const navigate = useNavigate()
  const [form, setForm] = useState({ nombre: '', email: '', password: '', rol: 'cliente' })
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)

  async function handleSubmit(e) {
    e.preventDefault()
    setError('')
    setLoading(true)
    try {
      await register(form)
      navigate('/')
    } catch (err) {
      setError(err.response?.data?.message || 'Error al registrarse')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="bg-surface text-on-surface min-h-screen flex flex-col">
      <main className="flex-grow flex items-center justify-center px-margin-mobile md:px-margin-desktop py-xl relative overflow-hidden">
        <div className="absolute top-[-10%] left-[-10%] w-[40%] h-[40%] bg-secondary-fixed/10 rounded-full blur-[120px] pointer-events-none" />
        <div className="absolute bottom-[-10%] right-[-10%] w-[30%] h-[30%] bg-primary-fixed/20 rounded-full blur-[100px] pointer-events-none" />

        <div className="w-full max-w-[480px] z-10">
          <div className="text-center mb-10">
            <h1 className="text-5xl font-extrabold text-primary tracking-tight">FitConnect</h1>
            <p className="text-lg text-on-surface-variant mt-2">Empieza tu camino hacia el rendimiento máximo.</p>
          </div>

          <div
            className="bg-surface-container-lowest rounded-xl p-md md:p-lg border border-outline-variant/30"
            style={{ boxShadow: '0 4px 15px rgba(15,23,42,0.04), 0 10px 30px rgba(15,23,42,0.02)' }}
          >
            <form onSubmit={handleSubmit} className="space-y-6">
              <div className="space-y-1">
                <h2 className="text-2xl font-bold text-on-surface">Crear cuenta</h2>
                <p className="text-sm text-on-surface-variant">Rellena tus datos para empezar.</p>
              </div>

              <div className="space-y-4">
                <div className="space-y-2">
                  <label className="block text-sm font-semibold tracking-wide text-on-surface-variant ml-1">Nombre completo</label>
                  <div className="relative group">
                    <span className="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-on-surface-variant transition-colors group-focus-within:text-secondary select-none">
                      person
                    </span>
                    <input
                      type="text"
                      required
                      value={form.nombre}
                      onChange={e => setForm({ ...form, nombre: e.target.value })}
                      placeholder="Tu nombre completo"
                      className="w-full bg-surface-container-low border border-outline-variant rounded-lg py-3.5 pl-12 pr-4 text-base focus:ring-2 focus:ring-secondary/20 focus:border-secondary outline-none transition-all placeholder:text-on-surface-variant/50"
                    />
                  </div>
                </div>

                <div className="space-y-2">
                  <label className="block text-sm font-semibold tracking-wide text-on-surface-variant ml-1">Correo electrónico</label>
                  <div className="relative group">
                    <span className="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-on-surface-variant transition-colors group-focus-within:text-secondary select-none">
                      mail
                    </span>
                    <input
                      type="email"
                      required
                      value={form.email}
                      onChange={e => setForm({ ...form, email: e.target.value })}
                      placeholder="nombre@ejemplo.com"
                      className="w-full bg-surface-container-low border border-outline-variant rounded-lg py-3.5 pl-12 pr-4 text-base focus:ring-2 focus:ring-secondary/20 focus:border-secondary outline-none transition-all placeholder:text-on-surface-variant/50"
                    />
                  </div>
                </div>

                <div className="space-y-2">
                  <label className="block text-sm font-semibold tracking-wide text-on-surface-variant ml-1">Contraseña</label>
                  <div className="relative group">
                    <span className="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-on-surface-variant transition-colors group-focus-within:text-secondary select-none">
                      lock
                    </span>
                    <input
                      type="password"
                      required
                      value={form.password}
                      onChange={e => setForm({ ...form, password: e.target.value })}
                      placeholder="••••••••"
                      className="w-full bg-surface-container-low border border-outline-variant rounded-lg py-3.5 pl-12 pr-4 text-base focus:ring-2 focus:ring-secondary/20 focus:border-secondary outline-none transition-all placeholder:text-on-surface-variant/50"
                    />
                  </div>
                </div>

                <div className="space-y-2">
                  <label className="block text-sm font-semibold tracking-wide text-on-surface-variant ml-1">Tipo de cuenta</label>
                  <div className="relative group">
                    <span className="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-on-surface-variant transition-colors group-focus-within:text-secondary select-none">
                      badge
                    </span>
                    <select
                      value={form.rol}
                      onChange={e => setForm({ ...form, rol: e.target.value })}
                      className="w-full bg-surface-container-low border border-outline-variant rounded-lg py-3.5 pl-12 pr-4 text-base focus:ring-2 focus:ring-secondary/20 focus:border-secondary outline-none transition-all appearance-none"
                    >
                      <option value="cliente">Cliente</option>
                      <option value="entrenador">Entrenador</option>
                    </select>
                  </div>
                </div>
              </div>

              {error && <p className="text-sm" style={{ color: '#ba1a1a' }}>{error}</p>}

              <button
                type="submit"
                disabled={loading}
                className="w-full bg-primary-container text-on-primary font-semibold tracking-wide py-4 rounded-lg shadow-sm hover:bg-primary transition-all active:scale-[0.98] flex items-center justify-center gap-2 group disabled:opacity-50"
              >
                {loading ? (
                  <>
                    <span className="material-symbols-outlined text-[20px] animate-spin">progress_activity</span>
                    Creando cuenta...
                  </>
                ) : (
                  <>
                    Crear cuenta
                    <span className="material-symbols-outlined text-[20px] transition-transform group-hover:translate-x-1">arrow_forward</span>
                  </>
                )}
              </button>
            </form>

            <p className="text-center mt-8 text-sm text-on-surface-variant">
              ¿Ya tienes cuenta?{' '}
              <Link to="/login" className="text-secondary font-semibold hover:underline ml-1">
                Iniciar sesión
              </Link>
            </p>
          </div>
        </div>
      </main>

      <footer className="w-full py-8 border-t border-outline-variant bg-surface-container-low">
        <p className="text-center text-sm text-on-surface-variant opacity-60">© 2024 FitConnect Performance Systems</p>
      </footer>
    </div>
  )
}
