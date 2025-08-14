# 🍅 Tomato Disease Classification API

API REST para clasificación de enfermedades en plantas de tomate usando Deep Learning con PyTorch y EfficientNet-B3.

## 📋 Descripción

Esta API permite identificar enfermedades en hojas de tomate a través del análisis de imágenes utilizando un modelo de Deep Learning entrenado con EfficientNet-B3. El sistema puede clasificar 6 tipos diferentes de condiciones:

- **Bacterial spot** - Mancha bacteriana
- **Early blight** - Tizón temprano  
- **Late blight** - Tizón tardío
- **Leaf mold** - Moho de la hoja
- **Septoria leaf spot** - Mancha foliar por Septoria
- **Healthy** - Saludable

## 🚀 Características

- ✅ API REST con FastAPI
- ✅ Modelo EfficientNet-B3 entrenado con PyTorch
- ✅ Procesamiento automático de imágenes
- ✅ Validación de tipos de archivo
- ✅ Respuestas con confianza y probabilidades
- ✅ Documentación automática con Swagger
- ✅ Logging detallado
- ✅ CORS habilitado

## 🛠️ Instalación

### Prerrequisitos

- Python 3.8+
- PyTorch (CPU version para la API)

### Opción 1: Con Conda (Recomendado)

```bash
# Crear entorno conda específico para API
conda create -n api_plantas python=3.9
conda activate api_plantas

# Instalar PyTorch CPU (más liviano para inferencia)
conda install pytorch torchvision torchaudio cpuonly -c pytorch

# Instalar otras dependencias
pip install -r requirements.txt
```

### Opción 2: Con pip y venv

```bash
# Crear entorno virtual
python -m venv api_plantas
# Activar entorno virtual
# En Windows:
api_plantas\Scripts\activate
# En Linux/Mac:
source api_plantas/bin/activate

# Instalar PyTorch CPU
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu

# Instalar otras dependencias
pip install -r requirements.txt
```

### Opción 3: Instalación global (No recomendado)

```bash
# Instalar PyTorch CPU
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu

# Instalar otras dependencias
pip install -r requirements.txt
```

### Dependencias principales

```
fastapi==0.104.1
uvicorn==0.24.0
torch==2.1.0  # PyTorch CPU
torchvision==0.16.0
pillow==10.1.0
opencv-python==4.8.1.78
pyyaml==6.0.1
python-multipart==0.0.6
```

### Estructura del proyecto

```
api_plantas/
├── main.py                    # Aplicación FastAPI principal
├── config_api.yml            # Configuración de la API
├── requirements.txt           # Dependencias Python
├── README.md                 # Este archivo
├── models/
│   └── best_model.pth        # Modelo PyTorch entrenado
├── utils/
│   ├── __init__.py
│   ├── model_loader.py       # Carga y manejo del modelo PyTorch
│   └── image_processor.py    # Procesamiento con torchvision
└── Tomato_Disease_API.postman_collection.json  # Colección Postman
```

## ⚙️ Configuración

El archivo `config_api.yml` contiene toda la configuración:

- **API settings**: Puerto, host, título, versión
- **Model settings**: Ruta del modelo PyTorch, clases, tamaño de imagen
- **Processing settings**: Extensiones permitidas, tamaño máximo, umbral de confianza

## 🏃‍♂️ Ejecución

### Modo desarrollo
```bash
python main.py
```

### Modo producción
```bash
uvicorn main:app --host 0.0.0.0 --port 8000
```

La API estará disponible en: `http://localhost:8000`

## 📚 Documentación

### Swagger UI
Accede a la documentación interactiva en: `http://localhost:8000/docs`

### ReDoc
Documentación alternativa en: `http://localhost:8000/redoc`

## 🔗 Endpoints

### Health Check
- `GET /` - Información general de la API
- `GET /health` - Estado de salud de la API

### Model Information  
- `GET /model/info` - Información detallada del modelo PyTorch
- `GET /classes` - Lista de clases disponibles

### Prediction
- `POST /predict` - Clasificar enfermedad en imagen usando PyTorch

## 🧪 Uso de la API

### Ejemplo con cURL

```bash
# Health check
curl -X GET "http://localhost:8000/health"

# Predicción
curl -X POST "http://localhost:8000/predict" \
  -H "accept: application/json" \
  -H "Content-Type: multipart/form-data" \
  -F "file=@imagen_tomate.jpg"
```

### Ejemplo con Python

```python
import requests

# Health check
response = requests.get("http://localhost:8000/health")
print(response.json())

# Predicción
with open("imagen_tomate.jpg", "rb") as f:
    files = {"file": f}
    response = requests.post("http://localhost:8000/predict", files=files)
    print(response.json())
```

### Respuesta de predicción

```json
{
  "success": true,
  "filename": "imagen_tomate.jpg",
  "image_info": {
    "width": 512,
    "height": 512,
    "format": "JPEG",
    "mode": "RGB",
    "size_mb": 0.15
  },
  "prediction": {
    "predicted_class": "Early blight",
    "confidence": 0.9234,
    "is_confident": true,
    "confidence_threshold": 0.7
  },
  "all_probabilities": {
    "Bacterial spot": 0.0123,
    "Early blight": 0.9234,
    "Late blight": 0.0456,
    "Leaf mold": 0.0087,
    "Septoria leaf spot": 0.0065,
    "Healthy": 0.0035
  },
  "timestamp": "2024-01-15T10:30:45.123456"
}
```

## 🧪 Testing con Postman

1. Importa la colección `Tomato_Disease_API.postman_collection.json`
2. Asegúrate de que la API esté ejecutándose
3. Ejecuta las pruebas en orden:
   - Health Check
   - Model Information
   - Disease Prediction
   - Error Cases

## 📁 Formatos de imagen soportados

- **JPG/JPEG** - Recomendado
- **PNG** - Soportado
- **BMP** - Soportado
- **TIFF** - Soportado

### Limitaciones

- Tamaño máximo: **10 MB**
- Resolución mínima recomendada: **224x224 px**
- Solo imágenes en color (RGB)

## 🔧 Troubleshooting

### Modelo PyTorch no encontrado
```
Error: Archivo de modelo no encontrado en: models/best_model.pth
```
**Solución**: Asegúrate de que el archivo `best_model.pth` (modelo PyTorch) esté en la carpeta `models/`

### Error de PyTorch
```
ModuleNotFoundError: No module named 'torch'
```
**Solución**: 
- **Con Conda**: `conda install pytorch torchvision torchaudio cpuonly -c pytorch`
- **Con pip**: `pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu`

### Error de arquitectura del modelo
```
RuntimeError: Error(s) in loading state_dict
```
**Solución**: Verifica que la arquitectura en `model_loader.py` coincida con el modelo entrenado

### Error de memoria
```
RuntimeError: [enforce fail at CPUAllocator.cpp]
```
**Solución**: La API usa CPU por defecto para ser más liviana. Si necesitas GPU, modifica `config_api.yml`

### Error de dependencias de visión
```
ModuleNotFoundError: No module named 'torchvision'
```
**Solución**: 
- **Con Conda**: `conda install torchvision -c pytorch`
- **Con pip**: `pip install torchvision --index-url https://download.pytorch.org/whl/cpu`

## 📊 Información del modelo

- **Arquitectura**: EfficientNet-B3 (PyTorch implementation)
- **Framework**: PyTorch 2.1.0
- **Estado**: `torch.save()` compatible
- **Clases**: 6 (5 enfermedades + saludable)
- **Precisión**: ~98.5% en validación
- **Tamaño de entrada**: 224x224 pixels
- **Normalización**: ImageNet (mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225])
- **Dispositivo**: CPU (para API ligera)
- **Transformaciones**: torchvision.transforms

## 🔄 Migración desde TensorFlow

Este proyecto originalmente usó TensorFlow pero se migró a PyTorch debido a:
- ✅ Mejor compatibilidad con CUDA en Windows
- ✅ Mayor flexibilidad en arquitecturas personalizadas  
- ✅ Debugging más intuitivo
- ✅ Mejor integración con el ecosistema Python

## 🤝 Contribución

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit tus cambios (`git commit -am 'Agregar nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Abre un Pull Request

## 📝 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para detalles.

## 👥 Autores

- **Tu Nombre** - *Desarrollo inicial* - [TuGitHub](https://github.com/tuusuario)

## 🙏 Agradecimientos

- Dataset de enfermedades de tomate
- **Comunidad PyTorch** - Framework principal
- **torchvision** - Transformaciones y modelos preentrenados
- FastAPI framework
- **EfficientNet PyTorch** implementation

---

⭐ **¡Dale una estrella al proyecto si te resulta útil!**