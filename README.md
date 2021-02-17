DistKontrol usb check
=========

Мониторинг доступности usb-ключей и их использования в устройстве [distkontrol](http://www.distkontrol.ru/).
Конфигурация /etc/dkclt/dkclt.cfg изменяется после запуска программой. Тесты на идемтотентность невозможны.

Requirements
------------

Для Ubuntu 20.04
```sh
ansible-galaxy role install -f -r requirements.yml
```

Role Variables
--------------

Name | Default Value | Description
---|---|---
`_node_exporter_system_group` | node-exp | 
`_node_exporter_system_user` | node-exp |
`node_exporter_textfile_dir` | /var/lib/node_exporter | каталог по умолчанию для textfile collector
`dkclt_config_dir` | /etc/dkclt |
`dkclt_config_file` | /etc/dkclt/dkclt.cfg | Конфигурация клиента
`dkclt_hubs` | "192.168.163.13:6565","192.168.163.14:6565" | Адреса Distkontrol
`dkclt_dkmon_community` | public | snmp community
`dkclt_dkmon_ip` | "192.168.163.13","192.168.163.14" | Список адресов без портов для скрипта

Dependencies
------------

cloudalchemy.node-exporter

Example Playbook
----------------

```yaml
- hosts: dkmon
  gather_facts: true
  connection: ssh
  roles:
    - cloudalchemy.node-exporter
    - ansible_distkontrol
```

License
-------

MIT
