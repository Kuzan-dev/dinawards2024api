# Usa la imagen oficial de Python como base
FROM python:3.11-slim

# Establece la zona horaria en Lima, Perú
ENV TZ=America/Lima
RUN apt-get update && apt-get install -y tzdata \
    && ln -fs /usr/share/zoneinfo/$TZ /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

LABEL maintainer="Zote_Zote"

# Define los argumentos de construcción y las variables de entorno
ARG ADMIN_BOOTSTRAP_PASSWORD
ARG JWT_KEY
ARG DATABASE_URL

ENV ADMIN_BOOTSTRAP_PASSWORD=$ADMIN_BOOTSTRAP_PASSWORD
ENV JWT_KEY=$JWT_KEY
ENV DATABASE_URL=$DATABASE_URL

# Instala dependencias necesarias
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Establece el directorio de trabajo
WORKDIR /app

# Copia los archivos de dependencias
COPY requirements.txt ./

# Instala las dependencias de Python
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# Copia el resto de la aplicación al directorio de trabajo
COPY . .

# Expone el puerto 720 para la API
EXPOSE 720

# Comando para ejecutar la aplicación
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "720"]