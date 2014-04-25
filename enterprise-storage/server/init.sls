glusterfs-server:
  pkg:
    - installed

{% set peers = salt['pillar.get']('enterprise-storage:peers',{}) %}

{% for peer in peers %}
{% set mount_path = pillar['enterprise-storage']['peers'][peer]['mount_path'] %}
{% set brick_path = pillar['enterprise-storage']['brick'] %}

{{ mount_path }}:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True
  mount.mounted:
    - device: {{ pillar['enterprise-storage']['peers'][peer]['device'] }}
    - fstype: xfs
    - opts: defaults
    - dump: 0
    - pass_num: 0
    - persist: True
    - mkmnt: True

{{ brick_path }}:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True
    - require:
      - file: {{ mount_path }}

{% if peers|length == 1 %}
enterprise-storage-volume:
  cmd:
    - run
    - name: gluster volume create enterprise-storage {% for peer in peers %}{{ peer }}:{{ brick_path }}{% endfor %}
    - unless: gluster volume info enterprise-storage

enterprise-storage:
  cmd:
    - run
    - name: gluster volume start enterprise-storage
    - unless: gluster volume info enterprise-storage | grep Started
    - require:
      - cmd: enterprise-storage-volume
{% elif peers|length > 1 %}

{% endif %}

{% endfor %}
