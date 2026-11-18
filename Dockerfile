FROM node:22-alpine AS ui
WORKDIR /work
COPY package*.json ./
RUN npm ci
COPY frontend ./frontend
RUN npm run build
FROM python:3.13-slim
ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1 APP_MODE=production
RUN useradd --create-home --uid 10001 cfcs
WORKDIR /app
COPY requirements-verified.txt ./
RUN pip install --no-cache-dir -r requirements-verified.txt
COPY backend ./backend
COPY migrations ./migrations
COPY scripts ./scripts
COPY --from=ui /work/frontend/index.html ./frontend/index.html
COPY --from=ui /work/frontend/public ./frontend/public
USER cfcs
EXPOSE 8000
HEALTHCHECK --interval=30s --timeout=5s CMD python -c "import urllib.request;urllib.request.urlopen('http://127.0.0.1:8000/api/health',timeout=4)"
CMD ["bash","scripts/start-production.sh"]
