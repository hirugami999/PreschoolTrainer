import customtkinter as ctk

app = ctk.CTk()

app.title("Подготовка дошкольников")
app.geometry("900x600")

title = ctk.CTkLabel(
    app,
    text="Подготовка дошкольников",
    font=("Arial", 36)
)
title.pack(pady=80)

math_button = ctk.CTkButton(
    app,
    text="Математика",
    width=250,
    height=60,
    font=("Arial", 22)
)
math_button.pack(pady=20)

grammar_button = ctk.CTkButton(
    app,
    text="Грамота",
    width=250,
    height=60,
    font=("Arial", 22)
)
grammar_button.pack(pady=20)

app.mainloop()