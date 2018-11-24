{% if "Windows" == grains["os"] %}
{%	set hellofile = "C:\hello.txt" %}
{% else %}
{%	set hellofile = "/tmp/hello.txt" %}
{%endif %}

{{ hellofile }}:
  file.managed:
    - source: salt://hello/hello.txt
