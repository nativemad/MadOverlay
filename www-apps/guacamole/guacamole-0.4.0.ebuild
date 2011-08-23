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
    mvn-2.2 compile war:war
}

src_install() {
	insinto /var/lib/${PN}
	newins ${S}/target/guacamole-default-webapp-0.4.0.war ${PN}.war
	elog "Please link /var/lib/${PN} in to your servlet container!"
}
