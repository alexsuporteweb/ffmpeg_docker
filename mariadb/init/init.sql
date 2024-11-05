-- Cria o banco de dados se não existir
create database watchlive character set utf8mb4 collate utf8mb4_bin;

-- Cria um usuário e concede permissões para acessar o banco de dados de qualquer lugar
CREATE USER 'watchlive'@'%' IDENTIFIED WITH caching_sha2_password BY 'watchlive';

GRANT ALL PRIVILEGES ON watchlive.* TO 'watchlive'@'%';

-- Revoga todas as permissões do usuário 'watchlive' em outros bancos de dados (opcional, para maior segurança)
REVOKE ALL PRIVILEGES ON *.* FROM 'watchlive'@'%';
REVOKE GRANT OPTION ON *.* FROM 'watchlive'@'%';

FLUSH PRIVILEGES;
quit;