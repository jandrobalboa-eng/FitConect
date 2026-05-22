import { useState, useRef, useEffect } from 'react'

const GROQ_API_KEY = import.meta.env.VITE_GROQ_API_KEY

const SYSTEM_PROMPT = `Eres FitBot, el asistente de IA de FitConnect. Eres experto en fitness, nutrición y entrenamiento deportivo. Responde siempre en español, de forma concisa y práctica. Cuando des planes de entrenamiento sé específico con series, repeticiones, descansos e intensidad (RIR). No des diagnósticos médicos.`

export default function FitBot() {
  const [messages, setMessages] = useState([])
  const [input, setInput] = useState('')
  const [loading, setLoading] = useState(false)
  const bottomRef = useRef(null)

  useEffect(() => {
    bottomRef.current?.scrollIntoView({ behavior: 'smooth' })
  }, [messages, loading])

  async function sendMessage(e) {
    e.preventDefault()
    if (!input.trim() || loading) return
    const userMsg = { role: 'user', content: input.trim() }
    const history = [...messages, userMsg]
    setMessages(history)
    setInput('')
    setLoading(true)
    try {
      const res = await fetch('https://api.groq.com/openai/v1/chat/completions', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${GROQ_API_KEY}`
        },
        body: JSON.stringify({
          model: 'llama-3.3-70b-versatile',
          messages: [{ role: 'system', content: SYSTEM_PROMPT }, ...history],
          temperature: 0.7,
          max_tokens: 1024
        })
      })
      const data = await res.json()
      const reply = data.choices?.[0]?.message?.content || 'Sin respuesta.'
      setMessages(prev => [...prev, { role: 'assistant', content: reply }])
    } catch {
      setMessages(prev => [...prev, { role: 'assistant', content: 'Error de conexión. Inténtalo de nuevo.' }])
    } finally {
      setLoading(false)
    }
  }

  if (!GROQ_API_KEY) {
    return (
      <div className="flex items-center justify-center h-64 text-on-surface-variant text-center p-md">
        <div>
          <span className="material-symbols-outlined text-[48px] block mb-sm text-outline-variant">smart_toy</span>
          <p className="font-semibold text-on-surface">FitBot no está configurado</p>
          <p className="text-sm mt-xs">Crea el archivo <code className="bg-surface-container px-1 rounded">.env.local</code> en la carpeta <code className="bg-surface-container px-1 rounded">frontend/</code> con:</p>
          <p className="text-xs mt-xs font-mono bg-surface-container px-md py-sm rounded-lg inline-block mt-sm">VITE_GROQ_API_KEY=gsk_xxxxxxxxxxxx</p>
          <p className="text-xs mt-sm text-on-surface-variant">Obtén tu clave gratuita en <span className="text-secondary">console.groq.com</span></p>
        </div>
      </div>
    )
  }

  return (
    <div className="flex flex-col h-[600px]">
      <div className="flex-grow overflow-y-auto space-y-md p-md">
        {messages.length === 0 && (
          <div className="flex flex-col items-center text-on-surface-variant pt-xl px-xl">
            <span className="material-symbols-outlined text-[56px] block mb-md text-secondary" style={{ fontVariationSettings: "'FILL' 1" }}>smart_toy</span>
            <p className="font-semibold text-on-surface">¡Hola! Soy FitBot</p>
            <p className="text-sm mt-xs text-center">Pregúntame sobre entrenamientos, nutrición, recuperación o cualquier duda de fitness.</p>
            <div className="flex flex-wrap justify-center gap-sm mt-md">
              {['¿Cómo mejorar mi sentadilla?', '¿Qué comer antes de entrenar?', 'Rutina para ganar masa muscular'].map(q => (
                <button key={q} onClick={() => setInput(q)}
                  className="text-xs border border-outline-variant rounded-full px-sm py-xs text-on-surface-variant hover:border-secondary hover:text-secondary transition-colors">
                  {q}
                </button>
              ))}
            </div>
          </div>
        )}
        {messages.map((msg, i) => (
          <div key={i} className={`flex ${msg.role === 'user' ? 'justify-end' : 'justify-start'} gap-sm`}>
            {msg.role === 'assistant' && (
              <div className="w-8 h-8 rounded-full bg-secondary-container flex items-center justify-center shrink-0 mt-1">
                <span className="material-symbols-outlined text-[16px] text-on-secondary-container">smart_toy</span>
              </div>
            )}
            <div className={`max-w-[80%] rounded-2xl px-md py-sm text-sm whitespace-pre-wrap ${
              msg.role === 'user'
                ? 'bg-secondary text-on-secondary rounded-tr-sm'
                : 'bg-surface-container-low text-on-surface rounded-tl-sm'
            }`}>
              {msg.content}
            </div>
          </div>
        ))}
        {loading && (
          <div className="flex justify-start gap-sm">
            <div className="w-8 h-8 rounded-full bg-secondary-container flex items-center justify-center shrink-0">
              <span className="material-symbols-outlined text-[16px] text-on-secondary-container">smart_toy</span>
            </div>
            <div className="bg-surface-container-low rounded-2xl rounded-tl-sm px-md py-sm flex items-center gap-xs">
              <span className="w-2 h-2 bg-on-surface-variant rounded-full animate-bounce" style={{ animationDelay: '0ms' }} />
              <span className="w-2 h-2 bg-on-surface-variant rounded-full animate-bounce" style={{ animationDelay: '150ms' }} />
              <span className="w-2 h-2 bg-on-surface-variant rounded-full animate-bounce" style={{ animationDelay: '300ms' }} />
            </div>
          </div>
        )}
        <div ref={bottomRef} />
      </div>
      <div className="border-t border-outline-variant p-md">
        <form onSubmit={sendMessage} className="flex gap-sm">
          <input
            value={input}
            onChange={e => setInput(e.target.value)}
            placeholder="Pregunta sobre fitness, nutrición..."
            className="flex-grow border border-outline-variant rounded-lg px-md py-2.5 text-sm focus:ring-2 focus:ring-secondary focus:border-secondary outline-none bg-surface-container-low"
          />
          <button type="submit" disabled={loading || !input.trim()}
            className="bg-secondary text-on-secondary px-md rounded-lg font-semibold text-sm hover:opacity-90 disabled:opacity-50 flex items-center gap-xs shrink-0">
            <span className="material-symbols-outlined text-[20px]">send</span>
          </button>
        </form>
      </div>
    </div>
  )
}
