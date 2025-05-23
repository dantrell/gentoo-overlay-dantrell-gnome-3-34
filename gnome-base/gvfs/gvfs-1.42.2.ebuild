# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit gnome.org gnome2-utils meson systemd xdg

DESCRIPTION="Virtual filesystem implementation for GIO"
HOMEPAGE="https://wiki.gnome.org/Projects/gvfs"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="*"

IUSE="afp archive bluray cdda elogind fuse google gnome-keyring gnome-online-accounts gphoto2 +http ios mtp nfs policykit samba systemd test +udev udisks zeroconf"
# elogind/systemd only relevant to udisks (in v1.38.1)
REQUIRED_USE="
	?? ( elogind systemd )
	cdda? ( udev )
	google? ( gnome-online-accounts )
	gphoto2? ( udev )
	mtp? ( udev )
	udisks? ( udev )
"

RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.57.2:2
	afp? ( >=dev-libs/libgcrypt-1.2.2:0= )
	sys-apps/dbus
	app-crypt/gcr:0=
	policykit? (
		>=sys-auth/polkit-0.114
		sys-libs/libcap )
	http? (
		dev-libs/libxml2:2
		>=net-libs/libsoup-2.58.0:2.4 )
	zeroconf? ( >=net-dns/avahi-0.6[dbus] )
	udev? ( >=dev-libs/libgudev-147:= )
	fuse? ( >=sys-fs/fuse-3:3 )
	udisks? ( >=sys-fs/udisks-1.97:2 )
	systemd? ( >=sys-apps/systemd-206:0= )
	elogind? ( >=sys-auth/elogind-229:0= )
	ios? (
		>=app-pda/libimobiledevice-1.2:=
		>=app-pda/libplist-1:= )
	gnome-online-accounts? ( >=net-libs/gnome-online-accounts-3.17.1:= )
	gnome-keyring? ( app-crypt/libsecret )
	bluray? ( media-libs/libbluray:= )
	mtp? (
		virtual/libusb:1
		>=media-libs/libmtp-1.1.15 )
	samba? (
		sys-libs/libunwind:=
		>=net-fs/samba-4[client] )
	archive? ( app-arch/libarchive:= )
	cdda? (
		dev-libs/libcdio:0=
		>=dev-libs/libcdio-paranoia-0.78.2 )
	google? ( >=dev-libs/libgdata-0.17.9:=[crypt,gnome-online-accounts] )
	gphoto2? ( >=media-libs/libgphoto2-2.5.0:= )
	nfs? ( >=net-fs/libnfs-1.9.8:= )
	net-misc/openssh
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-build/meson-0.49
	app-text/docbook-xsl-stylesheets
	app-text/docbook-xml-dtd:4.2
	dev-libs/libxslt
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	dev-util/gdbus-codegen
"

src_configure() {
	local enable_logind="false"
	if use systemd || use elogind; then
		enable_logind="true"
	fi

	local enable_gcrypt="false"
	if use afp; then # currently HAVE_GCRYPT and linkage only used with afp; check it on big bumps (grep for HAVE_GCRYPT and enable_gcrypt); adjust depends if changes
		enable_gcrypt="true"
	fi

	local enable_libusb="false"
	if use mtp; then # currently HAVE_LIBUSB and linkage only used with mtp; check it on big bumps (grep for HAVE_LIBUSB and enable_libusb); adjust depends if changes
		enable_libusb="true"
	fi

	local emesonargs=(
		-Dsystemduserunitdir="$(systemd_get_userunitdir)"
		-Dtmpfilesdir="${EPREFIX}"/usr/lib/tmpfiles.d
		$(meson_use policykit admin)
		$(meson_use ios afc)
		$(meson_use afp)
		$(meson_use archive)
		$(meson_use cdda)
		$(meson_use zeroconf dnssd)
		$(meson_use gnome-online-accounts goa)
		$(meson_use google)
		$(meson_use gphoto2)
		$(meson_use http)
		$(meson_use mtp)
		$(meson_use nfs)
		-Dsftp=true
		$(meson_use samba smb)
		$(meson_use udisks udisks2)
		$(meson_use bluray)
		$(meson_use fuse)
		-Dgcr=true
		-Dgcrypt=${enable_gcrypt}
		$(meson_use udev gudev)
		$(meson_use gnome-keyring keyring)
		-Dlogind=${enable_logind}
		-Dlibusb=${enable_libusb}
		-Ddevel_utils=false # wouldn't install any of it as of 1.38.1; some tests need it, but they aren't automated tests in v1.38.1
		-Dinstalled_tests=false
		-Dman=true
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
	gnome2_giomodule_cache_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
	gnome2_giomodule_cache_update
}
