import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom'
import { AuthProvider, useAuth } from './context/AuthContext'
import Navbar from './components/Navbar'
import PrivateRoute from './components/PrivateRoute'
import Login from './pages/Login'
import Register from './pages/Register'
import DashboardEntrenador from './pages/DashboardEntrenador'
import DashboardCliente from './pages/DashboardCliente'
import CrearRutina from './pages/CrearRutina'
import MisRutinas from './pages/MisRutinas'
import Metricas from './pages/Metricas'
import Ejercicios from './pages/Ejercicios'

function HomeRedirect() {
  const { user } = useAuth()
  if (!user) return <Navigate to="/login" replace />
  return user.rol === 'entrenador'
    ? <DashboardEntrenador />
    : <DashboardCliente />
}

export default function App() {
  return (
    <AuthProvider>
      <BrowserRouter>
        <div className="min-h-screen bg-background flex flex-col">
          <Navbar />
          <Routes>
            <Route path="/login" element={<Login />} />
            <Route path="/register" element={<Register />} />

            <Route path="/" element={
              <PrivateRoute><HomeRedirect /></PrivateRoute>
            } />

            <Route path="/precios" element={
              <PrivateRoute><Precios /></PrivateRoute>
            } />

            <Route path='/admin' element={
                <PrivateRoute><DashboardAdmin /></PrivateRoute>
            } />

            <Route path="/ejercicios" element={
              <PrivateRoute><Ejercicios /></PrivateRoute>
            } />

            <Route path="/crear-rutina" element={
              <PrivateRoute role="entrenador"><CrearRutina /></PrivateRoute>
            } />

            <Route path="/mis-rutinas" element={
              <PrivateRoute role="cliente"><MisRutinas /></PrivateRoute>
            } />

            <Route path="/metricas" element={
              <PrivateRoute role="cliente"><Metricas /></PrivateRoute>
            } />

            <Route path="*" element={<Navigate to="/" replace />} />
          </Routes>
        </div>
      </BrowserRouter>
    </AuthProvider>
  )
}
