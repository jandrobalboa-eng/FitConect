import { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import api from '../api/client'

const DIAS = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo']

export default function CrearRutina() {
  const navigate = useNavigate()
  const [clientes, setClientes] = useState([])
  const [ejercicios, setEjercicios] = useState([])
  const [form, setForm] = useState({ clienteId: '', nombre: '', descripcion: '', ejercicios: [] })
  const [guardando, setGuardando] = useState(false)
  const [error, setError] = useState('')

  useEffect(() => {
    api.get('/api/usuarios/clientes').then(res => setClientes(res.data.data)).catch(() => {})
    api.get('/api/ejercicios').then(res => setEjercicios(res.data.data)).catch(() => {})
  }, [])

  function agregarEjercicio() {
    setForm(f => ({
      ...f,
      ejercicios: [...f.ejercicios, { ejercicioId: '', series: 3, repeticiones: '12', descanso: '60s', diaSemana: 'Lunes' }]
    }))
  }

  function actualizarEjercicio(i, campo, valor) {
    setForm(f => {
      const ejs = [...f.ejercicios]
      ejs[i] = { ...ejs[i], [campo]: valor }
      return { ...f, ejercicios: ejs }
    })
  }

  function quitarEjercicio(i) {
    setForm(f => ({ ...f, ejercicios: f.ejercicios.filter((_, idx) => idx !== i) }))
  }

  async function handleSubmit(e) {
    e.preventDefault()
    if (form.ejercicios.length === 0) { setError('Añade al menos un ejercicio'); return }
    setError('')
    setGuardando(true)
    try {
      await api.post('/api/rutinas', {
        ...form,
        clienteId: parseInt(form.clienteId),
        ejercicios: form.ejercicios.map(ej => ({ ...ej, ejercicioId: parseInt(ej.ejercicioId), series: parseInt(ej.series) }))
      })
      navigate('/')
    } catch {
      setError('Error al crear la rutina')
    } finally {
      setGuardando(false)
    }
  }

  return (
    <div className="p-6 max-w-3xl mx-auto">
      <h2 className="text-2xl font-bold text-gray-800 mb-6">Crear rutina</h2>
      <form onSubmit={handleSubmit} className="space-y-5">
        <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-4 space-y-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Cliente</label>
            <select required value={form.clienteId}
              onChange={e => setForm({ ...form, clienteId: e.target.value })}
              className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm">
              <option value="">Selecciona un cliente</option>
              {clientes.map(c => <option key={c.id} value={c.id}>{c.nombre}</option>)}
            </select>
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Nombre de la rutina</label>
            <input type="text" required value={form.nombre}
              onChange={e => setForm({ ...form, nombre: e.target.value })}
              className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm" />
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Descripción</label>
            <textarea value={form.descripcion} rows={2}
              onChange={e => setForm({ ...form, descripcion: e.target.value })}
              className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm" />
          </div>
        </div>

        <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-4">
          <div className="flex justify-between items-center mb-3">
            <h3 className="font-semibold text-gray-700">Ejercicios</h3>
            <button type="button" onClick={agregarEjercicio}
              className="bg-blue-600 text-white text-sm px-3 py-1 rounded-lg hover:bg-blue-700">
              + Añadir
            </button>
          </div>

          {form.ejercicios.length === 0 && (
            <p className="text-gray-400 text-sm text-center py-4">Pulsa "Añadir" para agregar ejercicios</p>
          )}

          <div className="space-y-3">
            {form.ejercicios.map((ej, i) => (
              <div key={i} className="border border-gray-200 rounded-lg p-3 space-y-2">
                <div className="flex gap-2">
                  <select value={ej.ejercicioId} required
                    onChange={e => actualizarEjercicio(i, 'ejercicioId', e.target.value)}
                    className="flex-1 border border-gray-300 rounded-lg px-2 py-1 text-sm">
                    <option value="">Selecciona ejercicio</option>
                    {ejercicios.map(e => <option key={e.id} value={e.id}>{e.nombre}</option>)}
                  </select>
                  <button type="button" onClick={() => quitarEjercicio(i)}
                    className="text-red-400 hover:text-red-600 text-sm px-2">✕</button>
                </div>
                <div className="grid grid-cols-4 gap-2">
                  <div>
                    <label className="text-xs text-gray-500">Series</label>
                    <input type="number" min="1" value={ej.series}
                      onChange={e => actualizarEjercicio(i, 'series', e.target.value)}
                      className="w-full border border-gray-300 rounded px-2 py-1 text-sm" />
                  </div>
                  <div>
                    <label className="text-xs text-gray-500">Reps</label>
                    <input type="text" value={ej.repeticiones}
                      onChange={e => actualizarEjercicio(i, 'repeticiones', e.target.value)}
                      className="w-full border border-gray-300 rounded px-2 py-1 text-sm" />
                  </div>
                  <div>
                    <label className="text-xs text-gray-500">Descanso</label>
                    <input type="text" value={ej.descanso}
                      onChange={e => actualizarEjercicio(i, 'descanso', e.target.value)}
                      className="w-full border border-gray-300 rounded px-2 py-1 text-sm" />
                  </div>
                  <div>
                    <label className="text-xs text-gray-500">Día</label>
                    <select value={ej.diaSemana}
                      onChange={e => actualizarEjercicio(i, 'diaSemana', e.target.value)}
                      className="w-full border border-gray-300 rounded px-2 py-1 text-sm">
                      {DIAS.map(d => <option key={d}>{d}</option>)}
                    </select>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>

        {error && <p className="text-red-500 text-sm">{error}</p>}
        <button type="submit" disabled={guardando}
          className="w-full bg-blue-600 text-white py-2 rounded-xl hover:bg-blue-700 disabled:opacity-50">
          {guardando ? 'Creando...' : 'Crear rutina'}
        </button>
      </form>
    </div>
  )
}
