# 1. 基础镜像 (Base Image)
# FROM 指令告诉 Docker 以哪个环境为底座。这里使用的是带有 Java 17 的极简版 Linux 镜像（slim）。
# 这是容器能够识别并运行 "java" 命令的前提条件。
FROM openjdk:17-jdk-slim

# 作者标识
MAINTAINER xiaofuge

# 2. 环境变量配置
# ENV 指令用来设置容器内的系统环境变量。这里的 PARAMS 预留了一个空变量。
# 后续我们可以通过 docker-compose 环境配置注入类似 "--server.port=8080" 的启动参数给它。
ENV PARAMS=""

# 3. 容器时区校准
# 默认容器的系统时间是零时区 (UTC+0)，会引起 Java 打的日志时间和数据库插入时间差 8 小时。
# 所以这里写入 TZ=PRC (北京时间)，并用 RUN 在那个微型 Linux 里建立本地时区的系统软链接。
ENV TZ=PRC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 4. 拷贝应用包 (ADD -> 构建镜像最核心的一步)
# ⚠️ 这步必须要有你在外部使用 Maven（mvn clean package）先打出来的 target/ai-rag-knowledge-app.jar 作为前提。
# 它的作用就是：把宿主机（你外面的电脑）里的 jar 文件，抓取并放进这个 Linux 容器的根目录下，并命名为 /ai-rag-knowledge-app.jar。
ADD target/ai-rag-knowledge-app.jar /ai-rag-knowledge-app.jar

# 5. 声明容器启动入口执行动作 (Entrypoint)
# 当这个包含 Java 环境并塞入了你业务代码的容器一旦启动变成实例后，第一件事就是执行这句命令：
# 意思是启动终端 (sh -c)，并执行 java -jar 包命令，这正是将应用持续运行成后端服务的原因。
ENTRYPOINT ["sh","-c","java -jar $JAVA_OPTS /ai-rag-knowledge-app.jar $PARAMS"]