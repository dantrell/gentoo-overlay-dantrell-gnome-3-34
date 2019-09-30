# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit gnome2 meson

DESCRIPTION="Avoid the robots and make them crash into each other"
HOMEPAGE="https://wiki.gnome.org/Apps/Robots"

LICENSE="GPL-3+ CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="*"

IUSE=""

RDEPEND="
	>=dev-libs/glib-2.32:2
	dev-libs/libgnome-games-support:1=
	>=gnome-base/librsvg-2.36.2:2
	>=media-libs/libcanberra-0.26[gtk3]
	>=x11-libs/gtk+-3.15:3
"
DEPEND="${RDEPEND}
	dev-libs/appstream-glib
	>=dev-util/intltool-0.50
	dev-util/itstool
	sys-devel/gettext
	virtual/pkgconfig
"
