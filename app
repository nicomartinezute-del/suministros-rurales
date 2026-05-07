import streamlit as st

st.set_page_config(page_title="Calculador Suministros Rurales", layout="centered")

st.title("⚡ Clasificador de Suministros Rurales")
st.markdown("---")

# --- PASO 1: PERFIL DEL CLIENTE ---
st.subheader("1. Perfil del Solicitante")
perfil = st.selectbox("Tipo de Cliente / Beneficio:", [
    "Particular (Padrón Rural)",
    "Interés Social (TUS, MEVIR, AFAMPE, Escuelas)",
    "Productor Familiar MGAP / Bomba de Agua"
])

# --- PASO 2: DATOS TÉCNICOS ---
st.subheader("2. Datos del Suministro")
distancia = st.number_input("Distancia a la red (metros):", min_value=0, value=0, step=50)
potencia = st.number_input("Potencia solicitada (kW):", min_value=0.0, value=9.5, step=0.1)
viabilidad = st.radio("¿Existe viabilidad de red convencional?", ["Sí", "No"])

# --- PASO 3: LÓGICA DE DECISIÓN ---
st.markdown("---")
st.subheader("3. Resultado de la Clasificación")

if viabilidad == "No" and distancia >= 500:
    st.error("📍 Corresponde: SISTEMA FOTOVOLTAICO AUTÓNOMO (SFA)")
    st.info("**Costo Mensual (2026):**\n"
            "- Particular: $2.603,27 + IVA\n"
            "- Prod. Familiar: $731,91 + IVA")
else:
    # Lógica de Resoluciones
    if "Interés Social" in perfil:
        if distancia <= 1500 and potencia <= 3.7:
            st.success("✅ Resolución: INTERÉS SOCIAL (22.-383 + 23.-1315)")
            st.write("**Obra a cargo de:** UTE")
            st.write("**Monto:** Paga solo Tasa de Conexión.")
        else:
            st.warning("⚠️ Excede límites de Interés Social. Tramo >1500m a cargo de MEVIR o CER.")

    elif "Productor Familiar" in perfil:
        if distancia <= 2000:
            st.success("✅ Resolución: 26.-178 (Productor Familiar)")
            st.write("**Obra a cargo de:** UTE")
            st.write("**Costo:** Unidades de Beneficio Técnico (UBT) según tabla 2026.")
        else:
            st.info("📍 Corresponde: RÉGIMEN DE OBRA MIXTA (+2000m)")

    else:  # Particular
        if distancia <= 500 and potencia <= 9.5:
            st.success("✅ Resolución: 26.-178 (Particular)")
            st.write("**Obra a cargo de:** UTE")
            st.write("**Costo:** Sin costo de extensión, paga Tasa de Conexión.")
        else:
            st.info("📍 Corresponde: RESOLUCIÓN 22.-383 (Obra Mixta / ECE)")
            st.write("**Obra a cargo de:** Solicitante mediante ECE.")
            st.write("**Beneficio:** Entrega de materiales básicos previo depósito.")

st.markdown("---")
st.caption("Herramienta de referencia técnica basada en normativas 2026.")
