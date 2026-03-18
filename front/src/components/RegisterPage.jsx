import { useState } from "react";
import "../main.css";

const API_BASE_URL = (import.meta.env.VITE_API_BASE_URL ?? "http://127.0.0.1:8000").replace(/\/$/, "");
const REGISTER_URL = import.meta.env.VITE_REGISTER_URL ?? `${API_BASE_URL}/register`;

const RegisterPage = ({ onOpenLogin }) => {
  const [formData, setFormData] = useState({
    name: "",
    email: "",
    password: "",
  });
  const [submitState, setSubmitState] = useState({
    isLoading: false,
    error: "",
    success: "",
  });

  const handleChange = ({ target }) => {
    const { name, value } = target;

    setFormData((prev) => ({
      ...prev,
      [name]: value,
    }));
  };

  const handleSubmit = async (event) => {
    event.preventDefault();

    if (!formData.name || !formData.email || !formData.password) {
      setSubmitState({
        isLoading: false,
        error: "Заполни все поля перед регистрацией.",
        success: "",
      });
      return;
    }

    setSubmitState({
      isLoading: true,
      error: "",
      success: "",
    });

    try {
      const response = await fetch(REGISTER_URL, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(formData),
      });

      let data = null;
      try {
        data = await response.json();
      } catch {
        data = null;
      }

      if (!response.ok) {
        throw new Error(data?.detail || data?.message || "Не удалось зарегистрировать пользователя.");
      }

      setSubmitState({
        isLoading: false,
        error: "",
        success: "Регистрация прошла успешно. Теперь можно войти в аккаунт.",
      });
      setFormData({
        name: "",
        email: "",
        password: "",
      });
    } catch (error) {
      setSubmitState({
        isLoading: false,
        error: error.message || "Ошибка соединения с сервером.",
        success: "",
      });
    }
  };

  return (
    <section className="register-page" aria-label="Регистрация">
      <div className="register-left">
        <img src="./src/assets/Group 576.svg" alt="VAMS" className="register-logo" />
      </div>

      <div className="register-right">
        <div className="register-card">
          <h1 className="register-title">РЕГИСТРАЦИЯ</h1>

          <form className="register-form" onSubmit={handleSubmit}>
            <input
              type="text"
              name="name"
              placeholder="Имя"
              value={formData.name}
              onChange={handleChange}
              disabled={submitState.isLoading}
            />
            <input
              type="email"
              name="email"
              placeholder="Email"
              value={formData.email}
              onChange={handleChange}
              disabled={submitState.isLoading}
            />
            <input
              type="password"
              name="password"
              placeholder="Пароль"
              value={formData.password}
              onChange={handleChange}
              disabled={submitState.isLoading}
            />
            {submitState.error ? <p className="register-message register-message-error">{submitState.error}</p> : null}
            {submitState.success ? (
              <p className="register-message register-message-success">{submitState.success}</p>
            ) : null}
            <button type="submit" className="register-submit" disabled={submitState.isLoading}>
              {submitState.isLoading ? "Отправка..." : "Зарегистрироваться"}
            </button>
          </form>

          <button type="button" className="register-login-link" onClick={onOpenLogin}>
            Уже есть аккаунт? Войти
          </button>
        </div>
      </div>
    </section>
  );
};

export default RegisterPage;
