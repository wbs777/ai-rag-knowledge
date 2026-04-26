# ==============================================================================
# ⚠️ 注意事项：执行本脚本之前，必须确保你已经在上一级项目根目录中
# 执行了 Maven 编译指令：mvn clean package -Dmaven.test.skip=true 
# 并成功在 target 目录输出了 jar 包。否则 Docker 找不到要打进去的应用。
# ==============================================================================

# 1. 基础镜像本地构建命令
# 用法：docker build -t [镜像命名空间/镜像名称]:[版本号标签tag] -f [构建图纸路径] [构建上下文目录]
#    -t：表示给你打包好的最终镜像起个名字。如果是部署到自己的机器，建议把 fuzhengwei 换成自己的。
#    -f：表示强制指定当前文件所在的 "./Dockerfile" 作为构建指令说明书。
#    最后那个点 "." (句号)：极其重要，通知 Docker 引擎读取当前 app 目录下所有的文件结构传递给容器（从而使得 Dockerfile 里的 ADD 命令能拿到相对路径 target/... 下的 jar 包）。
docker build -t fuzhengwei/ai-rag-knowledge-app:1.2 -f ./Dockerfile .

# 2. （被注释）高级多架构跨平台构建方案
# 比如你的服务器是基于 X86 架构 (amd64)，但在基于苹果 M芯片系列 (arm) 下工作。 
# 可以使用 buildx 同时打通两种处理器架构适配的镜像。
# 后面的 --push 意思是只要它构建完了，就直接帮你利用你的凭证顺便推送到云端的公有/私有 Docker 仓库，这样其他机器用这名字就能 Pull 下来了。
# docker buildx build --load --platform liunx/amd64,linux/arm64 -t fuzhengwei/ai-rag-knowledge-app:1.2 -f ./Dockerfile . --push