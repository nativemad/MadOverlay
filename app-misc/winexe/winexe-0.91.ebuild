# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="winexe remotely executes commands on WindowsNT/2000/XP/2003 systems
from GNU/Linux"
HOMEPAGE="http://http://sourceforge.net/projects/${PN}/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/cyrus-sasl
	net-libs/gnutls
	dev-libs/popt"
RDEPEND="${DEPEND}"


src_compile() {
	cd ${S}/source4
	epatch "${FILESDIR}/filesdir.patch"
	./autogen.sh || die "autogen failed"
	# It only compiles with fhs enabled....
	econf --enable-fhs || die "econf failed."
	emake basics idl bin/winexe || die "emake failed."
}

src_install() {
	dobin source4/bin/winexe
}
