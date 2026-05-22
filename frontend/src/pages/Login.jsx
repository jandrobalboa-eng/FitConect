import { useState } from 'react'
import { useNavigate, Link } from 'react-router-dom'
import { useAuth } from '../context/AuthContext'

export default function Login() {
  const { login } = useAuth()
  const navigate = useNavigate()
  const [form, setForm] = useState({ email: '', password: '' })
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)
  const [showPassword, setShowPassword] = useState(false)

  async function handleSubmit(e) {
    e.preventDefault()
    setError('')
    setLoading(true)
    try {
      await login(form.email, form.password)
      navigate('/')
    } catch {
      setError('Email o contraseña incorrectos')
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
            <p className="text-lg text-on-surface-variant mt-2">Precision tracking for peak performance.</p>
          </div>

          <div
            className="bg-surface-container-lowest rounded-xl p-md md:p-lg border border-outline-variant/30"
            style={{ boxShadow: '0 4px 15px rgba(15,23,42,0.04), 0 10px 30px rgba(15,23,42,0.02)' }}
          >
            <form onSubmit={handleSubmit} className="space-y-6">
              <div className="space-y-1">
                <h2 className="text-2xl font-bold text-on-surface">Bienvenido de nuevo</h2>
                <p className="text-sm text-on-surface-variant">Introduce tus datos para acceder a tu panel.</p>
              </div>

              <div className="space-y-4">
                <div className="space-y-2">
                  <label className="block text-sm font-semibold tracking-wide text-on-surface-variant ml-1" htmlFor="email">
                    Correo electrónico
                  </label>
                  <div className="relative group">
                    <span className="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-on-surface-variant transition-colors group-focus-within:text-secondary select-none">
                      mail
                    </span>
                    <input
                      id="email"
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
                  <label className="block text-sm font-semibold tracking-wide text-on-surface-variant" htmlFor="password">
                    Contraseña
                  </label>
                  <div className="relative group">
                    <span className="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-on-surface-variant transition-colors group-focus-within:text-secondary select-none">
                      lock
                    </span>
                    <input
                      id="password"
                      type={showPassword ? 'text' : 'password'}
                      required
                      value={form.password}
                      onChange={e => setForm({ ...form, password: e.target.value })}
                      placeholder="••••••••"
                      className="w-full bg-surface-container-low border border-outline-variant rounded-lg py-3.5 pl-12 pr-12 text-base focus:ring-2 focus:ring-secondary/20 focus:border-secondary outline-none transition-all placeholder:text-on-surface-variant/50"
                    />
                    <button
                      type="button"
                      onClick={() => setShowPassword(v => !v)}
                      className="absolute right-4 top-1/2 -translate-y-1/2 text-on-surface-variant hover:text-on-surface transition-colors"
                    >
                      <span className="material-symbols-outlined">{showPassword ? 'visibility_off' : 'visibility'}</span>
                    </button>
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
                    Autenticando...
                  </>
                ) : (
                  <>
                    Iniciar sesión
                    <span className="material-symbols-outlined text-[20px] transition-transform group-hover:translate-x-1">arrow_forward</span>
                  </>
                )}
              </button>
            </form>

            <p className="text-center mt-8 text-sm text-on-surface-variant">
              ¿No tienes cuenta?{' '}
              <Link to="/register" className="text-secondary font-semibold hover:underline ml-1">
                Crear cuenta gratis
              </Link>
            </p>
          </div>
        </div>
      </main>

      <footer className="w-full py-8 border-t border-outline-variant bg-surface-container-low">
        <p className="text-center text-sm text-on-surface-variant opacity-60">© 2026 FitConnect Performance Systems</p>
      </footer>
    </div>
  )
}
