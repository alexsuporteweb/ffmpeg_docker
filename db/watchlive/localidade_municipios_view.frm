TYPE=VIEW
query=select `m`.`id` AS `id`,`m`.`nome` AS `nome`,`e`.`sigla` AS `sigla` from (`watchlive`.`localidade_municipios` `m` join `watchlive`.`localidade_estados` `e` on(`m`.`estado_id` = `e`.`id`)) order by `e`.`sigla`,`e`.`nome`
md5=fc0e22bf1c251fef1a9d189273f4471c
updatable=1
algorithm=0
definer_user=watchlive
definer_host=%
suid=2
with_check_option=0
timestamp=0001726491435116793
create-version=2
source=SELECT \n\n                                m.id,\n                                m.nome,\n                                e.sigla\n\n                                FROM\n                                localidade_municipios m\n                                JOIN localidade_estados e ON m.estado_id = e.id\n                                ORDER BY e.sigla, e.nome
client_cs_name=utf8mb4
connection_cl_name=utf8mb4_unicode_ci
view_body_utf8=select `m`.`id` AS `id`,`m`.`nome` AS `nome`,`e`.`sigla` AS `sigla` from (`watchlive`.`localidade_municipios` `m` join `watchlive`.`localidade_estados` `e` on(`m`.`estado_id` = `e`.`id`)) order by `e`.`sigla`,`e`.`nome`
mariadb-version=110502
