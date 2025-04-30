<pre lang="markdown"> <details> <summary>📁 Project Structure</summary> ```bash .
├── .gitignore
├── Makefile
├── README.md
├── secrets
│   ├── mariadb
│   │   ├── mdb_root_pwd.txt
│   │   └── mdb_user_pwd.txt
│   ├── ssl
│   │   ├── lpolizzi.42.fr.crt
│   │   └── lpolizzi.42.fr.key
│   └── wordpress
│       ├── wp_admin_mail.txt
│       ├── wp_admin_pwd.txt
│       └── wp_user_mail.txt
└── srcs
    ├── docker-compose.yml
    ├── .env
    └── requirements
        ├── mariadb
        │   ├── conf
        │   │   └── setup.sh
        │   └── Dockerfile
        ├── nginx
        │   ├── conf
        │   │   ├── entrypoint.sh
        │   │   └── nginx.conf.template
        │   └── Dockerfile
        └── wordpress
            ├── conf
            │   ├── setup.sh
            │   ├── wp-config.php
            │   └── www.conf.template
            └── Dockerfile

13 directories, 21 files
 ``` </details> </pre>
