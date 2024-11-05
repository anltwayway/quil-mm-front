# 使用 Node.js 18 的官方镜像
FROM node:18

# 设置工作目录
WORKDIR /app

# 安装 pnpm
RUN npm install -g pnpm

# 复制项目文件（可选，根据需要）
COPY package.json pnpm-lock.yaml* ./

# 安装依赖
RUN pnpm install

# 复制剩余项目文件
COPY . .

# 默认命令
CMD ["npm", "run", "dev"]

# Dockerfile 中添加环境变量
ENV VITE_PORT=3000
