require 'formula'

class I686ElfBinutils < Formula
  homepage 'http://www.gnu.org/software/binutils/binutils.html'
  url 'http://ftpmirror.gnu.org/binutils/binutils-2.23.2.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/binutils/binutils-2.23.2.tar.gz'
  sha1 'c3fb8bab921678b3e40a14e648c89d24b1d6efec'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}",
                          "--mandir=#{man}",
                          "--disable-werror",
                          "--enable-interwork",
                          "--disable-multilib",
                          "--disable-nls",
                          "--target=i686-elf"
    system "make"
    system "make install"
  end
end
