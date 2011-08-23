# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils
DESCRIPTION="This is the daemon used by www-apps/guacamole."


HOMEPAGE="http://guacamole.sourceforge.net/"
SRC_URI="mirror://sourceforge/guacamole/${P}.tar.gz"

LICENSE="AGPL-3"

SLOT="0"

KEYWORDS="~x86"

IUSE=""

DEPEND="net-libs/libguac"
RDEPEND="${DEPEND}"

src_configure() {
	econf
}


src_compile() {
	emake || die
}


src_install() {
	emake DESTDIR="${D}" install || die

	doinitd ${S}/init.d/guacd
}
