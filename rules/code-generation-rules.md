# 代码生成规则

# 代码模板引用

- Backend code must follow template at: templates/backend-code-template.md
- Frontend code must follow template at: templates/frontend-page-template.md

# 编译构建规则

- Do not automatically execute mvn clean install -DskipTests command
- Do not automatically trigger compilation after code modifications
- Do not execute any Maven commands unless user explicitly requests
- If compilation is needed, must ask user for permission first
