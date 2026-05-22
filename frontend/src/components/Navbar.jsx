import { Link, useLocation, useNavigate } from 'react-router-dom'
import { useAuth } from '../context/AuthContext'

export default function Navbar() {
  const { user, logout } = useAuth()
  const navigate = useNavigate()
  const location = useLocation()

  function handleLogout() {
    logout()
    navigate('/login')
  }

  if (!user) return null

  const initials = user.nombre
    ? user.nombre.split(' ').map(n => n[0]).join('').slice(0, 2).toUpperCase()
    : '?'

  const isActive = (path) => location.pathname === path

  const linkClass = (path) =>
    `text-sm font-semibold tracking-wide transition-colors duration-200 ${
      isActive(path)
        ? 'text-secondary border-b-2 border-secondary pb-0.5'
        : 'text-on-surface-variant hover:text-secondary'
    }`

  return (
    <header className="bg-surface sticky top-0 z-50 shadow-sm">
      <nav className="flex justify-between items-center w-full px-10 py-4 max-w-[1440px] mx-auto">
        <Link to="/" className="font-extrabold text-2xl text-primary tracking-tight">FitConnect</Link>

        <div className="hidden md:flex items-center gap-lg">
          {user.rol === 'entrenador' && (
            <>
              <Link to="/" className={linkClass('/')}>Dashboard</Link>
              <Link to="/ejercicios" className={linkClass('/ejercicios')}>Ejercicios</Link>
              <Link to="/crear-rutina" className={linkClass('/crear-rutina')}>Crear rutina</Link>
               <Link to="/precios" className={linkClass('/precios')}>Precios</Link>
            </>
          )}
          {user.rol === 'cliente' && (
            <>
              <Link to="/" className={linkClass('/')}>Dashboard</Link>
              <Link to="/mis-rutinas" className={linkClass('/mis-rutinas')}>Rutinas</Link>
              <Link to="/metricas" className={linkClass('/metricas')}>Métricas</Link>
              <Link to="/ejercicios" className={linkClass('/ejercicios')}>Ejercicios</Link>
             
            </>
          )}
        </div>

        <div className="flex items-center gap-sm">
          <div className="w-9 h-9 rounded-full bg-secondary-container flex items-center justify-center text-on-secondary-container text-sm font-bold shrink-0">
            {initials}
          </div>
          <span className="hidden md:block text-sm text-on-surface-variant">{user.nombre}</span>
          <button
            onClick={handleLogout}
            className="material-symbols-outlined text-on-surface-variant hover:text-error transition-colors ml-1"
            title="Cerrar sesión"
          >
            logout
          </button>
        </div>
      </nav>
    </header>
  )
}
