# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils
DESCRIPTION="Guacamole is a html5 vnc client as servlet"
HOMEPAGE="http://guacamole.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="AGPL-3"

SLOT="0"

KEYWORDS="~x86"

IUSE=""


DEPEND="dev-java/maven-bin"

RDEPEND="${DEPEND} 
	www-servers/tomcat
	>virtual/jre-1.6
	net-misc/guacd
	net-libs/libguac-client-vnc"


src_compile() {
    	mkdir ${HOME}/.m2
	cat /usr/share/maven-bin-2.2/conf/settings.xml | sed -e 's:<!-- localRepo:localRepo:g' \
	-e 's:/path/to/local/repo:'${HOME}/.m2':g' >${S}/settings.xml
	mvn-2.2 -s ${S}/settings.xml compile war:war
}

src_install() {
	sed -e 's:/path/to:/etc/guacamole:g' -i ${S}/doc/example/guacamole.properties || die "properties sed failed"
	insinto /etc/${PN}
	doins ${S}/doc/example/guacamole.properties
	doins ${S}/doc/example/user-mapping.xml
	insinto /var/lib/${PN}
	newins ${S}/target/guacamole-default-webapp-0.4.0.war ${PN}.war
	elog "Please link /var/lib/${PN} in to your servlet container!"
	elog "You will also need to define users and connectrions in /etc/guacamole/user-mapping.xml!"
}
