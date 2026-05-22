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
        ejercicios: form.ejercicios.map(ej => ({
          ...ej,
          ejercicioId: parseInt(ej.ejercicioId),
          series: parseInt(ej.series),
        }))
      })
      navigate('/')
    } catch {
      setError('Error al crear la rutina')
    } finally {
      setGuardando(false)
    }
  }

  const inputClass = "w-full bg-surface-container-low border border-outline-variant rounded-lg px-4 py-3 text-sm focus:ring-2 focus:ring-secondary focus:border-secondary outline-none transition-all"

  return (
    <div className="flex-grow max-w-[1440px] w-full mx-auto px-10 py-lg">
      <div className="space-y-md mb-lg border-b border-outline-variant pb-md">
        <h1 className="text-4xl font-extrabold text-primary tracking-tight">Crear rutina</h1>
        <p className="text-on-surface-variant">Diseña y asigna un programa de entrenamiento a un cliente.</p>
      </div>

      <form onSubmit={handleSubmit} className="max-w-3xl space-y-gutter">
        {/* General info */}
        <div
          className="bg-surface-container-lowest rounded-xl border border-outline-variant/30 p-md space-y-md"
          style={{ boxShadow: '0 4px 15px rgba(15,23,42,0.04)' }}
        >
          <h2 className="text-lg font-bold text-on-surface">Información general</h2>

          <div className="space-y-xs">
            <label className="block text-sm font-semibold text-on-surface">Cliente</label>
            <select
              required
              value={form.clienteId}
              onChange={e => setForm({ ...form, clienteId: e.target.value })}
              className={inputClass}
            >
              <option value="">Selecciona un cliente</option>
              {clientes.map(c => <option key={c.id} value={c.id}>{c.nombre}</option>)}
            </select>
          </div>

          <div className="space-y-xs">
            <label className="block text-sm font-semibold text-on-surface">Nombre de la rutina</label>
            <input
              type="text"
              required
              value={form.nombre}
              onChange={e => setForm({ ...form, nombre: e.target.value })}
              placeholder="Ej: Rutina fuerza semana 1"
              className={inputClass}
            />
          </div>

          <div className="space-y-xs">
            <label className="block text-sm font-semibold text-on-surface">Descripción</label>
            <textarea
              value={form.descripcion}
              rows={2}
              onChange={e => setForm({ ...form, descripcion: e.target.value })}
              placeholder="Enfocada en tren superior..."
              className={`${inputClass} resize-none`}
            />
          </div>
        </div>

        {/* Exercises */}
        <div
          className="bg-surface-container-lowest rounded-xl border border-outline-variant/30 p-md"
          style={{ boxShadow: '0 4px 15px rgba(15,23,42,0.04)' }}
        >
          <div className="flex justify-between items-center mb-md">
            <h2 className="text-lg font-bold text-on-surface">Ejercicios</h2>
            <button
              type="button"
              onClick={agregarEjercicio}
              className="flex items-center gap-xs bg-secondary text-on-secondary text-sm font-semibold px-4 py-2 rounded-lg hover:opacity-90 transition-opacity active:scale-95"
            >
              <span className="material-symbols-outlined text-[18px]">add</span>
              Añadir
            </button>
          </div>

          {form.ejercicios.length === 0 && (
            <div className="flex flex-col items-center justify-center py-lg text-on-surface-variant text-sm">
              <span className="material-symbols-outlined text-[40px] opacity-30 mb-sm">fitness_center</span>
              Pulsa "Añadir" para agregar ejercicios a la rutina.
            </div>
          )}

          <div className="space-y-sm">
            {form.ejercicios.map((ej, i) => (
              <div key={i} className="border border-outline-variant/50 rounded-lg p-sm space-y-sm bg-surface-container-low">
                <div className="flex gap-sm">
                  <select
                    value={ej.ejercicioId}
                    required
                    onChange={e => actualizarEjercicio(i, 'ejercicioId', e.target.value)}
                    className={`flex-1 ${inputClass}`}
                  >
                    <option value="">Selecciona ejercicio</option>
                    {ejercicios.map(e => <option key={e.id} value={e.id}>{e.nombre}</option>)}
                  </select>
                  <button
                    type="button"
                    onClick={() => quitarEjercicio(i)}
                    className="text-on-surface-variant hover:text-error transition-colors px-2"
                    title="Quitar ejercicio"
                  >
                    <span className="material-symbols-outlined">close</span>
                  </button>
                </div>
                <div className="grid grid-cols-4 gap-sm">
                  {[
                    { label: 'Series', field: 'series', type: 'number', min: 1 },
                    { label: 'Reps', field: 'repeticiones', type: 'text' },
                    { label: 'Descanso', field: 'descanso', type: 'text' },
                  ].map(({ label, field, type, min }) => (
                    <div key={field} className="space-y-xs">
                      <label className="block text-xs font-semibold text-on-surface-variant">{label}</label>
                      <input
                        type={type}
                        min={min}
                        value={ej[field]}
                        onChange={e => actualizarEjercicio(i, field, e.target.value)}
                        className="w-full bg-surface border border-outline-variant rounded px-2 py-1.5 text-sm focus:ring-2 focus:ring-secondary outline-none transition-all"
                      />
                    </div>
                  ))}
                  <div className="space-y-xs">
                    <label className="block text-xs font-semibold text-on-surface-variant">Día</label>
                    <select
                      value={ej.diaSemana}
                      onChange={e => actualizarEjercicio(i, 'diaSemana', e.target.value)}
                      className="w-full bg-surface border border-outline-variant rounded px-2 py-1.5 text-sm focus:ring-2 focus:ring-secondary outline-none transition-all"
                    >
                      {DIAS.map(d => <option key={d}>{d}</option>)}
                    </select>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>

        {error && <p className="text-sm" style={{ color: '#ba1a1a' }}>{error}</p>}

        <button
          type="submit"
          disabled={guardando}
          className="w-full bg-primary-container text-on-primary font-semibold tracking-wide py-4 rounded-xl hover:bg-primary transition-all active:scale-[0.98] flex items-center justify-center gap-2 disabled:opacity-50"
        >
          {guardando ? (
            <>
              <span className="material-symbols-outlined text-[20px] animate-spin">progress_activity</span>
              Creando...
            </>
          ) : (
            <>
              Crear rutina
              <span className="material-symbols-outlined text-[20px]">check_circle</span>
            </>
          )}
        </button>
      </form>
    </div>
  )
}
