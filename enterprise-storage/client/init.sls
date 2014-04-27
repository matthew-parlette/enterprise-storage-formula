glusterfs-client:
  pkg:
    - installed

{% set server = salt['pillar.get']('enterprise-storage:client:server',None) %}
{% set brick = salt['pillar.get']('enterprise-storage:brick',None) %}

{% if server and brick %}

/media/enterprise-storage:
  file.directory:
    - user: root
    - group: enterprise
    - mode: 2775
    - mkdirs: True
  mount.mounted:
    - device: enterprise-storage:/enterprise-storage
    - fstype: glusterfs
    - opts: defaults,_netdev
    - dump: 0
    - pass_num: 0
    - persist: True
    - mkmnt: True
  require:
    - pkg: glusterfs-client
    - group: enterprise

{% endif %}
