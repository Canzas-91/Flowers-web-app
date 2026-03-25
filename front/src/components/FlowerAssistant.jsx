import { useMemo, useState } from "react";
import { askFlowerAssistant } from "../api/publicApi";
import "./FlowerAssistant.css";

const QUICK_PROMPTS = [
  "Подбери букет до 3500 ₽",
  "Нужен букет для свидания",
  "Хочу что-то нежное и светлое",
  "Что выбрать в подарок маме?",
];

const INITIAL_MESSAGES = [
  {
    id: "welcome-1",
    role: "assistant",
    text: "Помогу подобрать букет по бюджету, поводу и предпочтениям.",
  },
  {
    id: "welcome-2",
    role: "assistant",
    text: "Опишите, для кого букет и какой ориентир по бюджету.",
  },
];

function normalizeAssistantPayload(payload) {
  if (!payload) {
    return {
      text: "Не удалось получить ответ от консультанта.",
      suggestions: [],
    };
  }

  return {
    text: payload.text || "Консультант не вернул текст ответа.",
    suggestions: Array.isArray(payload.suggestions) ? payload.suggestions : [],
  };
}

async function defaultRequestAssistantReply(messages) {
  return askFlowerAssistant(messages);
}

function FlowerAssistant({ onAddToCart, onOpenCatalog, requestAssistantReply = defaultRequestAssistantReply }) {
  const [isOpen, setIsOpen] = useState(false);
  const [draft, setDraft] = useState("");
  const [isLoading, setIsLoading] = useState(false);
  const [messages, setMessages] = useState(INITIAL_MESSAGES);

  const visibleMessages = useMemo(() => messages.slice(-8), [messages]);

  const submitMessage = async (text) => {
    const trimmedText = text.trim();
    if (!trimmedText || isLoading) {
      return;
    }

    const userMessage = {
      id: `user-${Date.now()}`,
      role: "user",
      text: trimmedText,
    };

    setMessages((prev) => [...prev, userMessage]);
    setDraft("");
    setIsOpen(true);
    setIsLoading(true);

    try {
      const history = [...messages, userMessage].map((message) => ({
        role: message.role,
        content: message.text,
      }));
      const payload = await requestAssistantReply(history);
      const assistantReply = normalizeAssistantPayload(payload);

      setMessages((prev) => [
        ...prev,
        {
          id: `assistant-${Date.now()}`,
          role: "assistant",
          text: assistantReply.text,
          suggestions: assistantReply.suggestions,
        },
      ]);
    } catch {
      setMessages((prev) => [
        ...prev,
        {
          id: `assistant-error-${Date.now()}`,
          role: "assistant",
          text: "Не удалось получить ответ от AI-консультанта. Проверьте backend API, Ollama и доступность базы данных.",
          suggestions: [],
          isError: true,
        },
      ]);
    } finally {
      setIsLoading(false);
    }
  };

  const handleSubmit = async (event) => {
    event.preventDefault();
    await submitMessage(draft);
  };

  return (
    <div className={`flower-assistant ${isOpen ? "is-open" : ""}`}>
      {isOpen ? (
        <section className="flower-assistant-panel" aria-label="Чат-помощник по выбору цветов">
          <div className="flower-assistant-header">
            <div>
              <p className="flower-assistant-eyebrow">Flower AI</p>
              <h2 className="flower-assistant-title">Помощник по букетам</h2>
            </div>
            <button
              type="button"
              className="flower-assistant-close"
              aria-label="Свернуть чат"
              onClick={() => setIsOpen(false)}
            >
              +
            </button>
          </div>

          <div className="flower-assistant-messages">
            {visibleMessages.map((message) => (
              <div
                key={message.id}
                className={`flower-assistant-message flower-assistant-message--${message.role} ${message.isError ? "is-error" : ""}`}
              >
                <p>{message.text}</p>

                {message.suggestions?.length ? (
                  <div className="flower-assistant-recommendations">
                    {message.suggestions.map((product) => (
                      <article key={`${message.id}-${product.id}`} className="flower-assistant-product">
                        <div>
                          <h3>{product.title}</h3>
                          <p>{product.description || product.category || "Подходит под ваш запрос"}</p>
                          <span>{product.price} ₽</span>
                        </div>
                        <button type="button" onClick={() => onAddToCart(product)}>
                          В корзину
                        </button>
                      </article>
                    ))}
                    <button type="button" className="flower-assistant-link" onClick={onOpenCatalog}>
                      Открыть каталог
                    </button>
                  </div>
                ) : null}
              </div>
            ))}

            {isLoading ? (
              <div className="flower-assistant-message flower-assistant-message--assistant flower-assistant-message--loading">
                <p>Консультант думает...</p>
              </div>
            ) : null}
          </div>

          <div className="flower-assistant-quick-actions">
            {QUICK_PROMPTS.map((prompt) => (
              <button key={prompt} type="button" disabled={isLoading} onClick={() => submitMessage(prompt)}>
                {prompt}
              </button>
            ))}
          </div>

          <form className="flower-assistant-form" onSubmit={handleSubmit}>
            <input
              type="text"
              value={draft}
              onChange={(event) => setDraft(event.target.value)}
              placeholder="Например: букет до 5000 ₽ для мамы"
              disabled={isLoading}
            />
            <button type="submit" disabled={isLoading}>
              {isLoading ? "..." : "Отправить"}
            </button>
          </form>
        </section>
      ) : null}

      <button
        type="button"
        className="flower-assistant-trigger"
        aria-label="Открыть чат с помощником"
        onClick={() => setIsOpen((prev) => !prev)}
      >
        <span>AI</span>
        <strong>Подбор букета</strong>
      </button>
    </div>
  );
}

export default FlowerAssistant;
