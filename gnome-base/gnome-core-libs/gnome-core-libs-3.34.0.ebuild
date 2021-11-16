# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="Metapackage for GNOME core libraries"
HOMEPAGE="https://www.gnome.org/"

LICENSE="metapackage"
SLOT="3.0"
KEYWORDS="*"

IUSE="cups python"

RDEPEND="
	>=dev-libs/glib-2.62:2
	>=x11-libs/gdk-pixbuf-2.38:2
	>=x11-libs/pango-1.42
	>=media-libs/clutter-1.26:1.0
	>=x11-libs/gtk+-3.24:3[cups?]
	>=dev-libs/atk-2.34
	>=x11-libs/libwnck-3.32.0:3
	>=gnome-base/librsvg-2.40.21
	>=gnome-base/gnome-desktop-${PV}:3
	>=x11-libs/startup-notification-0.12

	>=gnome-base/gvfs-1.42
	>=gnome-base/dconf-0.34

	>=media-libs/gstreamer-1.14.5:1.0
	>=media-libs/gst-plugins-base-1.14.5:1.0
	>=media-libs/gst-plugins-good-1.14.5:1.0

	dev-lang/vala:0.42
	dev-lang/vala:0.44
	dev-lang/vala:0.46

	python? ( >=dev-python/pygobject-${PV}:3 )
"
DEPEND=""
BDEPEND=""

S="${WORKDIR}"
