#!/bin/bash
INSTALL_MODE="mini"

check_compose() {
  if command -v yum >/dev/null 2>&1; then
    pksys="yum"
  elif command -v dnf >/dev/null 2>&1; then
    pksys="dnf"
  elif command -v apt-get >/dev/null 2>&1; then
    pksys="apt-get"
  else
    echo "ERROR: No supported package manager found."
    exit 1
  fi

  if ! docker compose version >/dev/null 2>&1; then
    echo "Docker Compose plugin not found, installing..."
    if [[ "$pksys" == "apt-get" ]]; then
      apt-get update
    fi

    $pksys install -y docker-compose-plugin || \
        $pksys install -y docker-compose
  fi

  # Check again
  if docker compose version >/dev/null 2>&1; then
    echo "Docker Compose is ready:"
    docker compose version
  else
    echo "ERROR: Docker Compose installation failed."
    echo "Please install Docker Compose yourself, then try again."
    exit 1
  fi
}


install_type_choose() {
  echo "Select installation type:"
  echo "  1) Mini - Runtime + mysql + redis + mongo"
  echo "  2) Full - Runtime + all services"
  echo
  read -r -p "Choose [1]: " INSTALL_TYPE
  INSTALL_TYPE="${INSTALL_TYPE:-1}"
  case "$INSTALL_TYPE" in
    1)
      echo "Installing Mini..."
      INSTALL_MODE="mini"
      ;;
    2)
      echo "Installing Full..."
      INSTALL_MODE="full"
      ;;
    *)
      echo "Default, using Mini."
      INSTALL_MODE="mini"
      ;;
  esac
}


input_val() {
  local valname="$1"
  local default="$2"
  local message="$3"
  local value

  read -r -p "$message [$default]: " value
  if [[ -z "$value" ]]; then
    value="$default"
  fi
  printf -v "$valname" '%s' "$value"
}


make_env() {
  echo
  echo "Please enter the information"
  echo "Included with authorization request emails"
  echo "You can ignore this; just press Enter."
  echo "-------------------------------------------"
  input_val LICENSE_APP_NAME "Evaluate" "Application name"
  input_val LICENSE_COMPANY "unknow" "Company"
  input_val LICENSE_DNS "$(hostname -f)" "DNS"
  input_val LICENSE_EMAIL "dev@example.com" "Email"

  MYSQL_PASSWORD=`openssl rand -base64 20`
  REDIS_PASS=`openssl rand -base64 20`
  MONGO_USERNAME=root
  MONGO_PASSWORD=`openssl rand -hex 20`
  SESSION_KEY=`openssl rand -base64 20`
  neo4j_username=root
  neo4j_password=`openssl rand -base64 20`
  ARTEMIS_USER=root
  ARTEMIS_PASSWORD=`openssl rand -base64 20`
  mongoURL=mongodb://mongo-x
  URL_PREFIX=/xboson

  UI_RENDER_HOST=ui-render-x
  MYSQL_HOST="mysql-x"
  REDIS_HOST="redis-x"
  MONGO_HOST="mongo-x"

  # if [[ "$MONGO_USERNAME:$MONGO_PASSWORD" != ":" ]]; then
  #   mongoURL=mongodb://$MONGO_USERNAME:$MONGO_PASSWORD@mongo-x
  # fi

cat > .env <<EOF
MYSQL_PASSWORD=$MYSQL_PASSWORD
SESSION_KEY=$SESSION_KEY
REDIS_PASS=$REDIS_PASS
mongoURL=$mongoURL
URL_PREFIX=$URL_PREFIX

LICENSE_APP_NAME=$LICENSE_APP_NAME
LICENSE_COMPANY=$LICENSE_COMPANY
LICENSE_DNS=$LICENSE_DNS
LICENSE_EMAIL=$LICENSE_EMAIL

UI_RENDER_HOST=$UI_RENDER_HOST
MYSQL_HOST=$MYSQL_HOST
REDIS_HOST=$REDIS_HOST
MONGO_HOST=$MONGO_HOST

# not used
MONGO_USERNAME=$MONGO_USERNAME
MONGO_PASSWORD=$MONGO_PASSWORD
ARTEMIS_USER=$ARTEMIS_USER
ARTEMIS_PASSWORD=$ARTEMIS_PASSWORD
NEO4J_AUTH=$neo4j_username/$neo4j_password
EOF
  echo "Make '.env' success."
}


make_compose() {
  local ipf="" # local test
  # local ipf="xbosoncore/" # on dockerhub
  cat > ./docker-compose.yml <<EOF
networks:
  xboson-net:
    name: xboson-net

services:
  mysql:
    image: ${ipf}xboson-mysql:latest
    container_name: \${MYSQL_HOST}
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: "\${MYSQL_PASSWORD}"
    networks:
      - xboson-net
    healthcheck:
      test:
        - "CMD-SHELL"
        - >
          test -f /var/lib/mysql/xboson.mysql-init-complete &&
          mysql -uroot -p"\$\${MYSQL_ROOT_PASSWORD}" 
          -e "SELECT 1 FROM mysql.user LIMIT 1" >/dev/null 2>&1
      interval: 5s
      timeout: 5s
      retries: 30
      start_period: 10s

  redis:
    image: ${ipf}xboson-redis:latest
    container_name: \${REDIS_HOST}
    restart: always
    environment:
      REDIS_PASS: "\${REDIS_PASS}"
    networks:
      - xboson-net
    healthcheck:
      test: ["CMD", "redis-cli", "-a", "\${REDIS_PASS}", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 5s

  mongodb:
    image: ${ipf}xboson-mongo:latest
    container_name: \${MONGO_HOST}
    restart: always
    # environment:
    #   MONGO_INITDB_ROOT_USERNAME: "\${MONGO_USERNAME}"
    #   MONGO_INITDB_ROOT_PASSWORD: "\${MONGO_PASSWORD}"
    networks:
      - xboson-net
    healthcheck:
      test:
        - CMD-SHELL
        - "mongo --quiet --eval 'db.adminCommand(\"ping\").ok' | grep -q 1"
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 10s

  ui-render:
    image: ${ipf}xboson-ui-ext:latest
    container_name: ${UI_RENDER_HOST}
    restart: always
    networks:
      - xboson-net

  xboson:
    image: ${ipf}xboson-runtime:latest
    container_name: xboson-rt
    restart: always
    environment:
      MYSQL_PASSWORD: "\${MYSQL_PASSWORD}"
      REDIS_PASSWORD: "\${REDIS_PASS}"
      SESSION_KEY: "\${SESSION_KEY}"
      LICENSE_APP_NAME: "\${LICENSE_APP_NAME}"
      LICENSE_COMPANY: "\${LICENSE_COMPANY}"
      LICENSE_DNS: "\${LICENSE_DNS}"
      LICENSE_EMAIL: "\${LICENSE_EMAIL}"
      URL_PREFIX: "\${URL_PREFIX}"
      UI_RENDER_HOST: "\${UI_RENDER_HOST}"
      MYSQL_HOST: "\${MYSQL_HOST}"
      REDIS_HOST: "\${REDIS_HOST}"
      MONGO_HOST: "\${MONGO_HOST}"
      # MONGO_USERNAME: "\${MONGO_USERNAME}"
      # MONGO_PASSWORD: "\${MONGO_PASSWORD}"
    networks:
      - xboson-net
    ports:
      - "8080:8080"
    depends_on:
      mysql:
        condition: service_healthy
      redis:
        condition: service_healthy
      mongodb:
        condition: service_healthy
EOF

if [[ $INSTALL_MODE == "full" ]]; then
  cat >> ./docker-compose.yml <<EOF

  artemis:
    image: ${ipf}xboson-artemis:latest
    container_name: mqtt-x
    restart: always
    environment:
      # ARTEMIS_USER: "\${ARTEMIS_USER}"
      # ARTEMIS_PASSWORD: "\${ARTEMIS_PASSWORD}"
      ANONYMOUS_LOGIN: "true"
      mongoURL: "\${mongoURL}"
    networks:
      - xboson-net

  hadoop-n1:
    image: bde2020/hadoop-namenode:2.0.0-hadoop3.1.3-java8
    container_name: hadoop-name-1
    restart: always
    environment:
      CLUSTER_NAME: hdfs1
      CORE_CONF_fs_defaultFS: hdfs://hadoop-name-1:9000
      HDFS_CONF_dfs_namenode_datanode_registration_ip___hostname___check: false
    networks:
      - xboson-net

  hadoop-d1:
    image: bde2020/hadoop-datanode:2.0.0-hadoop3.1.3-java8
    container_name: hadoop-data-1
    restart: always
    environment:
      CORE_CONF_fs_defaultFS: hdfs://hadoop-name-1:9000
      HDFS_CONF_dfs_replication: 1
    networks:
      - xboson-net

  neo4j:
    image: neo4j:4.2.1
    container_name: neo-x
    restart: always
    # environment:
      # NEO4J_AUTH: "\${NEO4J_AUTH}"
    networks:
      - xboson-net
EOF
fi
  echo "Make 'docker-compose.yml' success."
  if ! docker compose config >/dev/null; then
    echo "got validating error, stop"
    rm -f .env
    exit 1
  fi
}


startup_app() {
  if [[ -f ".env" ]]; then
    echo "'.env' already exists, skip initialization."
    exit 0
  fi
  check_compose
  install_type_choose
  make_env
  make_compose 
  if docker compose up; then
    echo ""
    docker ps
    echo ""
    echo "Install all sucess."
  else
    echo "got some error !"
  fi
}


show_help() {
  local name=`basename $0`
  echo "Usage:"
  echo "  $name --help"
  echo "  $name --backup  <mysql|mongo|web>"
  echo "  $name --restore <mysql|mongo|web> <file.tar.gz>"
  echo "  $name --license show"
  echo "  $name --license install"
}


backup_mysql() {
  echo 1
}


backup_web() {
  echo 1
}


backup_mongo() {
  echo 1
}


restore_mysql() {
  local file="$1"
}


restore_web() {
  local file="$1"
}


restore_mongo() {
  local file="$1"
}


license_show() {
  # TODO
  echo "license show"
}


license_install() {
  # TODO
  echo "license install"
}


is_run() {
  local container="$1"

  if ! docker inspect -f '{{.State.Running}}' "$container" 2>/dev/null | grep -q '^true$'; then
    echo "Error: container '$container' is not running" >&2
    exit 2
  fi
}


parse_args() {
  if [[ $# -eq 0 ]]; then
    startup_app
    return 0
  fi

  case "$1" in
    --help|-h)
      show_help
      ;;

    --backup)
      if [[ $# -ne 2 ]]; then
        echo "Error: --backup requires mysql, mongo, web or all" >&2
        show_help
        return 1
      fi

      case "$2" in
        mysql)
          is_run mysql-x
          backup_mysql
          ;;
        mongo)
          backup_mongo
          ;;
        web)
          backup_web
          ;;
        all)
          backup_mysql
          backup_web
          backup_mongo
          ;;
        *)
          echo "Error: invalid backup target: $2" >&2
          echo "Valid targets: mysql, mongo, web, all" >&2
          return 1
          ;;
      esac
      ;;

    --restore)
      if [[ $# -ne 3 ]]; then
        echo "Error: --restore requires <mysql|mongo|web> <file.tar.gz>" >&2
        show_help
        return 1
      fi

      case "$2" in
        mysql)
          restore_mysql "$3"
          ;;
        mongo)
          restore_mongo "$3"
          ;;
        web)
          restore_web "$3"
          ;;
        *)
          echo "Error: invalid restore target: $2" >&2
          echo "Valid targets: mysql, mongo, web" >&2
          return 1
          ;;
      esac
      ;;

    --license)
      if [[ $# -ne 2 ]]; then
        echo "Error: --license requires show or install" >&2
        show_help
        return 1
      fi

      case "$2" in
        show)
          license_show
          ;;
        install)
          license_install
          ;;
        *)
          echo "Error: invalid license command: $2" >&2
          echo "Valid commands: show, install" >&2
          return 1
          ;;
      esac
      ;;

    *)
      echo "Error: unknown option: $1" >&2
      show_help
      return 1
      ;;
  esac
}


# ================================
# Main
# ================================
parse_args "$@"

