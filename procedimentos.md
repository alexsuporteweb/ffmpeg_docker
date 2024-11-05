# compose install / update

docker exec -it watchlive_php composer update
docker exec -it watchlive_php npm install
docker exec -it watchlive_php npm run dev

# migrate & seed

docker exec -it watchlive_php php artisan migrate:refresh --seed

# permissoes na pasta

sudo chmod -R 777 app/storage

# Atualizar adminlte3
# https://github.com/jeroennoten/Laravel-AdminLTE/wiki/Installation

docker exec -it watchlive_php composer require jeroennoten/laravel-adminlte
docker exec -it watchlive_php php artisan adminlte:install -y

# Para Executar o Comando de Instalação Parcialmente
# Você pode instalar o AdminLTE sem sobrescrever os arquivos de configuração. 
# Para isso, basta especificar opções que não sobrescrevam o arquivo config/app.php:

docker exec -it watchlive_php php artisan adminlte:install --only=assets

# Para verificar se o Nginx está rodando:

docker exec -it watchlive_nginx ps aux | grep nginx

# Para verificar se a porta 1935 está aberta e acessível, use o comando netstat ou ss:

docker exec -it watchlive_nginx netstat -tuln | grep 1935

# Para verificar log do container watchlive_nginx

docker exec -it watchlive_nginx tail -f /var/log/nginx/error.log
docker exec -it watchlive_nginx tail -f /var/log/ffmpeg.log

# liberar permissoes na pasta

docker exec -it watchlive_nginx ls -l /var/hls/live/
docker exec -it watchlive_nginx chmod -R 777 /var/hls

# Verificar se RTMP trabalhando

docker exec -it watchlive_nginx ffmpeg -i rtmp://localhost/live/live1

# testar no container

ffmpeg -i rtmp://localhost/live/live1 -c:v libx264 -c:a aac -f flv rtmp://localhost/hls/live1
ffprobe rtmp://localhost/live/live1

# Para testar obs

Service: Custom...
Server: rtmp://localhost:1935/live/live1
Stream Key: live1

# Para testar vlc - media - Open Network Stream
Please enter a network URL: rtmp://localhost:1935/live/live1