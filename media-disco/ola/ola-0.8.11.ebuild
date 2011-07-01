# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils
DESCRIPTION="An open framework for DMX lightning control"
HOMEPAGE="http://code.google.com/p/linux-lighting/"
SRC_URI="http://linux-lighting.googlecode.com/files/${P}.tar.gz"


LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE="python webserver examples"

DEPEND="dev-libs/protobuf
	dev-util/cppunit
	webserver? ( net-libs/libmicrohttpd )"
RDEPEND="${DEPEND}"


src_configure() {
	enewgroup olad
	enewuser olad -1 -1 /var/lib/olad "olad,usb"
	sed -e 's/string home_dir = pwd_ptr->pw_dir/string home_dir = getenv("HOME")/g' -i ${S}/olad/OlaDaemon.cpp || die "homedir patch failed"
	econf --prefix=/usr $(use python && echo "--enable-python-libs") \
	$(use !webserver && echo "--disable-http") \
	$(use !examples && echo "--disable-examples")

}

src_compile() {
	#make || die
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
	doinitd ${FILESDIR}/initd/${PN}d || die "doinitd failed"
	doconfd ${FILESDIR}/confd/${PN}d  || die "doinitd failed"
}
