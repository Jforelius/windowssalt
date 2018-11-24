### A) Säädä windowsia saltilla siten, että windows on orja ja linux on herra:

Käytössäni xubuntu 18.04 livetikku. Asensin ensin salt-minion ja salt-master testaukseen:

	~$ sudo apt-get -y install salt-master salt-minion
	~$ echo -e "master: 192.168.10.35\nid:xubuntujuska" |sudo tee minion
	~$ sudo systemctl restart salt-minion.service

Tein myös testi moduulin nopeasti
	
	~$ cat init.sls 
	nethack-console:
	  pkg.installed
	
	/tmp/hello.txt:
	  file.managed:
	    - source: salt://hello/hello.txt

katsoin vielä saltin version ennen windowsin minion asennusta:
	~$ sudo salt --version
	salt 2017.7.4 (Nitrogen)

Asensin salt-minion 2017.7.4-py3-amd64 version, yhdistin slaveksi ja muokkasin hello:
	~$ cat init.sls	
	{% if "Windows" == grains["os"] %}
	{%	set hellofile = "C:\hello.txt" %}
	{% else %}
	{%	set hellofile = "/tmp/hello.txt" %}
	{%endif %}
	
	{{ hellofile }}:
	  file.managed:
	    - source: salt://hello/hello.txt


### B) windowsilla salttia ilman masteria - salt-call -local

Kokeilin tehdä salt-call --version komentoa windowsin powershellillä, mutta tuli erroreita.
Päätin käydä katsomassa saltin kansiota. Folderia tuplaklikkaamalla windows kysyi admin oikeuksia, joilla sain oikeudet kansioon. Nyt powershell komento toimi.

ongelmana windows pakettien löytö: saltstack dokumentaatio auttoi:
	salt-run winrepo.update_git_repos
	salt -G 'os:windows' pkg.refresh_db

Tämä ei toiminut heti. Teron sivustoilta löytyi seuraava fiksaus:
	~$ sudo mkdir /srv/salt/win
	~$ sudo chown root.salt /srv/salt/win
	~$ sudo chmod ug+rwx /srv/salt/win
	~$ sudo salt-run winrepo.update_git_repos
	~$ sudo salt -G 'os:windows' pkg.refresh_db
	windowsjuska:
	    ----------
	    failed:
	        0
	    success:
	        260
	    total:
	        260


Päätin kokeilla asentaa VLC ilman masteria windowsilla powershellissä:
	salt-call --local pkg.install vlc

Piti painaa adminina continue installiin. Vlc toimii kuten kuuluu.

Tein winkone moduulin, joka asentaa libreofficen:
	~$ cat top.sls
	base:
	  xubuntu*:
	    - hello
	  windows*:
	    - hello
	    - winkone

	~$ cat init.sls
	  libreoffice:
	  pkg.installed

### C) muokkaa windows ohjelman asetuksia saltilla

Päätin muuttaa Rust pelin keybindejäni saltin kautta. keys_default.cfg ovat defaultit, keys.cfg ovat itse muutetut.
Rust sijaitsee E asemassa windows koneellani.

	~$ cat init.sls
	E:\Steam\steamapps\common\Rust\cfg\keys.cfg:
	  file.managed:
	    - source: salt://rust/keys.cfg

Näistä voisi periaatteessa tehdä default.cfg korvaavan templaten.
