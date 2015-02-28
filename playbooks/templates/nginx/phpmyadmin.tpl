server {

  sendfile off;
  listen        80;
  server_name   {{ phpmyadmin.hostname }};
  root          {{ phpmyadmin.root }};
  index         index.php index.html index.htm;
  client_max_body_size 30m;

  location / {
    index  index.php index.html index.htm;
    try_files $uri @rewrite;
  }

  location @rewrite {
    rewrite ^ /index.php;
  }

  location ~ \.php$ {
    fastcgi_pass 127.0.0.1:9000;
    fastcgi_index index.php;
    include fastcgi.conf;
  }

}
