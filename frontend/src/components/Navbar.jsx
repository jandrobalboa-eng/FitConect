import { Link, useNavigate } from 'react-router-dom'
import { useAuth } from '../context/AuthContext'

export default function Navbar() {
  const { user, logout } = useAuth()
  const navigate = useNavigate()

  function handleLogout() {
    logout()
    navigate('/login')
  }

  if (!user) return null

  return (
    <nav className="bg-blue-600 text-white px-6 py-3 flex items-center justify-between">
      <span className="font-bold text-lg">FitConnect</span>
      <div className="flex items-center gap-4 text-sm">
        {user.rol === 'entrenador' && (
          <>
            <Link to="/" className="hover:underline">Dashboard</Link>
            <Link to="/ejercicios" className="hover:underline">Ejercicios</Link>
            <Link to="/crear-rutina" className="hover:underline">Crear rutina</Link>
          </>
        )}
        {user.rol === 'cliente' && (
          <>
            <Link to="/" className="hover:underline">Dashboard</Link>
            <Link to="/mis-rutinas" className="hover:underline">Mis rutinas</Link>
            <Link to="/metricas" className="hover:underline">Métricas</Link>
            <Link to="/ejercicios" className="hover:underline">Ejercicios</Link>
          </>
        )}
        <span className="text-blue-200">{user.nombre}</span>
        <button onClick={handleLogout} className="bg-blue-800 px-3 py-1 rounded hover:bg-blue-900">
          Salir
        </button>
      </div>
    </nav>
  )
}
