# Maintainer: StoneCold <forumi0721[at]gmail[dot]com>
# Contributer: Ndoskrnl <lollipop.studio.cn@gmail.com>

_gitname="webvirtcloud"
pkgname=("${_gitname}-git")
pkgver=20200420.767.d9fa434
pkgrel=1
pkgdesc="WebVirtCloud is virtualization web interface for admins and users"
arch=("x86_64")
url="https://github.com/retspen/webvirtcloud"
license=("Apache")
depends=("python-virtualenv" "python" "python-lxml" "libvirt" "libssh" "zlib" "libxslt" "nginx" "supervisor" "libsasl" "python-pkgconfig")
makedepends=("git" "gcc")
provides=("webvirtcloud" "webvirtcloud-git")
conflicts=("webvirtcloud" "webvirtcloud-git" "webvirtmgr" "webvirtmgr-git")
install="${pkgname}.install"
backup=("srv/webvirtcloud/webvirtcloud/settings.py")
source=("${_gitname}::git+https://github.com/retspen/webvirtcloud.git"
		"configuration-install.sh")
md5sums=('SKIP'
         'de75d0c7bc2d3414718fedf7a0376d4d')

pkgver() {
	cd "${srcdir}/${_gitname}"
	echo "$(git log -1 --format="%cd" --date=short | sed "s/-//g").$(git rev-list --count HEAD).$(git rev-parse --short HEAD)"
}

package() {
	install -dm0755 "${pkgdir}/srv/webvirtcloud"
	cp -r "${srcdir}/webvirtcloud" "${pkgdir}/srv"
	rm -rf "${pkgdir}/srv/webvirtcloud/.git"

	install -Dm0755 "${srcdir}/configuration-install.sh" "${pkgdir}/srv/webvirtcloud/configuration-install.sh"

	cd "${pkgdir}/srv/webvirtcloud"

	# Will auto generate secret key in post_install()
	cp webvirtcloud/settings.py.template webvirtcloud/settings.py

	# Install config
	install -dm0755 "${pkgdir}/etc/supervisor.d"
	sed "s/user=www-data/user=webvirtcloud/g" -i "${srcdir}/webvirtcloud/conf/supervisor/webvirtcloud.conf"
	install -Dm0644 "${srcdir}/webvirtcloud/conf/supervisor/webvirtcloud.conf" "${pkgdir}/etc/supervisor.d/webvirtcloud.ini"
	install -dm0755 "${pkgdir}/etc/nginx/conf.d"
	install -Dm0644 "${srcdir}/webvirtcloud/conf/nginx/webvirtcloud.conf" "${pkgdir}/etc/nginx/conf.d/webvirtcloud.conf"
}
