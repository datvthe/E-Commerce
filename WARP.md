`
# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.
``

Project overview
- The main app is a Java EE/Jakarta EE web application in WEBGMS built with Ant (NetBeans project). It follows a layered MVC: controllers (servlets) -> services -> DAOs -> models (POJOs) -> MySQL. Views are JSPs in web/views with shared components in web/views/component. Static assets live under web/assets.
- Routing: most controllers use @WebServlet; select routes are in web/WEB-INF/web.xml. RoleBasedAccessFilter exists but is not enabled unless added to web.xml.
- Key services: RoleBasedAccessControl (role/redirect logic), EmailService (JavaMail), GoogleAuthService (OAuth). Data access uses dao.DBConnection and DAOs per domain. Domain models are grouped by feature under src/java/model/*.
- Documentation: see WEBGMS/*.md for database schema and flows (database_diagram.md, project_structure_diagram.md, EMAIL_SETUP_GUIDE.md, google_oauth_setup.md, FORGOT_PASSWORD_README.md, etc.). SQL seeds and migrations are in WEBGMS/*.sql.

Common commands (PowerShell)
- Clean/build classes:
  ant -f WEBGMS/build.xml clean
  ant -f WEBGMS/build.xml -Dj2ee.server.home="C:\\path\\to\\tomcat" -Dlibs.CopyLibs.classpath="C:\\path\\to\\org-netbeans-modules-java-j2seproject-copylibstask.jar" compile
- Build WAR:
  ant -f WEBGMS/build.xml -Dj2ee.server.home="C:\\path\\to\\tomcat" -Dlibs.CopyLibs.classpath="C:\\path\\to\\org-netbeans-modules-java-j2seproject-copylibstask.jar" dist
  # Output: WEBGMS/dist/WEBGMS.war
- Deploy to local Tomcat (Manager app required):
  ant -f WEBGMS/build.xml -Dj2ee.server.home="C:\\path\\to\\tomcat" -Dlibs.CopyLibs.classpath="C:\\path\\to\\org-netbeans-modules-java-j2seproject-copylibstask.jar" -Dtomcat.home="C:\\path\\to\\tomcat" -Dtomcat.url="http://localhost:8080" -Dtomcat.username={{TOMCAT_USER}} -Dtomcat.password={{TOMCAT_PASSWORD}} run
- Undeploy:
  ant -f WEBGMS/build.xml -Dtomcat.home="C:\\path\\to\\tomcat" -Dtomcat.url="http://localhost:8080" -Dtomcat.username={{TOMCAT_USER}} -Dtomcat.password={{TOMCAT_PASSWORD}} run-undeploy
- Compile a single Java file:
  ant -f WEBGMS/build.xml -Djavac.includes="controller/common/CommonLoginController.java" compile-single
- Run unit tests (if tests exist under WEBGMS/test):
  ant -f WEBGMS/build.xml test
- Run a single test class:
  ant -f WEBGMS/build.xml -Dtest.includes="**/MyClassTest.java" test-single
- Run a single test method:
  ant -f WEBGMS/build.xml -Dtest.class="com.example.MyClassTest" -Dtest.method="shouldDoThing" test-single-method
- Precompile JSPs (optional):
  ant -f WEBGMS/build.xml -Dcompile.jsps=true compile-jsps
- Switch javax/jakarta servlet imports (Windows helpers):
  .\WEBGMS\fix_jakarta_imports.bat
  .\WEBGMS\fix_javax_to_jakarta.bat

Important configuration notes
- Ant requires two properties when building outside NetBeans:
  - j2ee.server.home pointing to a Tomcat installation; project.properties computes j2ee.platform.classpath from it.
  - libs.CopyLibs.classpath pointing to NetBeans’ org-netbeans-modules-java-j2seproject-copylibstask.jar.
- Database: DAOs use dao.DBConnection; connection details are hardcoded in code. Update there for local development or externalize if needed.
- Email/OAuth: follow WEBGMS/EMAIL_SETUP_GUIDE.md and WEBGMS/google_oauth_setup.md; do not store secrets in VCS.

High-level architecture map
- Controllers: src/java/controller/{common,user,seller,admin,manager,...} (servlets handle HTTP and forward to JSPs).
- Services: src/java/service/* (auth, RBAC, email, OAuth, wallet/payment integrations).
- DAOs: src/java/dao/* with DBConnection and per-entity DAOs.
- Models: src/java/model/* organized by domain (user, product, order, wallet, moderation, etc.).
- Filters: src/java/filter/* (e.g., RoleBasedAccessFilter for RBAC). Enable via web.xml mappings if needed.
- Views: web/views/{common,user,seller,admin,...} with shared components under web/views/component.
- Web config: web/WEB-INF/web.xml contains explicit servlet mappings and can register filters.
- Assets/templates: Additional UI templates under Electro-Bootstrap-1.0.0 and plain-free-bootstrap-admin-template-main; not part of the deployed WAR unless copied into WEBGMS/web.
