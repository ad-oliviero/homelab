FROM python:3.11-slim

RUN apt update
RUN apt install -y \
    git \
    libgl1 \
    libglib2.0-0
RUN rm -rf /var/lib/apt/lists/*


RUN pip install --no-cache-dir --upgrade pip uv
RUN uv pip install --system --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/rocm6.4

WORKDIR /app
RUN git clone https://github.com/Comfy-Org/ComfyUI.git .
RUN uv pip install --system --no-cache-dir -r requirements.txt

EXPOSE 8188

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
