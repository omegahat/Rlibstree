
WEB_DIR=www.omegahat.org:/home3/WebSites/Omega/Rlibstree

indexInstall: index.html

shipIndex: aux
	$(MAKE) -C ../inst/doc ship

index.html: configure index.html.in ../DESCRIPTION
	./configure

configure: configure.in 
	autoconf

aux: index.html
	scp index.html $(WEB_DIR)/index.html
	scp ../Changes ../FAQ.html $(WEB_DIR)

indexInstall indexOnly: index.html
	scp index.html $(WEB_DIR)/index.html
