
# 清理所有进程

taskkill /F /IM java.exe /T
taskkill /F /IM javaw.exe /T
taskkill /F /IM idea64.exe /T

- 完整打包（清理 + 编译 + 打包），只生成 jar 包，不启动服务
- 打包整个项目所有模块
  - mvn clean package -DskipTests
- 只打包 hny-admin 模块，并且自动把它依赖的其他模块一起编译打包，跳过测试。
  - mvn -pl hny-admin -am package -DskipTests
  - mvn -pl hny-modules/hny-demo -am package -DskipTests
- 用 Java 运行 hny-admin 模块打包好的 jar 包，把项目真正启动起来。
  - java -jar hny-admin\target\hny-admin.jar
